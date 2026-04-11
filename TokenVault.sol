// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenVault {
    address public immutable vaultOwner;
    mapping(address => mapping(address => uint256)) public userDeposits;

    event Deposit(address indexed token, address indexed user, uint256 amount);
    event Withdraw(address indexed token, address indexed user, uint256 amount);

    constructor() {
        vaultOwner = msg.sender;
    }

    function depositToken(address _token, uint256 _amount) external {
        require(_amount > 0, "Zero amount");
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        userDeposits[_token][msg.sender] += _amount;
        emit Deposit(_token, msg.sender, _amount);
    }

    function withdrawToken(address _token, uint256 _amount) external {
        require(_amount > 0, "Zero amount");
        require(userDeposits[_token][msg.sender] >= _amount, "Insufficient balance");
        
        userDeposits[_token][msg.sender] -= _amount;
        IERC20(_token).transfer(msg.sender, _amount);
        emit Withdraw(_token, msg.sender, _amount);
    }

    function getBalance(address _token, address _user) external view returns (uint256) {
        return userDeposits[_token][_user];
    }
}
