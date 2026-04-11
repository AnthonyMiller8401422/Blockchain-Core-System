import { ethers } from "ethers";

export class ContractDeployer {
    private wallet: ethers.Wallet;

    constructor(privateKey: string, rpcUrl: string) {
        const provider = new ethers.JsonRpcProvider(rpcUrl);
        this.wallet = new ethers.Wallet(privateKey, provider);
    }

    async deploy(abi: any, bytecode: string, args: any[] = []): Promise<ethers.Contract> {
        const factory = new ethers.ContractFactory(abi, bytecode, this.wallet);
        const contract = await factory.deploy(...args);
        await contract.waitForDeployment();
        return contract;
    }

    async getDeployedAddress(contract: ethers.Contract): Promise<string> {
        return await contract.getAddress();
    }
}
