// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StakingPool {
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 rewardDebt;
    }

    mapping(address => Stake) public userStakes;
    uint256 public totalStaked;
    uint256 public rewardPerSecond;
    uint256 public lastUpdateTime;
    uint256 public accRewardPerShare;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);

    constructor(uint256 _rewardPerSecond) {
        rewardPerSecond = _rewardPerSecond;
        lastUpdateTime = block.timestamp;
    }

    function updateReward() internal {
        if (block.timestamp > lastUpdateTime && totalStaked > 0) {
            uint256 timeElapsed = block.timestamp - lastUpdateTime;
            uint256 reward = timeElapsed * rewardPerSecond;
            accRewardPerShare += (reward * 1e18) / totalStaked;
        }
        lastUpdateTime = block.timestamp;
    }

    function stake() external payable {
        updateReward();
        Stake storage stake = userStakes[msg.sender];
        stake.amount += msg.value;
        stake.rewardDebt = (stake.amount * accRewardPerShare) / 1e18;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function unstake(uint256 _amount) external {
        Stake storage stake = userStakes[msg.sender];
        require(stake.amount >= _amount, "Insufficient stake");
        updateReward();
        uint256 reward = (stake.amount * accRewardPerShare) / 1e18 - stake.rewardDebt;
        stake.amount -= _amount;
        stake.rewardDebt = (stake.amount * accRewardPerShare) / 1e18;
        totalStaked -= _amount;
        payable(msg.sender).transfer(_amount);
        if (reward > 0) payable(msg.sender).transfer(reward);
        emit Unstaked(msg.sender, _amount);
        if (reward > 0) emit RewardClaimed(msg.sender, reward);
    }
}
