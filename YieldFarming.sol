// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract YieldFarming {
    struct Farm {
        uint256 totalStaked;
        uint256 rewardPerBlock;
        uint256 lastRewardBlock;
    }

    mapping(address => uint256) public userStake;
    Farm public farm;

    event Staked(address indexed user, uint256 amount);
    event RewardHarvested(address indexed user, uint256 reward);

    constructor(uint256 _rewardPerBlock) {
        farm.rewardPerBlock = _rewardPerBlock;
        farm.lastRewardBlock = block.number;
    }

    function updateFarm() internal {
        if (block.number > farm.lastRewardBlock) {
            farm.lastRewardBlock = block.number;
        }
    }

    function stake() external payable {
        updateFarm();
        userStake[msg.sender] += msg.value;
        farm.totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    function harvest() external {
        updateFarm();
        uint256 reward = (userStake[msg.sender] * farm.rewardPerBlock) / 1e18;
        payable(msg.sender).transfer(reward);
        emit RewardHarvested(msg.sender, reward);
    }
}
