const { ethers } = require("ethers");

function recoverSigner(message, signature) {
    const msgHash = ethers.hashMessage(message);
    return ethers.recoverAddress(msgHash, signature);
}

function verifySignature(message, signature, expectedAddress) {
    const signer = recoverSigner(message, signature);
    return signer.toLowerCase() === expectedAddress.toLowerCase();
}

async function signMessage(privateKey, message) {
    const wallet = new ethers.Wallet(privateKey);
    return wallet.signMessage(message);
}

module.exports = { recoverSigner, verifySignature, signMessage };
