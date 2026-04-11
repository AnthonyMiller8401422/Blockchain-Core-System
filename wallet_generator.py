from web3 import Web3
import secrets

def generate_eth_wallet():
    private_key = "0x" + secrets.token_hex(32)
    account = Web3().eth.account.from_key(private_key)
    return {
        "address": account.address,
        "private_key": private_key,
        "public_key": account.public_key.hex()
    }

def batch_generate_wallets(count):
    wallets = []
    for _ in range(count):
        wallets.append(generate_eth_wallet())
    return wallets

if __name__ == "__main__":
    wallet = generate_eth_wallet()
    print(wallet)
