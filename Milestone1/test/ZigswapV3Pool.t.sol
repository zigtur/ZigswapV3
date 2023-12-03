// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ZigswapV3Pool} from "../src/ZigswapV3Pool.sol";

contract ZigswapV3PoolTest is Test {
    ZigswapV3Pool public pool;

    function setUp() public {
        pool = new ZigswapV3Pool();
    }

    function test_Increment() public {
        
        assertEq(counter.number(), 1);
    }
}
