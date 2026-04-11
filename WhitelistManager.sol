// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WhitelistManager {
    mapping(address => bool) public whitelist;
    address public owner;
    uint256 public whitelistCount;

    event AddedToWhitelist(address indexed user);
    event RemovedFromWhitelist(address indexed user);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addToWhitelist(address _user) external onlyOwner {
        require(!whitelist[_user], "Already whitelisted");
        whitelist[_user] = true;
        whitelistCount++;
        emit AddedToWhitelist(_user);
    }

    function removeFromWhitelist(address _user) external onlyOwner {
        require(whitelist[_user], "Not whitelisted");
        whitelist[_user] = false;
        whitelistCount--;
        emit RemovedFromWhitelist(_user);
    }

    function batchWhitelist(address[] calldata _users) external onlyOwner {
        for (uint256 i = 0; i < _users.length; i++) {
            if (!whitelist[_users[i]]) {
                whitelist[_users[i]] = true;
                whitelistCount++;
                emit AddedToWhitelist(_users[i]);
            }
        }
    }
}
