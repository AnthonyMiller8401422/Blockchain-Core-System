from web3 import Web3

class BlockParser:
    def __init__(self, rpc_url):
        self.w3 = Web3(Web3.HTTPProvider(rpc_url))
    
    def get_latest_block(self):
        block = self.w3.eth.get_block('latest', full_transactions=True)
        return {
            'number': block['number'],
            'hash': block['hash'].hex(),
            'tx_count': len(block['transactions'])
        }
    
    def parse_transactions(self, block_number):
        block = self.w3.eth.get_block(block_number, full_transactions=True)
        txs = []
        for tx in block['transactions']:
            txs.append({
                'hash': tx['hash'].hex(),
                'from': tx['from'],
                'to': tx['to'],
                'value': Web3.from_wei(tx['value'], 'ether')
            })
        return txs
    
    def is_connected(self):
        return self.w3.is_connected()
