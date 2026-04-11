// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract AirdropManager {
    address public token;
    address public owner;
    mapping(address => bool) public claimed;

    event AirdropClaimed(address indexed user, uint256 amount);

    constructor(address _token) {
        token = _token;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function claimAirdrop(uint256 _amount) external {
        require(!claimed[msg.sender], "Already claimed");
        claimed[msg.sender] = true;
        IERC20(token).transfer(msg.sender, _amount);
        emit AirdropClaimed(msg.sender, _amount);
    }

    function batchAirdrop(address[] calldata _users, uint256 _amount) external onlyOwner {
        for (uint256 i = 0; i < _users.length; i++) {
            if (!claimed[_users[i]]) {
                claimed[_users[i]] = true;
                IERC20(token).transfer(_users[i], _amount);
                emit AirdropClaimed(_users[i], _amount);
            }
        }
    }
}
