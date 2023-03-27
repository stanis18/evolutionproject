// SPDX-License-Identifier: agpl-3.0
pragma solidity >= 0.5.0;



interface AaveFlashBorrowerLike {
  function executeOperation(
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata premiums,
    address initiator,
    bytes calldata params
  ) external returns (bool);
}
