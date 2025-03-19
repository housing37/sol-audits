from web3 import Web3
from _env import env

# Connect to an Ethereum node
# w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_KEY'))
w3 = Web3(Web3.HTTPProvider(env.pc_main))


# Contract address
contract_address = '0xbbeA78397d4d4590882EFcc4820f03074aB2AB29'

# Function selector (e.g., for excludeFromTax(address))
# function_selector = '0x7d394b5b'  # Replace with your actual selector

# "0x493722e5": "setExclusionFromTax(address,bool)" -> "[]",
function_selector = '0x493722e5'
# function_selector = bytes.fromhex('493722e5')

# Block range (adjust as needed, e.g., from deployment block)
# start_block = 12345678  # Replace with contract deployment block
# start_block = 21496400  # xusd contract deployment block
# start_block = 21496532  # xusd contract invoked close to deploy block
# start_block = 21498661  # xusd contract no 0x493722e5 before this block number
# start_block = 21499713  # xusd contract no 0x493722e5 before this block number
start_block = 21507852  # xusd contract no 0x493722e5 before this block number
end_block = w3.eth.block_number

excluded_addresses = set()
unexcluded_addresses = set()

print(f'traversing TXs... STARTING BLOCK: {start_block}')
for block in range(start_block, end_block + 1):
    try:
        block_data = w3.eth.get_block(block, full_transactions=True)
        for tx in block_data['transactions']:
            tx_hash = tx['hash'].hex()
            # print(f"Checking transaction {tx_hash} in block {block} for selector {function_selector}")
            print(".", end='', flush=True)
            # Ensure input is bytes
            tx_input = tx['input'] if isinstance(tx['input'], bytes) else bytes.fromhex(tx['input'][2:])
            # if tx_input.startswith(function_selector):
            if tx['to'] == contract_address:
                print('\n')
                print(f"Checking transaction {tx_hash} in block {block} for selector {function_selector}")
                # Extract the selector (first 4 bytes of input)
                called_selector = tx_input[:4].hex()
                print(f"  Found tx to contract: {contract_address} w/ selector {called_selector}")
                print(f"    checking for {called_selector} == {function_selector} ...", end=' ')
                if called_selector != function_selector:
                    print(" .... NOPE")
                else:
                # if called_selector == function_selector:
                # if tx_input.startswith(function_selector):
                    print(" .... YES")
                    print(f'  Found matching selector: {function_selector} in tx {tx["hash"].hex()}')
                    # Decode input data
                    address = '0x' + tx_input[4:36][12:].hex()  # First param: address (32 bytes, trim padding)
                    is_excluded = int.from_bytes(tx_input[36:68], 'big') == 1  # Second param: bool (32 bytes)
                    if is_excluded:
                        excluded_addresses.add(address)
                    else:
                        unexcluded_addresses.add(address)
                        # excluded_addresses.discard(address)  # Remove if set to false
                    print(f"    Found tx {tx['hash'].hex()} in block {block}: {address} -> {is_excluded}")
                print('\ntraversing TXs... continued')
            # # if tx['to'] == contract_address and tx['input'].startswith(function_selector):
            # if tx['to'] == contract_address:
            #     print(f"Found tx to {tx['to']} w/ input {tx['input']}")
            #     # Decode the input data
            #     input_data = tx['input']
            #     # Assuming the function takes an address as the first parameter
            #     address = '0x' + input_data[10:74][24:].hex()  # Offset 4 bytes (selector) + 32 bytes padded
            #     excluded_addresses.add(address)
            #     print(f"Found tx {tx['hash'].hex()} in block {block}: {address}")
    except Exception as e:
        print(f"Error at block {block}: {e}")

print("Addresses excluded from tax:", excluded_addresses)
print("Addresses unexcluded from tax:", unexcluded_addresses)