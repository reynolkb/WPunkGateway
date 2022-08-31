// Sources flattened with hardhat v2.9.3 https://hardhat.org

// File contracts/dependencies/openzeppelin/contracts/Context.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File contracts/dependencies/openzeppelin/contracts/Ownable.sol

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File contracts/interfaces/IPoolAddressesProvider.sol

/**
 * @title IPoolAddressesProvider
 *
 * @notice Defines the basic interface for a Pool Addresses Provider.
 **/
interface IPoolAddressesProvider {
    /**
     * @dev Emitted when the market identifier is updated.
     * @param oldMarketId The old id of the market
     * @param newMarketId The new id of the market
     */
    event MarketIdSet(string indexed oldMarketId, string indexed newMarketId);

    /**
     * @dev Emitted when the pool is updated.
     * @param oldAddress The old address of the Pool
     * @param newAddress The new address of the Pool
     */
    event PoolUpdated(address indexed oldAddress, address indexed newAddress);

    /**
     * @dev Emitted when the pool configurator is updated.
     * @param oldAddress The old address of the PoolConfigurator
     * @param newAddress The new address of the PoolConfigurator
     */
    event PoolConfiguratorUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the price oracle is updated.
     * @param oldAddress The old address of the PriceOracle
     * @param newAddress The new address of the PriceOracle
     */
    event PriceOracleUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the ACL manager is updated.
     * @param oldAddress The old address of the ACLManager
     * @param newAddress The new address of the ACLManager
     */
    event ACLManagerUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the ACL admin is updated.
     * @param oldAddress The old address of the ACLAdmin
     * @param newAddress The new address of the ACLAdmin
     */
    event ACLAdminUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the price oracle sentinel is updated.
     * @param oldAddress The old address of the PriceOracleSentinel
     * @param newAddress The new address of the PriceOracleSentinel
     */
    event PriceOracleSentinelUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the pool data provider is updated.
     * @param oldAddress The old address of the PoolDataProvider
     * @param newAddress The new address of the PoolDataProvider
     */
    event PoolDataProviderUpdated(
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when a new proxy is created.
     * @param id The identifier of the proxy
     * @param proxyAddress The address of the created proxy contract
     * @param implementationAddress The address of the implementation contract
     */
    event ProxyCreated(
        bytes32 indexed id,
        address indexed proxyAddress,
        address indexed implementationAddress
    );

    /**
     * @dev Emitted when a new non-proxied contract address is registered.
     * @param id The identifier of the contract
     * @param oldAddress The address of the old contract
     * @param newAddress The address of the new contract
     */
    event AddressSet(
        bytes32 indexed id,
        address indexed oldAddress,
        address indexed newAddress
    );

    /**
     * @dev Emitted when the implementation of the proxy registered with id is updated
     * @param id The identifier of the contract
     * @param proxyAddress The address of the proxy contract
     * @param oldImplementationAddress The address of the old implementation contract
     * @param newImplementationAddress The address of the new implementation contract
     */
    event AddressSetAsProxy(
        bytes32 indexed id,
        address indexed proxyAddress,
        address oldImplementationAddress,
        address indexed newImplementationAddress
    );

    /**
     * @notice Returns the id of the Omni market to which this contract points to.
     * @return The market id
     **/
    function getMarketId() external view returns (string memory);

    /**
     * @notice Associates an id with a specific PoolAddressesProvider.
     * @dev This can be used to create an onchain registry of PoolAddressesProviders to
     * identify and validate multiple Omni markets.
     * @param newMarketId The market id
     */
    function setMarketId(string calldata newMarketId) external;

    /**
     * @notice Returns an address by its identifier.
     * @dev The returned address might be an EOA or a contract, potentially proxied
     * @dev It returns ZERO if there is no registered address with the given id
     * @param id The id
     * @return The address of the registered for the specified id
     */
    function getAddress(bytes32 id) external view returns (address);

    /**
     * @notice General function to update the implementation of a proxy registered with
     * certain `id`. If there is no proxy registered, it will instantiate one and
     * set as implementation the `newImplementationAddress`.
     * @dev IMPORTANT Use this function carefully, only for ids that don't have an explicit
     * setter function, in order to avoid unexpected consequences
     * @param id The id
     * @param newImplementationAddress The address of the new implementation
     */
    function setAddressAsProxy(bytes32 id, address newImplementationAddress)
        external;

    /**
     * @notice Sets an address for an id replacing the address saved in the addresses map.
     * @dev IMPORTANT Use this function carefully, as it will do a hard replacement
     * @param id The id
     * @param newAddress The address to set
     */
    function setAddress(bytes32 id, address newAddress) external;

    /**
     * @notice Returns the address of the Pool proxy.
     * @return The Pool proxy address
     **/
    function getPool() external view returns (address);

    /**
     * @notice Updates the implementation of the Pool, or creates a proxy
     * setting the new `pool` implementation when the function is called for the first time.
     * @param newPoolImpl The new Pool implementation
     **/
    function setPoolImpl(address newPoolImpl) external;

    /**
     * @notice Returns the address of the PoolConfigurator proxy.
     * @return The PoolConfigurator proxy address
     **/
    function getPoolConfigurator() external view returns (address);

    /**
     * @notice Updates the implementation of the PoolConfigurator, or creates a proxy
     * setting the new `PoolConfigurator` implementation when the function is called for the first time.
     * @param newPoolConfiguratorImpl The new PoolConfigurator implementation
     **/
    function setPoolConfiguratorImpl(address newPoolConfiguratorImpl) external;

    /**
     * @notice Returns the address of the price oracle.
     * @return The address of the PriceOracle
     */
    function getPriceOracle() external view returns (address);

    /**
     * @notice Updates the address of the price oracle.
     * @param newPriceOracle The address of the new PriceOracle
     */
    function setPriceOracle(address newPriceOracle) external;

    /**
     * @notice Returns the address of the ACL manager.
     * @return The address of the ACLManager
     */
    function getACLManager() external view returns (address);

    /**
     * @notice Updates the address of the ACL manager.
     * @param newAclManager The address of the new ACLManager
     **/
    function setACLManager(address newAclManager) external;

    /**
     * @notice Returns the address of the ACL admin.
     * @return The address of the ACL admin
     */
    function getACLAdmin() external view returns (address);

    /**
     * @notice Updates the address of the ACL admin.
     * @param newAclAdmin The address of the new ACL admin
     */
    function setACLAdmin(address newAclAdmin) external;

    /**
     * @notice Returns the address of the price oracle sentinel.
     * @return The address of the PriceOracleSentinel
     */
    function getPriceOracleSentinel() external view returns (address);

    /**
     * @notice Updates the address of the price oracle sentinel.
     * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
     **/
    function setPriceOracleSentinel(address newPriceOracleSentinel) external;

    /**
     * @notice Returns the address of the data provider.
     * @return The address of the DataProvider
     */
    function getPoolDataProvider() external view returns (address);

    /**
     * @notice Updates the address of the data provider.
     * @param newDataProvider The address of the new DataProvider
     **/
    function setPoolDataProvider(address newDataProvider) external;
}

// File contracts/protocol/libraries/types/DataTypes.sol

library DataTypes {
    enum AssetType {
        ERC20,
        ERC721,
        ERC1155
    }

    struct ReserveData {
        //stores the reserve configuration
        ReserveConfigurationMap configuration;
        //the liquidity index. Expressed in ray
        uint128 liquidityIndex;
        //the current supply rate. Expressed in ray
        uint128 currentLiquidityRate;
        //variable borrow index. Expressed in ray
        uint128 variableBorrowIndex;
        //the current variable borrow rate. Expressed in ray
        uint128 currentVariableBorrowRate;
        //the current stable borrow rate. Expressed in ray
        uint128 currentStableBorrowRate;
        //timestamp of last update
        uint40 lastUpdateTimestamp;
        //the id of the reserve. Represents the position in the list of the active reserves
        uint16 id;
        // the asset type of the reserve (uint8)
        AssetType assetType;
        //xToken address
        address xTokenAddress;
        //stableDebtToken address
        address stableDebtTokenAddress;
        //variableDebtToken address
        address variableDebtTokenAddress;
        //address of the interest rate strategy
        address interestRateStrategyAddress;
        //the current treasury balance, scaled
        uint128 accruedToTreasury;
    }

    struct ReserveConfigurationMap {
        //bit 0-15: LTV
        //bit 16-31: Liq. threshold
        //bit 32-47: Liq. bonus
        //bit 48-55: Decimals
        //bit 56: reserve is active
        //bit 57: reserve is frozen
        //bit 58: borrowing is enabled
        //bit 59: stable rate borrowing enabled
        //bit 60: asset is paused
        //bit 61: borrowing in isolation mode is enabled
        //bit 62-63: reserved
        //bit 64-79: reserve factor
        //bit 80-115 borrow cap in whole tokens, borrowCap == 0 => no cap
        //bit 116-151 supply cap in whole tokens, supplyCap == 0 => no cap
        //bit 152-167 liquidation protocol fee
        //bit 168-175 eMode category
        //bit 176-211 unbacked mint cap in whole tokens, unbackedMintCap == 0 => minting disabled
        //bit 212-251 debt ceiling for isolation mode with (ReserveConfiguration::DEBT_CEILING_DECIMALS) decimals
        //bit 252-255 unused

        uint256 data;
    }

    struct UserConfigurationMap {
        /**
         * @dev Bitmap of the users collaterals and borrows. It is divided in pairs of bits, one pair per asset.
         * The first bit indicates if an asset is used as collateral by the user, the second whether an
         * asset is borrowed by the user.
         */
        uint256 data;
    }

    struct ERC721SupplyParams {
        uint256 tokenId;
        bool useAsCollateral;
    }

    enum InterestRateMode {
        NONE,
        STABLE,
        VARIABLE
    }

    struct ReserveCache {
        AssetType assetType;
        uint256 currScaledVariableDebt;
        uint256 nextScaledVariableDebt;
        uint256 currPrincipalStableDebt;
        uint256 currAvgStableBorrowRate;
        uint256 currTotalStableDebt;
        uint256 nextAvgStableBorrowRate;
        uint256 nextTotalStableDebt;
        uint256 currLiquidityIndex;
        uint256 nextLiquidityIndex;
        uint256 currVariableBorrowIndex;
        uint256 nextVariableBorrowIndex;
        uint256 currLiquidityRate;
        uint256 currVariableBorrowRate;
        uint256 reserveFactor;
        ReserveConfigurationMap reserveConfiguration;
        address xTokenAddress;
        address stableDebtTokenAddress;
        address variableDebtTokenAddress;
        uint40 reserveLastUpdateTimestamp;
        uint40 stableDebtLastUpdateTimestamp;
    }

    // struct ExecuteLiquidationCallParams {
    //     uint256 reservesCount;
    //     uint256 debtToCover;
    //     address collateralAsset;
    //     address debtAsset;
    //     address user;
    //     bool receiveOToken;
    //     address priceOracle;
    //     address priceOracleSentinel;
    // }

    // struct ExecuteERC721LiquidationCallParams {
    //     uint256 reservesCount;
    //     uint256 liquidationAmount;
    //     uint256 collateralTokenId;
    //     address collateralAsset;
    //     address liquidationAsset;
    //     address user;
    //     bool receiveNToken;
    //     address priceOracle;
    //     address priceOracleSentinel;
    // }

    struct ExecuteLiquidationCallParams {
        uint256 reservesCount;
        uint256 liquidationAmount;
        uint256 collateralTokenId;
        address collateralAsset;
        address liquidationAsset;
        address user;
        bool receiveXToken;
        address priceOracle;
        address priceOracleSentinel;
    }

    struct ExecuteSupplyParams {
        address asset;
        uint256 amount;
        address onBehalfOf;
        uint16 referralCode;
    }

    struct ExecuteSupplyERC721Params {
        address asset;
        DataTypes.ERC721SupplyParams[] tokenData;
        address onBehalfOf;
        uint16 referralCode;
    }

    struct ExecuteBorrowParams {
        address asset;
        address user;
        address onBehalfOf;
        uint256 amount;
        InterestRateMode interestRateMode;
        uint16 referralCode;
        bool releaseUnderlying;
        uint256 maxStableRateBorrowSizePercent;
        uint256 reservesCount;
        address oracle;
        address priceOracleSentinel;
    }

    struct ExecuteRepayParams {
        address asset;
        uint256 amount;
        InterestRateMode interestRateMode;
        address onBehalfOf;
        bool useOTokens;
    }

    struct ExecuteWithdrawParams {
        address asset;
        uint256 amount;
        address to;
        uint256 reservesCount;
        address oracle;
    }

    struct ExecuteWithdrawERC721Params {
        address asset;
        uint256[] tokenIds;
        address to;
        uint256 reservesCount;
        address oracle;
    }

    struct FinalizeTransferParams {
        address asset;
        address from;
        address to;
        bool usedAsCollateral;
        uint256 value;
        uint256 balanceFromBefore;
        uint256 balanceToBefore;
        uint256 reservesCount;
        address oracle;
    }

    struct CalculateUserAccountDataParams {
        UserConfigurationMap userConfig;
        uint256 reservesCount;
        address user;
        address oracle;
    }

    struct ValidateBorrowParams {
        ReserveCache reserveCache;
        UserConfigurationMap userConfig;
        address asset;
        address userAddress;
        uint256 amount;
        InterestRateMode interestRateMode;
        uint256 maxStableLoanPercent;
        uint256 reservesCount;
        address oracle;
        address priceOracleSentinel;
        AssetType assetType;
    }

    struct ValidateLiquidationCallParams {
        ReserveCache debtReserveCache;
        uint256 totalDebt;
        uint256 healthFactor;
        address priceOracleSentinel;
        AssetType assetType;
    }

    struct ValidateERC721LiquidationCallParams {
        ReserveCache debtReserveCache;
        uint256 totalDebt;
        uint256 healthFactor;
        uint256 tokenId;
        uint256 collateralDiscountedPrice;
        uint256 liquidationAmount;
        address priceOracleSentinel;
        address xTokenAddress;
        AssetType assetType;
    }

    struct CalculateInterestRatesParams {
        uint256 liquidityAdded;
        uint256 liquidityTaken;
        uint256 totalStableDebt;
        uint256 totalVariableDebt;
        uint256 averageStableBorrowRate;
        uint256 reserveFactor;
        address reserve;
        address xToken;
    }

    struct InitReserveParams {
        address asset;
        AssetType assetType;
        address xTokenAddress;
        address stableDebtAddress;
        address variableDebtAddress;
        address interestRateStrategyAddress;
        uint16 reservesCount;
        uint16 maxNumberReserves;
    }

    struct ExecuteFlashClaimParams {
        address receiverAddress;
        address nftAsset;
        uint256[] nftTokenIds;
        bytes params;
    }
}

// File contracts/interfaces/IPool.sol

/**
 * @title IPool
 *
 * @notice Defines the basic interface for an Omni Pool.
 **/
interface IPool {
    /**
     * @dev Emitted on supply()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address initiating the supply
     * @param onBehalfOf The beneficiary of the supply, receiving the xTokens
     * @param amount The amount supplied
     * @param referralCode The referral code used
     **/
    event Supply(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        uint16 indexed referralCode
    );

