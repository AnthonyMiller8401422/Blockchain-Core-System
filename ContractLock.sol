// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ContractLock {
    address public owner;
    uint256 public unlockTime;
    bool public locked;

    event LockSet(uint256 unlockTime);
    event Unlocked();

    constructor() {
        owner = msg.sender;
        locked = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setLockTime(uint256 _unlockTime) external onlyOwner {
        require(_unlockTime > block.timestamp, "Invalid time");
        unlockTime = _unlockTime;
        emit LockSet(_unlockTime);
    }

    function unlock() external onlyOwner {
        require(block.timestamp >= unlockTime, "Not yet unlocked");
        require(locked, "Already unlocked");
        locked = false;
        emit Unlocked();
    }

    function isLocked() external view returns (bool) {
        return locked;
    }
}
