// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RewardDistributor {
    address public owner;
    uint256 public totalRewards;
    mapping(address => uint256) public userRewards;

    event RewardDistributed(address indexed user, uint256 amount);
    event RewardsDeposited(uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        totalRewards += msg.value;
        emit RewardsDeposited(msg.value);
    }

    function distribute(address[] calldata _users, uint256[] calldata _amounts) external onlyOwner {
        require(_users.length == _amounts.length, "Length mismatch");
        uint256 total;
        for (uint256 i = 0; i < _amounts.length; i++) total += _amounts[i];
        require(total <= address(this).balance, "Insufficient balance");

        for (uint256 i = 0; i < _users.length; i++) {
            userRewards[_users[i]] += _amounts[i];
            payable(_users[i]).transfer(_amounts[i]);
            emit RewardDistributed(_users[i], _amounts[i]);
        }
    }
}