    event SupplyERC721(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        DataTypes.ERC721SupplyParams[] tokenData,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted on withdraw()
     * @param reserve The address of the underlying asset being withdrawn
     * @param user The address initiating the withdrawal, owner of xTokens
     * @param to The address that will receive the underlying asset
     * @param amount The amount to be withdrawn
     **/
    event Withdraw(
        address indexed reserve,
        address indexed user,
        address indexed to,
        uint256 amount
    );

    /**
     * @dev Emitted on withdrawERC721()
     * @param reserve The address of the underlying asset being withdrawn
     * @param user The address initiating the withdrawal, owner of xTokens
     * @param to The address that will receive the underlying asset
     * @param tokenIds The tokenIds to be withdrawn
     **/
    event WithdrawERC721(
        address indexed reserve,
        address indexed user,
        address indexed to,
        uint256[] tokenIds
    );

    /**
     * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
     * @param reserve The address of the underlying asset being borrowed
     * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
     * initiator of the transaction on flashLoan()
     * @param onBehalfOf The address that will be getting the debt
     * @param amount The amount borrowed out
     * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
     * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
     * @param referralCode The referral code used
     **/
    event Borrow(
        address indexed reserve,
        address user,
        address indexed onBehalfOf,
        uint256 amount,
        DataTypes.InterestRateMode interestRateMode,
        uint256 borrowRate,
        uint16 indexed referralCode
    );

    /**
     * @dev Emitted on repay()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The beneficiary of the repayment, getting his debt reduced
     * @param repayer The address of the user initiating the repay(), providing the funds
     * @param amount The amount repaid
     * @param useOTokens True if the repayment is done using xTokens, `false` if done with underlying asset directly
     **/
    event Repay(
        address indexed reserve,
        address indexed user,
        address indexed repayer,
        uint256 amount,
        bool useOTokens
    );

    /**
     * @dev Emitted on swapBorrowRateMode()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user swapping his rate mode
     * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
     **/
    event SwapBorrowRateMode(
        address indexed reserve,
        address indexed user,
        DataTypes.InterestRateMode interestRateMode
    );

    /**
     * @dev Emitted on setUserUseReserveAsCollateral()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user enabling the usage as collateral
     **/
    event ReserveUsedAsCollateralEnabled(
        address indexed reserve,
        address indexed user
    );

    /**
     * @dev Emitted on setUserUseReserveAsCollateral()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user enabling the usage as collateral
     **/
    event ReserveUsedAsCollateralDisabled(
        address indexed reserve,
        address indexed user
    );

    /**
     * @dev Emitted on rebalanceStableBorrowRate()
     * @param reserve The address of the underlying asset of the reserve
     * @param user The address of the user for which the rebalance has been executed
     **/
    event RebalanceStableBorrowRate(
        address indexed reserve,
        address indexed user
    );

    /**
     * @dev Emitted when a borrower is liquidated.
     * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
     * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
     * @param user The address of the borrower getting liquidated
     * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
     * @param liquidatedCollateralAmount The amount of collateral received by the liquidator
     * @param liquidator The address of the liquidator
     * @param receiveOToken True if the liquidators wants to receive the collateral xTokens, `false` if he wants
     * to receive the underlying collateral asset directly
     **/
    event LiquidationCall(
        address indexed collateralAsset,
        address indexed debtAsset,
        address indexed user,
        uint256 debtToCover,
        uint256 liquidatedCollateralAmount,
        address liquidator,
        bool receiveOToken
    );

    /**
     * @dev Emitted when the state of a reserve is updated.
     * @param reserve The address of the underlying asset of the reserve
     * @param liquidityRate The next liquidity rate
     * @param stableBorrowRate The next stable borrow rate
     * @param variableBorrowRate The next variable borrow rate
     * @param liquidityIndex The next liquidity index
     * @param variableBorrowIndex The next variable borrow index
     **/
    event ReserveDataUpdated(
        address indexed reserve,
        uint256 liquidityRate,
        uint256 stableBorrowRate,
        uint256 variableBorrowRate,
        uint256 liquidityIndex,
        uint256 variableBorrowIndex
    );

    /**
     * @dev Emitted when the protocol treasury receives minted xTokens from the accrued interest.
     * @param reserve The address of the reserve
     * @param amountMinted The amount minted to the treasury
     **/
    event MintedToTreasury(address indexed reserve, uint256 amountMinted);

    /**
     * @dev Emitted on flashClaim
     * @param target The address of the flash loan receiver contract
     * @param initiator The address initiating the flash claim
     * @param nftAsset address of the underlying asset of NFT
     * @param tokenId The token id of the asset being flash borrowed
     **/
    event FlashClaim(
        address indexed target,
        address indexed initiator,
        address indexed nftAsset,
        uint256 tokenId
    );

    /**
     * @dev Allows smart contracts to access the tokens within one transaction, as long as the tokens taken is returned.
     *
     * Requirements:
     *  - `nftTokenIds` must exist.
     *
     * @param receiverAddress The address of the contract receiving the tokens, implementing the IFlashClaimReceiver interface
     * @param nftAsset address of the underlying asset of NFT
     * @param nftTokenIds token ids of the underlying asset
     * @param params Variadic packed params to pass to the receiver as extra information
     */
    function flashClaim(
        address receiverAddress,
        address nftAsset,
        uint256[] calldata nftTokenIds,
        bytes calldata params
    ) external;

    /**
     * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying xTokens.
     * - E.g. User supplies 100 USDC and gets in return 100 oUSDC
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param onBehalfOf The address that will receive the xTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of xTokens
     *   is a different wallet
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     **/
    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    /**
     * @notice Supplies multiple `tokenIds` of underlying ERC721 asset into the reserve, receiving in return overlying nTokens.
     * - E.g. User supplies 2 BAYC and gets in return 2 nBAYC
     * @param asset The address of the underlying asset to supply
     * @param tokenData The list of tokenIds and their collateral configs to be supplied
     * @param onBehalfOf The address that will receive the xTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of xTokens
     *   is a different wallet
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     **/
    function supplyERC721(
        address asset,
        DataTypes.ERC721SupplyParams[] calldata tokenData,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    /**
     * @notice Supply with transfer approval of asset to be supplied done via permit function
     * see: https://eips.ethereum.org/EIPS/eip-2612 and https://eips.ethereum.org/EIPS/eip-713
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param onBehalfOf The address that will receive the xTokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of xTokens
     *   is a different wallet
     * @param deadline The deadline timestamp that the permit is valid
     * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     * @param permitV The V parameter of ERC712 permit sig
     * @param permitR The R parameter of ERC712 permit sig
     * @param permitS The S parameter of ERC712 permit sig
     **/
    function supplyWithPermit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external;

    /**
     * @notice Withdraws an `amount` of underlying asset from the reserve, burning the equivalent xTokens owned
     * E.g. User has 100 oUSDC, calls withdraw() and receives 100 USDC, burning the 100 oUSDC
     * @param asset The address of the underlying asset to withdraw
     * @param amount The underlying amount to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole xToken balance
     * @param to The address that will receive the underlying, same as msg.sender if the user
     *   wants to receive it on his own wallet, or a different address if the beneficiary is a
     *   different wallet
     * @return The final amount withdrawn
     **/
    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256);

    /**
     * @notice Withdraws multiple `tokenIds` of underlying ERC721  asset from the reserve, burning the equivalent nTokens owned
     * E.g. User has 2 nBAYC, calls withdraw() and receives 2 BAYC, burning the 2 nBAYC
     * @param asset The address of the underlying asset to withdraw
     * @param tokenIds The underlying tokenIds to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole xToken balance
     * @param to The address that will receive the underlying, same as msg.sender if the user
     *   wants to receive it on his own wallet, or a different address if the beneficiary is a
     *   different wallet
     * @return The final amount withdrawn
     **/
    function withdrawERC721(
        address asset,
        uint256[] calldata tokenIds,
        address to
    ) external returns (uint256);

    /**
     * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
     * already supplied enough collateral, or he was given enough allowance by a credit delegator on the
     * corresponding debt token (StableDebtToken or VariableDebtToken)
     * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
     *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
     * @param asset The address of the underlying asset to borrow
     * @param amount The amount to be borrowed
     * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
     * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
     *   0 if the action is executed directly by the user, without any middle-man
     * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
     * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
     * if he has been given credit delegation allowance
     **/
    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    /**
     * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
     * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @param onBehalfOf The address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @return The final amount repaid
     **/
    function repay(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf
    ) external returns (uint256);

    /**
     * @notice Repay with transfer approval of asset to be repaid done via permit function
     * see: https://eips.ethereum.org/EIPS/eip-2612 and https://eips.ethereum.org/EIPS/eip-713
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @param deadline The deadline timestamp that the permit is valid
     * @param permitV The V parameter of ERC712 permit sig
     * @param permitR The R parameter of ERC712 permit sig
     * @param permitS The S parameter of ERC712 permit sig
     * @return The final amount repaid
     **/
    function repayWithPermit(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external returns (uint256);

    /**
     * @notice Repays a borrowed `amount` on a specific reserve using the reserve xTokens, burning the
     * equivalent debt tokens
     * - E.g. User repays 100 USDC using 100 oUSDC, burning 100 variable/stable debt tokens
     * @dev  Passing uint256.max as amount will clean up any residual xToken dust balance, if the user xToken
     * balance is not enough to cover the whole debt
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
     * @return The final amount repaid
     **/
    function repayWithOTokens(
        address asset,
        uint256 amount,
        uint256 interestRateMode
    ) external returns (uint256);

    /**
     * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
     * @param asset The address of the underlying asset borrowed
     * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
     **/
    function swapBorrowRateMode(address asset, uint256 interestRateMode)
        external;

    /**
     * @notice Rebalances the stable interest rate of a user to the current stable rate defined on the reserve.
     * - Users can be rebalanced if the following conditions are satisfied:
     *     1. Usage ratio is above 95%
     *     2. the current supply APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too
     *        much has been borrowed at a stable rate and suppliers are not earning enough
     * @param asset The address of the underlying asset borrowed
     * @param user The address of the user to be rebalanced
     **/
    function rebalanceStableBorrowRate(address asset, address user) external;

    /**
     * @notice Allows suppliers to enable/disable a specific supplied asset as collateral
     * @param asset The address of the underlying asset supplied
     * @param useAsCollateral True if the user wants to use the supply as collateral, false otherwise
     **/
    function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
        external;

    /**
     * @notice Allows suppliers to enable/disable a specific supplied ERC721 asset with a tokenID as collateral
     * @param asset The address of the underlying asset supplied
     * @param tokenId the id of the supplied ERC721 token
     * @param useAsCollateral True if the user wants to use the supply as collateral, false otherwise
     **/
    function setUserUseERC721AsCollateral(
        address asset,
        uint256 tokenId,
        bool useAsCollateral
    ) external virtual;

    /**
     * @notice Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
     * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
     *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
     * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
     * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
     * @param user The address of the borrower getting liquidated
     * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
     * @param receiveOToken True if the liquidators wants to receive the collateral xTokens, `false` if he wants
     * to receive the underlying collateral asset directly
     **/
    function liquidationCall(
        address collateralAsset,
        address debtAsset,
        address user,
        uint256 debtToCover,
        bool receiveOToken
    ) external;

    function liquidationERC721(
        address collateralAsset,
        address liquidationAsset,
        address user,
        uint256 collateralTokenId,
        uint256 liquidationAmount,
        bool receiveNToken
    ) external;

    /**
     * @notice Returns the user account data across all the reserves
     * @param user The address of the user
     * @return totalCollateralBase The total collateral of the user in the base currency used by the price feed
     * @return totalDebtBase The total debt of the user in the base currency used by the price feed
     * @return availableBorrowsBase The borrowing power left of the user in the base currency used by the price feed
     * @return currentLiquidationThreshold The liquidation threshold of the user
     * @return ltv The loan to value of The user
     * @return healthFactor The current health factor of the user
     **/
    function getUserAccountData(address user)
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor,
            uint256 erc721HealthFactor
        );

    /**
     * @notice Initializes a reserve, activating it, assigning an xToken and debt tokens and an
     * interest rate strategy
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param xTokenAddress The address of the xToken that will be assigned to the reserve
     * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
     * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
     * @param interestRateStrategyAddress The address of the interest rate strategy contract
     **/
    function initReserve(
        address asset,
        DataTypes.AssetType assetType,
        address xTokenAddress,
        address stableDebtAddress,
        address variableDebtAddress,
        address interestRateStrategyAddress
    ) external;

    /**
     * @notice Drop a reserve
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     **/
    function dropReserve(address asset) external;

    /**
     * @notice Updates the address of the interest rate strategy contract
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param rateStrategyAddress The address of the interest rate strategy contract
     **/
    function setReserveInterestRateStrategyAddress(
        address asset,
        address rateStrategyAddress
    ) external;

    /**
     * @notice Sets the configuration bitmap of the reserve as a whole
     * @dev Only callable by the PoolConfigurator contract
     * @param asset The address of the underlying asset of the reserve
     * @param configuration The new configuration bitmap
     **/
    function setConfiguration(
        address asset,
        DataTypes.ReserveConfigurationMap calldata configuration
    ) external;

    /**
     * @notice Returns the configuration of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The configuration of the reserve
     **/
    function getConfiguration(address asset)
        external
        view
        returns (DataTypes.ReserveConfigurationMap memory);

    /**
     * @notice Returns the configuration of the user across all the reserves
     * @param user The user address
     * @return The configuration of the user
     **/
    function getUserConfiguration(address user)
        external
        view
        returns (DataTypes.UserConfigurationMap memory);

    /**
     * @notice Returns the normalized income normalized income of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The reserve's normalized income
     */
    function getReserveNormalizedIncome(address asset)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the normalized variable debt per unit of asset
     * @param asset The address of the underlying asset of the reserve
     * @return The reserve normalized variable debt
     */
    function getReserveNormalizedVariableDebt(address asset)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the state and configuration of the reserve
     * @param asset The address of the underlying asset of the reserve
     * @return The state and configuration data of the reserve
     **/
    function getReserveData(address asset)
        external
        view
        returns (DataTypes.ReserveData memory);

    /**
     * @notice Validates and finalizes an xToken transfer
     * @dev Only callable by the overlying xToken of the `asset`
     * @param asset The address of the underlying asset of the xToken
     * @param from The user from which the xTokens are transferred
     * @param to The user receiving the xTokens
     * @param amount The amount being transferred/withdrawn
     * @param balanceFromBefore The xToken balance of the `from` user before the transfer
     * @param balanceToBefore The xToken balance of the `to` user before the transfer
     */
    function finalizeTransfer(
        address asset,
        address from,
        address to,
        bool usedAsCollateral,
        uint256 amount,
        uint256 balanceFromBefore,
        uint256 balanceToBefore
    ) external;

    /**
     * @notice Returns the list of the underlying assets of all the initialized reserves
     * @dev It does not include dropped reserves
     * @return The addresses of the underlying assets of the initialized reserves
     **/
    function getReservesList() external view returns (address[] memory);

    /**
     * @notice Returns the address of the underlying asset of a reserve by the reserve id as stored in the DataTypes.ReserveData struct
     * @param id The id of the reserve as stored in the DataTypes.ReserveData struct
     * @return The address of the reserve associated with id
     **/
    function getReserveAddressById(uint16 id) external view returns (address);

    /**
     * @notice Returns the PoolAddressesProvider connected to this contract
     * @return The address of the PoolAddressesProvider
     **/
    function ADDRESSES_PROVIDER()
        external
        view
        returns (IPoolAddressesProvider);

    /**
     * @notice Returns the percentage of available liquidity that can be borrowed at once at stable rate
     * @return The percentage of available liquidity to borrow, expressed in bps
     */
    function MAX_STABLE_RATE_BORROW_SIZE_PERCENT()
        external
        view
        returns (uint256);

    /**
     * @notice Returns the maximum number of reserves supported to be listed in this Pool
     * @return The maximum number of reserves supported
     */
    function MAX_NUMBER_RESERVES() external view returns (uint16);

    /**
     * @notice Mints the assets accrued through the reserve factor to the treasury in the form of xTokens
     * @param assets The list of reserves for which the minting needs to be executed
     **/
    function mintToTreasury(address[] calldata assets) external;

    /**
     * @notice Rescue and transfer tokens locked in this contract
     * @param token The address of the token
     * @param to The address of the recipient
     * @param amount The amount of token to transfer
     */
    function rescueTokens(
        address token,
        address to,
        uint256 amount
    ) external;
}

// File contracts/dependencies/openzeppelin/contracts/IERC165.sol

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File contracts/dependencies/openzeppelin/contracts/IERC721.sol

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

// File contracts/dependencies/openzeppelin/contracts/IERC721Receiver.sol

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// File contracts/misc/interfaces/IPunks.sol

/**
 * @dev Interface for a permittable ERC721 contract
 * See https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC72 allowance (see {IERC721-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC721-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IPunks {
    function balanceOf(address account) external view returns (uint256);

    function punkIndexToAddress(uint256 punkIndex)
        external
        view
        returns (address owner);

    function buyPunk(uint256 punkIndex) external;

    function transferPunk(address to, uint256 punkIndex) external;
}

// File contracts/misc/interfaces/IWrappedPunks.sol

//import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @dev Interface for a permittable ERC721 contract
 * See https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC72 allowance (see {IERC721-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC721-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IWrappedPunks is IERC721 {
    function punkContract() external view returns (address);

    function mint(uint256 punkIndex) external;

    function burn(uint256 punkIndex) external;

    function registerProxy() external;

    function proxyInfo(address user) external returns (address proxy);
}

// File contracts/ui/interfaces/IWPunkGateway.sol

interface IWPunkGateway {
    function supplyPunk(
        address pool,
        DataTypes.ERC721SupplyParams[] calldata punkIndexes,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    function withdrawPunk(
        address pool,
        uint256[] calldata punkIndexes,
        address to
    ) external;
}

// File contracts/dependencies/openzeppelin/contracts/IERC721Enumerable.sol

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

// File contracts/dependencies/openzeppelin/contracts/IERC1155Receiver.sol

/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File contracts/interfaces/IRewardController.sol

/**
 * @title IRewardController
 *
 * @notice Defines the basic interface for an Omni Incentives Controller.
 **/
interface IRewardController {
    /**
     * @dev Emitted during `handleAction`, `claimRewards` and `claimRewardsOnBehalf`
     * @param user The user that accrued rewards
     * @param amount The amount of accrued rewards
     */
    event RewardsAccrued(address indexed user, uint256 amount);

