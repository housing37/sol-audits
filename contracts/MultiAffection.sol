// SPDX-License-Identifier: MIT
// ref (pc): 0x79474ff39B0F9Dc7d5F7209736C2a6913cf50F82
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
    function totalSupply() external returns (uint256);
    function decimals() external returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool);
}

interface affectionInterface {
    function Generate() external returns (uint64);
    function BuyWithG5(uint256 amount) external;
    function BuyWithPI(uint256 amount) external;
    function BuyWithMATH(uint256 amount) external;
}

contract MultiAffection {
    address private ownerAddress;

    mapping(address => uint256) private etherBalances;
    mapping(address => mapping(address => uint256)) private tokenBalances;

    uint public tax;
    uint public taxMax;
    address affectionContractAddress = 0x24F0154C1dCe548AdF15da2098Fdd8B8A3B8151D;
    address G5ContractAddress = 0x2fc636E7fDF9f3E8d61033103052079781a6e7D2;
    address PIContractAddress = 0xA2262D7728C689526693aE893D0fD8a352C7073C;
    address MATHContractAddress = 0xB680F0cc810317933F234f67EB6A9E923407f05D;
    affectionInterface affectionContract = affectionInterface(affectionContractAddress);
    IERC20 affectionToken = IERC20(affectionContractAddress);
    IERC20 G5Token = IERC20(G5ContractAddress);
    IERC20 PIToken = IERC20(PIContractAddress);
    IERC20 MATHToken = IERC20(MATHContractAddress);
    uint256 affectionTokenDecimals;
    uint256 G5TokenDecimals;
    uint256 PITokenDecimals;
    uint256 MATHTokenDecimals;

    constructor() {
        G5Token.approve(affectionContractAddress, G5Token.totalSupply());
        PIToken.approve(affectionContractAddress, PIToken.totalSupply());
        MATHToken.approve(affectionContractAddress, MATHToken.totalSupply());
        ownerAddress= msg.sender;
        tax = 1;
        taxMax = 15;
        affectionTokenDecimals = affectionToken.decimals();
        G5TokenDecimals = G5Token.decimals();
        PITokenDecimals = PIToken.decimals();
        MATHTokenDecimals = MATHToken.decimals();
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only the owner can call this");
        _;
    }

    function taxAmountByPercentage(uint256 percentage, uint256 value) public pure returns (uint256, uint256) {
        if (percentage == 0)
            return (value, 0);
        uint256 valueWithDecimals = value * 10**18;
        uint256 percentageToSubtract = valueWithDecimals * percentage / 100;
        uint256 result = valueWithDecimals - percentageToSubtract;
        uint256 subtractedAmount = value - (result / 10**18);
        return (result / 10**18, subtractedAmount);
    }

    function multiBuyWithG5(uint iterations) public {
        G5Token.transferFrom(msg.sender, address(this), iterations * 600000000000000000); // 0.6
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3  * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithG5(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function multiBuyWithPI(uint iterations) public {
        PIToken.transferFrom(msg.sender, address(this), iterations * 10000000000000000); // 0.01
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3 * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithPI(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function multiBuyWithMATH(uint iterations) public {
        MATHToken.transferFrom(msg.sender, address(this), iterations * 3 * 10 ** MATHTokenDecimals); // 3
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3 * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithMATH(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function setTax(uint percent) public onlyOwner {
        if (percent <= taxMax)
            tax = percent;
    }

    function setOwner(address newOwnerAddress) public onlyOwner {
        ownerAddress = newOwnerAddress;
    }

    function withdrawPLS() public onlyOwner {
        payable(ownerAddress).transfer(address(this).balance);
    }

    function withdrawERC20(address tokenAddress) public onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(ownerAddress, token.balanceOf(address(this)));
    }// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
    function totalSupply() external returns (uint256);
    function decimals() external returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool);
}

interface affectionInterface {
    function Generate() external returns (uint64);
    function BuyWithG5(uint256 amount) external;
    function BuyWithPI(uint256 amount) external;
    function BuyWithMATH(uint256 amount) external;
}

contract MultiAffection {
    address private ownerAddress;

    mapping(address => uint256) private etherBalances;
    mapping(address => mapping(address => uint256)) private tokenBalances;

    uint public tax;
    uint public taxMax;
    address affectionContractAddress = 0x24F0154C1dCe548AdF15da2098Fdd8B8A3B8151D;
    address G5ContractAddress = 0x2fc636E7fDF9f3E8d61033103052079781a6e7D2;
    address PIContractAddress = 0xA2262D7728C689526693aE893D0fD8a352C7073C;
    address MATHContractAddress = 0xB680F0cc810317933F234f67EB6A9E923407f05D;
    affectionInterface affectionContract = affectionInterface(affectionContractAddress);
    IERC20 affectionToken = IERC20(affectionContractAddress);
    IERC20 G5Token = IERC20(G5ContractAddress);
    IERC20 PIToken = IERC20(PIContractAddress);
    IERC20 MATHToken = IERC20(MATHContractAddress);
    uint256 affectionTokenDecimals;
    uint256 G5TokenDecimals;
    uint256 PITokenDecimals;
    uint256 MATHTokenDecimals;

    constructor() {
        G5Token.approve(affectionContractAddress, G5Token.totalSupply());
        PIToken.approve(affectionContractAddress, PIToken.totalSupply());
        MATHToken.approve(affectionContractAddress, MATHToken.totalSupply());
        ownerAddress= msg.sender;
        tax = 1;
        taxMax = 15;
        affectionTokenDecimals = affectionToken.decimals();
        G5TokenDecimals = G5Token.decimals();
        PITokenDecimals = PIToken.decimals();
        MATHTokenDecimals = MATHToken.decimals();
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only the owner can call this");
        _;
    }

    function taxAmountByPercentage(uint256 percentage, uint256 value) public pure returns (uint256, uint256) {
        if (percentage == 0)
            return (value, 0);
        uint256 valueWithDecimals = value * 10**18;
        uint256 percentageToSubtract = valueWithDecimals * percentage / 100;
        uint256 result = valueWithDecimals - percentageToSubtract;
        uint256 subtractedAmount = value - (result / 10**18);
        return (result / 10**18, subtractedAmount);
    }

    function multiBuyWithG5(uint iterations) public {
        G5Token.transferFrom(msg.sender, address(this), iterations * 600000000000000000); // 0.6
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3  * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithG5(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function multiBuyWithPI(uint iterations) public {
        PIToken.transferFrom(msg.sender, address(this), iterations * 10000000000000000); // 0.01
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3 * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithPI(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function multiBuyWithMATH(uint iterations) public {
        MATHToken.transferFrom(msg.sender, address(this), iterations * 3 * 10 ** MATHTokenDecimals); // 3
        for (uint i = 0; i < iterations; i++)
            affectionContract.Generate();
        uint256 amount = iterations * 3 * 10 ** affectionTokenDecimals;
        affectionContract.BuyWithMATH(amount);
        (uint256 amountSending, uint256 amountTaxed) =  taxAmountByPercentage(tax, amount);
        if (amountTaxed != 0)
            affectionToken.transfer(ownerAddress, amountTaxed);
        affectionToken.transfer(msg.sender, amountSending);
    }

    function setTax(uint percent) public onlyOwner {
        if (percent <= taxMax)
            tax = percent;
    }

    function setOwner(address newOwnerAddress) public onlyOwner {
        ownerAddress = newOwnerAddress;
    }

    function withdrawPLS() public onlyOwner {
        payable(ownerAddress).transfer(address(this).balance);
    }

    function withdrawERC20(address tokenAddress) public onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(ownerAddress, token.balanceOf(address(this)));
    }