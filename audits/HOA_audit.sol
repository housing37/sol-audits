// SOLAudits PC (HOA): 0x7901a3569679AEc3501dbeC59399F327854a70fe
// ref: https://oldscan.gopulse.com/#/address/0x7901a3569679AEc3501dbeC59399F327854a70fe?tab=contract_code
// auditor: @SOLAudits (t.me/SOLAudits0)
// audit_021224: https://pastebin.com/pR4z63kq

/** 
 INDEX
    0) solidity language version
    1) public vs external access
    2) use of 'onlyOwner' modifier
    3) following the ERC20 protocol rules
    4) accessing contract held tokens
    5) obvious findings worth mentioning 
 */

/** _BEGIN AUDIT_ */

/**
 -1) opening notes
    NOTE: this contract has no abilities at all, it does absolutely nothing
        - it is a classic meme coin
        - there was a specific number of tokens minted to a single address when the contract was created
        - there is no owner to mint (no more tokens can ever be minted)
        - there are no taxes applied to transfers (no one can change this feature)
        - no one can be blacklisted or banned from using this token
        - no admins can remove your tokens
        - there is litterally only 3 lines of code in this contract (example below)
        - ADDITIONALLY, this code is a directy copy of the GoPulseToken template from gopulse.com
            (ie. no one actually wrote any code from the HOA team)
 */
 // EXAMPLE (this is the entire contract):
    contract GoPulseToken is ERC20 {
        constructor(
            uint _supply,
            string memory _name,
            string memory _ticker
        ) ERC20(_name, _ticker) {
            _mint(msg.sender, _supply * 10 ** decimals());
        }
    }


/** 
 0) solidity language version
    - this conract is using solidity v0.8.0
        this is INDEED the latest version of solidity
        ref: https://soliditylang.org/

 DO IT YOURSELF:
    simply search 'pragma solidity' in any contract source code
 */
 // EXAMPLE (in this contract): 
    pragma solidity ^0.8.0;


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
    function transfer(address to, uint256 value) external returns (bool);


/** 
 2) use of 'onlyOwner' modifier
    - this contract does NOT use the widely trusted 'owner' rules (from the 'Ownable.sol' contract)
        NOTE: when a contract includes the 'owner' feature, it is simply claiming to follow a set of rules
            but any contract can 'claim' this, and still go against them in the source code (to fool people)

    NOTE: this contract has no abilities at all, it does absolutely nothing
        - it is a classic meme coin
        - there was a specific number of tokens minted to a single address when the contract was created
        - there is no owner to mint (no more tokens can ever be minted)
        - there are no taxes applied to transfers (no one can change this feature)
        - no one can be blacklisted or banned from using this token
        - no admins can remove your tokens
        - there is litterally only 3 lines of code in this contract (example below)
        - ADDITIONALLY, this code is a directy copy of the GoPulseToken template from gopulse.com
            (ie. no one actually wrote any code from the HOA team)
    
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
 4) accessing contract held tokens
    NOTE: some contracts need the ability to access (spend) misc tokens that are sent to it
        - this depends on what the contract was actually created to do
        - this is NOT referring the contract's actual ERC20 token that it represents

    - this contract does NOT contain the ability to access (spend) misc tokens that are sent to it
        NOTE: any tokens sent this contract can never be accessed again

 DO IT YOURSELF:
    simply search 'IERC20(' in any contract source code
 */
// EXAMPLE: 
    N / A

/** 
 5) obvious findings worth mentioning 
    NOTE: this contract has no abilities at all, it does absolutely nothing
        - it is a classic meme coin
        - there was a specific number of tokens minted to a single address when the contract was created
        - there is no owner to mint (no more tokens can ever be minted)
        - there are no taxes applied to transfers (no one can change this feature)
        - no one can be blacklisted or banned from using this token
        - no admins can remove your tokens
        - there is litterally only 3 lines of code in this contract (example below)
        - ADDITIONALLY, this code is a directy copy of the GoPulseToken template from gopulse.com
            (ie. no one actually wrote any code from the HOA team)

 DO IT YOURSELF:
    N / A
 */
// EXAMPLE (in this contract):
    contract GoPulseToken is ERC20 {
        constructor(
            uint _supply,
            string memory _name,
            string memory _ticker
        ) ERC20(_name, _ticker) {
            _mint(msg.sender, _supply * 10 ** decimals());
        }
    }

/** _END AUDIT_ */