    event RewardsClaimed(
        address indexed user,
        address indexed to,
        uint256 amount
    );

    /**
     * @dev Emitted during `claimRewards` and `claimRewardsOnBehalf`
     * @param user The address that accrued rewards
     * @param to The address that will be receiving the rewards
     * @param claimer The address that performed the claim
     * @param amount The amount of rewards
     */
    event RewardsClaimed(
        address indexed user,
        address indexed to,
        address indexed claimer,
        uint256 amount
    );

    /**
     * @dev Emitted during `setClaimer`
     * @param user The address of the user
     * @param claimer The address of the claimer
     */
    event ClaimerSet(address indexed user, address indexed claimer);

    /**
     * @notice Returns the configuration of the distribution for a certain asset
     * @param asset The address of the reference asset of the distribution
     * @return The asset index
     * @return The emission per second
     * @return The last updated timestamp
     **/
    function getAssetData(address asset)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );

    /**
     * LEGACY **************************
     * @dev Returns the configuration of the distribution for a certain asset
     * @param asset The address of the reference asset of the distribution
     * @return The asset index, the emission per second and the last updated timestamp
     **/
    function assets(address asset)
        external
        view
        returns (
            uint128,
            uint128,
            uint256
        );

    /**
     * @notice Whitelists an address to claim the rewards on behalf of another address
     * @param user The address of the user
     * @param claimer The address of the claimer
     */
    function setClaimer(address user, address claimer) external;

