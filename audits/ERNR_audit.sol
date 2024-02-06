
// PC audit: 0xee89b3a7c020e1b60575fd2b09afe8aa317a0656
// ref: https://oldscan.gopulse.com/#/address/0xee89b3a7c020e1b60575fd2b09afe8aa317a0656?tab=contract
//  (ERNR)
// auditor: @SOLAudits (t.me/SOLAudits0)
// audit_020624: pastebin.com/b0zfYqSX

/** public vs external access
    - contract indeed limits 'public' access and uses the 'external' keyword accordingly
    - this means that other contracts cannot execute calls to / interact with this contract
        only EOA / wallet addresses can interact with this contract
        this prevents extensive execution of the contacts code that can be hidden from block explorers
 */
 // EXAMPLE: search the use of 'external' keyword 
     function deposit(uint256 amount) external override onlyOwner {
        totalDividends = totalDividends + amount;
        dividendsPerShare = dividendsPerShare + dividendsPerShareAccuracyFactor * amount / totalShares;
		emit NewFundDeposit(amount);
    }

/** use of 'onlyOwner' modifier
    - contract has integrated is personalized 'onlyOwner' modifier (in parts of its code)
    - this means that is keeps track of a single address that can perform special actions 
        that no other address can do (a common action could be minting tokens)
    - however, it is worth noting that only part of this contract is not inheriting / using 
        the standard recognized Ownable.sol contract but instead, it has manually coded in its own 'onlyOwner' modifier
            however, the rest of the contract is indeed using 'Ownable.sol' just fine
        this is not great risk, since the 'onlyOwner' modifier is fairly simple (but still worth noting)
        this was probably just a minor oversite on the dev's part
 */
 // EXAMPLE: search 'contract Distributor' vs. 'contract ERNR is ERC20, Ownable'
     modifier onlyOwner() {
        require(msg.sender == owner, "!Token"); _;
    }

/** overriding ERC20 functions
    - when a contract 'overrides' a function, it means it is rewriting / changing a common function
        example: all ERC20 contracts have a '_tranfer' function that used to send tokens
            from one address to another
        if a contract 'overrides' this '_transfer' function, then that means the contract does something more
            or something else when someone uses it to send tokens from one address to another
    - this contract does indeed override the '_transfer' function
        it appears the addition of removing fees has been added when sending tokens
    - it also appears that the owner of this contract has the ability to pick and choose which addresses
        will have fees removed from them (this could be a red flag)
 */
 // EXAMPLE: if the sender is in the list 'isExcludedFromFee', then a transfer is processed normally
 //             otherwise, fees are removed
 	function _transfer(address sender, address recipient, uint256 amount) internal override(ERC20){ 
        if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) 
		{
            super._transfer(sender, recipient, amount);
        }
		else 
		{
		    (uint256 txnBurnFee, uint256 txnReflectionFee) = collectFee(amount, isAutomatedMarketMakerPairs[recipient], !isAutomatedMarketMakerPairs[sender] && !isAutomatedMarketMakerPairs[recipient]);
			if(txnBurnFee > 0) 
			{
/** Owner has the ability to freely spend tokens held by this contract address
    - there is function that allows the owner to withdraw tokens held by this contract
        NOTE: this is NOT referring this ERC20 contract token (but rather tokens that are sent to this contract)
    - WARNING: if this contract is meant to specifically distribute various tokens 
        as rewards to holders (or something like that), then this could be a red flag
         since the contract owner can freely do whatever it wants with these tokens at any time
    - also, the name of this function 'batchAirdrop', which is 'could be' misleading
        its possible that the word 'airdrop' is a designed feature by the admins of this contract
        HOWEVER, ultimately, this function simply lets the owner freely spend 
            whatever tokens they want that the contrat holds at any given time
 */
 // EXAMPLE: search 'batchAirdrop'
 	function batchAirdrop(address tokenAddress, address[] memory recipients, uint256[] memory amounts) public onlyOwner {
        require(recipients.length == amounts.length, "Arrays length mismatch");

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = amounts[i];

            require(recipient != address(0), "Invalid recipient address");
            require(amount > 0, "Amount must be greater than zero");

            IERC20(tokenAddress).transfer(recipient, amount);
        }
    }