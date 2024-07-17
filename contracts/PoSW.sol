// SPDX-License-Identifier: UNLICENSED
// ref (pc): 0xa2C927116f024CF21c4e6c6349C67e54ea267Dda
pragma solidity ^0.8.0;

import "github.com/ProofOfNoWork/PoNWContract/blob/main/PoNWToken.sol";

contract PoSW {
    using SafeMath for uint256;
    
    string public name = "Proof of Some Work";
    string public symbol = "PoSW";
    uint256 public constant MAX_TOTAL_SUPPLY = 33_000_000_000_000 * 1e18; // 33 trillion in wei

    address public owner;
    PoNW public PoNWToken;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public poNWBalance; // PoNW balance held by the PoSW contract
    mapping(address => mapping(address => uint256)) public allowance; // Mapping to keep track of allowances

    uint256 public totalSupply;
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed user, uint256 value);
    event Redeem(address indexed user, uint256 value);
    event Burn(address indexed user, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ApprovalRevoked(address indexed owner, address indexed spender);

    constructor(address payable _PoNWToken) {
        owner = msg.sender;
        PoNWToken = PoNW(_PoNWToken); // Assign the address as a contract instance
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        require(_spender != address(0), "Invalid spender address");
    
        // Set the spender's allowance for the sender
        allowance[msg.sender][_spender] = _value;
    
        // Emit an "Approval" event to log the approval
        emit Approval(msg.sender, _spender, _value);
    
        return true;
    }

    function revokeApproval(address _spender) external returns (bool success) {
        require(_spender != address(0), "Invalid spender address");
    
        // Revoke the spender's allowance for the sender
        allowance[msg.sender][_spender] = 0;
    
        // Emit an "ApprovalRevoked" event to log the revocation
        emit ApprovalRevoked(msg.sender, _spender);
    
        return true;
    }

    function mint2To1(uint256 _amountToMint) external returns (bool success) {
        require(_amountToMint > 0, "Invalid amount");
        uint256 senderPoNWBalance = PoNWToken.balanceOf(msg.sender);
        require(senderPoNWBalance >= _amountToMint, "Insufficient PoNW balance");

        // Calculate the amount of PoSW tokens to mint based on the amount of PoNW burned x2
        uint256 mintAmount = _amountToMint * 2;

        // Ensure the total supply doesn't exceed the maximum
        require(totalSupply + mintAmount <= MAX_TOTAL_SUPPLY, "Exceeds max total supply");

        // Mint PoSW tokens to the sender
        balanceOf[msg.sender] += mintAmount;
        totalSupply += mintAmount;

        // Transfer PoNW tokens from the sender to the contract
        require(PoNWToken.transferFrom(msg.sender, address(this), _amountToMint), "Transfer failed");

        emit Transfer(address(0x0000000000000000000000000000000000000369), msg.sender, mintAmount);
        emit Mint(msg.sender, mintAmount);
        return true;
    }

    function mint1To1(uint256 _amountToMint) external returns (bool success) {
        require(_amountToMint > 0, "Invalid amount");
        uint256 senderPoNWBalance = PoNWToken.balanceOf(msg.sender);
        require(senderPoNWBalance >= _amountToMint, "Insufficient PoNW balance");

        // Mint PoSW tokens to the sender at a 1:1 ratio based on the user's selection
        uint256 mintAmount = _amountToMint;

        // Ensure the total supply doesn't exceed the maximum
        require(totalSupply + mintAmount <= MAX_TOTAL_SUPPLY, "Exceeds max total supply");

        balanceOf[msg.sender] += mintAmount;
        poNWBalance[msg.sender] += _amountToMint;
        totalSupply += mintAmount;

        // Transfer PoNW tokens from the sender to the contract
        require(PoNWToken.transferFrom(msg.sender, address(this), _amountToMint), "Transfer failed");

        emit Transfer(address(0), msg.sender, mintAmount);
        emit Mint(msg.sender, mintAmount);
        return true;
    }

    function redeem(uint256 _value) external returns (bool success) {
        require(_value > 0, "Invalid amount");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        // Calculate the amount of PoNW tokens to redeem (after tax)
        uint256 redemptionAmount = (_value * 97) / 100; // 97% after a 3% tax
        require(poNWBalance[msg.sender] >= redemptionAmount, "Insufficient PoNW balance");

        // Reduce PoSW and PoNW balances
        balanceOf[msg.sender] -= _value;
        poNWBalance[msg.sender] -= redemptionAmount;

        // Transfer PoNW tokens to the sender
        require(PoNWToken.transfer(msg.sender, redemptionAmount), "Transfer failed");

        emit Transfer(msg.sender, address(0x0000000000000000000000000000000000000369), _value); // Burn PoSW tokens
        emit Redeem(msg.sender, redemptionAmount);
        return true;
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value > 0, "Invalid amount");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_from != address(0), "Invalid sender address");
        require(_to != address(0), "Invalid recipient address");
        require(_value > 0, "Invalid amount");

        uint256 allowedAmount = allowance[_from][msg.sender];
        require(allowedAmount >= _value, "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }


    function burnOwnership() external onlyOwner {
        owner = address(0); // Renounce ownership to the dead address
    }

    function getPoSWBurned() external view returns (uint256) {
        // Return the PoSW balance held by the contract at address 0x0000000000000000000000000000000000000369
        return balanceOf[address(0x0000000000000000000000000000000000000369)];
    }

}
