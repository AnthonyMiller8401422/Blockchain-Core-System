import { ethers } from "ethers";

export class EventListener {
    private provider: ethers.WebSocketProvider;

    constructor(wssUrl: string) {
        this.provider = new ethers.WebSocketProvider(wssUrl);
    }

    onContractEvent(
        contractAddress: string,
        abi: any[],
        eventName: string,
        callback: (...args: any[]) => void
    ) {
        const contract = new ethers.Contract(contractAddress, abi, this.provider);
        contract.on(eventName, callback);
    }

    onNewBlock(callback: (blockNumber: number) => void) {
        this.provider.on("block", callback);
    }

    destroy() {
        this.provider.removeAllListeners();
    }
}
