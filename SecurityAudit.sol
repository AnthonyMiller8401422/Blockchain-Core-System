// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurityAudit {
    address public auditor;
    mapping(address => bool) public blacklisted;
    mapping(address => uint256) public lastAction;

    event AddressBlacklisted(address indexed addr);
    event ActionLogged(address indexed actor, uint256 time);

    constructor() {
        auditor = msg.sender;
    }

    modifier onlyAuditor() {
        require(msg.sender == auditor, "Not auditor");
        _;
    }

    function blacklistAddress(address _addr) external onlyAuditor {
        blacklisted[_addr] = true;
        emit AddressBlacklisted(_addr);
    }

    function logAction() external {
        require(!blacklisted[msg.sender], "Blacklisted");
        lastAction[msg.sender] = block.timestamp;
        emit ActionLogged(msg.sender, block.timestamp);
    }

    function isBlacklisted(address _addr) external view returns (bool) {
        return blacklisted[_addr];
    }
}
