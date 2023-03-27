// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >= 0.5.0;
pragma experimental ABIEncoderV2;

import "./IERC20.sol";
import "./SafeMath.sol";


interface FlashBorrowerLike {
    function onFlashLoan(address user, address token, uint256 value, uint256 fee, bytes calldata) external;
}
interface LendingPoolAddressesProviderLike {
    function getLendingPool() external view returns (address);
}

interface LendingPoolLike {
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;

    function getReserveData(address asset) external view returns (ReserveData memory);

    struct ReserveData {
        //stores the reserve configuration
        ReserveConfigurationMap configuration;
        //the liquidity index. Expressed in ray
        uint128 liquidityIndex;
        //variable borrow index. Expressed in ray
        uint128 variableBorrowIndex;
        //the current supply rate. Expressed in ray
        uint128 currentLiquidityRate;
        //the current variable borrow rate. Expressed in ray
        uint128 currentVariableBorrowRate;
        //the current stable borrow rate. Expressed in ray
        uint128 currentStableBorrowRate;
        uint40 lastUpdateTimestamp;
        //tokens addresses
        address aTokenAddress;
        address stableDebtTokenAddress;
        address variableDebtTokenAddress;
        //address of the interest rate strategy
        address interestRateStrategyAddress;
        //the id of the reserve. Represents the position in the list of the active reserves
        uint8 id;
    }

    struct ReserveConfigurationMap {
       
        uint256 data;
    }
}

/**
 * @author Alberto Cuesta Cañada
 * @dev ERC-3156 wrapper for Aave flash loans.
 */
contract AaveERC3156 {
    using SafeMath for uint256;

    LendingPoolLike public lendingPool;

    constructor(LendingPoolAddressesProviderLike provider) public {
        lendingPool = LendingPoolLike(provider.getLendingPool());
    }

    /// @notice postcondition receiver == address(this)
    /// @notice postcondition msg.sender == address(s.lender)
    function flashLoan(address receiver, address token, uint256 value, bytes calldata data) external {
        address receiverAddress = address(this);

        address[] memory tokens = new address[](1);
        tokens[0] = address(token);

        uint256[] memory values = new uint256[](1);
        values[0] = value;

        // 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);
        bytes memory wrappedData = abi.encode(data, msg.sender, receiver);
        uint16 referralCode = 0;

        lendingPool.flashLoan(
            receiverAddress,
            tokens,
            values,
            modes,
            onBehalfOf,
            wrappedData,
            referralCode
        );
    }

    /// @dev Aave flash loan callback. It sends the value borrowed to `receiver`, and expects that the value plus the fee will be transferred back.
    function executeOperation(
        address[] calldata tokens,
        uint256[] calldata values,
        uint256[] calldata fees,
        address initiator,
        bytes calldata wrappedData
    )
        external returns (bool)
    {
        require(msg.sender == address(lendingPool), "Callbacks only allowed from Lending Pool");
        require(initiator == address(this), "Callbacks only initiated from this contract");

        (bytes memory data, address sender, address receiver) = abi.decode(wrappedData, (bytes, address, address));

        // Send the tokens to the original receiver using the ERC-3156 interface
        IERC20(tokens[0]).transfer(sender, values[0]);
        FlashBorrowerLike(receiver).onFlashLoan(sender, tokens[0], values[0], fees[0], data);

        // Approve the LendingPool contract allowance to *pull* the owed amount
        IERC20(tokens[0]).approve(address(lendingPool), values[0].add(fees[0]));

        return true;
    }

    /**
     * @dev The fee to be charged for a given loan.
     * @param token The loan currency.
     * @param value The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */
    function flashFee(address token, uint256 value) external view returns (uint256) {
        return value.mul(9).div(10000); // lendingPool.FLASHLOAN_PREMIUM_TOTAL()
    }

    /**
     * @dev The amount of currency available to be lended.
     * @param token The loan currency.
     * @return The amount of `token` that can be borrowed.
     */
    function flashSupply(address token) external view returns (uint256) {
        LendingPoolLike.ReserveData memory reserveData = lendingPool.getReserveData(token);
        return IERC20(reserveData.aTokenAddress).balanceOf(address(lendingPool));
    }
}