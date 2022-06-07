pragma solidity ^0.6.0;

contract Unpayable {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    fallback() external {
        revert("doesn't accept funds");
    }

    function putMoney() external payable {
        require(msg.value > 500 ether, "doesn't accept too small amount");
    }

    function refund(address payable who) external {
        require(msg.sender == owner, "only owner can call refund");
        who.transfer(address(this).balance);
    }
}

contract BreakForce {
    address payable coin;

    constructor(address _coin) public {
        coin = payable(_coin);
    }

    receive() external payable {}

    function destr() public {
        selfdestruct(coin);
    }
}
