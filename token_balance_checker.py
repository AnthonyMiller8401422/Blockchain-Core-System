from web3 import Web3

class TokenBalanceChecker:
    def __init__(self, rpc_url):
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))
        self.abi = [
            {
                "inputs": [{"internalType": "address", "name": "account", "type": "address"}],
                "name": "balanceOf",
                "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
                "stateMutability": "view",
                "type": "function"
            }
        ]
    
    def get_native_balance(self, address):
        balance = self.w3.eth.get_balance(address)
        return Web3.from_wei(balance, 'ether')
    
    def get_token_balance(self, token_address, wallet_address):
        contract = self.w3.eth.contract(address=token_address, abi=self.abi)
        balance = contract.functions.balanceOf(wallet_address).call()
        return Web3.from_wei(balance, 'ether')
