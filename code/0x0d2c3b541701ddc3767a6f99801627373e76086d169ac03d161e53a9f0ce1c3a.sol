// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title            Decompiled Contract
/// @author           Jonathan Becker <jonathan@jbecker.dev>
/// @custom:version   heimdall-rs v0.9.2
///
/// @notice           This contract was decompiled using the heimdall-rs decompiler.
///                     It was generated directly by tracing the EVM opcodes from this contract.
///                     As a result, it may not compile or even be valid solidity code.
///                     Despite this, it should be obvious what each function does. Overall
///                     logic should have been preserved throughout decompiling.
///
/// @custom:github    You can find the open-source decompiler here:
///                       https://heimdall.rs

contract DecompiledContract {
    uint256 public constant MAX_ACCOUNT_INDEX = 281474976710654;
    uint256 public constant MAX_API_KEY_INDEX = 254;
    uint256 public constant MAX_ASSET_INDEX = 62;
    uint256 public constant MAX_BATCH_DEPOSIT_LENGTH = 1000;
    uint256 public constant MAX_DEPOSIT_CAP_TICKS = 1152921504606846975;
    uint256 public constant MAX_MASTER_ACCOUNT_INDEX = 140737488355327;
    uint256 public constant MAX_ORDER_BASE_AMOUNT = 281474976710655;
    uint256 public constant MAX_ORDER_PRICE = 4294967295;
    uint256 public constant MAX_ORDER_QUOTE_AMOUNT = 281474976710655;
    uint256 public constant MAX_PERPS_MARKET_INDEX = 254;
    uint256 public constant MAX_POOL_SHARES_TO_MINT_OR_BURN = 1152921504606846975;
    uint256 public constant MAX_PUBLIC_MARKET_INDEX = 281474976710655;
    uint256 public constant MAX_SPOT_MARKET_INDEX = 4094;
    uint256 public constant MAX_STAKING_SHARES_TO_MINT_OR_BURN = 1152921504606846975;
    uint256 public constant MAX_TICK_SIZE = 340282366920938463463374607431768211455;
    uint256 public constant MIN_ASSET_INDEX = 1;
    uint256 public constant MIN_ORDER_PRICE = 1;
    uint256 public constant MIN_POOL_SHARES_TO_MINT_OR_BURN = 1;
    uint256 public constant MIN_SPOT_MARKET_INDEX = 2048;
    uint256 public constant MIN_STAKING_SHARES_TO_MINT_OR_BURN = 1;
    uint256 public constant NATIVE_ASSET_INDEX = 1;
    uint256 public constant NIL_ACCOUNT_INDEX = 281474976710655;
    uint256 public constant NIL_PUBLIC_MARKET_INDEX = 255;
    uint256 public constant PRIORITY_EXPIRATION = 1209600;
    uint256 public constant USDC_ASSET_INDEX = 3;
    
    bytes32 store_ag; // storage slot: 0x00
    bytes32 store_am; // storage slot: 0x01
    address store_aj; // storage slot: 0x05
    address store_m; // storage slot: 0x06
    address store_ak; // storage slot: 0x07
    uint64 public committedPriorityRequestCount; // storage slot: 0x07
    bytes32 store_j; // storage slot: 0x08
    uint64 store_c; // storage slot: 0x08
    uint64 store_d; // storage slot: 0x08
    uint64 store_u; // storage slot: 0x08
    bytes32 store_r; // storage slot: 0x09
    uint192 store_s; // storage slot: 0x09
    uint64 public executedBatchesCount; // storage slot: 0x09
    uint64 store_ad; // storage slot: 0x09
    uint64 store_o; // storage slot: 0x09
    uint64 store_t; // storage slot: 0x09
    bytes32 store_ab; // storage slot: 0x0a
    bytes32 store_ac; // storage slot: 0x0b
    uint64 public lastVerifiedEndBlockNumber; // storage slot: 0x0c
    bytes32 store_g; // storage slot: 0x0f
    uint8 store_f; // storage slot: 0x0f
    address public unresolved_61d027b3; // storage slot: 0x11
    bytes32 store_al; // storage slot: 0x11
    address public insuranceFundOperator; // storage slot: 0x12
    bytes32 store_af; // storage slot: 0x12
    uint48 store_z; // storage slot: 0x12
    uint256 store_b; // storage slot: 0x17
    address public coreMessaging; // storage slot: 0x01f4
    
    mapping(bytes32 => bytes32) storage_map_e; // storage slot: 0x02
    mapping(uint64 => bytes32) storage_map_q; // storage slot: 0x0d
    mapping(bytes32 => uint64) storage_map_p; // storage slot: 0x0e
    mapping(address => uint48) public addressToAccountIndex; // storage slot: 0x13
    mapping(bytes32 => bytes32) storage_map_y; // storage slot: 0x14
    mapping(uint64 => bytes32) storage_map_a; // storage slot: 0x15
    mapping(uint64 => bytes32) storage_map_ah; // storage slot: 0x01ed
    mapping(uint16 => bytes32) storage_map_i; // storage slot: 0x01f0
    mapping(address => bytes32) storage_map_ae; // storage slot: 0x01f1
    mapping(uint16 => mapping(uint256 => uint128)) storage_map_x; // storage slot: 0x01f2
    mapping(uint16 => mapping(uint48 => uint8)) storage_map_ai; // storage slot: 0x01f3
    
    error ZkLighter_InvalidPubDataType();
    event DesertMode();
    event InsuranceFundOperatorUpdate(address);
    event RegisterAssetConfig(uint16, address, uint8, uint56, uint128, uint64, uint64);
    event TreasuryUpdate(address);
    event UpdateAssetConfig(uint16, uint8, uint64, uint64);
    event WithdrawPending(address, uint16, uint128);
    
    /// @custom:selector    0x30f72b0a
    /// @custom:signature   __DEPRECATED_stateRootUpdates(uint64 arg0) public view returns (uint256)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function __DEPRECATED_stateRootUpdates(uint64 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0];
        return var_c;
    }
    
    /// @custom:selector    0x22b22256
    /// @custom:signature   activateDesertMode() public payable returns (bool)
    function activateDesertMode() public payable returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        if (store_c) {
            if (block.timestamp >= storage_map_e[store_d].field_1.field_0.field_0) {
                store_b = 0x01;
                return false;
            } else {
                if (block.timestamp < storage_map_e[store_d].field_1.field_0.field_0) {
                    store_b = 0x01;
                    return false;
                } else {
                    if (!store_f) {
                        store_g = store_g & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                        emit DesertMode();
                    }
                    store_b = 0x01;
                    return true;
                }
            }
        }
    }
    
    /// @custom:selector    0xcd565e08
    /// @custom:signature   assetConfigs(uint16 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function assetConfigs(uint16 arg0) public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_i[arg0].field_0;
        var_d = storage_map_i[arg0].field_160;
        var_e = storage_map_i[arg0].field_168;
        var_f = storage_map_i[arg0].field_1.field_0;
        var_g = storage_map_i[arg0].field_1.field_128;
        bytes32 var_h = storage_map_i[arg0].field_1 >> 0xc0;
        return abi.encodePacked(var_c, var_d, var_e, var_f, var_g, var_h);
    }
    
    /// @custom:selector    0x1b6592fa
    /// @custom:signature   cancelOutstandingDepositsForDesertMode(uint64 arg0, bytes[] arg1) public payable
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function cancelOutstandingDepositsForDesertMode(uint64 arg0, bytes[] arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (0x04 + arg1 + 0x20 < 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                    uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    require(0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x40 + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] > msg.data.length);
                }
            } else {
                require(store_b != 0x02, "ReentrancyGuard: reentrant call");
                store_b = 0x02;
                require(store_f, CustomError_f128b579());
                require(arg0, CustomError_f128b579());
                require(arg0 <= store_c, CustomError_f128b579());
                if (type(uint256).max + store_d <= 0xffffffffffffffff && (store_d + arg0 <= 0xffffffffffffffff && (store_d < uint64(store_d + arg0) && 0 < var_j))) {
                    require(var_l <= 0x64, CustomError_f128b579());
                }
            }
        }
    }
    
    /// @custom:selector    0xaab78a8e
    /// @custom:signature   committedBatchesCount() public view returns (uint256)
    function committedBatchesCount() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_j >> 0xc0;
    }
    
    /// @custom:selector    0x02cfb563
    /// @custom:signature   desertMode() public view returns (bool)
    function desertMode() public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_f;
    }
    
    /// @custom:selector    0x2d320e28
    /// @custom:signature   executeBatches((uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes32)[] arg0, bytes[] arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    function executeBatches((uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes32)[] arg0, bytes[] arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + msg.data[0x04 + arg0] * 0x0160 + 0x20) {
                if (!(var_c + 0x0160 > 0xffffffffffffffff | var_c + 0x0160 < var_c)) {
                    uint256 var_c = var_c + 0x0160;
                    require(uint64(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
                }
            } else {
                require(arg1 <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                    uint256 var_c = var_c + (0x20 + (var_e << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    if (0x04 + arg1 + 0x20 < 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                        require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
                        if (msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                            require(0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x40 + msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] > msg.data.length);
                        }
                    } else {
                        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
                        store_b = 0x02;
                        require(!store_f, CustomError_a74f50b3());
                        if (!store_f) {
                            require(store_m.code.length);
                            (bool success, bytes memory ret0) = address(store_m).requireUnpaused(); // staticcall
                            require(success);
                        } else {
                            require(!(var_j - var_j), CustomError_40068547());
                            require(executedBatchesCount >= var_j, CustomError_81b1c191());
                            if (0 < var_j && 0 < var_j) {
                                require(uint64(var_l) <= executedBatchesCount, CustomError_edb9c87f());
                                require(!(storage_map_p[store_o].field_0.field_0 - uint64(var_l)), CustomError_516e3eb1());
                                if (0 < var_j && (0 < var_j && !(var_c + 0x0180 > 0xffffffffffffffff | var_c + 0x0180 < var_c))) {
                                    uint256 var_c = var_c + 0x0180;
                                    require(!(keccak256(memory[var_c + 0x20:var_c + 0x20 + var_j]) - storage_map_q[uint64(var_l)]), CustomError_fbb7d3d2());
                                    if (0 < var_l) {
                                        if (0 <= 0x01 && 0 < var_l) {
                                            if (0 == (uint8(var_aj >> 0xf8) == 0x02)) {
                                                require(!(0x01 - uint8(var_aj >> 0xf8)), CustomError_fdbe1dce());
                                                if (var_l <= var_l) {
                                                    require(var_l >= 0x0f, CustomError_a9c58615());
                                                }
                                            } else {
                                                if (var_l <= var_l) {
                                                    require(var_l >= 0x11, CustomError_a9c58615());
                                                    if (!(var_c + 0x60 > 0xffffffffffffffff | var_c + 0x60 < var_c) && (0 != type(uint256).max && 0x01 <= 0x07)) {
                                                        require(var_l >= 0x07, "S");
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        require(!var_ar, CustomError_8c59c66d());
                                        if (storage_map_p[store_o].field_64.field_0 - store_d <= 0xffffffffffffffff) {
                                            store_j = store_j & 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff | storage_map_p[store_o].field_64 << 0x40 & 0xffffffffffffffff0000000000000000;
                                            store_r = store_r & 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff | uint64(var_l) << 0x40 & 0xffffffffffffffff0000000000000000;
                                            if (store_o != 0xffffffffffffffff) {
                                                store_r = store_s | 0x01 + store_o << 0xc0 & 0xffffffffffffffff000000000000000000000000000000000000000000000000;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x1b06a763
    /// @custom:signature   executedOnChainBatchesCount() public view returns (uint256)
    function executedOnChainBatchesCount() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_r >> 0xc0;
    }
    
    /// @custom:selector    0x634f0262
    /// @custom:signature   executedPriorityRequestCount() public view returns (uint64)
    function executedPriorityRequestCount() public view returns (uint64) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_u;
    }
    
    /// @custom:selector    0xd1cbc64f
    /// @custom:signature   getPendingBalance(address arg0, uint16 arg1) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    function getPendingBalance(address arg0, uint16 arg1) public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (!addressToAccountIndex[arg0].field_0) {
            if (0 == (arg0 == unresolved_61d027b3)) {
                if (insuranceFundOperator == arg0) {
                    return storage_map_x[arg1][0x01].field_0;
                } else {
                    return storage_map_x[arg1][0xffffffffffff].field_0;
                }
            } else {
                var_c = storage_map_x[arg1][0].field_0;
                return var_c;
            }
        } else {
            var_a = storage_map_x[arg1].field_0.field_0;
            var_c = storage_map_x[arg1][var_a].field_0;
            return var_c;
        }
    }
    
    /// @custom:selector    0xaf7c0260
    /// @custom:signature   getPendingBalanceLegacy(address arg0) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getPendingBalanceLegacy(address arg0) public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        if (!addressToAccountIndex[arg0].field_0) {
            if (0 == (arg0 == unresolved_61d027b3)) {
                if (insuranceFundOperator == arg0) {
                    return storage_map_y[0x01].field_0;
                } else {
                    return storage_map_y[0xffffffffffff].field_0;
                }
            } else {
                var_c = storage_map_y[0].field_0;
                return var_c;
            }
        } else {
            var_a = addressToAccountIndex[arg0].field_0.field_0;
            var_c = storage_map_y[var_a].field_0;
            return var_c;
        }
    }
    
    /// @custom:selector    0xfae2e046
    /// @custom:signature   lastAccountIndex() public view returns (uint48)
    function lastAccountIndex() public view returns (uint48) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_z;
    }
    
    /// @custom:selector    0x3177a48e
    /// @custom:signature   lastVerifiedStateRoot() public view returns (uint256)
    function lastVerifiedStateRoot() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_ab;
    }
    
    /// @custom:selector    0x3eec9538
    /// @custom:signature   lastVerifiedValidiumRoot() public view returns (uint256)
    function lastVerifiedValidiumRoot() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_ac;
    }
    
    /// @custom:selector    0x72fc4c39
    /// @custom:signature   openPriorityRequestCount() public view returns (uint64)
    function openPriorityRequestCount() public view returns (uint64) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_c;
    }
    
    /// @custom:selector    0x31c5da4e
    /// @custom:signature   pendingOnChainBatchesCount() public view returns (uint64)
    function pendingOnChainBatchesCount() public view returns (uint64) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_ad;
    }
    
    /// @custom:selector    0x25216fda
    /// @custom:signature   registerAssetConfig(uint16 arg0, address arg1, uint8 arg2, uint56 arg3, uint128 arg4, uint64 arg5, uint64 arg6) public payable
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg3 ["uint56", "bytes7", "int56"]
    /// @param              arg4 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg5 ["uint64", "bytes8", "int64"]
    /// @param              arg6 ["uint64", "bytes8", "int64"]
    function registerAssetConfig(uint16 arg0, address arg1, uint8 arg2, uint56 arg3, uint128 arg4, uint64 arg5, uint64 arg6) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xe0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - uint8(arg2)));
        require(!(arg3 - arg3));
        require(!(arg4 - uint128(arg4)));
        require(!(arg5 - arg5));
        require(!(arg6 - arg6));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(!store_f, CustomError_a74f50b3());
        require(store_m.code.length);
        (bool success, bytes memory ret0) = address(store_m).Unresolved_f5f84ed4(msg.sender); // staticcall
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                var_e = var_e;
                require(var_e - var_e < 0);
            }
        } else {
            require(arg0 != 0x01, CustomError_68982942());
            require(arg0 >= 0x01, CustomError_68982942());
            require(arg0 <= 0x3e, CustomError_68982942());
            require(arg1, CustomError_a28d29a7());
            require(!storage_map_ae[arg1].field_0.field_0, CustomError_a28d29a7());
            require(uint8(arg2), CustomError_a28d29a7());
            require(uint8(arg2) == 0x01, CustomError_a28d29a7());
            require(arg1.code.length, CustomError_a28d29a7());
            require(arg6, CustomError_a28d29a7());
            require(arg5 <= 0x0fffffffffffffff, CustomError_a28d29a7());
            if (!(uint128(uint128(arg3) * uint128(arg5)) - uint128(arg3) * uint128(arg5))) {
                require(arg3, CustomError_a28d29a7());
                require(uint128(uint128(arg3) * uint128(arg5)) <= 0xffffffffffffffffffff, CustomError_a28d29a7());
                if (!(var_e + 0xc0 > 0xffffffffffffffff | var_e + 0xc0 < var_e)) {
                    storage_map_i[arg0] = 0xffffffffffffff000000000000000000000000000000000000000000 & var_n << 0xa8 | (0xff0000000000000000000000000000000000000000 & var_o << 0xa0 | (address(var_p) | storage_map_i[arg0] & 0xffffffff00000000000000000000000000000000000000000000000000000000));
                    storage_map_i[arg0].field_1 = storage_map_i[arg0].field_1 & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | uint128(var_q);
                    storage_map_i[arg0].field_1 = 0xffffffffffffffff00000000000000000000000000000000 & uint64(var_r) << 0x80 | 0xffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffff & storage_map_i[arg0].field_1;
                    storage_map_i[arg0].field_1 = storage_map_i[arg0].field_1.field_0 | uint64(var_s) << 0xc0 & 0xffffffffffffffff000000000000000000000000000000000000000000000000;
                    storage_map_ae[arg1] = storage_map_ae[arg1] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000 | arg0;
                    emit RegisterAssetConfig(arg0, arg1, uint8(arg2), arg3, uint128(arg4), arg5, arg6);
                    store_b = 0x01;
                }
            }
        }
    }
    
    /// @custom:selector    0xaabe6078
    /// @custom:signature   setInsuranceFundOperator(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setInsuranceFundOperator(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(store_m.code.length);
        (bool success, bytes memory ret0) = address(store_m).Unresolved_f5f84ed4(msg.sender); // staticcall
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                var_e = var_e;
                require(var_e - var_e < 0);
            }
        } else {
            require(arg0, CustomError_2acea741());
            if (addressToAccountIndex[arg0].field_0) {
                require(!(addressToAccountIndex[arg0].field_0.field_0 - 0xffffffffffff), CustomError_d78db55d());
            }
            store_af = store_af & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
            emit InsuranceFundOperatorUpdate(insuranceFundOperator);
            store_b = 0x01;
        }
    }
    
    /// @custom:selector    0x9588eca2
    /// @custom:signature   stateRoot() public view returns (uint256)
    function stateRoot() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_ag;
    }
    
    /// @custom:selector    0xe9560055
    /// @custom:signature   stateRootUpdates(uint64 arg0) public view returns (uint256)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function stateRootUpdates(uint64 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_ah[arg0];
        return var_c;
    }
    
    /// @custom:selector    0xa44a9316
    /// @custom:signature   storedBatchHashes(uint64 arg0) public view returns (uint256)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function storedBatchHashes(uint64 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_q[arg0];
        return var_c;
    }
    
    /// @custom:selector    0x899cfa29
    /// @custom:signature   tokenToAssetIndex(address arg0) public view returns (uint16)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function tokenToAssetIndex(address arg0) public view returns (uint16) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_ae[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x55a2ba68
    /// @custom:signature   transferERC20(address arg0, address arg1, uint256 arg2, uint256 arg3) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function transferERC20(address arg0, address arg1, uint256 arg2, uint256 arg3) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (!store_f) {
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).requireUnpaused(); // staticcall
            require(success);
        } else {
            require(0xb3fffca23d4444ee73349825acd84f7b5020e387 != arg1);
            require(!(msg.sender - address(this)), CustomError_d463e24c());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            if (!success) {
                uint256 var_a = var_h + 0x24 + 0x40 - var_h + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                if (!(var_h + (var_h + 0x24 + 0x40 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x24 + 0x40 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
                    uint256 var_h = var_h + (var_h + 0x24 + 0x40 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    if (!(var_h + 0x40 > 0xffffffffffffffff | var_h + 0x40 < var_h)) {
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(arg1); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(var_k, "SafeERC20: low-level call failed");
                            } else {
                                require(var_k, "Address: call to non-contract");
                                require(0x20 + (0x60 + var_k) - 0x80 >= 0x20);
                                require(!(var_a - var_a));
                                require(var_a, "SafeERC20: ERC20 operation did not succeed");
                                (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
                                require(success);
                                if (!success && 0 <= 0) {
                                    require(0 <= arg3, CustomError_03a77b73());
                                    return 0;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x7b1a4909
    /// @custom:signature   transferETH(address arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function transferETH(address arg0, uint256 arg1) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        if (!store_f) {
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).requireUnpaused(); // staticcall
            require(success);
        } else {
            require(0xb3fffca23d4444ee73349825acd84f7b5020e387 != arg0);
            require(!(msg.sender - address(this)), CustomError_d463e24c());
            payable(address(arg0)).transfer(arg1);
            if (!ret0.length) {
                require(success, CustomError_8e94fb8e());
                return arg1;
            }
        }
    }
    
    /// @custom:selector    0x23ff50e1
    /// @custom:signature   Unresolved_23ff50e1(uint64 arg0) public pure
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function Unresolved_23ff50e1(uint64 arg0) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0180);
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0160);
        if (!(var_a + 0x0160 > 0xffffffffffffffff | var_a + 0x0160 < var_a)) {
            require(arg0 - arg0);
        }
    }
    
    /// @custom:selector    0x25394645
    /// @custom:signature   Unresolved_25394645(uint256 arg0, address arg1, address arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_25394645(uint256 arg0, address arg1, address arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(address(this) != 0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f, CustomError_647f3cb3());
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_g = var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + 0x647f3cb300000000000000000000000000000000000000000000000000000000) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg0];
            require(!(keccak256(memory[var_g + 0x20:var_g + 0x20 + var_j]) - 0x46700b4d40ac5c35af2c22dda2787a91eb567b06c924a8fb8ae9a05b20c08c21), CustomError_fc2bb126());
            require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] - (0x04 + arg0 + 0x20) >= 0x60);
            require(!(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]));
            require(address(msg.data[0x04 + arg0 + 0x20 + 0x20]) - msg.data[0x04 + arg0 + 0x20 + 0x20]);
        }
    }
    
    /// @custom:selector    0x377d4194
    /// @custom:signature   Unresolved_377d4194(uint48 arg0, address arg1, uint16 arg2, address arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint48", "bytes6", "int48"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint16", "bytes2", "int16"]
    /// @param              arg3 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_377d4194(uint48 arg0, address arg1, uint16 arg2, address arg3, uint256 arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(!(arg3 - uint128(arg3)));
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(store_f, CustomError_f128b579());
        require(!storage_map_ai[arg2][arg0].field_0, CustomError_f128b579());
        require(addressToAccountIndex[arg1].field_0, CustomError_17a73929());
        require(addressToAccountIndex[arg1].field_0.field_0 != 0xffffffffffff, CustomError_17a73929());
        if (addressToAccountIndex[arg1].field_0.field_0 && (addressToAccountIndex[arg1].field_0.field_0 == 0x01 && !(var_g + 0x40 > 0xffffffffffffffff | var_g + 0x40 < var_g))) {
            uint256 var_g = var_g + 0x40;
            uint256 var_i = msg.data[msg.data.length:msg.data.length + 0x20];
            if (!(var_g + 0x80 > 0xffffffffffffffff | var_g + 0x80 < var_g)) {
                uint256 var_g = var_g + 0x80;
                if (var_q && 0 >= var_q) {
                    (bool success, bytes memory ret0) = address(store_aj).Unresolved_7e4f7a8a(0x40); // staticcall
                    require(success);
                    if (success) {
                        if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                            uint256 var_g = var_g + 0x20;
                            require(var_g + 0x20 - var_g >= 0x20);
                            require(var_q - var_q, CustomError_f128b579());
                        }
                    } else {
                        require(0, CustomError_f128b579());
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x7271277e
    /// @custom:signature   Unresolved_7271277e(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    function Unresolved_7271277e(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01c0);
        require(0x0160 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(arg13 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg13] <= 0xffffffffffffffff);
        require(address(this) != 0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f, CustomError_a4a9ab33());
        (bool success, bytes memory ret0) = address(store_ak).ZkLighter_ImplCantDelegateToAddl(); // delegatecall
        require(success);
        return 0xa4a9ab3300000000000000000000000000000000000000000000000000000000;
    }
    
    /// @custom:selector    0x8a857083
    /// @custom:signature   Unresolved_8a857083(address arg0, uint16 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_8a857083(address arg0, uint16 arg1, uint256 arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(arg2 < 0x02);
        require(address(this) != 0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f, CustomError_a4a9ab33());
        (bool success, bytes memory ret0) = address(store_ak).ZkLighter_ImplCantDelegateToAddl(); // delegatecall
        require(success);
        return 0xa4a9ab3300000000000000000000000000000000000000000000000000000000;
    }
    
    /// @custom:selector    0xaa6fa142
    /// @custom:signature   Unresolved_aa6fa142(address arg0, bool arg1, uint256 arg2, uint256 arg3) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_aa6fa142(address arg0, bool arg1, uint256 arg2, uint256 arg3) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg0 - arg0));
        require(!(arg1 - uint8(arg1)));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(arg3 > 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xbdf723e8
    /// @custom:signature   Unresolved_bdf723e8(uint256 arg0, uint64 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    function Unresolved_bdf723e8(uint256 arg0, uint64 arg1) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0180);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + msg.data[0x04 + arg0] * 0x0160 + 0x20) {
                if (!(var_c + 0x0160 > 0xffffffffffffffff | var_c + 0x0160 < var_c)) {
                    require(uint64(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
                }
            } else {
                require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdc + msg.data.length < 0x0160);
            }
        }
    }
    
    /// @custom:selector    0xe415f0f4
    /// @custom:signature   Unresolved_e415f0f4(uint256 arg0, bool arg1, uint64 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_e415f0f4(uint256 arg0, bool arg1, uint64 arg2, uint256 arg3) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0180);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdc + msg.data.length >= 0x0160);
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(!store_f, CustomError_a74f50b3());
        require(store_m.code.length);
        (bool success, bytes memory ret0) = address(store_m).Unresolved_40550a1c(msg.sender); // staticcall
        require(success);
        if (!success) {
            if (!store_f) {
                require(store_m.code.length);
                (bool success, bytes memory ret0) = address(store_m).requireUnpaused(); // staticcall
                require(success);
            } else {
                require(msg.data[arg0 + 0x0124] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x0124]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]]);
                require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]], CustomError_1548f506());
                require(msg.data[arg0 + 0x0124] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x0124]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]]);
                if (msg.data[0x04 + arg0 + msg.data[arg0 + 0x0124]]) {
                    require(!uint8((0xff00000000000000000000000000000000000000000000000000000000000000 & msg.data[0x20 + (0x04 + arg0 + msg.data[arg0 + 0x0124])]) >> 0xf8), CustomError_2ccba61c());
                    require(!(uint64(msg.data[0x04 + arg0]) - msg.data[0x04 + arg0]));
                    require(arg2 - arg2, CustomError_02a546b3());
                }
            }
        }
    }
    
    /// @custom:selector    0xea2102e4
    /// @custom:signature   Unresolved_ea2102e4(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ea2102e4(uint256 arg0, uint256 arg1) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 > 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xf0f44260
    /// @custom:signature   Unresolved_f0f44260(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f0f44260(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(store_m.code.length);
        (bool success, bytes memory ret0) = address(store_m).Unresolved_f5f84ed4(msg.sender); // staticcall
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                var_e = var_e;
                require(var_e - var_e < 0);
            }
        } else {
            require(arg0, CustomError_4e5dd6e7());
            if (addressToAccountIndex[arg0].field_0) {
                require(!(addressToAccountIndex[arg0].field_0.field_0 - 0xffffffffffff), CustomError_e20b3007());
            }
            store_al = store_al & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
            emit TreasuryUpdate(unresolved_61d027b3);
            store_b = 0x01;
        }
    }
    
    /// @custom:selector    0xcd626497
    /// @custom:signature   updateAssetConfig(uint16 arg0, uint8 arg1, uint64 arg2, uint64 arg3) public payable
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    /// @param              arg3 ["uint64", "bytes8", "int64"]
    function updateAssetConfig(uint16 arg0, uint8 arg1, uint64 arg2, uint64 arg3) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg0 - arg0));
        require(!(arg1 - uint8(arg1)));
        require(!(arg2 - arg2));
        require(!(arg3 - arg3));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        require(!store_f, CustomError_a74f50b3());
        require(store_m.code.length);
        (bool success, bytes memory ret0) = address(store_m).Unresolved_f5f84ed4(msg.sender); // staticcall
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                var_e = var_e;
                require(var_e - var_e < 0);
            }
        } else {
            if (!(var_e + 0xc0 > 0xffffffffffffffff | var_e + 0xc0 < var_e)) {
                uint256 var_e = var_e + 0xc0;
                var_k = storage_map_i[0x4e487b7100000000000000000000000000000000000000000000000000000000].field_1.field_0;
                require(arg0 == 0x01, CustomError_68982942());
                require(uint8(arg1), CustomError_a28d29a7());
                require(uint8(arg1) == 0x01, CustomError_a28d29a7());
                require(uint8(arg1), CustomError_a28d29a7());
                require(uint8(arg1), CustomError_a28d29a7());
                require(arg3, CustomError_a28d29a7());
                require(arg2 <= 0x0fffffffffffffff, CustomError_a28d29a7());
                if (!(uint128(uint128(uint56(var_o)) * uint128(arg2)) - uint128(uint56(var_o)) * uint128(arg2))) {
                    require(uint128(uint128(uint56(var_o)) * uint128(arg2)) <= 0xffffffffffffffffffff, CustomError_a28d29a7());
                    if (!(var_e + 0xc0 > 0xffffffffffffffff | var_e + 0xc0 < var_e)) {
                        storage_map_i[arg0] = 0xffffffffffffff000000000000000000000000000000000000000000 & var_o << 0xa8 | (0xff0000000000000000000000000000000000000000 & var_w << 0xa0 | (address(var_p) | storage_map_i[arg0] & 0xffffffff00000000000000000000000000000000000000000000000000000000));
                        storage_map_i[arg0].field_1 = storage_map_i[arg0].field_1 & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | uint128(var_t);
                        storage_map_i[arg0].field_1 = 0xffffffffffffffff00000000000000000000000000000000 & uint64(var_x) << 0x80 | 0xffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffff & storage_map_i[arg0].field_1;
                        storage_map_i[arg0].field_1 = var_k | uint64(var_y) << 0xc0 & 0xffffffffffffffff000000000000000000000000000000000000000000000000;
                        emit UpdateAssetConfig(arg0, uint8(arg1), arg2, arg3);
                        store_b = 0x01;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x45dca05c
    /// @custom:signature   validiumRoot() public view returns (uint256)
    function validiumRoot() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_am;
    }
    
    /// @custom:selector    0x90fda39b
    /// @custom:signature   verifiedBatchesCount() public view returns (uint64)
    function verifiedBatchesCount() public view returns (uint64) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return executedBatchesCount;
    }
    
    /// @custom:selector    0x64420e05
    /// @custom:signature   verifiedPriorityRequestCount() public view returns (uint64)
    function verifiedPriorityRequestCount() public view returns (uint64) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_d;
    }
    
    /// @custom:selector    0x2f25807e
    /// @custom:signature   withdrawPendingBalance(address arg0, uint16 arg1, uint128 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    /// @param              arg2 ["address", "uint128", "bytes16", "int128"]
    function withdrawPendingBalance(address arg0, uint16 arg1, uint128 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - uint128(arg2)));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        if (!addressToAccountIndex[arg0].field_0) {
            require(uint128(arg2) > storage_map_x[arg1][0x01].field_0.field_0, CustomError_bb8f9df5());
            require(uint128(arg2) <= storage_map_x[arg1][0x01].field_0.field_0, CustomError_bb8f9df5());
        } else {
            require(uint128(arg2) > storage_map_x[arg1][storage_map_x[arg1].field_0.field_0].field_0.field_0, CustomError_bb8f9df5());
            require(uint128(arg2) <= storage_map_x[arg1][storage_map_x[arg1].field_0.field_0].field_0.field_0, CustomError_bb8f9df5());
            if (!(var_h + 0xc0 > 0xffffffffffffffff | var_h + 0xc0 < var_h)) {
                require(arg1 == 0x01, CustomError_68982942());
            }
        }
    }
    
    /// @custom:selector    0x975364c6
    /// @custom:signature   withdrawPendingBalanceLegacy(address arg0, uint128 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    function withdrawPendingBalanceLegacy(address arg0, uint128 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - uint128(arg1)));
        require(store_b != 0x02, "ReentrancyGuard: reentrant call");
        store_b = 0x02;
        if (!addressToAccountIndex[arg0].field_0) {
            require(uint128(arg1) > storage_map_y[0x01].field_0.field_0, CustomError_bb8f9df5());
            require(uint128(arg1) <= storage_map_y[0x01].field_0.field_0, CustomError_bb8f9df5());
            (bool success, bytes memory ret0) = address(store_m).Unresolved_3e413bee(0x20); // staticcall
            require(success);
            if (!success) {
                (bool success, bytes memory ret0) = address(address(this)).Unresolved_55a2ba68(0); // call
                require(success);
                require(success, "SafeCast: value doesn't fit in 128 bits");
            }
        } else {
            var_e = addressToAccountIndex[0x27].field_0.field_0;
            require(uint128(arg1) > storage_map_y[addressToAccountIndex[arg0].field_0.field_0].field_0.field_0, CustomError_bb8f9df5());
            require(uint128(arg1) <= storage_map_y[addressToAccountIndex[arg0].field_0.field_0].field_0.field_0, CustomError_bb8f9df5());
            (bool success, bytes memory ret0) = address(store_m).Unresolved_3e413bee(0x20); // staticcall
            require(success);
            if (!success) {
                (bool success, bytes memory ret0) = address(address(this)).Unresolved_55a2ba68(0); // call
                require(success);
                if (success) {
                    if (!(var_h + 0x20 > 0xffffffffffffffff | var_h + 0x20 < var_h)) {
                        uint256 var_h = var_h + 0x20;
                        require(var_h + 0x20 - var_h < 0x20, "SafeCast: value doesn't fit in 128 bits");
                    }
                } else {
                    require(0 <= 0xffffffffffffffffffffffffffffffff, "SafeCast: value doesn't fit in 128 bits");
                    if (storage_map_y[addressToAccountIndex[arg0].field_0.field_0].field_0.field_0 <= 0xffffffffffffffffffffffffffffffff) {
                        var_e = storage_map_y[addressToAccountIndex[0x27].field_0.field_0].field_0.field_0;
                        storage_map_y[var_e] = storage_map_y[var_e] & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | 0x3238206269747300000000000000000000000000000000000000000000000000.field_0;
                        emit WithdrawPending(0x27, 0x03, 0);
                        store_b = 0x01;
                    }
                }
            }
        }
    }
}