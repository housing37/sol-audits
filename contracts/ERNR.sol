//SPDX-License_Identifier: MIT


pragma solidity ^0.8.0;

interface IDistributor {
   function setDistributionCriteria(uint256 minPeriod, uint256 minDistribution) external;
   function setShare(address shareholder, uint256 amount) external;
   function deposit(uint256 amount) external;
   function process(uint256 gas) external;
}

contract Distributor is IDistributor {
    address owner;
	
    struct Share {
	  uint256 amount;
	  uint256 totalExcluded;
	  uint256 totalRealised;
    }
	
    address[] shareholders;
    mapping (address => uint256) public shareholderIndexes;
    mapping (address => uint256) public shareholderClaims;
    mapping (address => Share) public shares;
	
	event DistributionCriteriaUpdate(uint256 minPeriod, uint256 minDistribution);
	event NewFundDeposit(uint256 amount);

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public constant dividendsPerShareAccuracyFactor = 10 ** 36;
	
    uint256 public minPeriod = 100;
    uint256 public minDistribution = 1 * (10 ** 18);
	
    uint256 currentIndex;
	
    modifier onlyOwner() {
        require(msg.sender == owner, "!Token"); _;
    }
	
    constructor () {
        owner = msg.sender;
    }
	
	receive() external payable {}
	
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyOwner {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
		emit DistributionCriteriaUpdate(minPeriod, minDistribution);
    }
	
    function setShare(address shareholder, uint256 amount) external override onlyOwner {
        if(shares[shareholder].amount > 0)
		{
            distributeDividend(shareholder);
        }
		if(amount > 0 && shares[shareholder].amount == 0)
		{
           addShareholder(shareholder);
        }
		else if(amount == 0 && shares[shareholder].amount > 0)
		{
           removeShareholder(shareholder);
        }
        totalShares = totalShares - shares[shareholder].amount + amount;
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit(uint256 amount) external override onlyOwner {
        totalDividends = totalDividends + amount;
        dividendsPerShare = dividendsPerShare + dividendsPerShareAccuracyFactor * amount / totalShares;
		emit NewFundDeposit(amount);
    }
	
    function process(uint256 gas) external override onlyOwner {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(currentIndex >= shareholderCount)
			{
                currentIndex = 0;
            }
            if(shouldDistribute(shareholders[currentIndex]))
			{
                distributeDividend(shareholders[currentIndex]);
            }
            gasUsed = gasUsed + gasLeft - gasleft();
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }

    function shouldDistribute(address shareholder) internal view returns (bool) {
        return (shareholderClaims[shareholder] + minPeriod) < block.timestamp && getUnpaidEarnings(shareholder) > minDistribution;
    }
	
    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }
		
        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0) 
		{
		    (bool success, ) = shareholder.call{value: amount}("");
			if(success)
			{
			   totalDistributed = totalDistributed + amount;
			   shareholderClaims[shareholder] = block.timestamp;
			   shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
			   shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
			}
        }
    }
	
    function claimReflection() external {
		if(shouldDistribute(msg.sender)) 
		{
		   distributeDividend(msg.sender);
		}
    }
	
    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
        return shareholderTotalDividends - shareholderTotalExcluded;
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share * dividendsPerShare / dividendsPerShareAccuracyFactor;
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }
	
    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }

    
}
// File: contracts/IPulseX.sol



pragma solidity 0.8.2;

interface IPulseXFactory {
   function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IPulseXRouter {
   function factory() external pure returns (address);
   function WPLS() external pure returns (address);
   function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
}

// File: contracts/Context.sol



pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
	
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
// File: contracts/Ownable.sol



pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/IERC20.sol



pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
	
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
// File: contracts/IERC20Metadata.sol



pragma solidity ^0.8.0;


interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}
// File: contracts/ERC20.sol



pragma solidity ^0.8.0;




contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
	
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
	
    function name() public view virtual override returns (string memory) {
        return _name;
    }
	
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
	
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
	
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
	
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
	
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
	
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
	
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
	
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
	
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }
	
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
	
    function _transfer(address from, address to, uint256 amount ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }
	
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }
	
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }
	
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
	
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
	
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

//SPDX=License_Identifier: MIT

pragma solidity 0.8.2;





