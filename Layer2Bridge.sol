// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Layer2Bridge {
    address public l1Gateway;
    address public l2Gateway;
    mapping(uint256 => bool) public processedDeposits;

    event DepositInitiated(address indexed user, uint256 amount, uint256 depositId);
    event WithdrawCompleted(address indexed user, uint256 amount);

    constructor(address _l1, address _l2) {
        l1Gateway = _l1;
        l2Gateway = _l2;
    }

    function initiateDeposit() external payable returns (uint256) {
        uint256 id = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, msg.value)));
        processedDeposits[id] = false;
        emit DepositInitiated(msg.sender, msg.value, id);
        return id;
    }

    function completeWithdraw(address _user, uint256 _amount, uint256 _id) external {
        require(msg.sender == l2Gateway, "Not gateway");
        require(!processedDeposits[_id], "Processed");
        processedDeposits[_id] = true;
        payable(_user).transfer(_amount);
        emit WithdrawCompleted(_user, _amount);
    }
}
