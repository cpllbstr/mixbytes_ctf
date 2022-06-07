# %%
from web3 import Web3
import eth_abi
import eth_utils
import web3

contract_address = "0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9"

# w3 = Web3(Web3.HTTPProvider("https://rpc.api.moonriver.moonbeam.network"))

# impl_contract = w3.eth.get_storage_at(
#     contract_address,
#     "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc",
# )
# print(impl_contract)

# Web3.toChecksumAddress(impl_contract[20:])



# as_bytes = eth_utils.to_bytes(hexstr=impl_contract)
# eth_utils.to_normalized_address(as_bytes[-20:])
# Web3.toChecksumAddress(impl_contract)
# Web3.keccak(hexstr=impl_contract)
# print(impl_contract)