contract ERNR is ERC20, Ownable {
	uint256[] public reflectionFee;
	uint256[] public burnFee;
	
	uint256 public swapTokensAtAmount;
	uint256 public distributorGas;
	
	IPulseXRouter public pulseXRouter;
    address public pulseXPair;
	address public burnAddress;
	address public distributorAddress;
	Distributor distributor;
	
	bool private swapping;
	bool public distributionEnabled;
	
	mapping (address => bool) isDividendExempt;
	mapping (address => bool) public isExcludedFromFee;
	mapping (address => bool) public isAutomatedMarketMakerPairs;
	
	event AccountExcludeFromFee(address account, bool status);
	event SwapTokensAmountUpdated(uint256 amount);
	event AutomatedMarketMakerPairUpdated(address pair, bool value);
	event BurnFeeUpdated(uint256 buy, uint256 sell, uint256 p2p);
    event ReflectionFeeUpdated(uint256 buy, uint256 sell, uint256 p2p);

	constructor(address owner) ERC20("ERNR", "ERNR") {
	
	   burnAddress = address(0x0000000000000000000000000000000000000369);
	   pulseXRouter = IPulseXRouter(0x165C3410fC91EF562C50559f7d2289fEbed552d9);
       pulseXPair = IPulseXFactory(pulseXRouter.factory()).createPair(address(this), pulseXRouter.WPLS());
	   
	   distributor = new Distributor();
	   distributorAddress = address(distributor);
	   
	   reflectionFee.push(200);
	   reflectionFee.push(200);
	   reflectionFee.push(0);
	   
	   burnFee.push(100);
	   burnFee.push(100);
	   burnFee.push(0);
	   
	   isExcludedFromFee[address(owner)] = true;
       isExcludedFromFee[address(this)] = true;
	   
	   isDividendExempt[address(pulseXPair)] = true;
       isDividendExempt[address(this)] = true;
	   isDividendExempt[address(burnAddress)] = true;
	   
	   isAutomatedMarketMakerPairs[address(pulseXPair)] = true;   
	   swapTokensAtAmount = 100 * (10 ** 18);
	   distributorGas = 250000;
	   
	   distributionEnabled = true;
	   _mint(address(owner), 80000000000 * (10 ** 18));
    }
	
	receive() external payable {}
	
	function excludeFromFee(address account, bool status) external onlyOwner {
	   require(isExcludedFromFee[account] != status, "Account is already the value of 'status'");
	   
	   isExcludedFromFee[account] = status;
	   emit AccountExcludeFromFee(account, status);
	}
	
	function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
  	    require(amount <= totalSupply(), "Amount cannot be over the total supply.");
		require(amount >= 1 * (10 ** 18), "Minimum `500` token per swap required");
		
		swapTokensAtAmount = amount;
		emit SwapTokensAmountUpdated(amount);
  	}
	
	function setReflectionFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
	    require(burnFee[0] + buy  <= 2000 , "Max fee limit reached for 'BUY'");
		require(burnFee[1] + sell <= 2000 , "Max fee limit reached for 'SELL'");
		require(burnFee[2] + p2p  <= 2000 , "Max fee limit reached for 'P2P'");
		
		reflectionFee[0] = buy;
		reflectionFee[1] = sell;
		reflectionFee[2] = p2p;
		emit ReflectionFeeUpdated(buy, sell, p2p);
	}
	
	function setBurnFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
	    require(reflectionFee[0] + buy  <= 1000 , "Max fee limit reached for 'BUY'");
		require(reflectionFee[1] + sell <= 1000 , "Max fee limit reached for 'SELL'");
		require(reflectionFee[2] + p2p  <= 1000 , "Max fee limit reached for 'P2P'");
		
		burnFee[0] = buy;
		burnFee[1] = sell;
		burnFee[2] = p2p;
		emit BurnFeeUpdated(buy, sell, p2p);
	}
	
	function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
        require(pair != address(0), "Zero address");
		
		isAutomatedMarketMakerPairs[address(pair)] = value;
		emit AutomatedMarketMakerPairUpdated(pair, value);
    }
	
	function _transfer(address sender, address recipient, uint256 amount) internal override(ERC20){      
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

		uint256 contractTokenBalance = balanceOf(address(this));
		bool canSwap = contractTokenBalance >= swapTokensAtAmount;
		
		if (canSwap && !swapping && isAutomatedMarketMakerPairs[recipient]) 
		{
			swapping = true;
			swapTokensForPLS(swapTokensAtAmount);
			uint256 PLSBalance = address(this).balance;
			payable(distributorAddress).transfer(PLSBalance);
			distributor.deposit(PLSBalance);
			swapping = false;
        }
		
		if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) 
		{
            super._transfer(sender, recipient, amount);
        }
		else 
		{
		    (uint256 txnBurnFee, uint256 txnReflectionFee) = collectFee(amount, isAutomatedMarketMakerPairs[recipient], !isAutomatedMarketMakerPairs[sender] && !isAutomatedMarketMakerPairs[recipient]);
			if(txnBurnFee > 0) 
			{
			    super._transfer(sender, address(burnAddress), txnBurnFee);
			}
			if(txnReflectionFee > 0) 
			{
			    super._transfer(sender, address(this), txnReflectionFee);
			}
			super._transfer(sender, recipient, amount - txnBurnFee - txnReflectionFee);
        }
		
		if(!isDividendExempt[sender]){ try distributor.setShare(sender, balanceOf(sender)) {} catch {} }
        if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, balanceOf(recipient)) {} catch {} }
		if(distributionEnabled) 
		{
		   try distributor.process(distributorGas) {} catch {}
		}
    }
	
	function collectFee(uint256 amount, bool sell, bool p2p) private view returns (uint256, uint256) {
        uint256 neBurnFee = amount * (p2p ? burnFee[2] : sell ? burnFee[1] : burnFee[0]) / 10000;
		uint256 newReflectionFee = amount * (p2p ? reflectionFee[2] : sell ? reflectionFee[1] : reflectionFee[0]) / 10000;
        return (neBurnFee, newReflectionFee);
    }
	
	function swapTokensForPLS(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pulseXRouter.WPLS();
		
        _approve(address(this), address(pulseXRouter), tokenAmount);
        pulseXRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }
	
	function setIsDividendExempt(address holder, bool status) external onlyOwner {
       isDividendExempt[holder] = status;
       if(status)
	   {
            distributor.setShare(holder, 0);
       }
	   else
	   {
            distributor.setShare(holder, balanceOf(holder));
       }
    }
	
	function setDistributionStatus(bool status) external onlyOwner {
        distributionEnabled = status;
    }
	
	function setDistributionCriteria(uint256 minPeriod, uint256 minDistribution) external onlyOwner {
        distributor.setDistributionCriteria(minPeriod, minDistribution);
    }
	
	function setDistributorGas(uint256 gas) external onlyOwner {
       require(gas < 750000, "Gas is greater than limit");
       distributorGas = gas;
    }

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
}