    /**
     * @notice Returns the whitelisted claimer for a certain address (0x0 if not set)
     * @param user The address of the user
     * @return The claimer address
     */
    function getClaimer(address user) external view returns (address);

    /**
     * @notice Configure assets for a certain rewards emission
     * @param assets The assets to incentivize
     * @param emissionsPerSecond The emission for each asset
     */
    function configureAssets(
        address[] calldata assets,
        uint256[] calldata emissionsPerSecond
    ) external;

    /**
     * @notice Called by the corresponding asset on any update that affects the rewards distribution
     * @param asset The address of the user
     * @param userBalance The balance of the user of the asset in the pool
     * @param totalSupply The total supply of the asset in the pool
     **/
    function handleAction(
        address asset,
        uint256 totalSupply,
        uint256 userBalance
    ) external;

    /**
     * @notice Returns the total of rewards of a user, already accrued + not yet accrued
     * @param assets The assets to accumulate rewards for
     * @param user The address of the user
     * @return The rewards
     **/
    function getRewardsBalance(address[] calldata assets, address user)
        external
        view
        returns (uint256);

    /**
     * @notice Claims reward for a user, on the assets of the pool, accumulating the pending rewards
     * @param assets The assets to accumulate rewards for
     * @param amount Amount of rewards to claim
     * @param to Address that will be receiving the rewards
     * @return Rewards claimed
     **/
    function claimRewards(
        address[] calldata assets,
        uint256 amount,
        address to
    ) external returns (uint256);

