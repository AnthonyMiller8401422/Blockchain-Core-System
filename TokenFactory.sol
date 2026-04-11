// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenFactory {
    struct TokenInfo {
        address token;
        string name;
        string symbol;
        uint256 totalSupply;
    }

    TokenInfo[] public allTokens;
    event TokenCreated(address indexed token, string name, string symbol, uint256 supply);

    function createToken(string calldata _name, string calldata _symbol, uint256 _totalSupply) external returns (address) {
        CustomToken token = new CustomToken(_name, _symbol, _totalSupply, msg.sender);
        allTokens.push(TokenInfo(address(token), _name, _symbol, _totalSupply));
        emit TokenCreated(address(token), _name, _symbol, _totalSupply);
        return address(token);
    }

    function getTokenCount() external view returns (uint256) {
        return allTokens.length;
    }
}

contract CustomToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    address public owner;

    constructor(string memory _name, string memory _symbol, uint256 _supply, address _creator) {
        name = _name;
        symbol = _symbol;
        totalSupply = _supply * 10 ** decimals;
        balanceOf[_creator] = totalSupply;
        owner = _creator;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}
