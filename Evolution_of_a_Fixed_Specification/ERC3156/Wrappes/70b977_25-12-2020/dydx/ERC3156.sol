pragma solidity >= 0.5.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./IERC3156FlashBorrower.sol";
import "./SoloMarginLike.sol";
import "./DYDXFlashBorrowerLike.sol";
import "./DYDXDataTypes.sol";


contract DYDXERC3156 is DYDXFlashBorrowerLike {
    using SafeMath for uint256;

    uint256 internal NULL_ACCOUNT_ID = 0;
    uint256 internal NULL_MARKET_ID = 0;
    DYDXDataTypes.AssetAmount internal NULL_AMOUNT = DYDXDataTypes.AssetAmount({
        sign: false,
        denomination: DYDXDataTypes.AssetDenomination.Wei,
        ref: DYDXDataTypes.AssetReference.Delta,
        value: 0
    });
    bytes internal NULL_DATA = "";

    address internal _soloMarginAddress;
    mapping(address => uint256) internal _tokenAddressToMarketId;
    mapping(uint256 => address) internal _marketIdToTokenAddress;
    mapping(address => bool) internal _tokensRegistered;

    constructor (address soloMarginAddress)
    public {
        _soloMarginAddress = soloMarginAddress;
    }

    function registerPool(uint256 marketId) external  {
        address token = SoloMarginLike(_soloMarginAddress).getMarketTokenAddress(marketId);
        require(token != address(0), "SoloLiquidityProxy: cannot register empty market");

        _tokenAddressToMarketId[token] = marketId;
        _marketIdToTokenAddress[marketId] = token;
        _tokensRegistered[token] = true;
        IERC20(token).approve(_soloMarginAddress, uint256(-1));
    }

    function deregisterPool(uint256 marketId) external {
        address token = _marketIdToTokenAddress[marketId];

        _tokenAddressToMarketId[token] = 0;
        _marketIdToTokenAddress[marketId] = address(0);
        _tokensRegistered[token] = false;
        IERC20(token).approve(_soloMarginAddress, 0);
    }

    function flashSupply(address token) external view  returns (uint256) {
        if (isRegistered(token)) {
            return IERC20(token).balanceOf(_soloMarginAddress);
        }

        return 0;
    }

    function flashFee(address token, uint256 amount) public view  returns (uint256) {
        // Add 1 wei for markets 0-1 and 2 wei for markets 2-3
        return marketIdFromTokenAddress(token) < 2 ? 1 : 2;
    }

    function flashLoan(address receiver, address token, uint256 amount, bytes calldata data) external  {
        SoloMarginLike solo = SoloMarginLike(_soloMarginAddress);
        DYDXDataTypes.ActionArgs[] memory operations = new DYDXDataTypes.ActionArgs[](3);
        operations[0] = getWithdrawAction(token, amount);
        operations[1] = getCallAction(abi.encode(data, msg.sender, receiver, token, amount));
        operations[2] = getDepositAction(token, amount.add(flashFee(token, amount)));
        DYDXDataTypes.AccountInfo[] memory accountInfos = new DYDXDataTypes.AccountInfo[](1);
        accountInfos[0] = getAccountInfo();

        solo.operate(accountInfos, operations);
    }

    function callFunction(
        address innerSender,
        DYDXDataTypes.AccountInfo memory accountInfo,
        bytes memory wrappedData
    )
    public 
    {
        require(msg.sender == _soloMarginAddress, "SoloLiquidityProxy: callback only from SoloMargin");
        require(innerSender == address(this), "SoloLiquidityProxy: flashLoan only from this contract");

        (bytes memory data, address sender, address receiver, address token, uint256 amount) = 
            abi.decode(wrappedData, (bytes, address, address, address, uint256));

        // Transfer to `receiver`
        require(
            IERC20(token).transfer(receiver, amount),
            "SoloLiquidityProxy: transfer to invoker failed");

        IERC3156FlashBorrower(receiver).onFlashLoan(sender, token, amount, flashFee(token, amount), data);
    }

    function getAccountInfo() internal view returns (DYDXDataTypes.AccountInfo memory) {
        return DYDXDataTypes.AccountInfo({
            owner: address(this),
            number: 1
        });
    }

    function getWithdrawAction(address token, uint256 amount)
    internal
    view
    returns (DYDXDataTypes.ActionArgs memory)
    {
        return DYDXDataTypes.ActionArgs({
            actionType: DYDXDataTypes.ActionType.Withdraw,
            accountId: 0,
            amount: DYDXDataTypes.AssetAmount({
                sign: false,
                denomination: DYDXDataTypes.AssetDenomination.Wei,
                ref: DYDXDataTypes.AssetReference.Delta,
                value: amount
            }),
            primaryMarketId: marketIdFromTokenAddress(token),
            secondaryMarketId: NULL_MARKET_ID,
            otherAddress: address(this),
            otherAccountId: NULL_ACCOUNT_ID,
            data: NULL_DATA
        });
    }

    function getDepositAction(address token, uint256 repaymentAmount)
    internal
    view
    returns (DYDXDataTypes.ActionArgs memory)
    {
        return DYDXDataTypes.ActionArgs({
            actionType: DYDXDataTypes.ActionType.Deposit,
            accountId: 0,
            amount: DYDXDataTypes.AssetAmount({
                sign: true,
                denomination: DYDXDataTypes.AssetDenomination.Wei,
                ref: DYDXDataTypes.AssetReference.Delta,
                value: repaymentAmount
            }),
            primaryMarketId: marketIdFromTokenAddress(token),
            secondaryMarketId: NULL_MARKET_ID,
            otherAddress: address(this),
            otherAccountId: NULL_ACCOUNT_ID,
            data: NULL_DATA
        });
    }

    function getCallAction(bytes memory data_)
    internal
    view
    returns (DYDXDataTypes.ActionArgs memory)
    {
        return DYDXDataTypes.ActionArgs({
            actionType: DYDXDataTypes.ActionType.Call,
            accountId: 0,
            amount: NULL_AMOUNT,
            primaryMarketId: NULL_MARKET_ID,
            secondaryMarketId: NULL_MARKET_ID,
            otherAddress: address(this),
            otherAccountId: NULL_ACCOUNT_ID,
            data: data_
        });
    }

    function isRegistered(address token) internal view returns (bool) {
        return _tokensRegistered[token];
    }

    function marketIdFromTokenAddress(address token) internal view returns (uint256) {
        return _tokenAddressToMarketId[token];
    }
}