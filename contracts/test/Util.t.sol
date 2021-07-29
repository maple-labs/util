// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { DSTest } from "../../modules/ds-test/src/test.sol";

import { IMapleGlobalsLike } from "../interfaces/IMapleGlobalsLike.sol";

import { Util } from "../Util.sol";

contract MockGlobals is IMapleGlobalsLike {

    mapping(address => uint256) internal prices;

    function setLatestPrice(address asset, uint256 price) external {
        prices[asset] = price;
    }

    function getLatestPrice(address asset) external override view returns (uint256) {
        return prices[asset];
    }

}

contract MockToken {

    uint256 public decimals;

    constructor(uint256 _decimals) public {
        decimals = _decimals;
    }

}

contract UtilTest is DSTest {

    function assert_calcMinAmount(
        uint256 swapAmount,
        uint256 fromAssetLatestPrice,
        uint256 fromAssetDecimals,
        uint256 toAssetLatestPrice,
        uint256 toAssetDecimals,
        uint256 expectedAmount
    ) internal {
        MockToken fromAsset = new MockToken(fromAssetDecimals);
        MockToken toAsset   = new MockToken(toAssetDecimals);
        MockGlobals globals = new MockGlobals();

        globals.setLatestPrice(address(fromAsset), fromAssetLatestPrice);
        globals.setLatestPrice(address(toAsset),   toAssetLatestPrice);

        assertEq(Util.calcMinAmount(globals, address(fromAsset), address(toAsset), swapAmount), expectedAmount);
    }

    function test_calcMinAmount() external {
        assert_calcMinAmount(1_000_000, 1_000_000_000, 0, 1_000_000_000, 0, 1_000_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 3, 1_000_000_000, 0, 1_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 6, 1_000_000_000, 0, 1);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 0, 1_000_000_000, 3, 1_000_000_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 3, 1_000_000_000, 3, 1_000_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 6, 1_000_000_000, 3, 1_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 0, 1_000_000_000, 6, 1_000_000_000_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 3, 1_000_000_000, 6, 1_000_000_000);
        assert_calcMinAmount(1_000_000, 1_000_000_000, 6, 1_000_000_000, 6, 1_000_000);

        assert_calcMinAmount(0,         1_000_000_000, 0, 1_000_000_000, 0, 0);
        assert_calcMinAmount(0,         1_000_000_000, 3, 1_000_000_000, 0, 0);
        assert_calcMinAmount(0,         1_000_000_000, 6, 1_000_000_000, 0, 0);
        assert_calcMinAmount(0,         1_000_000_000, 0, 1_000_000_000, 3, 0);
        assert_calcMinAmount(0,         1_000_000_000, 3, 1_000_000_000, 3, 0);
        assert_calcMinAmount(0,         1_000_000_000, 6, 1_000_000_000, 3, 0);
        assert_calcMinAmount(0,         1_000_000_000, 0, 1_000_000_000, 6, 0);
        assert_calcMinAmount(0,         1_000_000_000, 3, 1_000_000_000, 6, 0);
        assert_calcMinAmount(0,         1_000_000_000, 6, 1_000_000_000, 6, 0);
        
        assert_calcMinAmount(1_000_000, 0,             0, 1_000_000_000, 0, 0);
        assert_calcMinAmount(1_000_000, 0,             3, 1_000_000_000, 0, 0);
        assert_calcMinAmount(1_000_000, 0,             6, 1_000_000_000, 0, 0);
        assert_calcMinAmount(1_000_000, 0,             0, 1_000_000_000, 3, 0);
        assert_calcMinAmount(1_000_000, 0,             3, 1_000_000_000, 3, 0);
        assert_calcMinAmount(1_000_000, 0,             6, 1_000_000_000, 3, 0);
        assert_calcMinAmount(1_000_000, 0,             0, 1_000_000_000, 6, 0);
        assert_calcMinAmount(1_000_000, 0,             3, 1_000_000_000, 6, 0);
        assert_calcMinAmount(1_000_000, 0,             6, 1_000_000_000, 6, 0);
    }

}
