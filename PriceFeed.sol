// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PriceFeed {
    address public admin;
    mapping(string => uint256) public prices;
    mapping(string => uint256) public decimals;

    event PriceUpdated(string indexed symbol, uint256 price);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function setPrice(string calldata _symbol, uint256 _price, uint256 _decimals) external onlyAdmin {
        prices[_symbol] = _price;
        decimals[_symbol] = _decimals;
        emit PriceUpdated(_symbol, _price);
    }

    function getPrice(string calldata _symbol) external view returns (uint256, uint256) {
        return (prices[_symbol], decimals[_symbol]);
    }
}
