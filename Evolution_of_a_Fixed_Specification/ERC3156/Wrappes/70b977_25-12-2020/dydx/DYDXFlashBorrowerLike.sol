pragma solidity >= 0.5.0;
pragma experimental ABIEncoderV2;


import "./DYDXDataTypes.sol";

/**
 * @title DYDXFlashBorrowerLike
 * @author dYdX
 *
 * Interface that Callees for Solo must implement in order to ingest data.
 */
interface DYDXFlashBorrowerLike {

    // ============ Public Functions ============

    /**
     * Allows users to send this contract arbitrary data.
     *
     * @param  sender       The msg.sender to Solo
     * @param  accountInfo  The account from which the data is being sent
     * @param  data         Arbitrary data given by the sender
     */
    function callFunction(
        address sender,
        DYDXDataTypes.AccountInfo calldata accountInfo,
        bytes calldata data
    )
    external;
}