    /**
     * @notice Claims reward for a user on its behalf, on the assets of the pool, accumulating the pending rewards.
     * @dev The caller must be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
     * @param assets The assets to accumulate rewards for
     * @param amount The amount of rewards to claim
     * @param user The address to check and claim rewards
     * @param to The address that will be receiving the rewards
     * @return The amount of rewards claimed
     **/
    function claimRewardsOnBehalf(
        address[] calldata assets,
        uint256 amount,
        address user,
        address to
    ) external returns (uint256);

    /**
     * @notice Returns the unclaimed rewards of the user
     * @param user The address of the user
     * @return The unclaimed user rewards
     */
    function getUserUnclaimedRewards(address user)
        external
        view
        returns (uint256);

    /**
     * @notice Returns the user index for a specific asset
     * @param user The address of the user
     * @param asset The asset to incentivize
     * @return The user index for the asset
     */
    function getUserAssetData(address user, address asset)
        external
        view
        returns (uint256);

    /**
     * @notice for backward compatibility with previous implementation of the Incentives controller
     * @return The address of the reward token
     */
    function REWARD_TOKEN() external view returns (address);

    /**
     * @notice for backward compatibility with previous implementation of the Incentives controller
     * @return The precision used in the incentives controller
     */
    function PRECISION() external view returns (uint8);

