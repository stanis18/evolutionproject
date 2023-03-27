// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >= 0.5.0;
pragma experimental ABIEncoderV2;

import "./DYDXDataTypes.sol";

interface SoloMarginLike {
    function operate(DYDXDataTypes.AccountInfo[] calldata accounts, DYDXDataTypes.ActionArgs[] calldata actions) external;
    function getMarketTokenAddress(uint256 marketId) external view returns (address);
}
