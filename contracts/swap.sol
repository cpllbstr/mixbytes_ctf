// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IWMOVR {
    function deposit() external payable;
}

contract SecureSwap {
    uint256 public constant IN_AMOUNT_OFFSET = 4;
    uint256 public constant IN_TOKEN_OFFSET = 4 + 32 + 32 + 32 + 32 + 32 + 32;
    uint256 public constant OUT_TOKEN_OFFSET =
        4 + 32 + 32 + 32 + 32 + 32 + 32 + 32;
    uint256 public constant TO_ADDRESS_OFFSET = 4 + 32 + 32 + 32;

    address public constant WMOVR = 0x98878B06940aE243284CA214f92Bb71a2b032B8A;

    address public constant SOLAR_ROUTER =
        0xAA30eF758139ae4a7f798112902Bf6d65612045f;

    address[] public ALLOWED_TOKENS;

    constructor() public {
        // pushing tokens allowed for trading
        ALLOWED_TOKENS.push(0xE3F5a90F9cb311505cd691a46596599aA1A0AD7D); //USDC
        ALLOWED_TOKENS.push(0xFfFFfFff1FcaCBd218EDc0EbA20Fc2308C778080); //xcKSM
        ALLOWED_TOKENS.push(WMOVR);
    }

    function deposit() external payable {
        // deposit MOVRs and convert ot WMOVR
        IWMOVR(WMOVR).deposit{value: msg.value}();
    }

    function swap(bytes calldata data) external returns (bool, bytes memory) {
        // encoded with selector data
        uint256 inAmount = _inAmount(data);
        address inToken = _inToken(data);
        address outToken = _outToken(data);
        address to = _to(data);

        require(
            IERC20(inToken).balanceOf(address(this)) >= inAmount,
            "not enough balance"
        );
        require(_checkTokenAllowed(outToken), "token not allowed");
        require(to == address(this), "wrong reciever");

        IERC20(inToken).approve(SOLAR_ROUTER, inAmount);
        return SOLAR_ROUTER.call(data);
    }

    function sweep(address token) external {
        // sweep airdrop or donations
        require(!_checkTokenAllowed(token), "token protected");

        IERC20(token).transfer(
            msg.sender,
            IERC20(token).balanceOf(address(this))
        );
    }

    function _checkTokenAllowed(address _token) internal view returns (bool) {
        for (uint256 i = 0; i < ALLOWED_TOKENS.length; i++) {
            if (ALLOWED_TOKENS[i] == _token) {
                return true;
            }
        }
        return false;
    }

    function _inAmount(bytes memory _data) internal pure returns (uint256) {
        return _toUint256(_data, IN_AMOUNT_OFFSET);
    }

    function _to(bytes memory _data) internal pure returns (address) {
        return address(_toUint256(_data, TO_ADDRESS_OFFSET));
    }

    function _inToken(bytes memory _data) internal pure returns (address) {
        return address(_toUint256(_data, IN_TOKEN_OFFSET));
    }

    function _outToken(bytes memory _data) internal pure returns (address) {
        return address(_toUint256(_data, OUT_TOKEN_OFFSET));
    }

    // extract uint256 from data
    function _toUint256(bytes memory _bytes, uint256 _start)
        internal
        pure
        returns (uint256)
    {
        require(_start + 32 >= _start, "toUint256_overflow");
        require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }
}
