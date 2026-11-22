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
    uint256 store_k; // storage slot: 0x00
    address public batchVerifier; // storage slot: 0x01
    bytes32 store_aa; // storage slot: 0x01
    address public exitVerifier; // storage slot: 0x02
    bytes32 store_z; // storage slot: 0x02
    address store_y; // storage slot: 0x03
    bytes32 store_ab; // storage slot: 0x03
    bytes32 store_ac; // storage slot: 0x04
    bytes32 store_d; // storage slot: 0x05
    uint8 store_j; // storage slot: 0x05
    bytes32 store_f; // storage slot: 0x0b
    uint64 store_e; // storage slot: 0x0b
    bytes32 store_v; // storage slot: 0x0f
    uint32 public nextUserId; // storage slot: 0x0f
    uint256 public rateLimit; // storage slot: 0x12
    bytes32 store_n; // storage slot: 0x13
    uint256 public rateLimitWindowUsed; // storage slot: 0x14
    bytes32 store_h; // storage slot: 0x15
    address store_q; // storage slot: 0x13649b2456f1b42fef0f0040b3aaeabcd21a76a0f3f5defd4f583839455116e8
    bytes32 store_s; // storage slot: 0x13649b2456f1b42fef0f0040b3aaeabcd21a76a0f3f5defd4f583839455116e9
    uint128 store_r; // storage slot: 0x13649b2456f1b42fef0f0040b3aaeabcd21a76a0f3f5defd4f583839455116e9
    uint8 store_t; // storage slot: 0x13649b2456f1b42fef0f0040b3aaeabcd21a76a0f3f5defd4f583839455116ea
    
    mapping(uint64 => bytes32) storage_map_b; // storage slot: 0x06
    mapping(uint64 => uint8) storage_map_ae; // storage slot: 0x08
    mapping(uint64 => bytes) storage_map_g; // storage slot: 0x0a
    mapping(uint8 => address) storage_map_m; // storage slot: 0x0c
    mapping(address => bytes32) storage_map_l; // storage slot: 0x0d
    mapping(bytes32 => bytes32) storage_map_a; // storage slot: 0x0e
    mapping(uint32 => mapping(uint8 => bytes32)) storage_map_i; // storage slot: 0x10
    mapping(uint32 => mapping(uint8 => bytes32)) storage_map_w; // storage slot: 0x11
    mapping(uint8 => bytes32) storage_map_ad; // storage slot: 0x8c6065603763fec3f5742441d3833f3f43b982453612d76adb39a885e3006b5f
    
    error RevokeHashMismatch();
    event Claimed(address, uint32, uint8, uint128, uint256);
    event DepositMade(address, address, uint32, uint8, uint64, uint256);
    event DepositQueued(uint64, uint32, uint8, uint64, uint64);
    event ExitVerifierSet(address, address);
    event ForceExitDone(uint32, uint8, uint64);
    event ForceExitEnabled(address);
    event Frozen(address);
    event OperatorSet(address, address);
    event RateLimitSet(uint256);
    event RateLimitTripped(uint256, uint256);
    event Unfrozen(address);
    event UserCreated(address, uint32);
    event VerifierSet(address, address);
    
    /// @custom:selector    0x1d0cce4c
    /// @custom:signature   addrOf(uint32 arg0) public view returns (address)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function addrOf(uint32 arg0) public view returns (address) {
        require(true);
        return storage_map_a[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0x783f860e
    /// @custom:signature   batchHashes(uint64 arg0) public view returns (uint256)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function batchHashes(uint64 arg0) public view returns (uint256) {
        require(true);
        return storage_map_b[arg0];
    }
    
    /// @custom:selector    0xd6bbb733
    /// @custom:signature   canForceExit() public view returns (bool)
    function canForceExit() public view returns (bool) {
        if (!uint8(store_d / 0x0100)) {
            if (store_e - uint64(store_f / 0x0100000000000000000000000000000000) <= 0xffffffffffffffff) {
                if (!storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                    if (store_h <= 0) {
                        if (storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                            return storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0;
                        } else {
                            return store_h > 0;
                        }
                    } else {
                        if (store_h <= 0x03f480 + store_h) {
                            if (storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                                return storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0;
                            } else {
                                return block.timestamp >= 0x03f480 + store_h;
                            }
                        }
                    }
                } else {
                    uint64 var_a = uint64(store_f / 0x0100000000000000000000000000000000);
                    if (store_h <= 0) {
                        if (block.timestamp >= storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                            return block.timestamp >= storage_map_g[var_a].field_1.field_0;
                        } else {
                            return store_h > 0;
                        }
                    } else {
                        if (store_h <= 0x03f480 + store_h) {
                            if (block.timestamp >= storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                                return block.timestamp >= storage_map_g[var_a].field_1.field_0;
                            } else {
                                return block.timestamp >= 0x03f480 + store_h;
                            }
                        }
                    }
                }
            }
        } else {
            return true;
        }
    }
    
    /// @custom:selector    0x26df8626
    /// @custom:signature   claimable(uint32 arg0, uint8 arg1) public view returns (address)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    function claimable(uint32 arg0, uint8 arg1) public view returns (address) {
        require(true);
        require(arg1 == uint8(arg1));
        return storage_map_i[arg0][arg1].field_0.field_0;
    }
    
    /// @custom:selector    0x99c5c931
    /// @custom:signature   claimWithdrawal(uint8 arg0, uint128 arg1) public
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    function claimWithdrawal(uint8 arg0, uint128 arg1) public {
        require(arg0 == uint8(arg0));
        require(arg1 == uint128(arg1));
        require(!store_j, CustomError_41dbb51e());
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(uint8(arg0) < 0x08, CustomError_16fb6fc9());
        require(0 - uint128(arg1), CustomError_969bf728());
        require(0 - storage_map_l[msg.sender].field_0, CustomError_fa8d395e());
        require(storage_map_i[storage_map_l[msg.sender].field_0.field_0][uint8(arg0)].field_0 >= uint128(arg1), CustomError_2ae40529());
        uint256 var_c = var_c + 0xa0;
        var_d = storage_map_m[uint8(arg0)].field_0;
        if (storage_map_m[uint8(arg0)].field_1.field_0 == storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) / uint128(arg1) | !uint128(arg1) && (0x0e10 <= store_n + 0x0e10 && rateLimitWindowUsed <= storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) + rateLimitWindowUsed)) {
            require(storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) + rateLimitWindowUsed <= rateLimit, CustomError_f1373cd2());
            rateLimitWindowUsed += storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1);
            if (storage_map_m[uint8(arg0)].field_0.field_0 - uint128(arg1) <= 0xffffffffffffffffffffffffffffffff) {
                storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)] = uint128(storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_0.field_0 - uint128(arg1)) | 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 & storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)];
                if (address(var_i)) {
                    payable(address(address(var_i))).transfer(0);
                    if (ret0.length == 0) {
                        if (!success) {
                            require(success, CustomError_90b8ec18());
                        } else {
                            require(0x80 + var_s - 0x80 >= 0x20);
                            require(var_d, CustomError_90b8ec18());
                        }
                        emit Claimed(msg.sender, storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_0.field_0, uint8(arg0), uint128(arg1), storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_1.field_0 * uint128(arg1));
                        store_k = 0x01;
                    } else {
                        if (!success) {
                            require(success, CustomError_90b8ec18());
                            emit Claimed(msg.sender, storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_0.field_0, uint8(arg0), uint128(arg1), storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_1.field_0 * uint128(arg1));
                            store_k = 0x01;
                        }
                    }
                } else {
                    payable(address(msg.sender)).transfer(storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_1.field_0 * uint128(arg1));
                    require(success, CustomError_90b8ec18());
                    emit Claimed(msg.sender, storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_0.field_0, uint8(arg0), uint128(arg1), storage_map_i[storage_map_m[uint8(arg0)].field_0.field_0][uint8(arg0)].field_1.field_0 * uint128(arg1));
                    store_k = 0x01;
                }
            }
        }
    }
    
    /// @custom:selector    0xcc0e153b
    /// @custom:signature   currencies(uint8 arg0) public view returns (bool)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function currencies(uint8 arg0) public view returns (bool) {
        require(arg0 == uint8(arg0));
        return abi.encodePacked(storage_map_m[arg0].field_0.field_0, storage_map_m[arg0].field_1.field_0.field_0, uint64(storage_map_m[arg0].field_1 / 0x0100000000000000000000000000000000), uint64(storage_map_m[arg0].field_1 / 0x01000000000000000000000000000000000000000000000000), storage_map_m[arg0].field_2.field_0);
    }
    
    /// @custom:selector    0xf340fa01
    /// @custom:signature   deposit(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function deposit(address arg0) public payable {
        require(true);
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(arg0, CustomError_32691b57());
        require(0 - msg.value, CustomError_749b5939());
        uint256 var_c = var_c + 0xa0;
        require(uint128(var_i), CustomError_16fb6fc9());
        if (uint128(var_i)) {
            require(!(msg.value % uint128(var_i)), CustomError_749b5939());
            if (uint128(var_j)) {
                require(msg.value / uint128(var_j) <= 0xffffffffffffffff, CustomError_749b5939());
                require(uint64(msg.value / uint128(var_j)) >= uint64(var_k), CustomError_6ba4a1c7());
                require(uint64(msg.value / uint128(var_j)) <= uint64(var_l), CustomError_744352e3());
                if (!storage_map_l[arg0].field_0) {
                    require(nextUserId <= 0xffffff, CustomError_2fa4a55a());
                    if (nextUserId + 0x01 <= 0xffffffff) {
                        store_v = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & store_v | uint32(nextUserId + 0x01);
                        storage_map_l[arg0] = nextUserId | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & storage_map_l[arg0];
                        storage_map_a[nextUserId] = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_a[nextUserId];
                        emit UserCreated(arg0, nextUserId);
                        if (block.timestamp <= 0x127500 + block.timestamp && store_e - 0x01 <= 0xffffffffffffffff) {
                            uint256 var_c = 0x40 + (0xa0 + var_c);
                            storage_map_g[store_e] = var_u;
                            storage_map_g[store_e].field_1 = uint64(var_v) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_g[store_e].field_1;
                            if (store_e - 0xffffffffffffffff) {
                                store_f = uint64(0x01 + store_e) | store_f & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
                                emit DepositMade(msg.sender, arg0, nextUserId, 0, uint64(msg.value / uint128(var_j)), msg.value);
                                emit DepositQueued(store_e, nextUserId, 0, uint64(msg.value / uint128(var_j)), uint64(0x127500 + block.timestamp));
                                store_k = 0x01;
                            }
                        }
                    }
                } else {
                    if (block.timestamp <= 0x127500 + block.timestamp && store_e - 0x01 <= 0xffffffffffffffff) {
                        uint256 var_c = 0x40 + (0xa0 + var_c);
                        storage_map_g[store_e] = var_u;
                        storage_map_g[store_e].field_1 = uint64(var_v) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_g[store_e].field_1;
                        if (store_e - 0xffffffffffffffff) {
                            store_f = uint64(0x01 + store_e) | store_f & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
                            emit DepositMade(msg.sender, arg0, storage_map_g[store_e].field_0.field_0, 0, uint64(msg.value / uint128(var_j)), msg.value);
                            emit DepositQueued(store_e, storage_map_g[store_e].field_0.field_0, 0, uint64(msg.value / uint128(var_j)), uint64(0x127500 + block.timestamp));
                            store_k = 0x01;
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x59e6800c
    /// @custom:signature   depositToken(address arg0, uint8 arg1, uint256 arg2) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function depositToken(address arg0, uint8 arg1, uint256 arg2) public {
        require(true);
        require(arg1 == uint8(arg1));
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(arg0, CustomError_32691b57());
        require(0 - uint8(arg1), CustomError_8ba13cff());
        require(uint8(arg1) < 0x08, CustomError_16fb6fc9());
        require(0 - arg2, CustomError_749b5939());
        require(address(var_i), CustomError_16fb6fc9());
        (bool success, bytes memory ret0) = address(address(var_i)).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_c + ret0.length - var_c >= 0x20);
        payable(address(address(var_i))).transfer(0);
        if (ret0.length == 0) {
            if (!success) {
                require(success, CustomError_90b8ec18());
                (bool success, bytes memory ret0) = address(address(var_i)).Unresolved_70a08231(address(this)); // staticcall
                require(success);
                uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_c + ret0.length - var_c >= 0x20);
                if (var_i - var_i <= var_i && uint128(var_u)) {
                    require(!((var_i - var_i) % uint128(var_u)), CustomError_749b5939());
                    if (uint128(var_u)) {
                        require((var_i - var_i) / uint128(var_u) <= 0xffffffffffffffff, CustomError_749b5939());
                        require(uint64((var_i - var_i) / uint128(var_u)) >= uint64(var_v), CustomError_6ba4a1c7());
                        require(uint64((var_i - var_i) / uint128(var_u)) <= uint64(var_w), CustomError_744352e3());
                        if (!storage_map_l[arg0].field_0) {
                            require(nextUserId <= 0xffffff, CustomError_2fa4a55a());
                            if (nextUserId + 0x01 <= 0xffffffff) {
                                store_v = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & store_v | uint32(nextUserId + 0x01);
                                storage_map_l[arg0] = nextUserId | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & storage_map_l[arg0];
                                storage_map_a[nextUserId] = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_a[nextUserId];
                                emit UserCreated(arg0, nextUserId);
                                if (block.timestamp <= 0x127500 + block.timestamp && store_e - 0x01 <= 0xffffffffffffffff) {
                                    uint256 var_c = 0x40 + (0xa0 + var_c);
                                    storage_map_g[store_e] = var_ae;
                                    storage_map_g[store_e].field_1 = uint64(var_af) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_g[store_e].field_1;
                                    if (store_e - 0xffffffffffffffff) {
                                        store_f = uint64(0x01 + store_e) | store_f & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
                                        emit DepositMade(msg.sender, arg0, nextUserId, uint8(arg1), uint64((var_i - var_i) / uint128(var_u)), var_i - var_i);
                                        emit DepositQueued(store_e, nextUserId, uint8(arg1), uint64((var_i - var_i) / uint128(var_u)), uint64(0x127500 + block.timestamp));
                                        store_k = 0x01;
                                    }
                                }
                            }
                        } else {
                            if (block.timestamp <= 0x127500 + block.timestamp && store_e - 0x01 <= 0xffffffffffffffff) {
                                uint256 var_c = 0x40 + (0xa0 + var_c);
                                storage_map_g[store_e] = var_ae;
                                storage_map_g[store_e].field_1 = uint64(var_af) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_g[store_e].field_1;
                                if (store_e - 0xffffffffffffffff) {
                                    store_f = uint64(0x01 + store_e) | store_f & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000;
                                    emit DepositMade(msg.sender, arg0, storage_map_g[store_e].field_0.field_0, uint8(arg1), uint64((var_i - var_i) / uint128(var_u)), var_i - var_i);
                                    emit DepositQueued(store_e, storage_map_g[store_e].field_0.field_0, uint8(arg1), uint64((var_i - var_i) / uint128(var_u)), uint64(0x127500 + block.timestamp));
                                    store_k = 0x01;
                                }
                            }
                        }
                    }
                }
            } else {
                require(0x80 + var_al - 0x80 < 0x20, CustomError_90b8ec18());
            }
        } else {
            if (!success) {
                require(success, CustomError_90b8ec18());
                (bool success, bytes memory ret0) = address(address(var_i)).Unresolved_70a08231(address(this), 0); // staticcall
                revert();
            }
        }
    }
    
    /// @custom:selector    0x93246022
    /// @custom:signature   exitClaimed(uint32 arg0, uint8 arg1) public view returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    function exitClaimed(uint32 arg0, uint8 arg1) public view returns (bool) {
        require(true);
        require(arg1 == uint8(arg1));
        return storage_map_w[arg0][arg1].field_0;
    }
    
    /// @custom:selector    0xd6fd590e
    /// @custom:signature   forceExitMode() public view returns (bool)
    function forceExitMode() public view returns (bool) {
        return uint8(store_d / 0x0100);
    }
    
    /// @custom:selector    0x62a5af3b
    /// @custom:signature   freeze() public
    function freeze() public {
        require(msg.sender == store_y, CustomError_82b42900());
        store_d = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
        emit Frozen(msg.sender);
    }
    
    /// @custom:selector    0x054f7d9c
    /// @custom:signature   frozen() public view returns (bool)
    function frozen() public view returns (bool) {
        return store_j;
    }
    
    /// @custom:selector    0xc310dd00
    /// @custom:signature   getClaimable(address arg0, uint8 arg1) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    function getClaimable(address arg0, uint8 arg1) public view returns (address) {
        require(true);
        require(arg1 == uint8(arg1));
        if (0 - storage_map_l[arg0].field_0) {
            return storage_map_i[storage_map_l[arg0].field_0.field_0][uint8(arg1)].field_0.field_0;
        } else {
            return 0;
        }
    }
    
    /// @custom:selector    0x408eb811
    /// @custom:signature   getDepositEntry(uint64 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function getDepositEntry(uint64 arg0) public view returns (bytes memory) {
        require(true);
        return abi.encodePacked(storage_map_g[arg0], storage_map_g[arg0].field_1.field_0.field_0);
    }
    
    /// @custom:selector    0x1c3692b9
    /// @custom:signature   lastPostTime() public view returns (uint256)
    function lastPostTime() public view returns (uint256) {
        return store_h;
    }
    
    /// @custom:selector    0xd278b223
    /// @custom:signature   nDepositsCommitted() public view returns (uint64)
    function nDepositsCommitted() public view returns (uint64) {
        return uint64(store_f / 0x010000000000000000);
    }
    
    /// @custom:selector    0x88507b01
    /// @custom:signature   nDepositsFinalized() public view returns (uint64)
    function nDepositsFinalized() public view returns (uint64) {
        return uint64(store_f / 0x0100000000000000000000000000000000);
    }
    
    /// @custom:selector    0x9b07aa7e
    /// @custom:signature   nDepositsQueued() public view returns (uint64)
    function nDepositsQueued() public view returns (uint64) {
        return store_e;
    }
    
    /// @custom:selector    0xeb77db65
    /// @custom:signature   nPosted() public view returns (uint64)
    function nPosted() public view returns (uint64) {
        return uint64(store_d / 0x010000);
    }
    
    /// @custom:selector    0x579a9f21
    /// @custom:signature   nProven() public view returns (uint64)
    function nProven() public view returns (uint64) {
        return uint64(store_d / 0x0100000000000000000000);
    }
    
    /// @custom:selector    0xffa1ac77
    /// @custom:signature   nSettled() public view returns (uint64)
    function nSettled() public view returns (uint64) {
        return uint64(store_d / 0x01000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x9f1d932e
    /// @custom:signature   openDepositCount() public view returns (uint64)
    function openDepositCount() public view returns (uint64) {
        if (store_e - uint64(store_f / 0x0100000000000000000000000000000000) <= 0xffffffffffffffff) {
            return uint64(store_e - uint64(store_f / 0x0100000000000000000000000000000000));
        }
    }
    
    /// @custom:selector    0xdd366e91
    /// @custom:signature   rateLimitWindowStart() public view returns (uint256)
    function rateLimitWindowStart() public view returns (uint256) {
        return store_n;
    }
    
    /// @custom:selector    0xa65490b6
    /// @custom:signature   secondsSinceLastPost() public view returns (uint256)
    function secondsSinceLastPost() public view returns (uint256) {
        if (block.timestamp - store_h <= block.timestamp) {
            return block.timestamp - store_h;
        }
    }
    
    /// @custom:selector    0xc287184e
    /// @custom:signature   setRateLimit(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setRateLimit(uint256 arg0) public {
        require(msg.sender == store_y, CustomError_82b42900());
        rateLimit = arg0;
        emit RateLimitSet(arg0);
    }
    
    /// @custom:selector    0x34dfe1e6
    /// @custom:signature   swapExitVerifier(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function swapExitVerifier(address arg0) public {
        require(true);
        require(msg.sender == store_y, CustomError_82b42900());
        require(arg0, CustomError_32691b57());
        emit ExitVerifierSet(exitVerifier, arg0);
        store_z = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_z;
    }
    
    /// @custom:selector    0x9eac9d22
    /// @custom:signature   swapVerifier(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function swapVerifier(address arg0) public {
        require(true);
        require(msg.sender == store_y, CustomError_82b42900());
        require(arg0, CustomError_32691b57());
        emit VerifierSet(batchVerifier, arg0);
        store_aa = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_aa;
    }
    
    /// @custom:selector    0x7d882097
    /// @custom:signature   totalDeposits() public view returns (uint64)
    function totalDeposits() public view returns (uint64) {
        return store_e;
    }
    
    /// @custom:selector    0x290601fb
    /// @custom:signature   triggerForceExit() public returns (bool)
    function triggerForceExit() public returns (bool) {
        if (!uint8(store_d / 0x0100)) {
            if (store_e - uint64(store_f / 0x0100000000000000000000000000000000) <= 0xffffffffffffffff && storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                if (store_h <= 0) {
                    if (block.timestamp >= storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                        if (block.timestamp < storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)].field_1.field_0) {
                            return false;
                        } else {
                            store_d = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_d;
                            emit ForceExitEnabled(msg.sender);
                            return true;
                        }
                    } else {
                        if (store_h <= 0) {
                            return false;
                        } else {
                            store_d = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_d;
                            emit ForceExitEnabled(msg.sender);
                            return true;
                        }
                    }
                } else {
                    if (store_h <= 0x03f480 + store_h) {
                        if (block.timestamp < 0x03f480 + store_h) {
                            return false;
                        } else {
                            store_d = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_d;
                            emit ForceExitEnabled(msg.sender);
                            return true;
                        }
                    }
                }
            }
        } else {
            return true;
        }
    }
    
    /// @custom:selector    0x6a28f000
    /// @custom:signature   unfreeze() public
    function unfreeze() public {
        require(msg.sender == store_y, CustomError_82b42900());
        store_d = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
        store_n = block.timestamp;
        rateLimitWindowUsed = 0;
        emit Unfrozen(msg.sender);
    }
    
    /// @custom:selector    0x10a23fee
    /// @custom:signature   Unresolved_10a23fee() public
    function Unresolved_10a23fee() public {
        require(msg.sender == store_y, CustomError_82b42900());
        if (rateLimitWindowUsed > rateLimit) {
            store_d = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
            emit RateLimitTripped(rateLimitWindowUsed, rateLimit);
        }
    }
    
    /// @custom:selector    0x29605e77
    /// @custom:signature   Unresolved_29605e77(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_29605e77(address arg0) public {
        require(true);
        require(msg.sender == store_y, CustomError_82b42900());
        require(arg0, CustomError_32691b57());
        emit OperatorSet(store_y, arg0);
        store_ab = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_ab;
    }
    
    /// @custom:selector    0x2eb4a7ab
    /// @custom:signature   Unresolved_2eb4a7ab() public view returns (uint256)
    function Unresolved_2eb4a7ab() public view returns (uint256) {
        return store_ac;
    }
    
    /// @custom:selector    0x4278f4ed
    /// @custom:signature   Unresolved_4278f4ed(bool arg0, address arg1) public
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_4278f4ed(bool arg0, address arg1) public {
        require(arg0 == uint8(arg0));
        require(arg1 == uint128(arg1));
        require(msg.sender == store_y, CustomError_82b42900());
        require(store_j, CustomError_41dbb51e());
        require(uint8(store_d / 0x0100), CustomError_41dbb51e());
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(uint8(arg0) < 0x08, CustomError_16fb6fc9());
        require(0 - uint128(arg1), CustomError_969bf728());
        require(storage_map_ad[uint8(arg0)].field_0 >= uint128(arg1), CustomError_2ae40529());
        uint256 var_d = var_d + 0xa0;
        var_a = storage_map_m[uint8(arg0)].field_0;
        if (storage_map_m[uint8(arg0)].field_1.field_0 == storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) / uint128(arg1) | !uint128(arg1) && (0x0e10 <= store_n + 0x0e10 && rateLimitWindowUsed <= storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) + rateLimitWindowUsed)) {
            require(storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1) + rateLimitWindowUsed <= rateLimit, CustomError_f1373cd2());
            rateLimitWindowUsed += storage_map_m[uint8(arg0)].field_1.field_0 * uint128(arg1);
            if (storage_map_m[uint8(arg0)].field_0.field_0 - uint128(arg1) <= 0xffffffffffffffffffffffffffffffff) {
                storage_map_ad[uint8(arg0)] = uint128(storage_map_ad[uint8(arg0)].field_0.field_0 - uint128(arg1)) | 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 & storage_map_ad[uint8(arg0)];
                if (address(var_i)) {
                    payable(address(address(var_i))).transfer(0);
                    if (ret0.length == 0) {
                        if (!success) {
                            require(success, CustomError_90b8ec18());
                        } else {
                            require(0x80 + var_s - 0x80 >= 0x20);
                            require(var_a, CustomError_90b8ec18());
                        }
                        emit Claimed(msg.sender, 0, uint8(arg0), uint128(arg1), storage_map_ad[uint8(arg0)].field_1.field_0 * uint128(arg1));
                        store_k = 0x01;
                    } else {
                        if (!success) {
                            require(success, CustomError_90b8ec18());
                            emit Claimed(msg.sender, 0, uint8(arg0), uint128(arg1), storage_map_ad[uint8(arg0)].field_1.field_0 * uint128(arg1));
                            store_k = 0x01;
                        }
                    }
                } else {
                    payable(address(msg.sender)).transfer(storage_map_ad[uint8(arg0)].field_1.field_0 * uint128(arg1));
                    require(success, CustomError_90b8ec18());
                    emit Claimed(msg.sender, 0, uint8(arg0), uint128(arg1), storage_map_ad[uint8(arg0)].field_1.field_0 * uint128(arg1));
                    store_k = 0x01;
                }
            }
        }
    }
    
    /// @custom:selector    0x4cf2cf12
    /// @custom:signature   Unresolved_4cf2cf12(uint256 arg0, uint64 arg1, uint64 arg2) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    function Unresolved_4cf2cf12(uint256 arg0, uint64 arg1, uint64 arg2) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(msg.sender == store_y, CustomError_82b42900());
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        if (0 < msg.data[0x04 + arg0]) {
            require(0x20 + (0x20 + (0x04 + arg0)) + 0x20 - (0x20 + (0x20 + (0x04 + arg0))) >= 0x20);
            require(msg.data[0x20 + (0x20 + (0x04 + arg0))] == uint64(msg.data[0x20 + (0x20 + (0x04 + arg0))]));
            require(0 - uint64(msg.data[0x20 + (0x20 + (0x04 + arg0))]), CustomError_81ffbe8b());
            require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
            require(msg.data[0x20 + (0x04 + arg0)] == uint64(msg.data[0x20 + (0x04 + arg0)]));
            require(uint64(msg.data[0x20 + (0x04 + arg0)]) > uint64(store_d / 0x01000000000000000000000000000000000000), CustomError_aa32fa71());
            require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
            require(msg.data[0x20 + (0x04 + arg0)] == uint64(msg.data[0x20 + (0x04 + arg0)]));
            require(uint64(msg.data[0x20 + (0x04 + arg0)]) == uint64(store_d / 0x010000), CustomError_fd003a63());
            require(msg.data[0x20 + (0x04 + arg0)] == uint64(msg.data[0x20 + (0x04 + arg0)]));
        }
    }
    
    /// @custom:selector    0x570ca735
    /// @custom:signature   Unresolved_570ca735() public view returns (address)
    function Unresolved_570ca735() public view returns (address) {
        return store_y;
    }
    
    /// @custom:selector    0x65435728
    /// @custom:signature   Unresolved_65435728(uint32 arg0, bool arg1, uint64 arg2, uint256 arg3) public
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_65435728(uint32 arg0, bool arg1, uint64 arg2, uint256 arg3) public {
        require(true);
        require(arg1 == uint8(arg1));
        require(true);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(uint8(store_d / 0x0100), CustomError_4064d6a0());
        require(!storage_map_w[arg0][uint8(arg1)].field_0, CustomError_bfc6c5e0());
        uint256 var_h = var_h + 0x8d;
        if (0 < var_k && 0 >= var_k) {
            (bool success, bytes memory ret0) = address(exitVerifier).Unresolved_7e4f7a8a(0x40); // staticcall
            require(success);
            uint256 var_h = var_h + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(var_h + ret0.length - var_h >= 0x20);
            require(var_m, CustomError_0b61be1e());
            if (uint128(arg2) + storage_map_i[arg0][uint8(arg1)].field_0.field_0 <= 0xffffffffffffffffffffffffffffffff) {
                storage_map_i[arg0][uint8(arg1)] = storage_map_i[arg0][uint8(arg1)] & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | uint128(uint128(arg2) + storage_map_i[arg0][uint8(arg1)].field_0.field_0);
                storage_map_w[arg0][uint8(arg1)] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_w[arg0][uint8(arg1)];
                emit ForceExitDone(arg0, uint8(arg1), arg2);
                store_k = 0x01;
            }
        }
    }
    
    /// @custom:selector    0x66fcf686
    /// @custom:signature   Unresolved_66fcf686(uint256 arg0, uint32 arg1, bool arg2, uint64 arg3) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    /// @param              arg2 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg3 ["uint64", "bytes8", "int64"]
    function Unresolved_66fcf686(uint256 arg0, uint32 arg1, bool arg2, uint64 arg3) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        require(uint8(store_d / 0x0100), CustomError_4064d6a0());
        if (store_e - uint64(store_f / 0x0100000000000000000000000000000000) <= 0xffffffffffffffff) {
            require(msg.data[0x04 + arg0], CustomError_dca8fefd());
            require(msg.data[0x04 + arg0] <= uint64(store_e - uint64(store_f / 0x0100000000000000000000000000000000)), CustomError_87baf7b7());
            if (uint64(store_f / 0x0100000000000000000000000000000000) - 0x01 <= 0xffffffffffffffff && 0 < msg.data[0x04 + arg0]) {
                require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
                require(msg.data[0x20 + (0x04 + arg0)] == uint32(msg.data[0x20 + (0x04 + arg0)]));
                if (0 < msg.data[0x04 + arg0]) {
                    require(0x20 + (0x20 + (0x04 + arg0)) + 0x20 - (0x20 + (0x20 + (0x04 + arg0))) >= 0x20);
                    require(msg.data[0x20 + (0x20 + (0x04 + arg0))] == uint8(msg.data[0x20 + (0x20 + (0x04 + arg0))]));
                    if (0 < msg.data[0x04 + arg0]) {
                        require(0x40 + (0x20 + (0x04 + arg0)) + 0x20 - (0x40 + (0x20 + (0x04 + arg0))) >= 0x20);
                        require(msg.data[0x40 + (0x20 + (0x04 + arg0))] == uint64(msg.data[0x40 + (0x20 + (0x04 + arg0))]));
                        uint256 var_h = 0xa0 + var_h;
                        if (uint64(store_f / 0x0100000000000000000000000000000000) <= 0xffffffffffffffff) {
                            require(keccak256(memory[0x20 + var_h:0x20 + var_h + var_i]) == storage_map_g[uint64(store_f / 0x0100000000000000000000000000000000)], CustomError_42af93ee());
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x75630730
    /// @custom:signature   Unresolved_75630730(uint256 arg0, uint64 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    function Unresolved_75630730(uint256 arg0, uint64 arg1) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(msg.sender == store_y, CustomError_82b42900());
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        require(true);
    }
    
    /// @custom:selector    0xae2cf66d
    /// @custom:signature   Unresolved_ae2cf66d(bool arg0, address arg1, address arg2, uint64 arg3) public pure
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg3 ["uint64", "bytes8", "int64"]
    function Unresolved_ae2cf66d(bool arg0, address arg1, address arg2, uint64 arg3) public pure {
        require(arg0 == uint8(arg0));
        require(true);
        require(arg2 == uint128(arg2));
        require(true);
    }
    
    /// @custom:selector    0xc4053c9e
    /// @custom:signature   Unresolved_c4053c9e(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_c4053c9e(uint256 arg0, uint256 arg1) public view {
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        if (uint64(store_d / 0x0100000000000000000000) + 0x01 <= 0xffffffffffffffff) {
            require(uint64(uint64(store_d / 0x0100000000000000000000) + 0x01) <= uint64(store_d / 0x010000), CustomError_38679f9d());
            require(0x20 >= 0x20);
            require(arg0 == uint64(arg0));
            require(uint64(arg0) == uint64(uint64(store_d / 0x0100000000000000000000) + 0x01), CustomError_010836a9());
            require(arg0 == uint64(arg0));
        }
    }
    
    /// @custom:selector    0xca2298c4
    /// @custom:signature   Unresolved_ca2298c4(bool arg0, uint256 arg1, uint64 arg2) public pure
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    function Unresolved_ca2298c4(bool arg0, uint256 arg1, uint64 arg2) public pure {
        if (!msg.value && arg0 == uint8(arg0)) {
            require(true);
        }
        revert();
    }
    
    /// @custom:selector    0xfcde7134
    /// @custom:signature   Unresolved_fcde7134(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_fcde7134(uint256 arg0, uint256 arg1) public {
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(!store_j, CustomError_41dbb51e());
        require(!uint8(store_d / 0x0100), CustomError_ca30896e());
        require(store_k - 0x02, CustomError_0e62d69f());
        store_k = 0x02;
        if (uint64(store_d / 0x01000000000000000000000000000000000000) + 0x01 <= 0xffffffffffffffff) {
            require(uint64(uint64(store_d / 0x01000000000000000000000000000000000000) + 0x01) <= uint64(store_d / 0x0100000000000000000000), CustomError_695e7ce4());
            require(storage_map_ae[uint64(uint64(store_d / 0x01000000000000000000000000000000000000) + 0x01)].field_0, CustomError_618104e8());
            require(0x20 >= 0x20);
            require(arg0 == uint64(arg0));
            require(uint64(arg0) == uint64(uint64(store_d / 0x01000000000000000000000000000000000000) + 0x01), CustomError_e641eb12());
            require(arg0 == uint64(arg0));
        }
    }
    
    /// @custom:selector    0xdbb96e41
    /// @custom:signature   userOf(address arg0) public view returns (uint32)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function userOf(address arg0) public view returns (uint32) {
        require(true);
        return storage_map_l[arg0].field_0.field_0;
    }
}