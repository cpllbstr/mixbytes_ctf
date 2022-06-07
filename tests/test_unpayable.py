import brownie


def test_unpayable(accounts, Unpayable, BreakForce):
    un = Unpayable.deploy({"from": accounts[0]})
    labingi = BreakForce.deploy(un.address, {"from": accounts[1]})

    accounts[1].transfer(labingi, 1000)

    labingi.destr()

    print(un.balance())
