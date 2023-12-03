// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./libraries/Tick.sol";
import "./libraries/Position.sol";

import "./interfaces/IZigswapV3Pool.sol";

contract ZigswapV3Pool is IZigswapV3Pool {
    using Tick for mapping(int24 => Tick.Info);
    using Position for mapping(bytes32 => Position.Info);
    using Position for Position.Info;

    int24 internal constant MIN_TICK = -887272;
    int24 internal constant MAX_TICK = 887272;

    address public immutable token0;
    address public immutable token1;

    struct Slot0 {
        uint160 sqrtPriceX96; // uint160 as it is 64 int bits + 96 fraction bits
        int24 tick;
    }

    Slot0 public slot0;

    uint128 public liquidity; // L

    mapping(int24 => Tick.Info) public ticks; // ticks info
    mapping(bytes32 => Position.Info) public positions; //Positions info

    constructor(address _token0, address _token1, uint160 _sqrtPriceX96, int24 _tick) {
        token0 = _token0;
        token1 = _token1;

        slot0 = Slot0({sqrtPriceX96: _sqrtPriceX96, tick: _tick});
    }

    function provideLiquidity(address _owner, int24 _lowerTick, int24 _upperTick, uint128 _amount)
        external returns (uint256 _amount0, uint256 _amount1) {
            if (
                lowerTick >= upperTick ||
                lowerTick < MIN_TICK ||
                upperTick > MAX_TICK
            ) revert InvalidTickRange();
            if (amount == 0) revert ZeroLiquidity();

            ticks.update(lowerTick, amount);
            ticks.update(upperTick, amount);

            Position.Info storage position = positions.get(
                owner,
                lowerTick,
                upperTick
            );
            position.update(amount);

            liquidity += uint128(amount);

            _amount0 = 0.998976618347425280 ether;
            _amount1 = 5000 ether;

            uint256 balance0Before;
            uint256 balance1Before;
            if (_amount0 > 0) balance0Before = balance0();
            if (_amount1 > 0) balance1Before = balance1();
            IUniswapV3MintCallback(msg.sender).uniswapV3MintCallback(
                _amount0,
                _amount1
            );
            if (_amount0 > 0 && balance0Before + _amount0 > balance0())
                revert InsufficientInputAmount();
            if (_amount1 > 0 && balance1Before + _amount1 > balance1())
                revert InsufficientInputAmount();

            emit Mint(msg.sender, _owner, _lowerTick, _upperTick, _amount, _amount0, _amount1);
    }





    // Internal View
    function balance0() internal returns (uint256 balance) {
        balance = IERC20(token0).balanceOf(address(this));
    }

    function balance1() internal returns (uint256 balance) {
        balance = IERC20(token1).balanceOf(address(this));
    }
}
