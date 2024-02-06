// ETH/PC (DAI/pDAI) SOLAudits: 0x6B175474E89094C44Da98b954EedeAC495271d0F
// ref: https://etherscan.io/address/0x6B175474E89094C44Da98b954EedeAC495271d0F#code
// auditor: @SOLAudits (t.me/SOLAudits0)
// audit_020624: https://pastebin.com/eESVYjEM

/** 
 INDEX
    0) solidity language version
    1) public vs external access
    2) use of 'onlyOwner' modifier
    3) following the ERC20 protocol rules
    4) spending the contract's held tokens
    5) obvious findings worth mentioning 
 */

/** _BEGIN AUDIT_ */

/** 
 0) solidity language version
    - this conract is using solidity v0.5.12
        this is 3 minor releases behind the latest (the latest is v0.8.x)
         its pretty old, but it was the newest when the contract was launched years ago
        there have been significant security updates since v0.5.x
            ref: https://soliditylang.org/

 DO IT YOURSELF:
    simply search 'pragma solidity' in any contract source code
 */
 // EXAMPLE (in this contract): 
    pragma solidity =0.5.12;


/** 
 1) public vs external access
    - this contract is INDEED completely standard and follows the ERC20 protocol exactly (it does NOT ignore these rules)
        NOTE: a 'protocol' is just another word meaning 'a set of rules'
        NOTE: contracts can choose to ignore these rules while still 'claiming' to follow these rules
        NOTE: if a contract chooses to ignore these rules (ie. 'override' them):
            this could mean the contract is changing things for better or for worse.
                (ie. it does neccessarily bad or good, it just means its not standard)
            HOWEVER: the more rules that it ignores, the less trustworty it generally is

    - this contract does INDEED use 'public' access and 'external' access safely
        NOTE: when a contract uses the word 'public' instead of (or more often than) 'external', it is less safe
            this means that the contract has the ability to hide activity from block explorers (like etherscan.io, etc.)

 DO IT YOURSELF:
    simpy search 'public' or 'external' in any contract source code
 */
 // EXAMPLE (in this contract):
    function transfer(address dst, uint wad) external returns (bool) {


/** 
 2) use of 'onlyOwner' modifier
    - this contract does NOT use the widely trusted 'owner' rules (from the 'Ownable.sol' contract)
        NOTE: when a contract includes the 'owner' feature, it is simply claiming to follow a set of rules
            but any contract can 'claim' this, and still go against them in the source code (to fool people)
    - HOWEVER, this contract was created before be the 'owner' rules were invented
    - HENCE, it does something similar but instead of declaring an 'owner', it declares a 'ward'

    - NOTE: the 'ward' (owner) does INDEED have the ability to mint tokens whenever they want 
    - HOWEVER: this ability to mint is completely logical considering how the DAI stable algorithm works
        (ie. it needs to be able to add & remove tokens from the market in order to maintain stability)
    - WARNING: there is absolutely no way to check and see what the ward (owner) address is
    - WARNING: there is absolutely no way to check and see if there are 0 'wards' (owners), or many 'wards' (owners)
    
 DO IT YOURSELF:
    simply search 'onlyOwner' or 'contract Ownable' or 'modifier onlyOwner' in any contract source code
 */
// EXAMPLE (in this contract):
    N / A


/** 
 3) following the ERC20 protocol rules
    - this contract is INDEED completely standard and follows the ERC20 protocol exactly (it does NOT ignore these rules)
        NOTE: a 'protocol' is just another word meaning 'a set of rules'
        NOTE: contracts can choose to ignore these rules while still 'claiming' to follow these rules
        NOTE: if a contract chooses to ignore these rules (ie. 'override' them):
            this could mean the contract is changing things for better or for worse.
                (ie. it does neccessarily bad or good, it just means its not standard)
            HOWEVER: the more rules that it ignores, the less trustworty it generally is

    - this contract does NOT ignore any rules ('override' is not found anywhere in the code)

 DO IT YOURSELF:
    simply search 'override' in any contract source code 
        (the more you find, the less trustworty it is)
 */
// EXAMPLE (in this contract):
    N / A


/** 
 4) spending contract's held tokens
    - some contracts need the ability to access (spend) misc tokens that are sent to it
        NOTE: this depends on what the contract was actually created to do
        NOTE: this is NOT referring the contract's actual ERC20 token that it represents

    - this contract does NOT contain the ability to access (spend) misc tokesn that are sent

 DO IT YOURSELF:
    simply search 'IERC20(' in any contract source code
 */
// EXAMPLE: 
    N / A

/** 
 5) obvious findings worth mentioning 
    - NOTE: the 'ward' (owner) does INDEED have the ability to mint tokens whenever they want 
    - HOWEVER: this ability to mint is completely logical considering how the DAI stable algorithm works
        (ie. it needs to be able to add & remove tokens from the market in order to maintain stability)
    - WARNING: there is absolutely no way to check and see what the ward (owner) address is
    - WARNING: there is absolutely no way to check and see if there are 0 'wards' (owners), or many 'wards' (owners)

 DO IT YOURSELF:
    N / A
 */
// EXAMPLE (in this contract):
    N / A

/** _END AUDIT_ */
