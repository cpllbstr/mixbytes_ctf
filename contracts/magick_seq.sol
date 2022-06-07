// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Player {
    function number() external returns (uint256);
}

contract MagicSequence {
    bool public accepted;
    bytes4[] private hashes;

    constructor() public {
        hashes.push(0xbeced095);
        hashes.push(0x42a7b7dd);
        hashes.push(0x45e010b9);
        hashes.push(0xa86c339e);
        accepted = false;
    }

    function start() public returns (bool) {
        Player player = Player(msg.sender);

        uint8 i = 0;
        while (i < 4) {
            if (
                bytes4(
                    uint32(
                        uint256(keccak256(abi.encodePacked(player.number()))) >>
                            224
                    )
                ) != hashes[i]
            ) {
                return false;
            }
            i++;
        }

        accepted = true;
        return true;
    }
}

contract Dumb {
    uint256[] public numbers;
    uint8 i;
    MagicSequence game;

    constructor(address _game) public {
        numbers.push(42);
        numbers.push(55);
        numbers.push(256);
        numbers.push(9876543);
        i = 0;
        game = MagicSequence(_game);
    }

    function play() public {
        game.start();
    }

    modifier inc() {
        _;
        i++;
    }

    function set_zero() public {
        i = 0;
    }

    function number() external inc returns (uint256) {
        return numbers[i];
    }
}
