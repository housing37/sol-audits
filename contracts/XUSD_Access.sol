// ref: https://oldscan.gopulse.com/#/address/0xbbeA78397d4d4590882EFcc4820f03074aB2AB29?tab=contract_code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title AuthLib
 * @dev A library for managing role-based access control (RBAC) using ranks. Allows accounts to be granted or revoked roles, and checks for required ranks.
 */
library AuthLib {
    // Custom error for unauthorized account access
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    // Enum representing different ranks in the system
    enum Rank {
        PRINCEPS,
        GLADIATOR,
        LEGATUS,
        SENATOR,
        CONSUL,       
        PREATORMAXIMUS
    }

    // Registry structure to store keys and their corresponding ranks
    struct Registry {
        uint256[] keys;  // Array to hold registered keys
        mapping(uint256 => uint256) indexOf;  // Maps key to its index in the keys array
        mapping(uint256 => bool) inserted;    // Tracks whether a key is inserted
        mapping(uint256 => Rank) keyRoles;    // Maps key to its assigned rank
    }

    // RoleData structure for managing roles of accounts
    struct RoleData {
        Registry registry;                  // Holds the registry for keys and roles
        mapping(address => Rank) ranks;     // Maps accounts to their assigned ranks
    }

    // Events
    event RoleGranted(address indexed account, Rank role);
    event RoleRevoked(address indexed account, Rank role);

    /**
     * @dev Registers a key with a specified rank in the registry.
     * @param _registry The registry where the key will be stored.
     * @param key The key to register (typically the address cast to uint256).
     * @param rank The rank to assign to the key.
     */
    function Register(Registry storage _registry, uint256 key, Rank rank) public {
        if (!_registry.inserted[key]) {
            _registry.inserted[key] = true;
            _registry.indexOf[key] = _registry.keys.length;
            _registry.keys.push(key);
            _registry.keyRoles[key] = rank;  // Store the rank with the key
        } else {
            // Update the rank if already registered
            _registry.keyRoles[key] = rank;
        }
    }

    /**
     * @dev Removes a key from the registry.
     * @param _registry The registry from which the key will be removed.
     * @param key The key to remove.
     */
    function Remove(Registry storage _registry, uint256 key) public {
        if (!_registry.inserted[key]) return;
        delete _registry.inserted[key];
        uint256 index = _registry.indexOf[key];
        uint256 lastKey = _registry.keys[_registry.keys.length - 1];
        _registry.keys[index] = lastKey;
        _registry.indexOf[lastKey] = index;
        delete _registry.indexOf[key];
        _registry.keys.pop();
        delete _registry.keyRoles[key];  // Remove the associated role
    }

    /**
     * @dev Grants a role (rank) to an account. This updates the registry and emits a RoleGranted event.
     * @param roleData The RoleData struct that holds the registry and ranks.
     * @param account The account to grant the role to.
     * @param rank The rank to assign to the account.
     */
    function grantRole(RoleData storage roleData, address account, Rank rank) public {
        uint256 key = uint256(uint160(account)); 
        roleData.ranks[account] = rank;
        Register(roleData.registry, key, rank);
        emit RoleGranted(account, rank);  // Emit event for granting role
    }

    /**
     * @dev Revokes a role (rank) from an account. This updates the registry and emits a RoleRevoked event.
     * @param roleData The RoleData struct that holds the registry and ranks.
     * @param account The account from which the role will be revoked.
     */
    function revokeRole(RoleData storage roleData, address account) public {
        uint256 key = uint256(uint160(account)); 
        Rank role = roleData.ranks[account];  // Capture the role before removal for the event
        delete roleData.ranks[account];
        Remove(roleData.registry, key);
        emit RoleRevoked(account, role);  // Emit event for revoking role
    }

    /**
     * @dev Checks whether an account holds the required role (rank) or higher.
     * @param roleData The RoleData struct that holds the registry and ranks.
     * @param requiredRank The minimum required rank for the account.
     * @param account The account to check for the required rank.
     */
    function checkRole(RoleData storage roleData, Rank requiredRank, address account) public view {
        require(roleData.ranks[account] >= requiredRank, "AccessControlUnauthorizedAccount");
    }

    /**
     * @dev Retrieves the highest rank assigned to an account.
     * @param roleData The RoleData struct that holds the registry and ranks.
     * @param account The account whose rank is being queried.
     * @return The highest rank held by the account.
     */
    function getHighestRankForAccount(RoleData storage roleData, address account) public view returns (Rank) {
        return roleData.ranks[account];
    }
}
