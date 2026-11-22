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
    uint256 public constant wrappedNativeToken = 1097077688018008265106216665536940668749033598146;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_i; // storage slot: 0x00
    bytes32 store_c; // storage slot: 0x01
    address public unresolved_2a6c53ec; // storage slot: 0x05
    bytes32 store_j; // storage slot: 0x05
    address public unresolved_5259248f; // storage slot: 0x06
    bytes32 store_k; // storage slot: 0x06
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x02
    mapping(address => bytes32) storage_map_b; // storage slot: 0x03
    mapping(address => bytes32) storage_map_e; // storage slot: 0x04
    mapping(address => uint8) storage_map_g; // storage slot: 0x07
    
    error CustomError_00000000();
    event Event_8be0079c();
    event Event_dbbddaff();
    event OperatorSet(address, bool);
    event WhitelistSet(address, bool);
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0xc683630d
    /// @custom:signature   isWhitelist(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isWhitelist(address arg0) public view returns (bool) {
        require(true);
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x4dfdc21f
    /// @custom:signature   maxNum() public view returns (uint256)
    function maxNum() public view returns (uint256) {
        return store_c;
    }
    
    /// @custom:selector    0x79a1c157
    /// @custom:signature   multiSend(address[] arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function multiSend(address[] arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(msg.data[0x04 + arg0], "empty tokens");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
            require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            if (!address(msg.data[0x04 + arg0 + 0x20])) {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_a9059cbb(arg1); // call
                require(!success, CustomError_5274afe7());
            } else {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_70a08231(address(this), arg1); // staticcall
                require(success);
                uint256 var_d = var_d + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_d + ret0.length - var_d >= 0x20);
                if (address(msg.data[0x04 + arg0 + 0x20])) {
                    (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_a9059cbb(arg1); // call
                    require(!success, CustomError_5274afe7());
                } else {
                    payable(address(arg1)).transfer(var_j);
                    revert();
                }
            }
        }
    }
    
    /// @custom:selector    0x0befee98
    /// @custom:signature   Unresolved_0befee98(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_0befee98(uint256 arg0) public {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        if (storage_map_e[msg.sender].field_0.field_0 + 0x0708 <= 0xffffffffffffffff) {
            require(block.timestamp >= uint64(storage_map_e[msg.sender].field_0.field_0 + 0x0708), "unwrap too frequently");
            require(arg0 <= store_c, "amount exceeds");
            storage_map_e[msg.sender] = uint64(block.timestamp) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_e[msg.sender];
            require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
            (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_2e1a7d4d(arg0); // call
            require(success);
            payable(address(msg.sender)).transfer(arg0);
            require(success);
        }
    }
    
    /// @custom:selector    0x0ca0a04b
    /// @custom:signature   Unresolved_0ca0a04b(uint256 arg0, uint64 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    function Unresolved_0ca0a04b(uint256 arg0, uint64 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(unresolved_2a6c53ec, "empty okx pmm");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            if (0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20 && msg.data[0x04 + arg0 + 0x20] == uint64(msg.data[0x04 + arg0 + 0x20])) {
                uint64 var_d = uint64(msg.data[0x04 + arg0 + 0x20]);
                if (unresolved_2a6c53ec.code.length) {
                    (bool success, bytes memory ret0) = address(unresolved_2a6c53ec).Unresolved_76ef573a(var_d); // call
                }
            }
            revert();
        }
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256) {
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            require(var_e >= 0x42, "sig len less than 66");
            uint256 var_a = var_a + 0x80;
            uint256 var_c = msg.data[0x64:0x64 + 0x41];
            if (0x41 < var_e) {
                if (var_f >> 0xf8) {
                    if (uint8(var_f >> 0xf8) + type(uint256).max) {
                        return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                    } else {
                        require(0x42 == var_e, "wrong length");
                        if (0x41 - var_e) {
                            if (0x02 <= 0x03) {
                                if (0x02 <= 0x03) {
                                    require(0x02 > 0x03, CustomError_fce698f7());
                                    revert CustomError_f645eedf();
                                }
                                require(storage_map_a[0].field_0, "err sig");
                                return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                            }
                        } else {
                            require(memory[0x20]);
                        }
                    }
                } else {
                    require(0x82 == var_e, "wrong length");
                    uint256 var_a = var_a + 0x60;
                    uint256 var_c = msg.data[0xa6:0xa6 + 0x40];
                    uint256 var_a = 0x21 + (0x20 + var_a + var_e);
                    if (0x41 - var_e) {
                        if (0x02 <= 0x03) {
                            if (0x02 <= 0x03) {
                                require(0x02 > 0x03, CustomError_fce698f7());
                                revert CustomError_f645eedf();
                            }
                            require(storage_map_a[0].field_0, "err sig");
                            require(0x20 + var_a + var_e - (0x20 + var_a) >= 0x40);
                            require(var_af == uint64(var_af));
                            require(var_ag == address(var_ag));
                            require(block.timestamp <= uint64(var_af), "ddl");
                            if (address(var_ag)) {
                                if (address(var_ag) == tx.origin) {
                                    require(address(var_ag) == tx.origin, "err sig 2");
                                } else {
                                    require(storage_map_g[address(var_ag)].field_0, "err sig 2");
                                }
                            }
                            return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                        }
                    } else {
                        uint256 var_a = var_a + 0x20;
                        var_aj = keccak256(memory[0x20 + var_a:0x20 + var_a + var_e]);
                        require(memory[0x20]);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x1f6eddba
    /// @custom:signature   Unresolved_1f6eddba(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1f6eddba(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(unresolved_2a6c53ec, "empty okx pmm");
        uint256 var_d = var_d + 0x64;
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
        if (!success && !success) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
            require(success);
            require(!ret0.length, CustomError_5274afe7());
            require(arg0.code.length, CustomError_5274afe7());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
            require(success);
            if (!ret0.length) {
                require(arg0.code.length, CustomError_5274afe7());
            } else {
                require(0x01 == var_m, CustomError_5274afe7());
            }
        }
    }
    
    /// @custom:selector    0x2ecc1126
    /// @custom:signature   Unresolved_2ecc1126(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2ecc1126(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x34b73ef6
    /// @custom:signature   Unresolved_34b73ef6(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_34b73ef6(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x53d6fd59
    /// @custom:signature   Unresolved_53d6fd59(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_53d6fd59(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_b[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[arg0];
        emit WhitelistSet(arg0, arg1);
    }
    
    /// @custom:selector    0x558a7297
    /// @custom:signature   Unresolved_558a7297(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_558a7297(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        emit OperatorSet(arg0, arg1);
    }
    
    /// @custom:selector    0x5f7510d2
    /// @custom:signature   Unresolved_5f7510d2(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_5f7510d2(address arg0) public view returns (bool) {
        require(true);
        return storage_map_g[arg0].field_0;
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_i = store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x7546be62
    /// @custom:signature   Unresolved_7546be62(uint256 arg0, uint64 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint64", "bytes8", "int64"]
    function Unresolved_7546be62(uint256 arg0, uint64 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(unresolved_2a6c53ec, "empty okx pmm");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            if (0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20 && msg.data[0x04 + arg0 + 0x20] == uint64(msg.data[0x04 + arg0 + 0x20])) {
                uint64 var_d = uint64(msg.data[0x04 + arg0 + 0x20]);
                if (unresolved_2a6c53ec.code.length) {
                    (bool success, bytes memory ret0) = address(unresolved_2a6c53ec).Unresolved_76ef573a(var_d); // call
                }
            }
            revert();
        }
    }
    
    /// @custom:selector    0x758e963a
    /// @custom:signature   Unresolved_758e963a(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_758e963a(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(unresolved_2a6c53ec, "empty okx pmm");
        uint256 var_d = var_d + 0x64;
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
        if (!success && !success) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
            require(success);
            require(!ret0.length, CustomError_5274afe7());
            require(arg0.code.length, CustomError_5274afe7());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_2a6c53ec); // call
            require(success);
            if (!ret0.length) {
                require(arg0.code.length, CustomError_5274afe7());
            } else {
                require(0x01 == var_m, CustomError_5274afe7());
            }
        }
    }
    
    /// @custom:selector    0x7a1a6240
    /// @custom:signature   Unresolved_7a1a6240(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_7a1a6240(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(unresolved_5259248f, "empty self pmm");
        uint256 var_d = var_d + 0x64;
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_5259248f); // call
        if (!success && !success) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_5259248f); // call
            require(success);
            require(!ret0.length, CustomError_5274afe7());
            require(arg0.code.length, CustomError_5274afe7());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_5259248f); // call
            require(success);
            if (!ret0.length) {
                require(arg0.code.length, CustomError_5274afe7());
            } else {
                require(0x01 == var_m, CustomError_5274afe7());
            }
        }
    }
    
    /// @custom:selector    0x9752ea12
    /// @custom:signature   Unresolved_9752ea12(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9752ea12(uint256 arg0, uint256 arg1) public view {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f);
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(arg1 <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
                    require(0x04 + arg1 + 0x20 >= 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20);
                    if (storage_map_a[msg.sender].field_0) {
                        revert("err length");
                    } else {
                        revert("not permitted");
                    }
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0x9ffae9d9
    /// @custom:signature   Unresolved_9ffae9d9(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9ffae9d9(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(unresolved_5259248f, "empty self pmm");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            uint256 var_d = msg.data[0x04 + arg0 + 0x20];
            if (unresolved_5259248f.code.length) {
                (bool success, bytes memory ret0) = address(unresolved_5259248f).Unresolved_825caba1(var_d); // call
            }
            revert();
        }
    }
    
    /// @custom:selector    0xb6f0a95e
    /// @custom:signature   Unresolved_b6f0a95e(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_b6f0a95e(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xba71dc70
    /// @custom:signature   Unresolved_ba71dc70(address arg0) public view returns (uint64)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_ba71dc70(address arg0) public view returns (uint64) {
        require(true);
        return storage_map_e[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0xd32d3659
    /// @custom:signature   Unresolved_d32d3659(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_d32d3659(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xd8de6a90
    /// @custom:signature   Unresolved_d8de6a90(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d8de6a90(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_j = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_j;
        emit Event_dbbddaff(0, arg0);
    }
    
    /// @custom:selector    0xd9caed12
    /// @custom:signature   Unresolved_d9caed12(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d9caed12(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xe59e32a2
    /// @custom:signature   Unresolved_e59e32a2(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e59e32a2(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_k = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
        emit Event_dbbddaff(0x01, arg0);
    }
    
    /// @custom:selector    0xea598cb0
    /// @custom:signature   Unresolved_ea598cb0(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ea598cb0(uint256 arg0) public payable {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_d0e30db0{ value: arg0 }(var_d); // call
        require(success);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_i = arg0 | store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xde0e9a3e
    /// @custom:signature   unwrap(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function unwrap(uint256 arg0) public {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_2e1a7d4d(arg0); // call
        require(success);
    }
}