    /**
     * @dev Gets the distribution end timestamp of the emissions
     */
    function DISTRIBUTION_END() external view returns (uint256);
}

// File contracts/interfaces/IInitializableNToken.sol

/**
 * @title IInitializablenToken
 *
 * @notice Interface for the initialize function on NToken
 **/
interface IInitializableNToken {
    /**
     * @dev Emitted when an nToken is initialized
     * @param underlyingAsset The address of the underlying asset
     * @param pool The address of the associated pool
     * @param treasury The address of the treasury
     * @param incentivesController The address of the incentives controller for this nToken
     * @param nTokenName The name of the nToken
     * @param nTokenSymbol The symbol of the nToken
     * @param params A set of encoded parameters for additional initialization
     **/
    event Initialized(
        address indexed underlyingAsset,
        address indexed pool,
        address treasury,
        address incentivesController,
        string nTokenName,
        string nTokenSymbol,
        bytes params
    );

    /**
     * @notice Initializes the nToken
     * @param pool The pool contract that is initializing this contract
     * @param treasury The address of the Omni treasury, receiving the fees on this nToken
     * @param underlyingAsset The address of the underlying asset of this nToken (E.g. WETH for oWETH)
     * @param incentivesController The smart contract managing potential incentives distribution
     * @param nTokenName The name of the nToken
     * @param nTokenSymbol The symbol of the nToken
     * @param params A set of encoded parameters for additional initialization
     */
    function initialize(
        IPool pool,
        address treasury,
        address underlyingAsset,
        IRewardController incentivesController,
        uint8 nTokenDecimals,
        string calldata nTokenName,
        string calldata nTokenSymbol,
        bytes calldata params
    ) external;
}

// File contracts/interfaces/INToken.sol

/**
 * @title INToken
 * @author ParallelFi
 * @notice Defines the basic interface for an NToken.
 **/
interface INToken is
    IERC721Enumerable,
    IInitializableNToken,
    IERC721Receiver,
    IERC1155Receiver
{
    /**
     * @dev Emitted during the transfer action
     * @param from The user whose tokens are being transferred
     * @param to The recipient
     * @param tokenId The id of the token being transferred
     **/
    event BalanceTransfer(
        address indexed from,
        address indexed to,
        uint256 tokenId
    );

    /**
     * @dev Emitted during claimERC20Airdrop()
     * @param token The address of the token
     * @param to The address of the recipient
     * @param amount The amount being claimed from the airdrop
     **/
    event ClaimERC20Airdrop(
        address indexed token,
        address indexed to,
        uint256 amount
    );

    /**
     * @dev Emitted during claimERC721Airdrop()
     * @param token The address of the token
     * @param to The address of the recipient
     * @param ids The ids of the tokens being claimed from the airdrop
     **/
    event ClaimERC721Airdrop(
        address indexed token,
        address indexed to,
        uint256[] ids
    );

    /**
     * @dev Emitted during claimERC1155Airdrop()
     * @param token The address of the token
     * @param to The address of the recipient
     * @param ids The ids of the tokens being claimed from the airdrop
     * @param amounts The amount of NFTs being claimed from the airdrop for a specific id.
     * @param data The data of the tokens that is being claimed from the airdrop. Usually this is 0.
     **/
    event ClaimERC1155Airdrop(
        address indexed token,
        address indexed to,
        uint256[] ids,
        uint256[] amounts,
        bytes data
    );

    /**
     * @dev Emitted during executeAirdrop()
     * @param airdropContract The address of the airdrop contract
     **/
    event ExecuteAirdrop(address indexed airdropContract);

    /**
     * @notice Mints `amount` nTokens to `user`
     * @param onBehalfOf The address of the user that will receive the minted nTokens
     * @param tokenData The list of the tokens getting minted and their collateral configs
     * @return `true` if the the previous balance of the user was 0
     */
    function mint(
        address onBehalfOf,
        DataTypes.ERC721SupplyParams[] calldata tokenData
    ) external returns (bool);

    /**
     * @notice Burns nTokens from `user` and sends the equivalent amount of underlying to `receiverOfUnderlying`
     * @dev In some instances, the mint event could be emitted from a burn transaction
     * if the amount to burn is less than the interest that the user accrued
     * @param from The address from which the nTokens will be burned
     * @param receiverOfUnderlying The address that will receive the underlying
     * @param tokenIds The ids of the tokens getting burned
     **/
    function burn(
        address from,
        address receiverOfUnderlying,
        uint256[] calldata tokenIds
    ) external returns (bool);

    // TODO are we using the Treasury at all? Can we remove?
    // /**
    //  * @notice Mints nTokens to the reserve treasury
    //  * @param tokenId The id of the token getting minted
    //  * @param index The next liquidity index of the reserve
    //  */
    // function mintToTreasury(uint256 tokenId, uint256 index) external;

    /**
     * @notice Transfers nTokens in the event of a borrow being liquidated, in case the liquidators reclaims the nToken
     * @param from The address getting liquidated, current owner of the nTokens
     * @param to The recipient
     * @param tokenId The id of the token getting transferred
     **/
    function transferOnLiquidation(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @notice Transfers the underlying asset to `target`.
     * @dev Used by the Pool to transfer assets in borrow(), withdraw() and flashLoan()
     * @param user The recipient of the underlying
     * @param tokenId The id of the token getting transferred
     **/
    function transferUnderlyingTo(address user, uint256 tokenId) external;

    /**
     * @notice Handles the underlying received by the nToken after the transfer has been completed.
     * @dev The default implementation is empty as with standard ERC721 tokens, nothing needs to be done after the
     * transfer is concluded. However in the future there may be nTokens that allow for example to stake the underlying
     * to receive LM rewards. In that case, `handleRepayment()` would perform the staking of the underlying asset.
     * @param user The user executing the repayment
     * @param tokenId The amount getting repaid
     **/
    function handleRepayment(address user, uint256 tokenId) external;

    /**
     * @notice Allow passing a signed message to approve spending
     * @dev implements the permit function as for
     * https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
     * @param owner The owner of the funds
     * @param spender The spender
     * @param value The tokenId
     * @param deadline The deadline timestamp, type(uint256).max for max deadline
     * @param v Signature param
     * @param s Signature param
     * @param r Signature param
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @notice Returns the address of the underlying asset of this nToken (E.g. WETH for oWETH)
     * @return The address of the underlying asset
     **/
    function UNDERLYING_ASSET_ADDRESS() external view returns (address);

    /**
     * @notice Returns the address of the Omni treasury, receiving the fees on this nToken.
     * @return Address of the Omni treasury
     **/
    function RESERVE_TREASURY_ADDRESS() external view returns (address);

    /**
     * @notice Get the domain separator for the token
     * @dev Return cached value if chainId matches cache, otherwise recomputes separator
     * @return The domain separator of the token at current chain
     */
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /**
     * @notice Returns the nonce for owner.
     * @param owner The address of the owner
     * @return The nonce of the owner
     **/
    function nonces(address owner) external view returns (uint256);

    /**
     * @notice Rescue and transfer tokens locked in this contract
     * @param token The address of the token
     * @param to The address of the recipient
     * @param value The tokenId or amount to transfer
     */
    function rescueTokens(
        address token,
        address to,
        uint256 value
    ) external;

    /**
     * @notice Claims ERC20 Airdrops.
     * @param token The address of the token
     * @param to The address of the recipient
     * @param amount The amount being claimed from the airdrop
     **/
    function claimERC20Airdrop(
        address token,
        address to,
        uint256 amount
    ) external;

    /**
     * @notice Claims ERC721 Airdrops.
     * @param token The address of the token
     * @param to The address of the recipient
     * @param ids The ids of the tokens being claimed from the airdrop
     **/
    function claimERC721Airdrop(
        address token,
        address to,
        uint256[] calldata ids
    ) external;

    /**
     * @notice Claims ERC1155 Airdrops.
     * @param token The address of the token
     * @param to The address of the recipient
     * @param ids The ids of the tokens being claimed from the airdrop
     * @param amounts The amount of NFTs being claimed from the airdrop for a specific id.
     * @param data The data of the tokens that is being claimed from the airdrop. Usually this is 0.
     **/
    function claimERC1155Airdrop(
        address token,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;

    /**
     * @notice Executes airdrop.
     * @param airdropContract The address of the airdrop contract
     * @param airdropParams Third party airdrop abi data. You need to get this from the third party airdrop.
     **/
    function executeAirdrop(
        address airdropContract,
        bytes calldata airdropParams
    ) external;
}

// File contracts/ui/WPunkGatewayOriginal.sol

// ERC721 imports

contract WPunkGatewayOriginal is IWPunkGateway, IERC721Receiver, Ownable {
    IPunks internal immutable Punk;
    IWrappedPunks internal immutable WPunk;
    IPool internal immutable Pool;
    address public proxy;

    /**
     * @dev Sets the WETH address and the PoolAddressesProvider address. Infinite approves pool.
     * @param punk Address of the Punk contract
     * @param wpunk Address of the Wrapped Punk contract
     * @param owner Address of the owner of this contract
     * @param pool Address of the proxy pool of this contract
     **/
    constructor(
        address punk,
        address wpunk,
        address owner,
        address pool
    ) {
        Punk = IPunks(punk);
        WPunk = IWrappedPunks(wpunk);
        transferOwnership(owner);

        // create new WPunk Proxy for PunkGateway contract
        WPunk.registerProxy();
        // proxy of PunkGateway contract is the new Proxy created above
        proxy = WPunk.proxyInfo(address(this));

        Pool = IPool(pool);
        WPunk.setApprovalForAll(pool, true);
    }

    /**
     * @dev supplies (deposits) WPunk into the reserve, using native Punk. A corresponding amount of the overlying asset (xTokens)
     * is minted.
     * @param pool address of the targeted underlying pool
     * @param punkIndexes punkIndexes to supply to gateway
     * @param onBehalfOf address of the user who will receive the xTokens representing the supply
     * @param referralCode integrators are assigned a referral code and can potentially receive rewards.
     **/
    function supplyPunk(
        address pool,
        DataTypes.ERC721SupplyParams[] calldata punkIndexes,
        address onBehalfOf,
        uint16 referralCode
    ) external {
        for (uint256 i = 0; i < punkIndexes.length; i++) {
            Punk.buyPunk(punkIndexes[i].tokenId);
            Punk.transferPunk(proxy, punkIndexes[i].tokenId);
            WPunk.mint(punkIndexes[i].tokenId);
        }

        Pool.supplyERC721(
            address(WPunk),
            punkIndexes,
            onBehalfOf,
            referralCode
        );
    }

    /**
     * @dev withdraws the WPUNK _reserves of msg.sender.
     * @param pool address of the targeted underlying pool
     * @param punkIndexes indexes of nWPunks to withdraw and receive native WPunk
     * @param to address of the user who will receive native Punks
     */
    function withdrawPunk(
        address pool,
        uint256[] calldata punkIndexes,
        address to
    ) external {
        INToken nWPunk = INToken(
            Pool.getReserveData(address(WPunk)).xTokenAddress
        );
        for (uint256 i = 0; i < punkIndexes.length; i++) {
            nWPunk.safeTransferFrom(msg.sender, address(this), punkIndexes[i]);
        }
        Pool.withdrawERC721(address(WPunk), punkIndexes, address(this));
        for (uint256 i = 0; i < punkIndexes.length; i++) {
            WPunk.burn(punkIndexes[i]);
            Punk.transferPunk(to, punkIndexes[i]);
        }
    }

    /**
     * @dev transfer ERC721 from the utility contract, for ERC721 recovery in case of stuck tokens due
     * direct transfers to the contract address.
     * @param from punk owner of the transfer
     * @param to recipient of the transfer
     * @param tokenId tokenId to send
     */
    function emergencyTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) external onlyOwner {
        IERC721(address(WPunk)).safeTransferFrom(from, to, tokenId);
    }

    /**
     * @dev transfer native Punk from the utility contract, for native Punk recovery in case of stuck Punk
     * due selfdestructs or transfer punk to pre-computated contract address before deployment.
     * @param to recipient of the transfer
     * @param punkIndex punk to send
     */
    function emergencyPunkTransfer(address to, uint256 punkIndex)
        external
        onlyOwner
    {
        Punk.transferPunk(to, punkIndex);
    }

    /**
     * @dev Get WPunk address used by WPunkGateway
     */
    function getWPunkAddress() external view returns (address) {
        return address(WPunk);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
