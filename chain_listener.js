const { ethers } = require("ethers");

class ChainListener {
    constructor(rpcUrl) {
        this.provider = new ethers.WebSocketProvider(rpcUrl);
    }

    listenForBlocks(callback) {
        this.provider.on("block", (blockNumber) => {
            callback(blockNumber);
        });
    }

    listenForTransfers(contractAddress, callback) {
        const abi = ["event Transfer(address indexed from, address indexed to, uint256 value)"];
        const contract = new ethers.Contract(contractAddress, abi, this.provider);
        contract.on("Transfer", (from, to, value) => {
            callback({ from, to, value: value.toString() });
        });
    }

    stopListening() {
        this.provider.removeAllListeners();
    }
}

module.exports = ChainListener;
