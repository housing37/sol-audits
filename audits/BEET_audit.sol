// PC (BEETroot) SOLAudits: 0xeDA0073B4Aa1b1B6f9c718c3036551ab46E5Ec32
// ref: https://oldscan.gopulse.com/#/address/0xeDA0073B4Aa1b1B6f9c718c3036551ab46E5Ec32?tab=contract
//  (BEETroot)
// auditor: @SOLAudits (t.me/SOLAudits0)
// audit_020624: https://pastebin.com/fHxzazY3

/** INDEX
    0) solidity language version
    1) public vs external access
    2) use of 'onlyOwner' modifier
    3) overriding ERC20 protocol functions
    4) spending the contract's held tokens
    5) obvious findings worth mentioning 
 */


/** _BEGIN AUDIT_ */

/** 
 0) solidity language version
    - this conract is using solidity v0.6.12
        this is 2 minor releases behind the latest 
            (the latest is v0.8.x)
        there have been significant security updates since v0.6
            ref: https://soliditylang.org/
 */
 // EXAMPLE: search 'pragma solidity' in any contract source code
    pragma solidity ^0.6.12;

/** 
 1) public vs external access
    - this contract only uses 'public' accessors for all is non-private functions
        this means that not only can EOA (wallet) address interact with this contract
            but also any other contract on the blockchain can interact witht this contract
    - this is a VERY HIGH SECURITY RISK    
        this ALLOWS extensive execution of the contact's code that can be hidden from block explorers
         (ie. another contract could execute multiple transfers of tokens in a single tx)
    - if the contract were to use 'external' accessor insteaf of 'public'
        this would be a lot safer, as it would allow only wallets to interfact with the contract
         and when wallets interact with a contract, they can generally only do one action per tx on the blockchain
          (ie. this makes significantly harder to hide activity from block explorers)
 */
 // EXAMPLE: search 'public' or 'external' in a contract source code
    function excludeFromReward(address account) public onlyOwner() {
    function includeInReward(address account) external onlyOwner() {

/** 
 2) use of 'onlyOwner' modifier
    - this contract does indeed inherit from the widely trusted Ownable.sol contract
    - this means the contract does indeed 'appear to be' following the widely accepted rules of using 'ownership'
    - however, this is not to say that other addresses cannot control the contract
        especialy if the contract uses 'public' accessors
    - WARNING: in this contract, the owner can be set to wallet address OR another contract address
 */
// EXAMPLE: search 'onlyOwner' or 'contract Ownable' or 'modifier onlyOwner' in any contract source code
    contract Ownable is Context {
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function excludeFromReward(address account) public onlyOwner() {

/** 
 3) overriding ERC20 protocol functions
    - using the abstract ERC20 protocol contract means that the
        contract 'intends' to follow all the rules of an ERC20 based token
    - HOWEVER, this does not mean that the contract is 'indeed' following all the rules
        this is where 'overriding' comes into play
    - if a contract 'overrides' an ERC20 function (like the _transfer function),
        then the contract is not following the rules and is changing what _transfer actually does
    - NOTE: if a contract is changing the rules...
        this could be changing the rules for 'better' or for 'worse'
        or this could be changing the rules to fascilitate a specific feature (like taxing transfers)
    - WARNING: this contract is overriding ALL of the ERC20 function rules
    - WARNING: this contract overrides the _transfer function and gives it the ability
        to freely choose which addresses to tax and not to tax when simply sending tokens
  */
//EXAMPLE: saerch 'ERC20' or 'IERC20' in any contract soure code
    contract BEETroot is Context, IERC20, Ownable {
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        //indicates if fee should be deducted from transfer
        bool takeFee = true;
        
        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }

/** 
 4) spending contract's held tokens
    - some contracts need the ability to spend misc tokens that are sent to it
        (this is not referring the contract's actual ERC20 token)
    - this contract does not contain that ability 
 */
// EXAMPLE: search 'IERC20(' in any contract source code
    IERC20(tokenAddress).transfer(recipient, amount);

/** 
 5) obvious findings worth mentioning 
    - WARNING: this contract retains the ability to freely choose who gets earns rewards and who doesn't 
    - WARNING: this contract retains the ability to freely choose who gets taxed and who doesn't
    - WARNING: this contract retains the ability to freely increase or decrease taxes
    - this activiety could allow admins to easily 'pinch' value from wallet holdings and go unoticed
 */
// EXAMPLE: 
    function includeInReward(address account) external onlyOwner() {
    function excludeFromReward(address account) public onlyOwner() {
    function includeInFee(address account) public onlyOwner {
    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {


/** _END AUDIT_ */