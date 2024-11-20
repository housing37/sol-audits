// ref: https://oldscan.gopulse.com/#/address/0xbbeA78397d4d4590882EFcc4820f03074aB2AB29?tab=contract_code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Access.sol"; // Assuming AuthLib includes all the functionality as discussed

/**
 * @title AccessManager
 * @dev A contract for managing role-based access control. Allows accounts to be granted or revoked roles, and checks for required ranks.
 * This contract uses the AuthLib library for role management.
 */
contract AccessManager {
    using AuthLib for AuthLib.RoleData;

    // State variable for storing role data
    AuthLib.RoleData private roleData;

    // Event declarations for logging changes in role assignments
    event RoleGranted(address indexed account, AuthLib.Rank role);
    event RoleRevoked(address indexed account);
    modifier onlyGladiator() {
        require(checkRole(msg.sender,  AuthLib.Rank.GLADIATOR), "Access Restricted");
        _;
    }

    modifier onlySenator() {
        require(checkRole(msg.sender,  AuthLib.Rank.SENATOR), "Access Restricted");
        _;
    }

    modifier onlyConsul() {
        require(checkRole(msg.sender,  AuthLib.Rank.CONSUL),"Access Restricted");
        _;
    }

    modifier onlyLegatus() {
        require(checkRole(msg.sender,  AuthLib.Rank.LEGATUS),"Access Restricted");
        _;
    }
                    
    modifier onlyPreatormaximus() {
        require(checkRole(msg.sender,  AuthLib.Rank.PREATORMAXIMUS),"Access Restricted");
        _;
    }
       uint256 private locked = 1;

    modifier nonReentrant() virtual {
        require(locked == 1, "REENTRANCY");

        locked = 2;

        _;

        locked = 1;
    }
    /**
     * @dev Constructor that grants the contract deployer the highest role (PREATORMAXIMUS).
     */
    constructor() {
        // Grant the deployer the highest role initially
        roleData.grantRole(msg.sender, AuthLib.Rank.PREATORMAXIMUS);
    }

    /**
     * @notice Grants a specific role to an account.
     * @dev Only accounts with the CONSUL or higher role can grant roles.
     * @param account The address of the account to grant the role to.
     * @param rank The rank (role) to assign to the account.
     */
    function grantRole(address account, AuthLib.Rank rank) public {
        // Check if the caller has sufficient privileges (CONSUL or higher)
        require(
            roleData.getHighestRankForAccount(msg.sender) >= AuthLib.Rank.CONSUL,
            "Insufficient privileges to grant roles."
        );
        // Grant the role to the specified account
        roleData.grantRole(account, rank);
        // Emit an event for logging
        emit RoleGranted(account, rank);
    }

    /**
     * @notice Revokes a role from a specific account.
     * @dev Only accounts with the CONSUL or higher role can revoke roles.
     * @param account The address of the account to revoke the role from.
     */
    function revokeRole(address account) public {
        // Check if the caller has sufficient privileges (CONSUL or higher)
        require(
            roleData.getHighestRankForAccount(msg.sender) >= AuthLib.Rank.CONSUL,
            "Insufficient privileges to revoke roles."
        );
        // Revoke the role from the specified account
        roleData.revokeRole(account);
        // Emit an event for logging
        emit RoleRevoked(account);
    }

    /**
     * @notice Checks if an account has a specific role or higher.
     * @param account The address of the account to check.
     * @param rank The required rank to check against.
     * @return True if the account holds the required rank or higher, false otherwise.
     */
    function checkRole(address account, AuthLib.Rank rank) public view returns (bool) {
        // Check if the account has the specified role or higher
        return roleData.getHighestRankForAccount(account) >= rank;
    }

    /**
     * @notice Returns the highest rank (role) assigned to an account.
     * @param account The address of the account to query.
     * @return The rank held by the account.
     */
    function getAccountRank(address account) public view returns (AuthLib.Rank) {
        // Retrieve the highest rank assigned to the account
        return roleData.getHighestRankForAccount(account);
    }
}
