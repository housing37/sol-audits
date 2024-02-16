    // SPDX-License-Identifier: Unlicensed

    pragma solidity ^0.8.24;

    import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
    import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

    /**
    * @title SquirrelSwap
    * @dev A smart contract on PulseChain for redeeming SQS (Squirrels) NFTs for SQRL (SQUIRRELS) ERC-20 tokens and vice versa.
    */
    contract SquirrelSwap is ReentrancyGuard {

        // Contract addresses related to SquirrelSwap functionality.
        address public constant squirrelOriginAddress   = 0x62485524efC14D699f419f3F68a2b3d4e0661304; // Address filling the contract with sufficient SQRL for 555 NFT redemptions
        address public constant sqrlContract            = 0x4DD1473b0c0a6eD0f362250497DEac45B2bB8c42; // Address of SQRL ERC-20 token contract
        address public constant sqsNFTContract          = 0xbde24E5C36bE2008DbD5c08f6782e778f835920F; // Address of SQS (Squirrels) NFT contract

        // Constants
        uint256 private constant _totalSQSTokenSupply   = 555;        // Total supply of SQS (Squirrels) NFTs in the sqsNFTContract contract
        uint256 private constant _sqrlPerNFT            = 555 * 1e18; // Rate at which SQRL is redeemed per NFT. 555 SQRL per NFT

        /**
        * @dev Amount of SQRL tokens required to fill the contract with sufficient SQRL for 555 NFT redemptions.
        * Calculated as the product of _sqrlPerNFT (555 SQRL per NFT) and _totalSQSTokenSupply (total supply of SQS NFTs: 555).
        * This value, set at 308,025 SQRL, represents the specific amount needed for a successful execution of the fillSquirrelDrey function.
        */
        uint256 private constant _squirrelDreySupply  = _sqrlPerNFT * _totalSQSTokenSupply; 

        // Variables related to contract state and tracking.
        bool private hasFilledDrey;        // Boolean flag indicating whether the fillSquirrelDrey function has been successfully executed.
        uint256 public availableSQRL;      // Tracks the total amount of available SQRL in the contract.
        uint256 public availableNFTs;      // Tracks the total number of available NFTs in the contract.
        uint256[] private _availableIDs;   // Stores the tokenIDs of available NFTs in an array.
        

        // Events
        /**
        * @dev Emitted when the squirrelOriginAddress fills the contract with SQRL tokens.
        * @param SQRL The amount of SQRL tokens supplied to the contract.
        */
        event DreyFilled(uint256 SQRL);

        /**
        * @dev Emitted when an NFT is redeemed for SQRL.
        * @param redeemer The address redeeming the NFT for SQRL.
        * @param tokenIDRedeemed The tokenID of the redeemed NFT.
        * @param sqrlReceived The amount of SQRL tokens received in exchange for the NFT.
        */
        event NFTRedeemedForSQRL(
        address redeemer, 
        uint256 tokenIDRedeemed, 
        uint256 sqrlReceived
        );

        /**
        * @dev Emitted when SQRL tokens are redeemed for an NFT.
        * @param redeemer The address redeeming SQRL for an NFT.
        * @param tokenIDReceived The tokenID of the NFT received in exchange for SQRL.
        * @param sqrlRedeemed The amount of SQRL tokens redeemed for the NFT.
        */
        event SQRLRedeemedForNFT(
        address redeemer, 
        uint256 tokenIDReceived, 
        uint256 sqrlRedeemed
        );

        constructor() {
            // Initialize available SQRL and NFTs to 0.
            availableSQRL = 0;
            availableNFTs = 0;
        }

        /**
        * @dev Checks whether the caller has approved the contract to spend a specified amount of SQRL tokens.
        * @param amount The amount of SQRL tokens the caller is attempting to spend.
        * No explicit return value. Ensures that the allowance granted by the caller to this contract is greater than or equal to the specified SQRL amount.
        * Throws an error with a message if the caller's SQRL allowance is insufficient.
        */
        function checkSQRLApproval(uint256 amount) internal view {
            require(IERC20(sqrlContract).allowance(msg.sender, address(this)) >= amount, "Not enough SQRL allowance");
        }

        /**
        * @dev Checks whether the caller has approved the contract to transfer a specified NFT.
        * @param tokenID The identifier of the NFT the caller is attempting to transfer to this contract.
        * No explicit return value. Ensures that the specified NFT (identified by tokenID) is approved for transfer to this contract.
        * Throws an error with a message if the NFT is not approved for transfer to the contract.
        */
        function checkNFTApproval(uint256 tokenID) internal view {
            require(IERC721(sqsNFTContract).getApproved(tokenID) == address(this), "Not approved for NFT transfer");
        }

        /**
        * @dev Retrieves the array of available NFT IDs.
        * @return An array containing the available NFT IDs.
        */
        function getAvailableNFTs() external view returns (uint256[] memory) {
            return _availableIDs;
        }

        // fillSquirrelDrey
        /**
        * @dev Fills the contract with enough SQRL for 555 NFT redemptions.
        * Only the squirrelOriginAddress can initiate this function, and it can only be executed once.
        * Transfers 308,025 SQRL tokens from squirrelOriginAddress to the contract.
        * Emits a DreyFilled event to log the amount of SQRL tokens supplied.
        * @return The amount of SQRL supplied to the contract.
        */
        function fillSquirrelDrey() external nonReentrant returns (uint256) {
            require(msg.sender != address(0), "Invalid sender address");
            require(msg.sender == squirrelOriginAddress, "Only squirrelOriginAddress can fill contract with SQRL");
            require(!hasFilledDrey, "The squirrelOriginAddress has already initiated SQRL token supply");

            // Check if the squirrelOriginAddress has approved and has sufficient balance for transferring 308,025 SQRL to the contract.
            checkSQRLApproval(_squirrelDreySupply);
            require(IERC20(sqrlContract).balanceOf(msg.sender) >= _squirrelDreySupply, "Insufficient SQRL balance");
        
            hasFilledDrey = true;

            // Transfer SQRL tokens from squirrelOriginAddress to the contract
            IERC20(sqrlContract).transferFrom(msg.sender, address(this), _squirrelDreySupply);

            // Increase the available SQRL balance of the contract by _squirrelDreySupply
            availableSQRL += _squirrelDreySupply;

            emit DreyFilled(_squirrelDreySupply);

            return _squirrelDreySupply;
        }

        // redeemNFTForSQRL
        /**
        * @dev Deposits an NFT into the contract in exchange for SQRL.
        * Requires the contract to have sufficient SQRL to exchange for a redeemed NFT.
        * Transfers NFT from the caller to the contract and SQRL from the contract to the caller.
        * Emits an NFTRedeemedForSQRL event to log the NFT redemption.
        * @param tokenID The tokenID of the NFT to be redeemed.
        * @return A tuple containing the redeemed NFT's tokenID and the amount of SQRL transferred to the redeemer.
        */
        function redeemNFTForSQRL(uint256 tokenID) external nonReentrant returns (uint256, uint256) {
            require(msg.sender != address(0), "Invalid sender address");
            // Check the contract has sufficient SQRL to exchange for an NFT
            require(availableSQRL >= _sqrlPerNFT, "Insufficient SQRL in the contract");

            // Check the NFT is not already in the availableIDs array
            require(!isTokenIDAvailable(tokenID), "NFT already processed");

            // Check if the caller has approved and owns the specified NFT for transferring to the contract
            checkNFTApproval(tokenID); 
            require(IERC721(sqsNFTContract).ownerOf(tokenID) == msg.sender, "Caller does not own the specified NFT");

            // Update availableIDs, decrease available SQRL by _sqrlPerNFT, and increase available NFT count
            _availableIDs.push(tokenID);
            availableSQRL -= _sqrlPerNFT;
            availableNFTs += 1;

            // Transfer NFT from the caller to the contract
            IERC721(sqsNFTContract).transferFrom(msg.sender, address(this), tokenID);

            // Transfer SQRL from the contract to the caller
            IERC20(sqrlContract).transfer(msg.sender, _sqrlPerNFT);

            emit NFTRedeemedForSQRL(msg.sender, tokenID, _sqrlPerNFT);

            return (tokenID, _sqrlPerNFT);
        }

        // redeemSQRLForNFT
        /**
        * @dev Withdraws an NFT from the contract in exchange for SQRL.
        * Requires the contract to have an available NFT to exchange for redeemed SQRL.
        * Transfers SQRL from the caller to the contract and an NFT from the contract to the caller.
        * If no tokenID is specified, it withdraws the first available NFT in the _availableIDs array.
        * Emits an SQRLRedeemedForNFT event to log the SQRL redemption.
        * @param tokenID The tokenID of the NFT to be withdrawn (optional, use 0 for the first available).
        * @return A tuple containing the amount of SQRL redeemed and the tokenID of the NFT transferred to the redeemer.
        */
        function redeemSQRLForNFT(uint256 tokenID) external nonReentrant returns (uint256, uint256) {
            require(msg.sender != address(0), "Invalid sender address");
            // Check if the contract has an NFT to exchange for SQRL
            require(availableNFTs > 0, "Zero NFTs in the contract");

            // Check if the caller has approved and has sufficient balance for transferring 555 SQRL to the contract
            checkSQRLApproval(_sqrlPerNFT);
            require(IERC20(sqrlContract).balanceOf(msg.sender) >= _sqrlPerNFT, "Insufficient SQRL balance");

            // Check if the specified NFT tokenID is available for withdrawal. If no tokenID specified (0) use the first available NFT
            if (tokenID == 0) {

                tokenID = _availableIDs[0];
            } else {

                require(isTokenIDAvailable(tokenID), "Specified NFT is not available");
            }

            // Update availableIDs, increase available SQRL by _sqrlPerNFT, and decrease available NFT count
            removeAvailableNFT(tokenID);
            availableSQRL += _sqrlPerNFT;
            availableNFTs -= 1;

            // Transfer SQRL from the caller to the contract
            IERC20(sqrlContract).transferFrom(msg.sender, address(this), _sqrlPerNFT);

            // Transfer NFT from the contract to the caller
            IERC721(sqsNFTContract).transferFrom(address(this), msg.sender, tokenID);

            emit SQRLRedeemedForNFT(msg.sender, tokenID, _sqrlPerNFT);

            return (_sqrlPerNFT, tokenID);
        }

        /**
        * @dev Checks if a specified NFT tokenID is available for exchange.
        * This internal view function iterates through the availableNFTs array to check if the specified tokenID is present.
        * @param tokenID The tokenID to check.
        * @return Returns true if the tokenID is found in the array; otherwise, returns false if the tokenID is not found in the array.
        */
        function isTokenIDAvailable(uint256 tokenID) internal view returns (bool) {
            for (uint256 i = 0; i < availableNFTs; i++) {
                if (_availableIDs[i] == tokenID) {
                    return true;
                }
            }
            return false;
        }

        /**
        * @dev Removes a withdrawn NFT tokenID from the availableNFTs array.
        * This internal function iterates through the availableNFTs array to find the specified tokenID.
        * If the tokenID is found, it moves the last element to the removed position and then decreases the array length.
        * @param tokenID The tokenID to be removed.
        */
        function removeAvailableNFT(uint256 tokenID) internal {
            for (uint256 i = 0; i < availableNFTs; i++) {
                if (_availableIDs[i] == tokenID) {

                    _availableIDs[i] = _availableIDs[availableNFTs - 1];
                    _availableIDs.pop();
                    return;
                }
            }
        }
    }
