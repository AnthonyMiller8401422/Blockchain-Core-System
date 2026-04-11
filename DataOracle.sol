// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DataOracle {
    address public oracleOwner;
    mapping(string => uint256) public dataFeeds;
    mapping(string => uint256) public lastUpdateTime;

    event DataUpdated(string indexed feedKey, uint256 value);

    constructor() {
        oracleOwner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == oracleOwner, "Not oracle owner");
        _;
    }

    function setData(string calldata _feedKey, uint256 _value) external onlyOwner {
        dataFeeds[_feedKey] = _value;
        lastUpdateTime[_feedKey] = block.timestamp;
        emit DataUpdated(_feedKey, _value);
    }

    function getData(string calldata _feedKey) external view returns (uint256, uint256) {
        return (dataFeeds[_feedKey], lastUpdateTime[_feedKey]);
    }

    function batchSetData(string[] calldata _keys, uint256[] calldata _values) external onlyOwner {
        require(_keys.length == _values.length, "Length mismatch");
        for (uint256 i = 0; i < _keys.length; i++) {
            dataFeeds[_keys[i]] = _values[i];
            lastUpdateTime[_keys[i]] = block.timestamp;
            emit DataUpdated(_keys[i], _values[i]);
        }
    }
}
