// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Web3Auth {
    mapping(address => bool) public authenticated;
    mapping(address => uint256) public authExpiry;
    address public admin;

    event UserAuthenticated(address indexed user, uint256 expiry);
    event UserRevoked(address indexed user);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function authenticateUser(address _user, uint256 _duration) external onlyAdmin {
        uint256 expiry = block.timestamp + _duration;
        authenticated[_user] = true;
        authExpiry[_user] = expiry;
        emit UserAuthenticated(_user, expiry);
    }

    function revokeAuth(address _user) external onlyAdmin {
        authenticated[_user] = false;
        emit UserRevoked(_user);
    }

    function checkAuth(address _user) external view returns (bool) {
        return authenticated[_user] && block.timestamp <= authExpiry[_user];
    }
}
