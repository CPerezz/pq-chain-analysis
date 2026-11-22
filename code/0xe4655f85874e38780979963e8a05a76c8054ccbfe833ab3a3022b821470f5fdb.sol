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
    address store_b; // storage slot: 0x00
    bytes32 store_c; // storage slot: 0x00
    
    mapping(bytes32 => bytes32) storage_map_a; // storage slot: 0x01
    
    error CustomError_00000000();
    fallback() external payable {
        if (msg.data.length) {
            if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000) + 0x05b9e1cd00000000000000000000000000000000000000000000000000000000) {
                if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000 & 0xffffffff00000000000000000000000000000000000000000000000000000000) >= 0x1000000000000000000000000000000000000000000000000000000000) {
                    if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000 & 0xffffffff00000000000000000000000000000000000000000000000000000000) >= 0x2000000000000000000000000000000000000000000000000000000000) {
                        if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000) >= 0x3000000000000000000000000000000000000000000000000000000000) {
                            if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000 & 0xffffffff00000000000000000000000000000000000000000000000000000000) >= 0x4000000000000000000000000000000000000000000000000000000000) {
                                if ((msg.data[0] & 0xffffffff00000000000000000000000000000000000000000000000000000000 & 0xffffffff00000000000000000000000000000000000000000000000000000000) >= 0x5000000000000000000000000000000000000000000000000000000000) {
                                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0x2cb7866900000000000000000000000000000000000000000000000000000000) {
                                        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xe9d9458200000000000000000000000000000000000000000000000000000000) {
                                            require(storage_map_a[0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]].field_0, "D");
                                            uint256 var_d = msg.data[0:msg.data.length];
                                            (bool success, bytes memory ret0) = address(storage_map_a[0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]].field_0.field_0).Unresolved_(memory[0x80:0x80 + (msg.data.length + 0x80 - 0x80)]); // delegatecall
                                            require(success);
                                        } else {
                                            require(msg.data.length <= msg.data.length);
                                            require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40);
                                            require(arg1 <= 0xffffffffffffffff);
                                            require(0x04 + arg1 + 0x1f < 0x04 + (msg.data.length - 0x04));
                                            if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(0x80 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < 0x80 | 0x80 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
                                                require(0x04 + arg1 + msg.data[0x04 + arg1] + 0x20 <= 0x04 + (msg.data.length - 0x04));
                                                uint256 var_i = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]];
                                                if (var_k <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                                                    uint256 var_a = var_a + 0x20;
                                                    require(memory[0x20]);
                                                } else {
                                                    if (0x03 <= 0x03) {
                                                        if (0x03 <= 0x03) {
                                                            if (0x03 <= 0x03) {
                                                                require(0x03 > 0x03, CustomError_d78bce0c());
                                                                revert CustomError_fce698f7();
                                                            }
                                                            revert CustomError_f645eedf();
                                                        }
                                                        return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        bytes32 var_j = arg4 >> 0x60;
                                        uint256 var_a = 0x75 + (0x80 + var_a);
                                        require(msg.sender == address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])), "P");
                                        require(address(arg4 >> 0x60).code.length);
                                        (bool success, bytes memory ret0) = address(address(var_j)).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
                                        require(success);
                                        if (arg1) {
                                            require(address(arg4 >> 0x60).code.length);
                                            (bool success, bytes memory ret0) = address(address(var_j)).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
                                            require(success);
                                        }
                                    }
                                } else {
                                    require(msg.sender == store_b, "R");
                                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffbf00000000000000000000000000000000000000000000000000000000) {
                                        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffbe00000000000000000000000000000000000000000000000000000000) {
                                            if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffbc00000000000000000000000000000000000000000000000000000000) {
                                                if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffb800000000000000000000000000000000000000000000000000000000) {
                                                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffb700000000000000000000000000000000000000000000000000000000) {
                                                        if (!((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffb600000000000000000000000000000000000000000000000000000000)) {
                                                            storage_map_a[arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000] = arg0 >> 0x60 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_a[arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000];
                                                        }
                                                    } else {
                                                        require(arg1 >> 0x60, "Send 0x0");
                                                        payable(address(address(arg1 >> 0x60))).transfer(arg0);
                                                        require(success);
                                                    }
                                                } else {
                                                    store_c = arg0 >> 0x60 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_c;
                                                }
                                            } else {
                                                require(msg.data.length <= msg.data.length);
                                                require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x60);
                                                require(arg0 <= 0xffffffffffffffff);
                                                require(0x04 + arg0 + 0x1f < 0x04 + (msg.data.length - 0x04));
                                                if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
                                                    uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f);
                                                    require(0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05)) <= 0x04 + (msg.data.length - 0x04));
                                                }
                                            }
                                        } else {
                                            require(msg.data.length <= msg.data.length);
                                            require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x60);
                                            require(arg0 <= 0xffffffffffffffff);
                                            require(0x04 + arg0 + 0x1f < 0x04 + (msg.data.length - 0x04));
                                            if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
                                                uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f);
                                                require(0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05)) <= 0x04 + (msg.data.length - 0x04));
                                                if (0x04 + arg0 + 0x20 >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                                                    require(arg1 <= 0xffffffffffffffff);
                                                    require(0x04 + arg1 + 0x1f < 0x04 + (msg.data.length - 0x04));
                                                } else {
                                                    require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                                                }
                                            }
                                        }
                                    } else {
                                        require(arg1 >> 0x60, "Send 0x0");
                                        require(address(arg0 >> 0x60).code.length);
                                        (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(address(arg1 >> 0x60), arg0, 0x53656e6420307830000000000000000000000000000000000000000000000000); // call
                                        require(success);
                                    }
                                }
                            } else {
                                require(!(msg.sender - 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123), "A");
                                if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffcf00000000000000000000000000000000000000000000000000000000) {
                                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffce00000000000000000000000000000000000000000000000000000000) {
                                        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffcb00000000000000000000000000000000000000000000000000000000) {
                                            if (!((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffca00000000000000000000000000000000000000000000000000000000)) {
                                                require(msg.data.length <= msg.data.length);
                                                require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x60);
                                                require(arg1 <= 0xffffffffffffffff);
                                            }
                                        } else {
                                            require(msg.data.length <= msg.data.length);
                                            require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x60);
                                            require(arg0 <= 0xffffffffffffffff);
                                            require(0x04 + arg0 + 0x1f < 0x04 + (msg.data.length - 0x04));
                                            if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
                                                require(0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05)) <= 0x04 + (msg.data.length - 0x04));
                                            }
                                        }
                                    } else {
                                        require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
                                        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_2e1a7d4d{ value: 0 }(arg0, 0x01); // call
                                        require(success);
                                    }
                                } else {
                                    require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
                                    (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_d0e30db0{ value: arg0 }(arg0); // call
                                    require(success);
                                }
                            }
                        } else {
                            require(!(msg.sender - 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123), "A");
                            if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffde00000000000000000000000000000000000000000000000000000000) {
                                if (!((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffdf00000000000000000000000000000000000000000000000000000000)) {
                                    (bool success, bytes memory ret0) = address(arg0 >> 0x60).balances(0); // staticcall
                                    require(success);
                                    uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                    require(var_a + ret0.length - var_a >= 0x20);
                                    require(arg0 == var_d);
                                    uint256 var_d = msg.data[0x38:0x38 + 0x84];
                                    (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_00000000{ value: 0 }(0x01, 0x4100000000000000000000000000000000000000000000000000000000000000, var_z, var_aa, 0); // call
                                    require(success);
                                }
                            } else {
                                require(msg.value >= block.number, "U");
                                (bool success, bytes memory ret0) = address(arg0 >> 0x60).balances(0); // staticcall
                                require(success);
                                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                require(var_a + ret0.length - var_a >= 0x20);
                                require(arg0 == var_d);
                                uint256 var_d = msg.data[0x38:0x38 + 0x84];
                                (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_00000000{ value: 0 }(0x01, 0x4100000000000000000000000000000000000000000000000000000000000000, var_z, var_aa, 0); // call
                                require(success);
                                payable(address(block.coinbase)).transfer(arg5);
                                require(success);
                            }
                        }
                    } else {
                        require(!(msg.sender - 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123), "A");
                        require(msg.value >= block.number, "U");
                        if (!((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffef00000000000000000000000000000000000000000000000000000000)) {
                            if ((arg3 >> 0xf8) + type(uint256).max) {
                                if (uint8(arg3 >> 0xf8) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe) {
                                    require(!(uint8(arg3 >> 0xf8) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd), "V2ID");
                                } else {
                                    uint256 var_a = 0x48 + var_a;
                                    var_ad = keccak256(memory[0x20 + var_a:0x20 + var_a + var_d]);
                                    uint256 var_a = 0x75 + var_a;
                                    if (!0x01) {
                                        address var_ah = address(var_ad);
                                        require(address(arg0 >> 0x60).code.length);
                                        (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(var_ah); // call
                                        require(success);
                                    } else {
                                        if (!0x01) {
                                            (bool success, bytes memory ret0) = address(address(var_ad)).Unresolved_0902f1ac(var_ah); // staticcall
                                        } else {
                                            if (!0) {
                                                (bool success, bytes memory ret0) = address(address(var_ad)).Unresolved_0902f1ac(var_ah); // staticcall
                                            } else {
                                                address var_ah = address(var_ad);
                                                if (address(arg0 >> 0x60).code.length) {
                                                    (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(var_ah); // call
                                                    if (success) {
                                                        (bool success, bytes memory ret0) = address(var_ah).Unresolved_0902f1ac(var_ah); // staticcall
                                                    }
                                                }
                                            }
                                        }
                                        revert();
                                    }
                                }
                            } else {
                                uint256 var_a = 0x48 + var_a;
                                var_ad = keccak256(memory[0x20 + var_a:0x20 + var_a + var_d]);
                                uint256 var_af = 0x75 + var_a - var_a - 0x20;
                                uint256 var_a = 0x75 + var_a;
                                if (!0x01) {
                                    require(address(arg0 >> 0x60).code.length);
                                    (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(address(var_ad)); // call
                                    require(success);
                                    if (arg0 >> 0x60 >= arg0 >> 0x60) {
                                        if (address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])).code.length) {
                                            (bool success, bytes memory ret0) = address(arg2).Unresolved_022c0d9f{ value: 0 }(arg2); // call
                                        }
                                        revert();
                                    } else {
                                        require(address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])).code.length);
                                        (bool success, bytes memory ret0) = address(0).Unresolved_022c0d9f{ value: 0 }(0); // call
                                        require(success);
                                        if (arg3) {
                                            payable(address(block.coinbase)).transfer(arg3);
                                            require(success);
                                        }
                                    }
                                } else {
                                    if (!0x01) {
                                        (bool success, bytes memory ret0) = address(0).Unresolved_0902f1ac(0); // staticcall
                                        require(success);
                                        uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                        require(var_a + ret0.length - var_a >= 0x60);
                                        require(var_d == uint112(var_d));
                                        require(var_i == uint112(var_i));
                                        require(var_k == uint32(var_k));
                                        if ((uint112(var_i) - arg2) * 0x03e5) {
                                            if (0x01 + arg2 * uint112(var_d) * 0x03e8 / ((uint112(var_i) - arg2) * 0x03e5) <= arg1 && address(arg0 >> 0x60).code.length) {
                                                (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(0); // call
                                                if (success) {
                                                    if (arg0 >> 0x60 >= arg0 >> 0x60) {
                                                        if (address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])).code.length) {
                                                            (bool success, bytes memory ret0) = address(0).Unresolved_022c0d9f{ value: 0 }(arg2); // call
                                                        }
                                                    } else {
                                                        if (address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])).code.length) {
                                                            (bool success, bytes memory ret0) = address(0).Unresolved_022c0d9f{ value: 0 }(0); // call
                                                        }
                                                    }
                                                }
                                            }
                                            revert();
                                        }
                                    } else {
                                        if (!0) {
                                            (bool success, bytes memory ret0) = address(0).Unresolved_0902f1ac(0); // staticcall
                                            require(success);
                                            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                            require(var_a + ret0.length - var_a >= 0x60);
                                            require(var_d == uint112(var_d));
                                            require(var_i == uint112(var_i));
                                            require(var_k == uint32(var_k));
                                            if (arg1 * 0x03e5 + uint112(var_d) * 0x03e8) {
                                                if (arg1 * uint112(var_i) * 0x03e5 / (arg1 * 0x03e5 + uint112(var_d) * 0x03e8) >= arg2 && address(arg0 >> 0x60).code.length) {
                                                    (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(0); // call
                                                }
                                                revert();
                                            }
                                        } else {
                                            address var_ah = address(var_ad);
                                            if (address(arg0 >> 0x60).code.length) {
                                                (bool success, bytes memory ret0) = address(address(arg0 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(var_ah, arg1); // call
                                                if (success) {
                                                    (bool success, bytes memory ret0) = address(var_ah).Unresolved_0902f1ac(var_ah); // staticcall
                                                }
                                            }
                                            revert();
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    require(!(msg.sender - 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123), "A");
                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xffffffff00000000000000000000000000000000000000000000000000000000) {
                        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffffe00000000000000000000000000000000000000000000000000000000) {
                            if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffffc00000000000000000000000000000000000000000000000000000000) {
                                if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffffb00000000000000000000000000000000000000000000000000000000) {
                                    if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffffa00000000000000000000000000000000000000000000000000000000) {
                                        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffff900000000000000000000000000000000000000000000000000000000) {
                                            if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffff800000000000000000000000000000000000000000000000000000000) {
                                                if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffff700000000000000000000000000000000000000000000000000000000) {
                                                    if (!((0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]) + 0xfffffff600000000000000000000000000000000000000000000000000000000)) {
                                                        require(msg.value >= block.number, "U");
                                                        uint256 var_a = var_a + 0x80;
                                                        uint256 var_a = var_a + 0xf5;
                                                        var_v = 11;
                                                        (bool success, bytes memory ret0) = address(var_ah).Unresolved_a34123a7{ value: 0 }(var_v); // call
                                                        revert();
                                                    }
                                                } else {
                                                    uint256 var_a = var_a + 0x80;
                                                    uint256 var_a = var_a + 0xf5;
                                                    var_v = 11;
                                                    (bool success, bytes memory ret0) = address(var_ah).Unresolved_a34123a7{ value: 0 }(var_v); // call
                                                    revert();
                                                }
                                            } else {
                                                uint256 var_a = var_a + 0x80;
                                                uint256 var_a = var_a + 0xf5;
                                                uint256 var_a = var_a + 0x4b;
                                                (bool success, bytes memory ret0) = address(var_ah).Unresolved_3c8a7d8d{ value: 0 }(address(this)); // call
                                                revert();
                                            }
                                        } else {
                                            if (arg1 >> 0x60 >= arg1 >> 0x60) {
                                                uint256 var_a = 0x80 + var_a;
                                                (bool success, bytes memory ret0) = address(var_ah).slot0(); // staticcall
                                                require(success);
                                                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                                require(var_a + ret0.length - var_a >= 0xe0);
                                                require(var_d == address(var_d));
                                                require(var_i == 11);
                                            } else {
                                                (bool success, bytes memory ret0) = address(var_ah).slot0(); // staticcall
                                                require(success);
                                                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                                require(var_a + ret0.length - var_a >= 0xe0);
                                                require(var_d == address(var_d));
                                                require(var_i == 11);
                                                require(var_k == uint16(var_k));
                                            }
                                        }
                                    } else {
                                        require(msg.value >= block.number, "U");
                                        if (arg1 >> 0x60 >= arg1 >> 0x60) {
                                            uint256 var_a = 0x80 + var_a;
                                            (bool success, bytes memory ret0) = address(var_ah).Unresolved_128acb08{ value: 0 }(address(arg3 >> 0x60), 0); // call
                                            require(success);
                                            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                            require(var_a + ret0.length - var_a < 0x40, "S");
                                        } else {
                                            (bool success, bytes memory ret0) = address(var_ah).Unresolved_128acb08{ value: 0 }(address(arg3 >> 0x60), 0x01); // call
                                            require(success);
                                            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                            require(var_a + ret0.length - var_a >= 0x40);
                                            require(var_d <= arg2, "S");
                                            payable(address(block.coinbase)).transfer(arg3);
                                            require(success);
                                        }
                                    }
                                } else {
                                    require(msg.value >= block.number, "U");
                                    if (arg1 >> 0x60 >= arg1 >> 0x60) {
                                        uint256 var_a = 0x80 + var_a;
                                        (bool success, bytes memory ret0) = address(var_ah).Unresolved_128acb08{ value: 0 }(address(arg3 >> 0x60), 0); // call
                                        require(success);
                                        uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                        require(var_a + ret0.length - var_a >= 0x40);
                                        require(var_i <= arg2, "S");
                                    } else {
                                        (bool success, bytes memory ret0) = address(var_ah).Unresolved_128acb08{ value: 0 }(address(arg3 >> 0x60), 0x01); // call
                                        require(success);
                                        uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                        require(var_a + ret0.length - var_a >= 0x40);
                                        if (arg0 <= 0) {
                                            require(var_d <= arg2, "S");
                                        } else {
                                            if (var_i - 0x8000000000000000000000000000000000000000000000000000000000000000) {
                                                require(0 - var_i >= arg2, "S");
                                            }
                                        }
                                    }
                                }
                            } else {
                                if (arg1 >> 0x60 >= arg1 >> 0x60) {
                                    uint256 var_a = 0x80 + var_a;
                                    (bool success, bytes memory ret0) = address(var_ah).slot0(); // staticcall
                                    require(success);
                                    uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                    require(var_a + ret0.length - var_a >= 0xe0);
                                    require(var_d == address(var_d));
                                    require(var_i == 11);
                                } else {
                                    (bool success, bytes memory ret0) = address(var_ah).slot0(); // staticcall
                                    require(success);
                                    uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                    require(var_a + ret0.length - var_a >= 0xe0);
                                    require(var_d == address(var_d));
                                    require(var_i == 11);
                                    require(var_k == uint16(var_k));
                                }
                            }
                        } else {
                            require(msg.value >= block.number, "U");
                            if (arg1 >> 0x60 >= arg1 >> 0x60) {
                                uint256 var_a = 0x80 + var_a;
                                uint256 var_a = 0x75 + (0x80 + var_a);
                                (bool success, bytes memory ret0) = address(address(keccak256(memory[var_a + 0x20:var_a + 0x20 + var_d]))).Unresolved_128acb08{ value: 0 }(address(this), 0); // call
                                require(success);
                                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                require(var_a + ret0.length - var_a < 0x40, "S");
                            } else {
                                uint256 var_a = 0x80 + var_a;
                                uint256 var_a = 0x75 + (0x80 + var_a);
                                (bool success, bytes memory ret0) = address(address(keccak256(memory[var_a + 0x20:var_a + 0x20 + var_d]))).Unresolved_128acb08{ value: 0 }(address(this), 0x01); // call
                                require(success);
                                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                require(var_a + ret0.length - var_a >= 0x40);
                                require(var_d <= arg2, "S");
                                payable(address(block.coinbase)).transfer(arg3);
                                require(success);
                            }
                        }
                    } else {
                        require(msg.value >= block.number, "U");
                        if (arg1 >> 0x60 >= arg1 >> 0x60) {
                            uint256 var_a = 0x80 + var_a;
                            uint256 var_a = 0x75 + (0x80 + var_a);
                            (bool success, bytes memory ret0) = address(address(keccak256(memory[var_a + 0x20:var_a + 0x20 + var_d]))).Unresolved_128acb08{ value: 0 }(address(this), 0); // call
                            require(success);
                            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                            require(var_a + ret0.length - var_a >= 0x40);
                            require(var_i <= arg2, "S");
                        } else {
                            uint256 var_a = 0x80 + var_a;
                            uint256 var_a = 0x75 + (0x80 + var_a);
                            (bool success, bytes memory ret0) = address(address(keccak256(memory[var_a + 0x20:var_a + 0x20 + var_d]))).Unresolved_128acb08{ value: 0 }(address(this), 0x01); // call
                            require(success);
                            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                            require(var_a + ret0.length - var_a >= 0x40);
                            if (arg0 <= 0) {
                                require(var_d <= arg2, "S");
                            } else {
                                if (var_i - 0x8000000000000000000000000000000000000000000000000000000000000000) {
                                    require(0 - var_i >= arg2, "S");
                                }
                            }
                        }
                    }
                }
            } else {
                if (arg4 >> 0x60 >= arg4 >> 0x60) {
                    uint256 var_a = 0x80 + var_a;
                    uint256 var_a = 0x75 + (0x80 + var_a);
                    require(msg.sender == address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])), "P");
                    require(address(arg4 >> 0x60).code.length);
                    (bool success, bytes memory ret0) = address(address(arg4 >> 0x60)).Unresolved_a9059cbb{ value: 0 }(msg.sender, arg1); // call
                } else {
                    address var_j = address(arg4 >> 0x60);
                    uint256 var_a = 0x75 + (0x80 + var_a);
                    require(msg.sender == address(keccak256(memory[0x20 + var_a:0x20 + var_a + var_d])), "P");
                    require(address(arg4 >> 0x60).code.length);
                    (bool success, bytes memory ret0) = address(var_j).Unresolved_a9059cbb{ value: 0 }(msg.sender, arg0); // call
                }
                require(success);
            }
        }
    }
    
}