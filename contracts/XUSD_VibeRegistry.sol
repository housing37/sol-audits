// ref: https://oldscan.gopulse.com/#/address/0xbbeA78397d4d4590882EFcc4820f03074aB2AB29?tab=contract_code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import './Address.sol';
import './VibeLibRegistry.sol';
import "./registry.sol";
import "./AccessorMod.sol";
import "./atropamath.sol";
import "./XUSD.sol";
import "./Classes/VibeBase.sol";

/**
 * @title VibeRegistry
 * @dev This contract manages user vibes, class structures, and reward distribution through multiple registries.
 * Access control is handled via the inherited AccesorMod, providing restrictions on key operations.
 */
contract VibeRegistry is AccesorMod {
    using VibeLibRegistry for VibeLibRegistry.Registry;
    using Address for address;
    using AtropaMath for address;
    using LibRegistry for LibRegistry.Registry;
     using AuthLib for AuthLib.RoleData;

    // Custom Errors
    error NotAllowedAccess();
    error UnauthorizedAccess(AuthLib.Rank roleId, address addr);

    // Data structures for class and reward management
    struct MaterClass {
        address classAddress;
        uint updatedTimestamp;
        bool process;
        string description;
        VibeBase.Importance level;
    }

    struct RewardClass {
        address classAddress;
        bool process;
        string description;
    }

    struct userVibe {
        address userAddress;
        address classAddress;
        int vibes;
        uint timestamp;
        bool active;
    }

    struct VibeClass {
        address classAddress;
        uint aura;
        uint updatedTimestamp;
        bool active;
        bool process;
        string description;
    }

    struct UserProfileHash {
        address userAddress;
        int vibes;
        LibRegistry.Registry MasterReg;
    }

    struct Wing {
        uint64 Omnicron;
        uint64 Omega;
    }

    // Events
    event ClassAdded(address indexed classAddress, uint classType);
    event ClassRemoved(address indexed classAddress, uint classType);
    event ClassDeactivated(address indexed classAddress, uint classType);
    event ClassLimitUpdated(uint newLimit);
    event VibesCalculated(address indexed user, int vibes);
    event VibeUserDeactivated(address indexed user, address classAddress);
    event VibeUserActivated(address indexed user, address classAddress);
    event RewardsCalculated(address indexed classAddress, bytes reason);
    event WhitelistedContractAdded(address indexed contractAddress);
    event MasterClassVibesUpdated(address indexed classAddress, int vibes);
    event MasterClassErrorLogged(address indexed classAddress, uint Omnicron);

    // State variables
    XUSD public xusd;

    VibeLibRegistry.Registry internal MasterClassFromRegistry;
    VibeLibRegistry.Registry internal MasterClassToRegistry;
    VibeLibRegistry.Registry internal MasterClassCallerRegistry;
    VibeLibRegistry.Registry internal MasterClassContractRegistry;
    VibeLibRegistry.Registry internal MasterClassSenderRegistry;

    LibRegistry.Registry internal ErrorReg;

    mapping(address => MaterClass) internal MasterClassSenderMap;
    mapping(address => MaterClass) internal MasterClassFromMap;
    mapping(address => MaterClass) internal MasterClassToMap;
    mapping(address => MaterClass) internal MasterClassCallerMap;
    mapping(address => RewardClass) internal MasterClassContractMap;
    mapping(address => UserProfileHash) internal MasterUser;

    mapping(address => int) internal userTotalVibes;
    mapping(uint => userVibe) internal userClassVibe;
    mapping(address => mapping(address => Wing)) internal userVibesMap;
    mapping(uint => bool) internal TroubleShoot;
    mapping(address => bool) internal whitelistedContracts;

    uint internal classLimit = 50;
    uint internal denominator = 7500;
    int internal legatusRank = 350;
    int internal gladiator = 350;
    uint64 public constant MotzkinPrime = 953467954114363;

    /**
     * @notice Initializes the VibeRegistry contract.
     * @param _accessControl The address of the access control contract.
     * @param _xusd The address of the XUSD contract used for rewards.
     */
    constructor(address _accessControl, address _xusd) AccesorMod(_accessControl) {
        xusd = XUSD(_xusd);
  
    }

    /**
     * @notice Updates the class limit for registry sorting.
     * @param limit The new class limit.
     * @dev Can only be called by the Consul.
     */
    function setClassLimit(uint limit) external onlyConsul {
        classLimit = limit;
        emit ClassLimitUpdated(limit);
    }

    /**
     * @notice Adds a new class to the specified registry.
     * @param class The address of the class to be added.
     * @param classType The type of class (0: To, 1: From, 2: Caller, 3: Sender, 4: Contract).
     * @param _process Whether the class requires processing.
     * @dev Can only be called by a Senator.
     */
    function addClass(
        address class,      
        uint classType,
        bool _process
    ) external onlySenator {
        MaterClass memory newClass = MaterClass({
            classAddress: class,
            updatedTimestamp: block.timestamp,            
            process: _process,
            description: VibeBase(class).getDescription(),
            level: VibeBase(class).getLevel()
        });

        if (classType == 0) {
            MasterClassToRegistry.Register(class, VibeBase(class).getLevel());
            MasterClassToMap[class] = newClass;
        } else if (classType == 1) {
            MasterClassFromRegistry.Register(class, VibeBase(class).getLevel());
            MasterClassFromMap[class] = newClass;
        } else if (classType == 2) {
            MasterClassCallerRegistry.Register(class, VibeBase(class).getLevel());
            MasterClassCallerMap[class] = newClass;
        } else if (classType == 3) {
            MasterClassSenderRegistry.Register(class, VibeBase(class).getLevel());
            MasterClassSenderMap[class] = newClass;
        } else if (classType == 4) {
            MasterClassContractRegistry.Register(class, VibeBase(class).getLevel());
            MasterClassContractMap[class] = RewardClass({
                classAddress: class,
                process: _process,
                description: VibeBase(class).getDescription()
            });
        }
        emit ClassAdded(class, classType);
    }

    /**
 * @notice View function to calculate the current total vibe of a user.
 * @param user The address of the user whose vibe you want to calculate.
 * @return The total vibes of the user.
 */
function calculateCurrentVibe(address user) external  returns (int) {
    int totalVibes = 0;
    
    // Iterate over the "to" registry for vibe classes
    totalVibes += _calculateVibesForAddressView(user, MasterClassToRegistry, MasterClassToMap);

    // Iterate over the "from" registry for vibe classes
    totalVibes += _calculateVibesForAddressView(user, MasterClassFromRegistry, MasterClassFromMap);

    // Iterate over the "caller" registry for vibe classes
    totalVibes += _calculateVibesForAddressView(user, MasterClassCallerRegistry, MasterClassCallerMap);

    // Iterate over the "sender" registry for vibe classes
    totalVibes += _calculateVibesForAddressView(user, MasterClassSenderRegistry, MasterClassSenderMap);

    // Ensure that the total vibes stay within the range 0-9999
    totalVibes = totalVibes < int(0) ? int(0) : totalVibes > int(9999) ? int(9999) : totalVibes;

    return totalVibes;
}

/**
 * @dev Internal view function to calculate vibes for a given user from a registry.
 * This function does not modify state and is safe to be used within a view function.
 * @param user The user address to calculate vibes for.
 * @param registry The registry to query classes from.
 * @param classMap Mapping from class addresses to MaterClass structs.
 * @return The calculated vibes for this specific registry.
 */
function _calculateVibesForAddressView(
    address user,
    VibeLibRegistry.Registry storage registry,
    mapping(address => MaterClass) storage classMap
) internal  returns (int) {
    int sumVibes = 0;

    uint count = registry.Count() >= classLimit ? classLimit : registry.Count();

    for (uint i = 0; i < count; i++) {
        address classAddress = registry.GetHashByIndex(i);
        MaterClass storage vibeClass = classMap[classAddress];
        uint Omnicron = user.hashWith(vibeClass.classAddress);
        bool userHasVibe = userClassVibe[Omnicron].timestamp != 0;

        if (userHasVibe && userClassVibe[Omnicron].timestamp > vibeClass.updatedTimestamp) {
            sumVibes += userClassVibe[Omnicron].vibes;
        } else {
            try IVibeCalculator(vibeClass.classAddress).calculateTotalBasisFee(user, 0) returns (int _vibes) {
                sumVibes += _vibes;
            } catch {
                // If there's an issue calculating vibes, ignore this class
            }
        }
    }

    return sumVibes;
}

    /**
     * @notice Deactivates and removes a class from the specified registry.
     * @param class The address of the class to be removed.
     * @param classType The type of class (0: To, 1: From, 2: Caller, 3: Sender, 4: Contract).
     * @dev Can only be called by the Consul.
     */
    function deactivateVibe(address class, uint classType) external onlyConsul {
        if (classType == 0) {
            MasterClassToRegistry.Remove(class);
        } else if (classType == 1) {
            MasterClassFromRegistry.Remove(class);
        } else if (classType == 2) {
            MasterClassCallerRegistry.Remove(class);
        } else if (classType == 3) {
            MasterClassSenderRegistry.Remove(class);
        } else if (classType == 4) {
            MasterClassContractRegistry.Remove(class);
        }
        emit ClassDeactivated(class, classType);
    }

    /**
     * @notice Calculates vibes for multiple addresses, sums them, and applies to the caller.
     * @param to The address of the recipient.
     * @param from The address of the sender.
     * @param _caller The address of the contract caller.
     * @param sender The address of the transaction initiator.
     * @param amount The amount to process.
     * @return The sum of calculated vibes and the original amount.
     */
    function calculateAndSumBasis(
        address to,
        address from,
        address _caller,
        address sender,
        uint amount
    ) external  returns (int, uint) {
 
        int sumVibes = 0;
        int vibe = 0;

        // Calculate vibes for each address and update the total sum
        (vibe, ) = calculateVibesForAddress(to, MasterClassToRegistry, MasterClassToMap, amount);
        sumVibes += vibe;

        (vibe, ) = calculateVibesForAddress(from, MasterClassFromRegistry, MasterClassFromMap, amount);
        sumVibes += vibe;

        (vibe, ) = calculateVibesForAddress(_caller, MasterClassCallerRegistry, MasterClassCallerMap, amount);
        sumVibes += vibe;

        (vibe, ) = calculateVibesForAddress(sender, MasterClassSenderRegistry, MasterClassSenderMap, amount);
        sumVibes += vibe;

        calculateRewards(to, from, _caller, sender, amount, sumVibes);

        sumVibes = sumVibes < int(0) ? int(0) : sumVibes > int(9999) ? int(9999) : sumVibes;
        userTotalVibes[_caller] = sumVibes;

        if (whitelistedContracts[to] || whitelistedContracts[from] || whitelistedContracts[_caller] || whitelistedContracts[sender]) {
            sumVibes = 0;
        }

        emit VibesCalculated(_caller, sumVibes);
 

        return (sumVibes, amount);
    }

    /**
 * @notice View the current vibes of a specific user.
 * @param user The address of the user whose vibes you want to query.
 * @return The current vibes of the user.
 */
function viewVibes(address user) external view returns (int) {
    return userTotalVibes[user];
}


    /**
     * @dev Internal function to calculate vibes for an address.
     * Sorts the registry if the class limit is reached.
     * @param user The user address to calculate vibes for.
     * @param registry The registry to query classes from.
     * @param classMap Mapping from class addresses to MaterClass structs.
     * @param amount The transaction amount.
     * @return The calculated vibes and the input amount.
     */
    function calculateVibesForAddress(
        address user,
        VibeLibRegistry.Registry storage registry,
        mapping(address => MaterClass) storage classMap,
        uint amount
    ) internal returns (int, uint) {
        int sumVibes = 0;

        if (registry.Count() >= classLimit) {
            registry.SortRegistryByAccessStyle();
        }

        uint count = registry.Count() >= classLimit ? classLimit : registry.Count();

        for (uint i; i < count; ) {
            address classAddress = registry.GetHashByIndex(i);
            MaterClass storage vibeClass = classMap[classAddress];
            uint Omnicron = user.hashWith(vibeClass.classAddress);
            bool userHasVibe = userClassVibe[Omnicron].timestamp != 0;

            if (userHasVibe && userClassVibe[Omnicron].timestamp > vibeClass.updatedTimestamp) {
                if (!vibeClass.process) {
                    userClassVibe[Omnicron].timestamp = block.timestamp;
                    sumVibes += userClassVibe[Omnicron].vibes;
                } else {
                    try IVibeCalculator(vibeClass.classAddress).calculateTotalBasisFee(user, amount) returns (int _vibes) {
                        userClassVibe[Omnicron].vibes = _vibes;
                        userClassVibe[Omnicron].timestamp = block.timestamp;
                    } catch {
                        registry.Remove(classAddress);
                        return (0, amount); // Return without updating vibes
                    }
                    sumVibes += userClassVibe[Omnicron].vibes;
                }
            } else {
                try IVibeCalculator(vibeClass.classAddress).calculateTotalBasisFee(user, amount) returns (int _vibes) {
                    userClassVibe[Omnicron].vibes = _vibes;
                    userClassVibe[Omnicron].timestamp = block.timestamp;
                } catch {
                    registry.Remove(classAddress);
                    return (0, amount); // Return without updating vibes
                }
                sumVibes += userClassVibe[Omnicron].vibes;
            }

            unchecked {
                i++;
            }
        }


        emit MasterClassVibesUpdated(user, sumVibes);
        return (sumVibes, amount);
    }

    /**
     * @dev Internal function to calculate rewards for users.
     * Calls external reward modules for each active contract class.
     * @param to The address of the recipient.
     * @param from The address of the sender.
     * @param _caller The address of the contract caller.
     * @param sender The address of the transaction initiator.
     * @param amount The amount to process.
     * @param sumVibes The calculated sum of vibes.
     */
function calculateRewards(
    address to,
    address from,
    address _caller,
    address sender,
    uint amount,
    int sumVibes
) internal {
    uint count = MasterClassContractRegistry.Count();

    if (count >= classLimit) {
        MasterClassContractRegistry.SortRegistryByAccessStyle();
    }

    for (uint i; i < count; ) {
        address classHash = MasterClassContractRegistry.GetHashByIndex(i);
        RewardClass storage rewardClass = MasterClassContractMap[classHash];

        try IRewardsModule(rewardClass.classAddress).calculateRewards(to, from, _caller, sender, amount, sumVibes) {
            // Successful reward calculation
        } catch (bytes memory reason) {
            // Log the error without reverting
            emit RewardsCalculationFailed(classHash, reason);

           
        }

        unchecked {
            i++;
        }
    }
}

// Event to log the errors
event RewardsCalculationFailed(address indexed classHash, bytes reason);

    /**
     * @notice Sets a contract as whitelisted for vibe calculations.
     * @param contractWhite The address of the contract to whitelist.
     * @dev Can only be called by a Senator.
     */
    function setWhitelistedContract(address contractWhite) external onlySenator {
        whitelistedContracts[contractWhite] = true;
        emit WhitelistedContractAdded(contractWhite);
    }

    /**
     * @notice Deactivates a user's vibe entry for a specific class.
     * @param user The address of the user.
     * @param class The address of the class.
     * @dev Can only be called by the Consul.
     */
    function deactivateVibeUser(address user, address class) external onlyConsul {
        uint Omnicron = user.hashWith(class);
        userClassVibe[Omnicron].active = true;
        emit VibeUserDeactivated(user, class);
    }

    /**
     * @notice Reactivates a user's vibe entry for a specific class.
     * @param user The address of the user.
     * @param class The address of the class.
     * @dev Can only be called by the Consul.
     */
    function activateVibeUser(address user, address class) external onlyConsul {
        uint Omnicron = user.hashWith(class);
        userClassVibe[Omnicron].active = false;
        emit VibeUserActivated(user, class);
    }

    /**
     * @dev Example function to log a class error.
     * @param class The address of the class where the error occurred.
     * @param Omnicron The hashed value identifying the error.
     */
    function logMasterClassError(address class, uint Omnicron) internal {
        ErrorReg.Register(Omnicron);
        emit MasterClassErrorLogged(class, Omnicron);
    }
}
