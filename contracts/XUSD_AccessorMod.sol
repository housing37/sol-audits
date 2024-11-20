// ref: https://oldscan.gopulse.com/#/address/0xbbeA78397d4d4590882EFcc4820f03074aB2AB29?tab=contract_code
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Classes/AccessManager.sol";

/**
 * @title BaseClass
 * @dev This is an abstract base class contract that includes basic functionalities for user activation and class basis management.
 */
abstract contract AccesorMod {
 using AuthLib for AuthLib.RoleData;

AccessManager accessControl;


 constructor(address access){
    accessControl = AccessManager(access);
 }
   
   modifier onlyPreatormaximus() {
        require(accessControl.checkRole(msg.sender,  AuthLib.Rank.PREATORMAXIMUS),"Access Restricted");
        _;
    }

      modifier onlyGladiator() {
        require(accessControl.checkRole(msg.sender,  AuthLib.Rank.GLADIATOR), "Access Restricted");
        _;
    }

    modifier onlySenator() {
        require(accessControl.checkRole(msg.sender,  AuthLib.Rank.SENATOR), "Access Restricted");
        _;
    }

    modifier onlyConsul() {
        require(accessControl.checkRole(msg.sender,  AuthLib.Rank.CONSUL),"Access Restricted");
        _;
    }

      modifier onlyLegatus() {
        require(accessControl.checkRole(msg.sender,  AuthLib.Rank.LEGATUS),"Access Restricted");
        _;
    }
   


    uint256 private locked = 1;

    modifier nonReentrant() virtual {
        require(locked == 1, "REENTRANCY");

        locked = 2;

        _;

        locked = 1;
    }

   
}
