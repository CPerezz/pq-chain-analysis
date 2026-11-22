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
    uint256 public constant unresolved_54fd4d50 = 1;
    
    error CustomError_00000000();
    
    /// @custom:selector    0x4b02d2f6
    /// @custom:signature   herring() public view returns (uint256)
    function herring() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(block.timestamp % 0x0c + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5));
        return ;
    }
    
    /// @custom:selector    0x07e5c0d2
    /// @custom:signature   Unresolved_07e5c0d2(uint256 arg0, uint248 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_07e5c0d2(uint256 arg0, uint248 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 >> 0x10) {
            uint256 var_b = msg.data[0x22:0x22 + uint24(arg0 >> 0x10)];
            if (var_b >> 0xf0 & 0x4000) {
                if (!(var_b >> 0xf0 & 0x1000)) {
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                    revert CustomError_90b8ec18();
                } else {
                    bytes32 var_d = var_e >> 0x60;
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                    if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                        (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        }
                        revert CustomError_3e3f8f73();
                    } else {
                        require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                        uint256 var_c = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length];
                        require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + uint24(arg0 >> 0x10)), CustomError_31560a0e());
                        require((var_j >> 0x80) + msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] <= address(this).balance, CustomError_f4d678b8());
                        payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + var_c);
                        if (!success) {
                            require(!(0x20 & var_b >> 0xf0));
                            if (!0) {
                                revert CustomError_2dd205a1();
                            } else {
                                revert CustomError_9a446475();
                            }
                        } else {
                            require(0 != ret0.length * !(var_b >> 0xf0 & 0x01), CustomError_2dd205a1());
                            if ((0xe0 & var_b >> 0xec) + 0x20 > ret0.length) {
                                revert CustomError_0310a487();
                            } else {
                                revert CustomError_2dd205a1();
                            }
                        }
                    }
                }
            }
        } else {
            uint256 var_c = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length];
            return var_c;
        }
    }
    
    /// @custom:selector    0x10c3405f
    /// @custom:signature   Unresolved_10c3405f(uint256 arg0, uint256 arg1, uint248 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_10c3405f(uint256 arg0, uint256 arg1, uint248 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (arg1 >> 0x10) {
            uint256 var_c = msg.data[0x42:0x42 + uint24(arg1 >> 0x10)];
            if (var_c >> 0xf0 & 0x4000) {
                if (!(var_c >> 0xf0 & 0x1000)) {
                    (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_a9059cbb(var_f >> 0x60); // call
                    revert CustomError_90b8ec18();
                } else {
                    bytes32 var_e = var_f >> 0x60;
                    (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                    if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                        (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                        if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                            (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                        }
                        revert CustomError_3e3f8f73();
                    } else {
                        require(0x01 == (var_c >> 0xf7 & 0x03), CustomError_c7009900());
                        uint256 var_d = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length];
                        require(var_b + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_b + uint24(arg1 >> 0x10)), CustomError_31560a0e());
                        require((var_j >> 0x80) + msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] <= address(this).balance, CustomError_f4d678b8());
                        payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + var_d);
                        if (!success) {
                            require(!(0x20 & var_c >> 0xf0));
                            if (!0) {
                                revert CustomError_2dd205a1();
                            } else {
                                revert CustomError_9a446475();
                            }
                        } else {
                            require(0 != ret0.length * !(var_c >> 0xf0 & 0x01), CustomError_2dd205a1());
                            if ((0xe0 & var_c >> 0xec) + 0x20 > ret0.length) {
                                revert CustomError_0310a487();
                            } else {
                                revert CustomError_2dd205a1();
                            }
                        }
                    }
                }
            }
        } else {
            require(msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] >= arg0, CustomError_064a4ec6());
            uint256 var_d = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length];
            return var_d;
        }
    }
    
    /// @custom:selector    0x1c6eced5
    /// @custom:signature   Unresolved_1c6eced5(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1c6eced5(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        bytes32 var_c = arg0 >> 0x60;
        (bool success, bytes memory ret0) = address(var_c).Unresolved_095ea7b3(var_c); // call
        if (!success && !success) {
            bytes32 var_c = arg0 >> 0x60;
            (bool success, bytes memory ret0) = address(var_c).Unresolved_095ea7b3(var_c); // call
            if (success) {
                require(ret0.length > 0x1f & 0xf8d8ab0e00000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_19be9a90());
            } else {
                require(success, CustomError_19be9a90());
            }
        }
        return arg1;
    }
    
    /// @custom:selector    0x20b04554
    /// @custom:signature   Unresolved_20b04554(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_20b04554(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0x23a69e75
    /// @custom:signature   Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0x26367361
    /// @custom:signature   Unresolved_26367361(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_26367361(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        payable(address(arg0 >> 0x60)).transfer(msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff20]);
        require(success);
        uint256 var_e = msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff40];
        return var_e;
    }
    
    /// @custom:selector    0x2636f7f8
    /// @custom:signature   Unresolved_2636f7f8(address arg0, uint248 arg1) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    function Unresolved_2636f7f8(address arg0, uint248 arg1) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        if (!(var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_b)) {
            uint256 var_b = var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            revert CustomError_ddb5de5e();
        }
    }
    
    /// @custom:selector    0x26678dcd
    /// @custom:signature   Unresolved_26678dcd(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_26678dcd(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (0 == !(arg0 >> 0x60)) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(arg0 >> 0x60); // call
            if (success) {
                require(ret0.length > 0x1f & 0xf8d8ab0e00000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_fb7f5079());
            } else {
                require(success, CustomError_fb7f5079());
            }
            return arg1;
        } else {
            payable(address(arg0 >> 0x60)).transfer(arg1);
            if (!ret0.length) {
                require(success, CustomError_b12d13eb());
                return arg1;
            }
        }
    }
    
    /// @custom:selector    0x2c8958f6
    /// @custom:signature   Unresolved_2c8958f6(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_2c8958f6(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0x3dd5cfd1
    /// @custom:signature   Unresolved_3dd5cfd1(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_3dd5cfd1(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (msg.data.length == 0x24) {
            (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
            if (!success) {
                (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
            }
            (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
            if (!success) {
                (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
                require(!success, CustomError_19be9a90());
                require(success, CustomError_19be9a90());
                uint256 var_c = arg0 / 0xe8d4a51000;
                (bool success, bytes memory ret0) = address(0xf6e72db5454dd049d0788e411b06cfaf16853042).Unresolved_8d7ef9bb(address(this)); // call
                require(success);
                return var_c;
            }
        } else {
            if (0x38 == msg.data.length) {
                (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
                if (!success) {
                    (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
                }
                (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
                if (!success) {
                    (bool success, bytes memory ret0) = address(0x6b175474e89094c44da98b954eedeac495271d0f).Unresolved_095ea7b3(0xf6e72db5454dd049d0788e411b06cfaf16853042); // call
                    revert CustomError_19be9a90();
                }
            }
        }
    }
    
    /// @custom:selector    0x3e88c8ab
    /// @custom:signature   Unresolved_3e88c8ab(address arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_3e88c8ab(address arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0x454c96c2
    /// @custom:signature   Unresolved_454c96c2(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_454c96c2(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        bytes32 var_b = var_c;
        (bool success, bytes memory ret0) = address(0xc537e898cd774e2dcba3b14ea6f34c93d5ea45e1).Unresolved_f1c5e014{ value: msg.value }(var_b); // call
        require(success);
        return var_i;
    }
    
    /// @custom:selector    0x48c95033
    /// @custom:signature   Unresolved_48c95033() public payable returns (uint256)
    function Unresolved_48c95033() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_48c89491(0x20); // call
        require(success);
        return var_f;
    }
    
    /// @custom:selector    0x4b64e492
    /// @custom:signature   Unresolved_4b64e492(address arg0, uint248 arg1, uint256 arg2, uint248 arg3) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_4b64e492(address arg0, uint248 arg1, uint256 arg2, uint248 arg3) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        if (!(var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_b)) {
            uint256 var_b = var_b + (var_b + msg.data.length - var_b + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd0 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            revert CustomError_ddb5de5e();
        }
    }
    
    /// @custom:selector    0x5109d8b6
    /// @custom:signature   Unresolved_5109d8b6(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_5109d8b6(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (0x40 & arg0) {
            if (arg0 >> 0x04 & 0x01) {
                (bool success, bytes memory ret0) = address(address(arg0 >> 0x38)).Unresolved_0902f1ac(var_b); // staticcall
                require(success);
                if (arg0 & 0x08) {
                    (bool success, bytes memory ret0) = address(arg2 >> 0x60).Unresolved_(memory[0x08:0x08 + 0x24]); // staticcall
                    require(success);
                    if (0x01 == arg0 >> 0x07 && (0x01 == (arg0 >> 0x04 & 0x01) && (0x01 == arg0 >> 0x07 && (0x01 == arg0 >> 0x07 && 0x01 == arg0 >> 0x07)))) {
                        require((var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0) - var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0)) * 0x0a ** uint8(arg2 >> 0xf0) / 0x0de0b6b3a7640000 >= arg1, CustomError_064a4ec6());
                        (bool success, bytes memory ret0) = address(address(arg0 >> 0x38)).Unresolved_00000000((var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0) - var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0)) * 0x0a ** uint8(arg2 >> 0xf0) / 0x0de0b6b3a7640000 * !(arg0 >> 0x07), (var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0) - var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0)) * 0x0a ** uint8(arg2 >> 0xf0) / 0x0de0b6b3a7640000 * (arg0 >> 0x07)); // call
                        require(success);
                        return (var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0) - var_d * 0x0de0b6b3a7640000 / 0x0a ** uint8(arg2 >> 0xf0)) * 0x0a ** uint8(arg2 >> 0xf0) / 0x0de0b6b3a7640000;
                    }
                }
            } else {
                (bool success, bytes memory ret0) = address(address(arg0 >> 0x38)).Unresolved_0902f1ac(var_b); // staticcall
                revert();
            }
        }
    }
    
    /// @custom:selector    0x654b6487
    /// @custom:signature   Unresolved_654b6487(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_654b6487(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0x6ae40711
    /// @custom:signature   Unresolved_6ae40711(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint240)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_6ae40711(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint240) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 & 0x20) {
            if (0x10 & arg0) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_0902f1ac(var_b); // staticcall
                require(success);
                if (arg0 & 0x08) {
                    (bool success, bytes memory ret0) = address(arg2 >> 0x60).Unresolved_(memory[0x0c:0x0c + 0x24]); // staticcall
                    require(success);
                    require((0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d) * var_e / (var_d * 0x3b9aca00 + (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d)) >= arg1, CustomError_064a4ec6());
                    if (0x01 == (0x01 & arg0 >> 0x06)) {
                        payable(address(arg0 >> 0x60)).transfer(0);
                    } else {
                        if (!(0x01 & arg0 >> 0x06)) {
                            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_00000000((0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d) * var_e / (var_d * 0x3b9aca00 + (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d)) * !(arg0 >> 0x07), (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d) * var_e / (var_d * 0x3b9aca00 + (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d)) * (arg0 >> 0x07)); // call
                        } else {
                            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_00000000((0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d) * var_e / (var_d * 0x3b9aca00 + (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d)) * !(arg0 >> 0x07)); // call
                        }
                    }
                    require(success);
                    return (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d) * var_e / (var_d * 0x3b9aca00 + (0x3b9aca00 - (arg0 >> 0xe0)) * (0x0902f1ac022c0d9f6d9a640a70a0823100000000000000000000000000000000 - var_d));
                }
            } else {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_0902f1ac(var_b); // staticcall
                revert();
            }
        } else {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_0902f1ac(var_b); // staticcall
            revert();
        }
    }
    
    /// @custom:selector    0x6b4be0b9
    /// @custom:signature   Unresolved_6b4be0b9(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_6b4be0b9(uint256 arg0) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(arg0 >> 0x60)) {
            return address(this).balance;
        } else {
            if (address(this) == arg0 >> 0x60) {
                if (address(arg0 >> 0x60).balance) {
                    return type(uint256).max + (type(uint256).max + address(arg0 >> 0x60).balance);
                } else {
                    return address(arg0 >> 0x60).balance;
                }
            } else {
                return address(arg0 >> 0x60).balance;
            }
        }
    }
    
    /// @custom:selector    0x6c4eca27
    /// @custom:signature   Unresolved_6c4eca27(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_6c4eca27(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        bytes32 var_c = arg0 >> 0x60;
        (bool success, bytes memory ret0) = address(var_c).Unresolved_a9059cbb(var_c); // call
        if (success) {
            require(ret0.length > 0x1f & 0xf8d8ab0e00000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
        return arg1;
    }
    
    /// @custom:selector    0x6f5ec5ce
    /// @custom:signature   Unresolved_6f5ec5ce(uint256 arg0, uint248 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_6f5ec5ce(uint256 arg0, uint248 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 >> 0x60) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
            uint256 var_b = msg.data[0x18:0x18 + (msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8)];
            if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] | !(var_b >> 0xf0 & 0x8000)) {
                if (var_b >> 0xf0 & 0x4000) {
                    if (!(var_b >> 0xf0 & 0x1000)) {
                        (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_a9059cbb(var_g >> 0x60); // call
                        revert CustomError_90b8ec18();
                    } else {
                        bytes32 var_f = var_g >> 0x60;
                        (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                        if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                            (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                            if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                            }
                            revert CustomError_3e3f8f73();
                        } else {
                            require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                            require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8), CustomError_31560a0e());
                            require((var_l >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] <= address(this).balance, CustomError_f4d678b8());
                            payable(address(var_m >> 0x60)).transfer((var_l >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                            if (!success) {
                                require(!(0x20 & var_b >> 0xf0));
                                if (!0) {
                                    revert CustomError_2dd205a1();
                                } else {
                                    revert CustomError_9a446475();
                                }
                            } else {
                                require(0 != ret0.length * !(var_b >> 0xf0 & 0x01), CustomError_2dd205a1());
                                require((0xe0 & var_b >> 0xec) + 0x20 <= ret0.length, CustomError_0310a487());
                            }
                        }
                    }
                }
            } else {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
                require(success);
                require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
                if (0x3e3f8f7300000000000000000000000000000000000000000000000000000000 - 0x3e3f8f7300000000000000000000000000000000000000000000000000000000 <= 0x3e3f8f7300000000000000000000000000000000000000000000000000000000) {
                    return 0x4e487b7100000000000000000000000000000000000000000000000000000000 - 0x4e487b7100000000000000000000000000000000000000000000000000000000;
                }
            }
        }
    }
    
    /// @custom:selector    0x7225b0d0
    /// @custom:signature   Unresolved_7225b0d0(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_7225b0d0(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (arg1 <= arg1 + arg2 && arg3 - (arg1 + arg2) <= arg3) {
            if (arg0 >> 0x60) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(arg0 >> 0x60); // call
                revert CustomError_fb7f5079();
            } else {
                payable(address(arg0 >> 0x60)).transfer(arg1);
                require(ret0.length, CustomError_b12d13eb());
            }
        }
    }
    
    /// @custom:selector    0x744c8c09
    /// @custom:signature   Unresolved_744c8c09(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_744c8c09(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (arg2 - arg1 <= arg2) {
            if (arg0 >> 0x60) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(arg0 >> 0x60); // call
                if (success) {
                    require(ret0.length > 0x1f & 0x4e487b7100000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_fb7f5079());
                } else {
                    require(success, CustomError_fb7f5079());
                }
                return arg2 - arg1;
            } else {
                payable(address(arg0 >> 0x60)).transfer(arg1);
                if (!ret0.length) {
                    require(success, CustomError_b12d13eb());
                    return arg2 - arg1;
                }
            }
        }
    }
    
    /// @custom:selector    0x773e7756
    /// @custom:signature   Unresolved_773e7756(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_773e7756(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (arg2 * (arg1 >> 0xf0) / arg2 == arg1 >> 0xf0 | !arg2 && (arg2 * (arg1 >> 0xf0) / arg2 == arg1 >> 0xf0 | !arg2 && (arg2 * (arg1 >> 0xf0) / 0x0186a0 <= arg2 * (arg1 >> 0xf0) / 0x0186a0 + arg2 * (arg1 >> 0xf0) / 0x0186a0 && arg2 - (arg2 * (arg1 >> 0xf0) / 0x0186a0 + arg2 * (arg1 >> 0xf0) / 0x0186a0) <= arg2))) {
            if (arg0 >> 0x60) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(arg0 >> 0x60); // call
                revert CustomError_fb7f5079();
            } else {
                payable(address(arg0 >> 0x60)).transfer(arg2 * (arg1 >> 0xf0) / 0x0186a0);
                require(ret0.length, CustomError_b12d13eb());
            }
        }
    }
    
    /// @custom:selector    0x860a32ec
    /// @custom:signature   Unresolved_860a32ec(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_860a32ec(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(arg1 >> 0xe8 <= msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9, CustomError_dedc8335());
        uint256 var_c = msg.data[0x27:0x27 + (arg1 >> 0xe8)];
        if (arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0) | !(var_c >> 0xf0 & 0x8000)) {
            if (var_c >> 0xf0 & 0x4000) {
                if (!(var_c >> 0xf0 & 0x1000)) {
                    (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_a9059cbb(var_f >> 0x60); // call
                    revert CustomError_90b8ec18();
                } else {
                    bytes32 var_e = var_f >> 0x60;
                    (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                    if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                        (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                        if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                            (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_e); // call
                        }
                        revert CustomError_3e3f8f73();
                    } else {
                        require(0x01 == (0x03 & var_c >> 0xf7), CustomError_c7009900());
                        require(var_b + (arg1 >> 0xe8) + 0x20 >= var_b + 0x16 + 0x10 + 0x28 + 0x20, CustomError_31560a0e());
                        require((var_j >> 0x80) + (arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0)) <= address(this).balance, CustomError_f4d678b8());
                        payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + (arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0)));
                        if (!success) {
                            require(!(0x20 & var_c >> 0xf0));
                            if (!0) {
                                revert CustomError_2dd205a1();
                            } else {
                                revert CustomError_9a446475();
                            }
                        } else {
                            if (0 == ret0.length * !(var_c >> 0xf0 & 0x01)) {
                                require(!(var_c >> 0xf0 & 0x0200), CustomError_2dd205a1());
                                if (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] > arg0) {
                                    if (arg1 >> 0xe8 < msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9) {
                                        uint256 var_c = msg.data[0x27 + (arg1 >> 0xe8):0x27 + (arg1 >> 0xe8) + (msg.data.length - (arg1 >> 0xe8) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9)];
                                        if (!(msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] - arg0 | !(var_c >> 0xf0 & 0x8000))) {
                                            return arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0);
                                        }
                                    } else {
                                        return arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0);
                                    }
                                } else {
                                    bytes32 var_d = arg0 ^ (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] ^ arg0) * (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] < arg0);
                                    return var_d;
                                }
                            } else {
                                if ((0xe0 & var_c >> 0xec) + 0x20 > ret0.length) {
                                    revert CustomError_0310a487();
                                } else {
                                    revert CustomError_2dd205a1();
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] > arg0) {
                if (arg1 >> 0xe8 < msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9) {
                    uint256 var_c = msg.data[0x27 + (arg1 >> 0xe8):0x27 + (arg1 >> 0xe8) + (msg.data.length - (arg1 >> 0xe8) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9)];
                    if (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] - arg0 | !(var_c >> 0xf0 & 0x8000)) {
                        if (var_c >> 0xf0 & 0x4000) {
                            if (!(var_c >> 0xf0 & 0x1000)) {
                                (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_a9059cbb(var_f >> 0x60); // call
                                revert CustomError_90b8ec18();
                            } else {
                                bytes32 var_n = var_f >> 0x60;
                                (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_n); // call
                                if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                                    (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_n); // call
                                    if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                        (bool success, bytes memory ret0) = address(var_h >> 0x60).Unresolved_095ea7b3(var_n); // call
                                    }
                                    revert CustomError_3e3f8f73();
                                } else {
                                    require(0x01 == (var_c >> 0xf7 & 0x03), CustomError_c7009900());
                                    require(var_b + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_b + (msg.data.length - (arg1 >> 0xe8) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb9)), CustomError_31560a0e());
                                    require((var_j >> 0x80) + (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] - arg0) <= address(this).balance, CustomError_f4d678b8());
                                    payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + (msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] - arg0));
                                    if (!success) {
                                        require(!(0x20 & var_c >> 0xf0));
                                        if (var_c >> 0xf0 & 0x0200) {
                                            require(0, CustomError_2dd205a1());
                                            require(0 >= var_p, CustomError_9a446475());
                                        }
                                    } else {
                                        if (0 != ret0.length * !(var_c >> 0xf0 & 0x01)) {
                                            require((0xe0 & var_c >> 0xec) + 0x20 <= ret0.length, CustomError_0310a487());
                                        }
                                        require(!(var_c >> 0xf0 & 0x0200), CustomError_2dd205a1());
                                    }
                                    return 0;
                                }
                            }
                        }
                    } else {
                        return 0;
                    }
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        }
    }
    
    /// @custom:selector    0x91dd7346
    /// @custom:signature   Unresolved_91dd7346(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_91dd7346(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a) && msg.data[0x04 + arg0 + 0x20] & 0x01) {
            if (msg.data[0x04 + arg0 + 0x20] & 0x80) {
                bytes32 var_g = msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60;
                bytes32 var_p = msg.data[0x04 + arg0 + 0x20 + 0x2f] >> 0xf0;
                (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_f3cd914c(var_g); // call
                require(success);
                if (0x01 == (msg.data[0x04 + arg0 + 0x20] & 0x01)) {
                    bytes32 var_g = msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60;
                    (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_a5841194(var_g); // call
                    require(success);
                    if (0 == msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60) {
                        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).settle{ value: 0 - (0x4e487b7100000000000000000000000000000000000000000000000000000000 >> 0x80) }(); // call
                        revert();
                    } else {
                        (bool success, bytes memory ret0) = address(msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60).Unresolved_a9059cbb(0x04444c5dc75cb358380d2e3de08a90); // call
                        require(success);
                        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).settle(); // call
                        require(success);
                        bytes32 var_h = msg.data[0x04 + arg0 + 0x20 + var_p + 0x45] >> 0x60;
                        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_0b0d9c09(0 - (0x4e487b7100000000000000000000000000000000000000000000000000000000 >> 0x80)); // call
                        require(success);
                        return abi.encodePacked(0x20, var_t, var_v);
                    }
                } else {
                    (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).sync(var_h); // call
                    revert();
                }
            } else {
                bytes32 var_g = msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60;
                bytes32 var_h = msg.data[0x04 + arg0 + 0x20 + 0x15] >> 0x60;
                bytes32 var_i = msg.data[0x04 + arg0 + 0x20 + 0x29] >> 0xe8;
                bytes32 var_j = msg.data[0x04 + arg0 + 0x20 + 0x2c] >> 0xe8;
                bytes32 var_p = msg.data[0x04 + arg0 + 0x20 + 0x2f] >> 0xf0;
                (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).Unresolved_f3cd914c(var_g, var_h, var_i, var_j); // call
                if (success) {
                    if (0x01 == (msg.data[0x04 + arg0 + 0x20] & 0x01)) {
                        bytes32 var_g = msg.data[0x04 + arg0 + 0x20 + 0x01] >> 0x60;
                        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).sync(var_g); // call
                    } else {
                        (bool success, bytes memory ret0) = address(0x04444c5dc75cb358380d2e3de08a90).sync(var_h); // call
                    }
                }
                revert();
            }
        }
    }
    
    /// @custom:selector    0x98aed105
    /// @custom:signature   Unresolved_98aed105(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_98aed105(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(arg0 >> 0x60)) {
            if (arg0 >> 0x10) {
                if (uint16(arg0 >> 0x60) == 0xffff) {
                    uint256 var_b = msg.data[0x36:0x36 + uint24(arg0 >> 0x10)];
                    if (var_b >> 0xf0 & 0x4000) {
                        if (!(var_b >> 0xf0 & 0x1000)) {
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                            revert CustomError_90b8ec18();
                        } else {
                            bytes32 var_d = var_e >> 0x60;
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                            if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                }
                                revert CustomError_3e3f8f73();
                            } else {
                                require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                                require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + uint24(arg0 >> 0x10)), CustomError_31560a0e());
                                require(var_j >> 0x80 <= address(this).balance, CustomError_f4d678b8());
                                payable(address(var_k >> 0x60)).transfer(var_j >> 0x80);
                                if (!success) {
                                    require(!(0x20 & var_b >> 0xf0));
                                    if (!0) {
                                        revert CustomError_2dd205a1();
                                    } else {
                                        revert CustomError_9a446475();
                                    }
                                } else {
                                    if ((0xe0 & var_b >> 0xec) + 0x20 > ret0.length) {
                                        revert CustomError_0310a487();
                                    } else {
                                        revert CustomError_2dd205a1();
                                    }
                                }
                            }
                        }
                    }
                } else {
                    require(uint16(arg0 >> 0x60), CustomError_a6d73b28());
                    if (0) {
                        uint256 var_b = msg.data[0x36:0x36 + uint24(arg0 >> 0x10)];
                        if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0 | !(var_b >> 0xf0 & 0x8000) && var_b >> 0xf0 & 0x4000) {
                            if (!(var_b >> 0xf0 & 0x1000)) {
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                                revert CustomError_90b8ec18();
                            } else {
                                bytes32 var_d = var_e >> 0x60;
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                    if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                        (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                    }
                                    revert CustomError_3e3f8f73();
                                } else {
                                    require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                                    require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + uint24(arg0 >> 0x10)), CustomError_31560a0e());
                                    require((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0 <= address(this).balance, CustomError_f4d678b8());
                                    payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0);
                                    if (!success) {
                                        require(!(0x20 & var_b >> 0xf0));
                                        if (!0) {
                                            revert CustomError_2dd205a1();
                                        } else {
                                            revert CustomError_9a446475();
                                        }
                                    } else {
                                        require(0 != ret0.length * !(var_b >> 0xf0 & 0x01), CustomError_2dd205a1());
                                        if ((0xe0 & var_b >> 0xec) + 0x20 > ret0.length) {
                                            revert CustomError_0310a487();
                                        } else {
                                            revert CustomError_2dd205a1();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                require(!(arg0 >> 0x60), CustomError_a6d73b28());
                return 0;
            }
        }
    }
    
    /// @custom:selector    0x9df46e8c
    /// @custom:signature   Unresolved_9df46e8c(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_9df46e8c(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        (bool success, bytes memory ret0) = address(0xba1333333333a1ba1108e8412f11850a5c319ba9).Unresolved_2bfb780c(0x20); // call
        require(success);
        require(!(arg2 - arg2));
        (bool success, bytes memory ret0) = address(arg2).Unresolved_a9059cbb(0xba1333333333a1ba1108e8412f11850a5c319ba9); // call
        require(!success, CustomError_fb7f5079());
        require(success, CustomError_fb7f5079());
        (bool success, bytes memory ret0) = address(0xba1333333333a1ba1108e8412f11850a5c319ba9).Unresolved_15afd409(arg2); // call
        require(success);
        (bool success, bytes memory ret0) = address(0xba1333333333a1ba1108e8412f11850a5c319ba9).Unresolved_ae639329(arg3); // call
        require(success);
        return var_m;
    }
    
    /// @custom:selector    0xa1dab4eb
    /// @custom:signature   Unresolved_a1dab4eb(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_a1dab4eb(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0xa87a1ae8
    /// @custom:signature   Unresolved_a87a1ae8(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a87a1ae8(uint256 arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(var_a + 0x0160 < var_a | var_a + 0x0160 > 0xffffffffffffffff)) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).getOraclePrice(); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_00000000(var_p); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x08:0x08 + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x0c:0x0c + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x10:0x10 + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x14:0x14 + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x18:0x18 + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_(memory[0x1c:0x1c + 0x04]); // staticcall
            (bool success, bytes memory ret0) = address(arg0 >> 0x60)._TARGET_QUOTE_TOKEN_AMOUNT_(); // staticcall
        }
    }
    
    /// @custom:selector    0xbd46a343
    /// @custom:signature   Unresolved_bd46a343(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_bd46a343(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 >> 0xf8 & 0x40) {
            if (0x80 & arg0 >> 0xf8) {
                bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                if ((!ret0.length | ret0.length > 0x1f & var_d == 0x01) & success) {
                    (bool success, bytes memory ret0) = address(msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60).Unresolved_945bcec9{ value: !msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)] * 0x0120 }(0); // call
                    require(success);
                    return 0 - var_s;
                } else {
                    bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                    (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                    if ((!ret0.length | ret0.length > 0x1f & var_d == 0x01) & success) {
                        bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                        (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                    }
                    revert CustomError_3e3f8f73();
                }
            } else {
                bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                if ((!ret0.length | ret0.length > 0x1f & var_d == 0x01) & success) {
                    bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                    (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(var_b); // call
                }
                revert CustomError_3e3f8f73();
            }
        } else {
            (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(0xba12222222228d8ba445958a75a0704d566bf2c8); // call
            (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(0xba12222222228d8ba445958a75a0704d566bf2c8); // call
            if ((!ret0.length | ret0.length > 0x1f & var_d == 0x01) & success) {
                (bool success, bytes memory ret0) = address(msg.data[0x05 + (arg0 >> 0xf3 & 0x01e0)]).Unresolved_095ea7b3(0xba12222222228d8ba445958a75a0704d566bf2c8); // call
            }
            revert CustomError_3e3f8f73();
        }
    }
    
    /// @custom:selector    0xbdb69421
    /// @custom:signature   Unresolved_bdb69421(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_bdb69421(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        payable(address(address(this))).transfer(0);
        if (success) {
            if (!success) {
                if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]) {
                    if (address(arg0 >> 0x60)) {
                        if (address(arg0 >> 0x60) != 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee) {
                            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(address(arg0 >> 0x60)); // call
                            if (!success) {
                                require(success, CustomError_fb7f5079());
                                return 0xfb7f507900000000000000000000000000000000000000000000000000000000;
                            }
                        } else {
                            require(address(this).balance >= msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0], CustomError_f4d678b8());
                            payable(address(address(arg0 >> 0x60))).transfer(msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                            if (!ret0.length) {
                                require(success, CustomError_b12d13eb());
                                return 0xb12d13eb00000000000000000000000000000000000000000000000000000000;
                            }
                        }
                    }
                } else {
                    return 0x4e487b7100000000000000000000000000000000000000000000000000000000;
                }
            } else {
                return 0x4e487b7100000000000000000000000000000000000000000000000000000000;
            }
        } else {
            if (!success) {
                if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]) {
                    if (address(arg0 >> 0x60)) {
                        if (address(arg0 >> 0x60) != 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee) {
                            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(address(arg0 >> 0x60)); // call
                            if (success) {
                                require(ret0.length > 0x1f & 0x4e487b7100000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_fb7f5079());
                            } else {
                                require(success, CustomError_fb7f5079());
                            }
                            return 0;
                        } else {
                            require(address(this).balance >= msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0], CustomError_f4d678b8());
                            payable(address(address(arg0 >> 0x60))).transfer(msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                            if (!ret0.length) {
                                require(success, CustomError_b12d13eb());
                                return 0;
                            }
                        }
                    }
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        }
    }
    
    /// @custom:selector    0xc028b46d
    /// @custom:signature   Unresolved_c028b46d(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_c028b46d(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(arg1 >> 0x60)) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).getTradeInfo(); // staticcall
            require(success);
        } else {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).getTradeInfo(); // staticcall
            require(success);
            if (0x01 == (arg0 & 0x01)) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_022c0d9f(arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000 * var_f / (var_g + arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000)); // call
                require(success);
                require(arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000 * var_f / (var_g + arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000) >= arg0, CustomError_064a4ec6());
                return arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000 * var_f / (var_g + arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000);
            } else {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_022c0d9f(arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000 * var_g / (var_f + arg2 * (0x0de0b6b3a7640000 - var_e) / 0x0de0b6b3a7640000)); // call
                revert();
            }
        }
    }
    
    /// @custom:selector    0xc9e75c48
    /// @custom:signature   Unresolved_c9e75c48(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_c9e75c48(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(arg0 >> 0x60)) {
            if (arg0 >> 0x10) {
                if (uint16(arg0 >> 0x60) == 0xffff) {
                    uint256 var_b = msg.data[0x36:0x36 + uint24(arg0 >> 0x10)];
                    if (var_b >> 0xf0 & 0x4000) {
                        if (!(var_b >> 0xf0 & 0x1000)) {
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                            revert CustomError_90b8ec18();
                        } else {
                            bytes32 var_d = var_e >> 0x60;
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                            if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                }
                                revert CustomError_3e3f8f73();
                            } else {
                                require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                                require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + uint24(arg0 >> 0x10)), CustomError_31560a0e());
                                require(var_j >> 0x80 <= address(this).balance, CustomError_f4d678b8());
                                payable(address(var_k >> 0x60)).transfer(var_j >> 0x80);
                                if (!success) {
                                    require(!(0x20 & var_b >> 0xf0));
                                    if (!0) {
                                        revert CustomError_2dd205a1();
                                    } else {
                                        revert CustomError_9a446475();
                                    }
                                } else {
                                    if ((0xe0 & var_b >> 0xec) + 0x20 > ret0.length) {
                                        revert CustomError_0310a487();
                                    } else {
                                        revert CustomError_2dd205a1();
                                    }
                                }
                            }
                        }
                    }
                } else {
                    require(uint16(arg0 >> 0x60), CustomError_a6d73b28());
                    if (0) {
                        uint256 var_b = msg.data[0x36:0x36 + uint24(arg0 >> 0x10)];
                        if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0 | !(var_b >> 0xf0 & 0x8000) && var_b >> 0xf0 & 0x4000) {
                            if (!(var_b >> 0xf0 & 0x1000)) {
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                                revert CustomError_90b8ec18();
                            } else {
                                bytes32 var_d = var_e >> 0x60;
                                (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                    if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                        (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                                    }
                                    revert CustomError_3e3f8f73();
                                } else {
                                    require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                                    require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + uint24(arg0 >> 0x10)), CustomError_31560a0e());
                                    require((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0 <= address(this).balance, CustomError_f4d678b8());
                                    payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] * uint16(arg0 >> 0x60) / 0);
                                    if (!success) {
                                        require(!(0x20 & var_b >> 0xf0));
                                        if (!0) {
                                            revert CustomError_2dd205a1();
                                        } else {
                                            revert CustomError_9a446475();
                                        }
                                    } else {
                                        require(0 != ret0.length * !(var_b >> 0xf0 & 0x01), CustomError_2dd205a1());
                                        if ((0xe0 & var_b >> 0xec) + 0x20 > ret0.length) {
                                            revert CustomError_0310a487();
                                        } else {
                                            revert CustomError_2dd205a1();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                require(!(arg0 >> 0x60), CustomError_a6d73b28());
                return 0;
            }
        }
    }
    
    /// @custom:selector    0xcd211e1e
    /// @custom:signature   Unresolved_cd211e1e(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_cd211e1e(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg2 <= arg0) {
            return arg2;
        } else {
            if (arg2 - arg0 > arg1 >> 0x80) {
                if (arg2 && address(arg0 >> 0x60)) {
                    if (address(arg0 >> 0x60) != 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee) {
                        (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(0xb01f8f528702d411d24c9bb8cc0e2fff779ec013); // call
                        revert CustomError_fb7f5079();
                    } else {
                        require(address(this).balance >= arg2 - arg0 - (arg2 - arg0) * arg2 / arg2, CustomError_f4d678b8());
                        payable(address(0xb01f8f528702d411d24c9bb8cc0e2fff779ec013)).transfer(arg2 - arg0 - (arg2 - arg0) * arg2 / arg2);
                        if (!ret0.length) {
                            require(success, CustomError_b12d13eb());
                            return arg2 - (arg2 - arg0 - (arg2 - arg0) * arg2 / arg2);
                        }
                    }
                }
            } else {
                return arg2;
            }
        }
    }
    
    /// @custom:selector    0xceaadabb
    /// @custom:signature   Unresolved_ceaadabb(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_ceaadabb(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(0xba1333333333a1ba1108e8412f11850a5c319ba9).Unresolved_48c89491(0x20); // call
        require(success);
        return var_k;
    }
    
    /// @custom:selector    0xd6bdbf78
    /// @custom:signature   Unresolved_d6bdbf78(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_d6bdbf78(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(arg0 >> 0x60)) {
            (bool success, bytes memory ret0) = address(address(this)).Unresolved_70a08231(address(this)); // staticcall
            revert CustomError_0d6593b9();
        } else {
            bytes32 var_b = arg0 >> 0x60;
            (bool success, bytes memory ret0) = address(var_b).Unresolved_70a08231(var_b); // staticcall
            require(!(ret0.length <= 0x1f | !success), CustomError_0d6593b9());
            if (address(this) == arg0 >> 0x60) {
                if (0x0d6593b900000000000000000000000000000000000000000000000000000000) {
                    return type(uint256).max + 0x0d6593b900000000000000000000000000000000000000000000000000000000;
                } else {
                    return 0x0d6593b900000000000000000000000000000000000000000000000000000000;
                }
            } else {
                return 0x0d6593b900000000000000000000000000000000000000000000000000000000;
            }
        }
    }
    
    /// @custom:selector    0xe2e1d3c6
    /// @custom:signature   Unresolved_e2e1d3c6(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_e2e1d3c6(uint256 arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(var_g).ocean(); // staticcall
        require(success);
        (bool success, bytes memory ret0) = address(var_g).Unresolved_095ea7b3(address(0xa6ec335f00000000000000000000000000000000000000000000000000000000)); // call
        if (!success) {
            (bool success, bytes memory ret0) = address(var_g).Unresolved_095ea7b3(address(0xa6ec335f00000000000000000000000000000000000000000000000000000000)); // call
            require(!success, CustomError_19be9a90());
            require(success, CustomError_19be9a90());
            bytes32 var_a = arg1 >> 0x60;
            (bool success, bytes memory ret0) = address(var_a).Unresolved_d44f70b4(0x40); // call
            require(success);
        }
    }
    
    /// @custom:selector    0xe413f48d
    /// @custom:signature   Unresolved_e413f48d(address arg0, address arg1, address arg2, uint256 arg3) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_e413f48d(address arg0, address arg1, address arg2, uint256 arg3) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        (bool success, bytes memory ret0) = address(arg2).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0xee63c1e5
    /// @custom:signature   Unresolved_ee63c1e5(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint0)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_ee63c1e5(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint0) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg1 >> 0x60 && (arg0 & 0x40 && 0 != (arg0 & 0x20))) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_24b31a0c(arg1 >> 0x60); // call
            require(success);
            return 0 - var_h;
        }
    }
    
    /// @custom:selector    0xee777b01
    /// @custom:signature   Unresolved_ee777b01(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ee777b01(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - address(this)), CustomError_f8d8ab0e());
        if (arg1 * (arg1 >> 0xf0) / arg1 == arg1 >> 0xf0 | !arg1) {
            if (arg0 >> 0x60) {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(arg0 >> 0x60); // call
                if (success) {
                    require(ret0.length > 0x1f & 0x4e487b7100000000000000000000000000000000000000000000000000000000 == 0x01, CustomError_fb7f5079());
                } else {
                    require(success, CustomError_fb7f5079());
                }
                return arg1 - arg1 * (arg1 >> 0xf0) / 0x0186a0;
            } else {
                payable(address(arg0 >> 0x60)).transfer(arg1 * (arg1 >> 0xf0) / 0x0186a0);
                if (!ret0.length) {
                    require(success, CustomError_b12d13eb());
                    return arg1 - arg1 * (arg1 >> 0xf0) / 0x0186a0;
                }
            }
        }
    }
    
    /// @custom:selector    0xef35c31f
    /// @custom:signature   Unresolved_ef35c31f(uint256 arg0, uint248 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_ef35c31f(uint256 arg0, uint248 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        uint256 var_b = msg.data[0x18:0x18 + (msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8)];
        if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] | !(var_b >> 0xf0 & 0x8000)) {
            if (var_b >> 0xf0 & 0x4000) {
                if (!(var_b >> 0xf0 & 0x1000)) {
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                    revert CustomError_90b8ec18();
                } else {
                    bytes32 var_d = var_e >> 0x60;
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                    if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                        (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        }
                        revert CustomError_3e3f8f73();
                    } else {
                        require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                        require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8), CustomError_31560a0e());
                        require((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] <= address(this).balance, CustomError_f4d678b8());
                        payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                        if (!success) {
                            require(!(0x20 & var_b >> 0xf0));
                            if (!0) {
                                revert CustomError_2dd205a1();
                            } else {
                                revert CustomError_9a446475();
                            }
                        } else {
                            require(0 != ret0.length * !(var_b >> 0xf0 & 0x01), CustomError_2dd205a1());
                            require((0xe0 & var_b >> 0xec) + 0x20 <= ret0.length, CustomError_0310a487());
                        }
                    }
                }
            }
        } else {
            if (!(arg0 >> 0x60)) {
                return address(this).balance;
            } else {
                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
                require(success);
                require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
                return 0x3e3f8f7300000000000000000000000000000000000000000000000000000000;
            }
        }
    }
    
    /// @custom:selector    0xf2fa6b66
    /// @custom:signature   Unresolved_f2fa6b66(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_f2fa6b66(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg2 <= arg0) {
            return arg2;
        } else {
            if (arg2 - arg0 > arg1 >> 0x80) {
                if (arg2 - arg0 > arg1 >> 0x80) {
                    if (arg2 - arg0) {
                        if (address(arg0 >> 0x60)) {
                            if (address(arg0 >> 0x60) != 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee) {
                                (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_a9059cbb(0xb01f8f528702d411d24c9bb8cc0e2fff779ec013); // call
                                if (success) {
                                    require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
                                } else {
                                    require(success, CustomError_fb7f5079());
                                }
                                return arg2 - (arg2 - arg0);
                            } else {
                                require(address(this).balance >= arg2 - arg0, CustomError_f4d678b8());
                                payable(address(0xb01f8f528702d411d24c9bb8cc0e2fff779ec013)).transfer(arg2 - arg0);
                                if (!ret0.length) {
                                    require(success, CustomError_b12d13eb());
                                    return arg2 - (arg2 - arg0);
                                }
                            }
                        }
                    } else {
                        return arg2 - (arg2 - arg0);
                    }
                } else {
                    return arg2;
                }
            } else {
                return arg2;
            }
        }
    }
    
    /// @custom:selector    0xf3e98cb3
    /// @custom:signature   Unresolved_f3e98cb3(uint256 arg0, uint248 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_f3e98cb3(uint256 arg0, uint248 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        uint256 var_b = msg.data[0x18:0x18 + (msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8)];
        if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] | !(var_b >> 0xf0 & 0x8000)) {
            if (var_b >> 0xf0 & 0x4000) {
                if (!(var_b >> 0xf0 & 0x1000)) {
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_a9059cbb(var_e >> 0x60); // call
                    revert CustomError_90b8ec18();
                } else {
                    bytes32 var_d = var_e >> 0x60;
                    (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                    if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                        (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                            (bool success, bytes memory ret0) = address(var_g >> 0x60).Unresolved_095ea7b3(var_d); // call
                        }
                        revert CustomError_3e3f8f73();
                    } else {
                        require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                        require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8), CustomError_31560a0e());
                        require((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] <= address(this).balance, CustomError_f4d678b8());
                        payable(address(var_k >> 0x60)).transfer((var_j >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                        if (!success) {
                            require(!(0x20 & var_b >> 0xf0));
                            if (!0) {
                                revert CustomError_2dd205a1();
                            } else {
                                revert CustomError_9a446475();
                            }
                        } else {
                            if (0 == ret0.length * !(var_b >> 0xf0 & 0x01)) {
                                require(!(var_b >> 0xf0 & 0x0200), CustomError_2dd205a1());
                                uint256 var_h = msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0];
                                return msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0];
                            } else {
                                require((0xe0 & var_b >> 0xec) + 0x20 <= ret0.length, CustomError_0310a487());
                            }
                        }
                    }
                }
            }
        } else {
            if (!0) {
                if (!(arg0 >> 0x60)) {
                    return address(this).balance;
                } else {
                    (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
                    require(success);
                    require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
                    return var_h;
                }
            } else {
                return 0;
            }
        }
    }
    
    /// @custom:selector    0xf65ca39c
    /// @custom:signature   Unresolved_f65ca39c(uint256 arg0, uint248 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint248", "bytes31", "int248"]
    function Unresolved_f65ca39c(uint256 arg0, uint248 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 >> 0x60) {
            (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
            uint256 var_b = msg.data[0x18:0x18 + (msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8)];
            if (msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] | !(var_b >> 0xf0 & 0x8000)) {
                if (var_b >> 0xf0 & 0x4000) {
                    if (!(var_b >> 0xf0 & 0x1000)) {
                        (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_a9059cbb(var_g >> 0x60); // call
                        revert CustomError_90b8ec18();
                    } else {
                        bytes32 var_f = var_g >> 0x60;
                        (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                        if (!((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success)) {
                            (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                            if ((!ret0.length | ret0.length > 0x1f & 0x90b8ec1800000000000000000000000000000000000000000000000000000000 == 0x01) & success) {
                                (bool success, bytes memory ret0) = address(var_i >> 0x60).Unresolved_095ea7b3(var_f); // call
                            }
                            revert CustomError_3e3f8f73();
                        } else {
                            require(0x01 == (var_b >> 0xf7 & 0x03), CustomError_c7009900());
                            require(var_a + 0x16 + 0x10 + 0x28 + 0x20 <= 0x20 + (var_a + msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8), CustomError_31560a0e());
                            require((var_l >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0] <= address(this).balance, CustomError_f4d678b8());
                            payable(address(var_m >> 0x60)).transfer((var_l >> 0x80) + msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0]);
                            if (!success) {
                                require(!(0x20 & var_b >> 0xf0));
                                if (!0) {
                                    revert CustomError_2dd205a1();
                                } else {
                                    revert CustomError_9a446475();
                                }
                            } else {
                                if (0 == ret0.length * !(var_b >> 0xf0 & 0x01)) {
                                    require(!(var_b >> 0xf0 & 0x0200), CustomError_2dd205a1());
                                    uint256 var_j = msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0];
                                    return msg.data[msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0];
                                } else {
                                    require((0xe0 & var_b >> 0xec) + 0x20 <= ret0.length, CustomError_0310a487());
                                }
                            }
                        }
                    }
                }
            } else {
                if (!0) {
                    (bool success, bytes memory ret0) = address(arg0 >> 0x60).Unresolved_70a08231(address(this)); // staticcall
                    require(success);
                    require(!(ret0.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), CustomError_b11b9762());
                    if (var_j - var_j <= var_j) {
                        return 0x4e487b7100000000000000000000000000000000000000000000000000000000 - 0x4e487b7100000000000000000000000000000000000000000000000000000000;
                    }
                } else {
                    return 0;
                }
            }
        }
    }
    
    /// @custom:selector    0xfa461e33
    /// @custom:signature   Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0xfa483e72
    /// @custom:signature   Unresolved_fa483e72(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_fa483e72(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(msg.data[0x24 + arg2]).Unresolved_a9059cbb(msg.sender); // call
        if (success) {
            require(ret0.length > 0x1f & var_d == 0x01, CustomError_fb7f5079());
        } else {
            require(success, CustomError_fb7f5079());
        }
    }
    
    /// @custom:selector    0xfbb7cd06
    /// @custom:signature   Unresolved_fbb7cd06(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_fbb7cd06(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (arg0 >> 0xf8 & 0x40) {
            if (0x80 & arg0 >> 0xf8) {
                bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(var_b); // call
                if (!success) {
                    bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                    (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(var_b); // call
                    require(!success, CustomError_19be9a90());
                    require(success, CustomError_19be9a90());
                    (bool success, bytes memory ret0) = address(msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60).Unresolved_52bbbe29{ value: !(arg1 >> 0x60) * msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + msg.data.length] }(0xe0); // call
                    require(success);
                    return 0x19be9a9000000000000000000000000000000000000000000000000000000000;
                }
            } else {
                bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(var_b); // call
                if (!success) {
                    bytes32 var_b = msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffcc + msg.data.length] >> 0x60;
                    (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(var_b); // call
                    revert CustomError_19be9a90();
                }
            }
        } else {
            (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(0xba12222222228d8ba445958a75a0704d566bf2c8); // call
            if (!success) {
                (bool success, bytes memory ret0) = address(arg1 >> 0x60).Unresolved_095ea7b3(0xba12222222228d8ba445958a75a0704d566bf2c8); // call
                revert CustomError_19be9a90();
            }
        }
    }
}