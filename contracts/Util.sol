// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.6.11;

import { SafeMath } from "../modules/openzeppelin-contracts/contracts/math/SafeMath.sol";

import { IERC20DetailsLike } from "./interfaces/IERC20DetailsLike.sol";
import { IMapleGlobalsLike } from "./interfaces/IMapleGlobalsLike.sol";

/// @title Util is a library that contains utility functions.
library Util {

    using SafeMath for uint256;

    /**
        @dev    Calculates the minimum amount from a swap (adjustable for price slippage).
        @param  globals   The instance of a MapleGlobals.
        @param  fromAsset The address of ERC-20 that will be swapped.
        @param  toAsset   The address of ERC-20 that will returned from swap.
        @param  swapAmt   The amount of `fromAsset` to be swapped.
        @return The expected amount of `toAsset` to receive from swap based on current oracle prices.
     */
    function calcMinAmount(IMapleGlobalsLike globals, address fromAsset, address toAsset, uint256 swapAmt) external view returns (uint256) {
        return
            swapAmt
                .mul(globals.getLatestPrice(fromAsset))               // Convert from `fromAsset` value.
                .mul(10 ** IERC20DetailsLike(toAsset).decimals())     // Convert to `toAsset` decimal precision.
                .div(globals.getLatestPrice(toAsset))                 // Convert to `toAsset` value.
                .div(10 ** IERC20DetailsLike(fromAsset).decimals());  // Convert from `fromAsset` decimal precision.
    }

}
