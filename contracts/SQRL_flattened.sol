
// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.20;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: .deps/npm/@openzeppelin/contracts/SquirrelSwap.sol



    pragma solidity ^0.8.24;




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
