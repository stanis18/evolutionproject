// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >= 0.5.0;

import "./IERC20.sol";
import "./IERC3156FlashLender.sol";

contract FlashBorrower  {
    enum Action {NORMAL, STEAL, REENTER}

    uint256 public flashBalance;
    address public flashUser;
    address public flashToken;
    uint256 public flashValue;
    uint256 public flashFee;

    /// @notice postcondition user == address(this)
    /// @notice postcondition msg.sender == address(s.lender)
    function onFlashLoan(address user, address token, uint256 value, uint256 fee, bytes calldata data) external  {
        (Action action) = abi.decode(data, (Action)); // Use this to unpack arbitrary data
        flashUser = user;
        flashToken = token;
        flashValue = value;
        flashFee = fee;
        if (action == Action.NORMAL) {
            flashBalance = IERC20(token).balanceOf(address(this));
            IERC20(token).transfer(msg.sender, value + fee); // Resolve the flash loan
        } else if (action == Action.STEAL) {
            // Do nothing
        } else if (action == Action.REENTER) {
            flashBorrow(msg.sender, token, value * 2);
            IERC20(token).transfer(msg.sender, value + fee);
        }
    }

    function flashBorrow(address lender, address token, uint256 value) public {
        // Use this to pack arbitrary data to `onFlashLoan`
        bytes memory data = abi.encode(Action.NORMAL);
        IERC3156FlashLender(lender).flashLoan(address(this), token, value, data);
    }

    function flashBorrowAndSteal(address lender, address token, uint256 value) public {
        // Use this to pack arbitrary data to `onFlashLoan`
        bytes memory data = abi.encode(Action.STEAL);
        IERC3156FlashLender(lender).flashLoan(address(this), token, value, data);
    }

    function flashBorrowAndReenter(address lender, address token, uint256 value) public {
        // Use this to pack arbitrary data to `onFlashLoan`
        bytes memory data = abi.encode(Action.REENTER);
        IERC3156FlashLender(lender).flashLoan(address(this), token, value, data);
    }
}
