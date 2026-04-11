// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingEscrow {
    struct Lock {
        uint256 amount;
        uint256 endTime;
    }

    mapping(address => Lock) public locks;
    uint256 public totalLocked;

    event Locked(address indexed user, uint256 amount, uint256 endTime);
    event Unlocked(address indexed user, uint256 amount);

    function lockTokens(uint256 _duration) external payable {
        require(msg.value > 0, "Zero amount");
        uint256 endTime = block.timestamp + _duration;
        Lock storage lock = locks[msg.sender];
        lock.amount += msg.value;
        lock.endTime = endTime;
        totalLocked += msg.value;
        emit Locked(msg.sender, msg.value, endTime);
    }

    function unlock() external {
        Lock storage lock = locks[msg.sender];
        require(lock.amount > 0, "No lock");
        require(block.timestamp >= lock.endTime, "Locked");
        uint256 amount = lock.amount;
        lock.amount = 0;
        totalLocked -= amount;
        payable(msg.sender).transfer(amount);
        emit Unlocked(msg.sender, amount);
    }

    function getVotingPower(address _user) external view returns (uint256) {
        Lock memory lock = locks[_user];
        if (block.timestamp < lock.endTime) return lock.amount;
        return 0;
    }
}
