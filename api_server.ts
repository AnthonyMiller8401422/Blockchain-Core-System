import express from "express";
import { ethers } from "ethers";

const app = express();
app.use(express.json());

const provider = new ethers.JsonRpcProvider("https://ethereum-rpc.publicnode.com");

app.get("/api/balance/:address", async (req, res) => {
    try {
        const balance = await provider.getBalance(req.params.address);
        res.json({ balance: ethers.formatEther(balance) });
    } catch (e) {
        res.status(400).json({ error: (e as Error).message });
    }
});

app.get("/api/block/latest", async (req, res) => {
    const num = await provider.getBlockNumber();
    res.json({ blockNumber: num });
});

app.listen(3000, () => {
    console.log("API running on port 3000");
});
