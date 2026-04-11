const { ethers } = require("ethers");

class Web3Connector {
    constructor(rpcUrl) {
        this.provider = new ethers.JsonRpcProvider(rpcUrl);
        this.wallet = null;
    }

    async connectWallet(privateKey) {
        this.wallet = new ethers.Wallet(privateKey, this.provider);
        return this.wallet.address;
    }

    async getBalance(address) {
        const balance = await this.provider.getBalance(address);
        return ethers.formatEther(balance);
    }

    async sendTransaction(to, value) {
        if (!this.wallet) throw new Error("Wallet not connected");
        const tx = await this.wallet.sendTransaction({
            to,
            value: ethers.parseEther(value)
        });
        await tx.wait();
        return tx.hash;
    }

    async getBlockNumber() {
        return await this.provider.getBlockNumber();
    }
}

module.exports = Web3Connector;
