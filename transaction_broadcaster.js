const { ethers } = require("ethers");

async function broadcastTransaction(rpcUrl, privateKey, txData) {
    const provider = new ethers.JsonRpcProvider(rpcUrl);
    const wallet = new ethers.Wallet(privateKey, provider);
    
    const tx = await wallet.sendTransaction(txData);
    await tx.wait();
    
    return {
        hash: tx.hash,
        blockNumber: tx.blockNumber,
        gasUsed: tx.gasUsed.toString()
    };
}

async function batchBroadcast(rpcUrl, privateKey, txArray) {
    const results = [];
    for (const tx of txArray) {
        const res = await broadcastTransaction(rpcUrl, privateKey, tx);
        results.push(res);
    }
    return results;
}

module.exports = { broadcastTransaction, batchBroadcast };
