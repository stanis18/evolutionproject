// SPDX-License-Identifier: LGPL-3.0-or-later
// use the flash loan EIP to receive tokens and then call arbitrary actions
pragma solidity >= 0.5.0;


import {Address} from "./Address.sol";
import {IERC20} from "./IERC20.sol";
import {ArgobytesClone} from "./ArgobytesClone.sol";
import {ArgobytesAuth} from "./ArgobytesAuth.sol";
import {Address2} from "./Address2.sol";
import {IERC3156FlashBorrower} from "./IERC3156FlashBorrower.sol";
import {IERC3156FlashLender} from "./IERC3156FlashLender.sol";

contract ArgobytesFlashBorrower is ArgobytesClone, IERC3156FlashBorrower {

    // because we make heavy use of delegatecall, we want to make sure our storage is durable
    bytes32 constant FLASH_BORROWER_POSITION = keccak256("argobytes.storage.FlashBorrower.lender");
    struct FlashBorrowerStorage {
        mapping(address => bool) lenders;
        bool pending_flashloan;
        Action pending_action;
        bytes pending_return;
    }
    function flashBorrowerStorage() internal pure returns (FlashBorrowerStorage storage s) {
        bytes32 position = FLASH_BORROWER_POSITION;
        assembly {
            s.slot := position
        }
    }

    function approveLender(address lender) external auth(ArgobytesAuth.CallType.ADMIN) {
        FlashBorrowerStorage storage s = flashBorrowerStorage();

        s.lenders[lender] = true;

        // TODO: emit an event
    }

    function denyLender(address lender) external auth(ArgobytesAuth.CallType.ADMIN) {
        FlashBorrowerStorage storage s = flashBorrowerStorage();

        delete s.lenders[lender];
    }

    /// @dev Initiate a flash loan
    function flashBorrow(
        address lender,
        address token,
        uint256 amount,
        Action calldata action
    ) public returns (bytes memory returned) {
        FlashBorrowerStorage storage s = flashBorrowerStorage();

        // check auth
        if (msg.sender != owner()) {
            requireAuth(action.target, action.call_type, action.target_calldata.toBytes4());
        }
        revert("make sure lender is approved");

        // we could pass the calldata to the lender and have them pass it back, but that seems less safe
        // use storage so that no one can change it
        s.pending_action = action;
        s.pending_flashloan = true;

        s.lender.flashLoan(this, token, amount, "");
        // s.pending_loan is changed to false

        // copy the call's returned value to return it from this function
        returned = s.pending_return;

        // clear the pending values
        delete s.pending_action;
        delete s.pending_return;
    }
    
    /// @notice postcondition initiator == address(this)
    /// @notice postcondition msg.sender == address(s.lender)
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external  returns(bytes32) {
        FlashBorrowerStorage storage s = flashBorrowerStorage();

        // auth
        // pending_loan is like the opposite of a re-entrancy guard
        require(
            s.pending_flashloan,
            "FlashBorrower !pending_loan"
        );
        require(
            msg.sender == address(s.lender),
            "FlashBorrower !lender"
        );
        require(
            initiator == address(this),
            "FlashBorrower !initiator"
        );

        // clear pending_loan now in case the delegatecall tries to do something sneaky
        // though i think storing things in state will protect things better
        s.pending_flashloan = false;

        require(
            Address.isContract(s.pending_target),
            "ArgobytesProxy.execute BAD_TARGET"
        );

        // uncheckedDelegateCall is safe because we just checked that `target` is a contract
        // emit an event with the response?
        bytes memory returned;
        if (s.pending_action.call_type == ArgobytesAuth.CallType.DELEGATE) {
            returned = Address2.uncheckedDelegateCall(
                s.pending_action.target,
                s.pending_action.target_calldata,
                "FlashLoanBorrower.onFlashLoan !delegatecall"
            );
        } else {
            returned = Address2.uncheckedCall(
                s.pending_action.target,
                s.pending_action.target_calldata,
                "FlashLoanBorrower.onFlashLoan !call"
            );
        }

        // since we can't return the call's return from here, we store it in state
        s.pending_return = returned;

        // approve paying back the loan
        IERC20(token).approve(address(s.lender), amount + fee);

        // return their special response
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
