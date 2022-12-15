// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Bank {
    error ZeroAddress();
    error Forbidden();
    error InvalidInput();
    error InsufficientBalance();
    error LowLimit();
    
    
    IERC20 public token;
    AggregatorV3Interface internal priceFeed;

    address private Owner;
    
    mapping (address => uint) userDeposit;
    mapping (address => uint) userLimit;
    constructor(address _deployer, address _interfaceAgg) {
        if(_deployer == address(0) || _interfaceAgg==address(0)) revert ZeroAddress();
        Owner = _deployer;
        priceFeed = AggregatorV3Interface(_interfaceAgg);
    }

    function setDepositCurrency(address _token)external  {
        if(msg.sender!=Owner) revert Forbidden();
        if(_token == address(0)) revert ZeroAddress();
        token = IERC20(_token);
    }
    function DepositToken(uint amount) external {
        if(amount==0) revert InvalidInput();
        if(token.balanceOf(msg.sender)<amount) revert InsufficientBalance();
        token.transfer(address(this),amount);
        userDeposit[msg.sender]+=amount;
    }

    function calculateLoanLimit(address _address) internal {
        uint userUsd = userDeposit[_address];
        (uint80 roundId, int price,uint startedAt,uint timeStamp,uint80 answeredInRound) = priceFeed.latestRoundData();
        int userAmtInEth = int(userUsd)/price;

        //loanLimit == 70%
        uint loanLimit = uint((7 * userAmtInEth)/(10));
        userLimit[_address]= loanLimit * 1 ether;

        

    }
    function getLoan(uint amount) external {
        calculateLoanLimit(msg.sender);
        if(userLimit[msg.sender]<amount) revert LowLimit();
        
    }
}