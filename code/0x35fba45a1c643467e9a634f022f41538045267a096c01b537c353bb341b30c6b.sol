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
    uint256 public constant MAX_BATCH_CALLS = 200;
    uint256 public constant MAX_BPS = 10000;
    uint256 public constant unresolved_34b834fb = 3600;
    uint256 public constant unresolved_49e936a2 = 200;
    uint256 public constant unresolved_6fa9568a = 256;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_p; // storage slot: 0x00
    address store_o; // storage slot: 0x01
    bytes32 store_b; // storage slot: 0x01
    uint256 public unresolved_ed529d79; // storage slot: 0x02
    uint256 public unresolved_d3ce8236; // storage slot: 0x03
    address public unresolved_adb423aa; // storage slot: 0x07
    bytes32 store_q; // storage slot: 0x07
    address public safetyGuardian; // storage slot: 0x08
    bytes32 store_h; // storage slot: 0x08
    bytes32 store_l; // storage slot: 0x09
    bytes32 store_i; // storage slot: 0x0a
    uint16 store_r; // storage slot: 0x0a
    uint256 public safetyEpoch; // storage slot: 0x0b
    
    mapping(address => bytes32) storage_map_c; // storage slot: 0x04
    mapping(address => uint256) public unresolved_5efe1179; // storage slot: 0x05
    mapping(address => uint8) storage_map_n; // storage slot: 0x06
    mapping(address => bytes32) storage_map_j; // storage slot: 0x0c
    
    error CustomError_00000000();
    event Event_0fc30517();
    event Event_8be0079c();
    event Event_a51b5196();
    event Event_e7b18eb0();
    event Event_fa56da73();
    event LimitsSet(uint256, uint256);
    event NativeDeposited(address, uint256);
    event NativeWithdrawn(address, uint256);
    event OwnershipTransferStarted(address, address);
    event PausedSet(bool);
    event TokenDeposited(address, address, uint256);
    
    /// @custom:selector    0xc4c834be
    /// @custom:signature   beginOwnershipTransfer(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function beginOwnershipTransfer(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        require(arg0, CustomError_e6c4247b());
        store_b = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
        emit OwnershipTransferStarted(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xdb6b5246
    /// @custom:signature   depositNative() public view
    function depositNative() public view {
        emit NativeDeposited(msg.sender, msg.value);
    }
    
    /// @custom:selector    0x13e7c9d8
    /// @custom:signature   operators(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function operators(address arg0) public view returns (bool) {
        require(true);
        return storage_map_c[arg0].field_0;
    }
    
    /// @custom:selector    0x530011a7
    /// @custom:signature   pauseByGuardian() public
    function pauseByGuardian() public {
        require(msg.sender == safetyGuardian, CustomError_3f12c4b8());
        if (!uint8(store_b / 0x010000000000000000000000000000000000000000)) {
            store_b = 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_b;
            emit PausedSet(0x01);
        }
    }
    
    /// @custom:selector    0xc4590d3f
    /// @custom:signature   setLimits(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function setLimits(uint256 arg0, uint256 arg1) public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        require(0 - arg0, CustomError_6e84a40c());
        require(arg0 <= 0xc8, CustomError_3999d3be());
        unresolved_ed529d79 = arg0;
        unresolved_d3ce8236 = arg1;
        emit LimitsSet(arg0, arg1);
    }
    
    /// @custom:selector    0x01e33667
    /// @custom:signature   Unresolved_01e33667(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_01e33667(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x0e10a24b
    /// @custom:signature   Unresolved_0e10a24b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0e10a24b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        require(!arg0.code.length, CustomError_e6c4247b());
        store_h = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
        emit Event_a51b5196(arg0);
    }
    
    /// @custom:selector    0x102faed0
    /// @custom:signature   Unresolved_102faed0(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_102faed0(uint256 arg0, uint256 arg1) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        require(!uint8(store_b / 0x010000000000000000000000000000000000000000), CustomError_9e87fac8());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(0 - msg.data[0x04 + arg0], CustomError_2a67cf23());
        require(msg.data[0x04 + arg0] <= 0xc8, CustomError_3971ddf8());
        require(0 - arg1, CustomError_626ade30());
        if (arg1 == arg1 * msg.data[0x04 + arg0] / msg.data[0x04 + arg0] | !msg.data[0x04 + arg0]) {
            require(msg.value == arg1 * msg.data[0x04 + arg0], CustomError_626ade30());
            if (0 >= msg.data[0x04 + arg0]) {
                emit Event_e7b18eb0(msg.sender, var_d, arg1, arg1 * var_d);
                store_b = 0x01000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
            } else {
                if (0 < msg.data[0x04 + arg0]) {
                    require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                    require(!address(msg.data[0x04 + arg0 + 0x20]).code.length, CustomError_e6c4247b());
                    if (0 >= 0) {
                        payable(address(address(msg.data[0x04 + arg0 + 0x20]))).transfer(arg1);
                        revert CustomError_f4b3b1bc();
                    } else {
                        if (0 < msg.data[0x04 + arg0]) {
                            require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                            require(msg.data[0x04 + arg0 + 0x20] != address(msg.data[0x04 + arg0 + 0x20]), CustomError_3e918579());
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x1344c0e7
    /// @custom:signature   Unresolved_1344c0e7() public view returns (uint16)
    function Unresolved_1344c0e7() public view returns (uint16) {
        return uint16(store_i / 0x010000);
    }
    
    /// @custom:selector    0x16c38b3c
    /// @custom:signature   Unresolved_16c38b3c(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_16c38b3c(uint256 arg0) public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        store_b = store_b & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | 0x010000000000000000000000000000000000000000 * arg0;
        emit PausedSet(arg0);
    }
    
    /// @custom:selector    0x1ef8fb53
    /// @custom:signature   Unresolved_1ef8fb53(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1ef8fb53(uint256 arg0, uint256 arg1) public view {
        if (!msg.value && (arg0 <= 0xffffffffffffffff && msg.data[0x04 + arg0] <= 0xffffffffffffffff)) {
            require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] != address(msg.data[0x04 + arg0 + 0x20]), CustomError_82d5d76a());
            }
        }
        revert();
    }
    
    /// @custom:selector    0x338b5dea
    /// @custom:signature   Unresolved_338b5dea(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_338b5dea(address arg0, uint256 arg1) public {
        require(true);
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(arg0, CustomError_e6c4247b());
        payable(address(var_l)).transfer(0);
        if (ret0.length == 0) {
            if (!success) {
                require(success, CustomError_54a3dcad());
                emit TokenDeposited(msg.sender, var_l, arg1);
                store_b = 0x01000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
            } else {
                require(!var_m);
            }
        } else {
            if (!success) {
                require(success, CustomError_54a3dcad());
                emit TokenDeposited(msg.sender, var_m, arg1);
            } else {
                require(!var_p, CustomError_54a3dcad());
                emit TokenDeposited(msg.sender, arg0, arg1);
            }
            store_b = 0x01000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        }
    }
    
    /// @custom:selector    0x4e6f8245
    /// @custom:signature   Unresolved_4e6f8245() public view returns (uint256)
    function Unresolved_4e6f8245() public view returns (uint256) {
        uint256 var_b = 0xc0 + var_b;
        uint256 var_b = 0x62 + var_b;
        return keccak256(memory[0x20 + var_b:0x20 + var_b + var_k]);
    }
    
    /// @custom:selector    0x53adb556
    /// @custom:signature   Unresolved_53adb556(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint64 arg7, uint64 arg8, uint256 arg9, address arg10, address arg11, uint256 arg12, uint16 arg13, uint16 arg14, uint256 arg15, uint256 arg16) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint64", "bytes8", "int64"]
    /// @param              arg8 ["uint64", "bytes8", "int64"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg11 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint16", "bytes2", "int16"]
    /// @param              arg14 ["uint16", "bytes2", "int16"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    function Unresolved_53adb556(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint64 arg7, uint64 arg8, uint256 arg9, address arg10, address arg11, uint256 arg12, uint16 arg13, uint16 arg14, uint256 arg15, uint256 arg16) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x01e0);
        require(arg16 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg16] <= 0xffffffffffffffff);
        require(msg.sender != unresolved_8da5cb5b, CustomError_ea8e4eb5());
        require(storage_map_c[msg.sender].field_0, CustomError_ea8e4eb5());
        require(!uint8(store_b / 0x010000000000000000000000000000000000000000), CustomError_9e87fac8());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        require(msg.data[0x04 + arg0 + 0x40] < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1 + (msg.data.length - (0x04 + arg0)));
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x40] + 0x20 <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]);
        uint256 var_a = (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f) + (0x20 + var_i + 0x20 + 0x60) + 0x20 - var_i - 0x20;
        uint256 var_i = (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f) + (0x20 + var_i + 0x20 + 0x60) + 0x20;
        require(0x20 >= 0x20);
        require(arg1 == address(arg1));
        if (address(arg1) == 0) {
            require(address(arg1) != 0, CustomError_0e33904a());
            require(arg3 == keccak256(memory[0x20 + var_i:0x20 + var_i + var_l]), CustomError_9822401c());
            require(0 - safetyEpoch, CustomError_0adede31());
            require(arg4 == safetyEpoch, CustomError_49a129eb());
            require(storage_map_j[msg.sender] == arg5, CustomError_78c57dbf());
            if (arg6 - block.timestamp <= arg6) {
                require(arg6 - block.timestamp <= uint64(store_i / 0x0100000000), CustomError_68ba131d());
                require(0x20 >= 0x20);
                require(true);
                require(0x20 >= 0x20);
                require(true);
                if (arg9) {
                    require(arg7 > block.number, CustomError_8f223a4d());
                    require(arg7 <= block.number, CustomError_8f223a4d());
                    if (arg8 - arg7 <= arg8) {
                        require(arg8 - arg7 <= uint64(store_i / 0x01000000000000000000000000), CustomError_2d71cfb7());
                        uint256 var_m = msg.data[0x24:0x24 + 0x01e0];
                        uint256 var_i = 0xc0 + var_i;
                        require(msg.data[0x04 + arg16] == 0x41, CustomError_8baa579f());
                        require(msg.data[0x04 + arg16 + 0x20 + 0x20] > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, CustomError_8baa579f());
                        require(msg.data[0x04 + arg16 + 0x20 + 0x20] <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, CustomError_8baa579f());
                        if (memory[0x20]) {
                            require(address(var_ac), CustomError_8baa579f());
                            require(address(var_ac) == unresolved_adb423aa, CustomError_8baa579f());
                            if (0x20 >= 0x20) {
                                require(!arg15, CustomError_5942599a());
                                require(store_l <= arg12, CustomError_5f990f());
                                if (!store_l) {
                                    require(0x20 >= 0x20);
                                    require(true);
                                    require(0x20 >= 0x20);
                                    require(false, CustomError_78c57dbf());
                                } else {
                                    require(0x20 >= 0x20);
                                    require(true);
                                    require(0x20 >= 0x20);
                                    require(true);
                                    require(0x20 >= 0x20);
                                    require(arg1 == address(arg1));
                                    require(address(arg1), CustomError_0e33904a());
                                    require(arg10.code.length, CustomError_0e33904a());
                                    (bool success, bytes memory ret0) = address(arg10).Unresolved_00000000(0); // staticcall
                                    if (ret0.length == 0) {
                                        uint256 var_i = var_i + 0x24;
                                        (bool success, bytes memory ret0) = address(arg10).Unresolved_(memory[var_i:var_i + (var_i + var_l - var_i)]); // staticcall
                                        if (ret0.length == 0) {
                                            if (!success) {
                                                require(!success, CustomError_0e33904a());
                                                require(success, CustomError_0e33904a());
                                                require(0x80 + var_ai - 0x80 >= 0x20);
                                                require(var_a == address(var_a));
                                                require(0x80 + var_ai - 0x80 >= 0x20);
                                                require(var_a == address(var_a));
                                                if (address(var_a) == address(arg1)) {
                                                    require(address(var_a) == address(arg1), CustomError_0e33904a());
                                                    uint256 var_i = var_i + 0x24;
                                                    (bool success, bytes memory ret0) = address(arg10).Unresolved_(memory[var_i:var_i + (var_i + var_l - var_i)]); // staticcall
                                                    require(ret0.length == 0, CustomError_0e33904a());
                                                    require(!success, CustomError_0e33904a());
                                                    require(success, CustomError_0e33904a());
                                                    require(0x80 + var_ai - 0x80 >= 0x60);
                                                    require(var_a == uint112(var_a));
                                                }
                                            }
                                        } else {
                                            require(success, CustomError_0e33904a());
                                        }
                                    } else {
                                        (bool success, bytes memory ret0) = address(arg10).Unresolved_0e33904a(0); // staticcall
                                        require(ret0.length != 0, CustomError_0e33904a());
                                        uint256 var_i = var_i + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                    }
                                }
                            }
                        }
                        revert();
                    }
                }
            }
        } else {
            require(0x20 >= 0x20);
        }
    }
    
    /// @custom:selector    0x59dc842d
    /// @custom:signature   Unresolved_59dc842d(address arg0, uint256 arg1, uint256 arg2, uint16 arg3) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint16", "bytes2", "int16"]
    function Unresolved_59dc842d(address arg0, uint256 arg1, uint256 arg2, uint16 arg3) public pure {
        if (!msg.value) {
            require(true);
        }
        revert();
    }
    
    /// @custom:selector    0x5b6d7c28
    /// @custom:signature   Unresolved_5b6d7c28(uint256 arg0, uint256 arg1, uint256 arg2) public pure returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_5b6d7c28(uint256 arg0, uint256 arg1, uint256 arg2) public pure returns (uint256) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        require(msg.data[0x04 + arg0 + 0x40] < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1 + (msg.data.length - (0x04 + arg0)));
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x40] + 0x20 <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]);
        uint256 var_f = (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f) + (0x20 + var_f + 0x20 + 0x60) + 0x20;
        return keccak256(memory[0x20 + var_f:0x20 + var_f + var_j]);
    }
    
    /// @custom:selector    0x5c1c6dcd
    /// @custom:signature   Unresolved_5c1c6dcd(uint256 arg0, uint256 arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_5c1c6dcd(uint256 arg0, uint256 arg1, uint256 arg2) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.sender != unresolved_8da5cb5b, CustomError_ea8e4eb5());
        require(storage_map_c[msg.sender].field_0, CustomError_ea8e4eb5());
        require(!uint8(store_b / 0x010000000000000000000000000000000000000000), CustomError_9e87fac8());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(!uint8(store_h / 0x010000000000000000000000000000000000000000), CustomError_0a0e458c());
        require(0 - msg.data[0x20 + (0x04 + arg0)], CustomError_4b839867());
        require(msg.data[0x20 + (0x04 + arg0)] <= unresolved_5efe1179[msg.sender], CustomError_e820c1f7());
        unresolved_5efe1179[msg.sender] -= var_i;
        require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        require(address(this) != address(msg.data[0x04 + arg0]), CustomError_82d5d76a());
        require(address(msg.data[0x04 + arg0]).code.length, CustomError_82d5d76a());
        require(msg.data[0x20 + (0x04 + arg0)] <= unresolved_d3ce8236, CustomError_7a0e1985());
        require(storage_map_n[address(msg.data[0x04 + arg0])].field_0, CustomError_e356c1d3());
        require(address(this).balance >= msg.data[0x04 + arg0 + 0x20], CustomError_e4a567cf());
        require(msg.data[0x04 + arg0 + 0x40] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]);
        uint256 var_e = msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]):0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]) + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]];
        payable(address(address(msg.data[0x04 + arg0]))).transfer(msg.data[0x04 + arg0 + 0x20]);
        require(success, CustomError_25593c6c());
        emit Event_fa56da73(msg.sender, address(msg.data[0x04 + arg0]), msg.data[0x04 + arg0 + 0x20], 0);
        store_b = 0x01000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return uint8(store_b / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x79ba5097
    /// @custom:signature   Unresolved_79ba5097() public
    function Unresolved_79ba5097() public {
        require(msg.sender == store_o, CustomError_30cd7471());
        store_p = msg.sender | store_p & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        store_b = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
        store_q = msg.sender | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_q;
        store_h = msg.sender & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | store_h & 0xffffffffffffffffffffff000000000000000000000000000000000000000000 | 0x010000000000000000000000000000000000000000;
        safetyEpoch += 0x01;
        emit Event_8be0079c(unresolved_8da5cb5b, msg.sender);
        emit Event_0fc30517(msg.sender, 0x01, store_l, store_r, uint16(store_i / 0x010000), uint64(store_i / 0x0100000000), uint64(store_i / 0x01000000000000000000000000), safetyEpoch);
        emit Event_a51b5196(msg.sender);
        store_b = 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_b;
        emit PausedSet(0x01);
    }
    
    /// @custom:selector    0x7b6d6a18
    /// @custom:signature   Unresolved_7b6d6a18(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_7b6d6a18(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure returns (uint256) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if (0 >= msg.data[0x04 + arg0]) {
            uint256 var_d = 0x40 + (0x20 + var_d + (msg.data[0x04 + arg0] << 0x05));
            return keccak256(memory[0x20 + var_d:0x20 + var_d + var_f]);
        } else {
            require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)] == address(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)]));
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40] < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1 + (msg.data.length - (msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20))));
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40]] <= 0xffffffffffffffff);
            require(msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40] + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40]]);
        }
    }
    
    /// @custom:selector    0x7bfaa95d
    /// @custom:signature   Unresolved_7bfaa95d() public view returns (uint64)
    function Unresolved_7bfaa95d() public view returns (uint64) {
        return uint64(store_i / 0x01000000000000000000000000);
    }
    
    /// @custom:selector    0xa3111bdb
    /// @custom:signature   Unresolved_a3111bdb(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a3111bdb(uint256 arg0, uint256 arg1) public {
        if (!msg.value && (arg0 <= 0xffffffffffffffff && msg.data[0x04 + arg0] <= 0xffffffffffffffff)) {
            require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                require(address(msg.data[0x04 + arg0 + 0x20]), CustomError_e6c4247b());
                storage_map_c[address(msg.data[0x04 + arg0 + 0x20])] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[address(msg.data[0x04 + arg0 + 0x20])];
            }
        }
        revert();
    }
    
    /// @custom:selector    0xb44e11af
    /// @custom:signature   Unresolved_b44e11af(uint256 arg0, uint256 arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_b44e11af(uint256 arg0, uint256 arg1, uint256 arg2) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender != unresolved_8da5cb5b, CustomError_ea8e4eb5());
        require(storage_map_c[msg.sender].field_0, CustomError_ea8e4eb5());
        require(!uint8(store_b / 0x010000000000000000000000000000000000000000), CustomError_9e87fac8());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(!uint8(store_h / 0x010000000000000000000000000000000000000000), CustomError_0a0e458c());
        require(0 - msg.data[0x04 + arg0], CustomError_c2e5347d());
        require(msg.data[0x04 + arg0] >= unresolved_ed529d79, CustomError_6e84a40c());
        require(msg.data[0x04 + arg0] <= 0xc8, CustomError_3999d3be());
        if (0 >= msg.data[0x04 + arg0]) {
            if (0 <= address(this).balance) {
                revert CustomError_4b839867();
            } else {
                revert CustomError_e4a567cf();
            }
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            }
        }
    }
    
    /// @custom:selector    0xb8fe8d5f
    /// @custom:signature   Unresolved_b8fe8d5f(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b8fe8d5f(address arg0) public view returns (bool) {
        require(true);
        return storage_map_n[arg0].field_0;
    }
    
    /// @custom:selector    0xbd3f8c97
    /// @custom:signature   Unresolved_bd3f8c97() public view returns (uint16)
    function Unresolved_bd3f8c97() public view returns (uint16) {
        return store_r;
    }
    
    /// @custom:selector    0xbf36574a
    /// @custom:signature   Unresolved_bf36574a() public view returns (uint64)
    function Unresolved_bf36574a() public view returns (uint64) {
        return uint64(store_i / 0x0100000000);
    }
    
    /// @custom:selector    0xd5ca44f9
    /// @custom:signature   Unresolved_d5ca44f9(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    function Unresolved_d5ca44f9(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x01e0);
        require(arg16 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg16] <= 0xffffffffffffffff);
        require(msg.sender != unresolved_8da5cb5b, CustomError_ea8e4eb5());
        require(storage_map_c[msg.sender].field_0, CustomError_ea8e4eb5());
        require(!uint8(store_b / 0x010000000000000000000000000000000000000000), CustomError_9e87fac8());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(0 - msg.data[0x04 + arg0], CustomError_c2e5347d());
        require(msg.data[0x04 + arg0] >= unresolved_ed529d79, CustomError_6e84a40c());
        require(msg.data[0x04 + arg0] <= 0xc8, CustomError_3999d3be());
        if (0 >= msg.data[0x04 + arg0]) {
            require(0 <= address(this).balance, CustomError_e4a567cf());
            if (0 >= msg.data[0x04 + arg0]) {
                uint256 var_f = 0x40 + (0x20 + var_f + (msg.data[0x04 + arg0] << 0x05));
                require(0x20 >= 0x20);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
                require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)] == address(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)]));
                require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40] < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1 + (msg.data.length - (msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20))));
                require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40]] <= 0xffffffffffffffff);
                require(msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40] + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x40]]);
            }
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            }
        }
    }
    
    /// @custom:selector    0xd6ce27cc
    /// @custom:signature   Unresolved_d6ce27cc(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d6ce27cc(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_j[arg0];
    }
    
    /// @custom:selector    0xe02e5e48
    /// @custom:signature   Unresolved_e02e5e48() public view returns (bool)
    function Unresolved_e02e5e48() public view returns (bool) {
        return uint8(store_h / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0xe30c3978
    /// @custom:signature   Unresolved_e30c3978() public view returns (address)
    function Unresolved_e30c3978() public view returns (address) {
        return store_o;
    }
    
    /// @custom:selector    0xebac3155
    /// @custom:signature   Unresolved_ebac3155(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ebac3155(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xf00086bb
    /// @custom:signature   Unresolved_f00086bb() public view returns (uint256)
    function Unresolved_f00086bb() public view returns (uint256) {
        return store_l;
    }
    
    /// @custom:selector    0xf698da25
    /// @custom:signature   Unresolved_f698da25() public view returns (uint256)
    function Unresolved_f698da25() public view returns (uint256) {
        uint256 var_g = 0xc0 + var_g;
        return keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]);
    }
    
    /// @custom:selector    0x07b18bde
    /// @custom:signature   withdrawNative(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function withdrawNative(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        require(uint8(store_b / 0x01000000000000000000000000000000000000000000) == 0x01, CustomError_ed3ba6a6());
        store_b = 0x02000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
        require(arg0, CustomError_e6c4247b());
        require(address(this).balance <= address(this).balance, CustomError_e4a567cf());
        payable(address(arg0)).transfer(address(this).balance);
        require(success, CustomError_f4b3b1bc());
        emit NativeWithdrawn(arg0, address(this).balance);
        store_b = 0x01000000000000000000000000000000000000000000 | 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff & store_b;
    }
}