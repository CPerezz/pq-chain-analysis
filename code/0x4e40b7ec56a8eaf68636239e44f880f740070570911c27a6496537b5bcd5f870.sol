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
    
    /// @custom:selector    0xc89e4361
    /// @custom:signature   delegate() public payable returns (uint256)
    function delegate() public payable returns (uint256) {
        require(0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 == msg.sender);
        (bool success, bytes memory ret0) = address(address(msg.data[0] >> 0x40)).Unresolved_(memory[0:msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe8]); // delegatecall
        require(success != 0);
        return ;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint248", "bytes31", "int248"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256) {
        if (arg2 == 0x41) {
            if (var_d >= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1) {
                return 0;
            } else {
                address var_e = ecrecover(arg0, arg5);
                if (var_e != 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21) {
                    return 0;
                } else {
                    return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                }
            }
        } else {
            if (arg2 == 0x40) {
                if ((arg4 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) >= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1) {
                    return 0;
                } else {
                    address var_e = ecrecover(arg0, 0x1b + (arg4 >> 0xff), arg4 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
                    if (var_e != 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21) {
                        return 0;
                    } else {
                        return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                    }
                }
            } else {
                return 0;
            }
        }
    }
    
    /// @custom:selector    0x1944799f
    /// @custom:signature   Unresolved_1944799f(uint256 arg0) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_1944799f(uint256 arg0) public view {
        if (msg.sender == 0xa88800cd213da5ae406ce248380802bd53b47647) {
            revert("10");
        } else {
            revert("20");
        }
    }
    
    /// @custom:selector    0x3b50d421
    /// @custom:signature   Unresolved_3b50d421(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_3b50d421(uint256 arg0, uint256 arg1) public payable {
        require(msg.sender == 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 | msg.sender == 0xd2f4eb459bd4f7b175fd0cec578229bfa3bde7 | (msg.sender == 0xd66570edcdade24edda902b28f2172e9ef8395dd | msg.sender == 0xad67d3a4fe6040ccb8ae703a443202ec6b9e4a0f) | (msg.sender == 0xc252ceec3ad24c47657638c323d96249a9f1b42a | msg.sender == 0xc47eff2d0b444001dfc2121aaf9b6d6db76af010 | (msg.sender == 0x0ff82acd0cd11bff58729e7dc9cdcdbe1fcf7a74 | msg.sender == 0xd267fda7ecbe322e64bf807de06e8e2284b72da9)), "10");
        if (0x01 && 0 < uint8(arg0 >> 0xf0)) {
            if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xec & 0x0f) == 0) {
                if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                    if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                        (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                        require(success);
                    } else {
                        uint128 var_b = uint128(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0x58);
                        (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                        revert();
                    }
                } else {
                    if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                        (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                    } else {
                        uint128 var_b = uint128(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0x58);
                        (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                    }
                    revert();
                }
            } else {
                if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xec & 0x0f) == 0x01) {
                    if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x01) == 0x01 && ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01 && ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x02) == 0x02 == 0x01 && (msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x02) == 0x02 == 0x01))) {
                        if (!uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xd8)) {
                            (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                            revert();
                        } else {
                            if (uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xd8) + 0x01 >= arg0 >> 0xf8) {
                                (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                                revert();
                            } else {
                                (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                                require(success);
                                if (0) {
                                    if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                                        require(var_m <= 0x8000000000000000000000000000000000000000000000000000000000000000 - uint128(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0x58) + 0x8000000000000000000000000000000000000000000000000000000000000000, "14");
                                    } else {
                                        require(0x08c379a000000000000000000000000000000000000000000000000000000000 <= 0x8000000000000000000000000000000000000000000000000000000000000000 - uint128(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0x58) + 0x8000000000000000000000000000000000000000000000000000000000000000, "14");
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xec & 0x0f) == 0x02) {
                        if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                            (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_a9059cbb{ value: 0 }(address(this)); // call
                            require(success != 0);
                            require(ret0.length == 0, "16");
                        }
                    } else {
                        require((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xec & 0x0f) == 0x03, "15");
                        if ((msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                            address var_b = address(msg.data[0x06 + 0x14 * (arg0 >> 0xf8) + 0x20] >> 0x38);
                            (bool success, bytes memory ret0) = address(msg.data[0x06 + uint8(msg.data[0x06 + 0x14 * (arg0 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                            require(success);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xfa461e33
    /// @custom:signature   Unresolved_fa461e33(uint256 arg0, uint256 arg1) public payable
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_fa461e33(uint256 arg0, uint256 arg1) public payable {
        require(tx.origin == 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 | tx.origin == 0xd2f4eb459bd4f7b175fd0cec578229bfa3bde7 | (tx.origin == 0xd66570edcdade24edda902b28f2172e9ef8395dd | tx.origin == 0xad67d3a4fe6040ccb8ae703a443202ec6b9e4a0f) | (tx.origin == 0xc252ceec3ad24c47657638c323d96249a9f1b42a | tx.origin == 0xc47eff2d0b444001dfc2121aaf9b6d6db76af010 | (tx.origin == 0x0ff82acd0cd11bff58729e7dc9cdcdbe1fcf7a74 | tx.origin == 0xd267fda7ecbe322e64bf807de06e8e2284b72da9)), "10");
        if (0x01 && 0 < uint8(arg4 >> 0xf0)) {
            if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xec & 0x0f) == 0) {
                if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                    if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                        require(success);
                    } else {
                        uint128 var_b = uint128(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0x58);
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                        revert();
                    }
                } else {
                    if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                    } else {
                        uint128 var_b = uint128(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0x58);
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                    }
                    revert();
                }
            } else {
                if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xec & 0x0f) == 0x01) {
                    if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x01) == 0x01 && ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01 && ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x02) == 0x02 == 0x01 && (msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x02) == 0x02 == 0x01))) {
                        if (!uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xd8)) {
                            (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                            revert();
                        } else {
                            if (uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xd8) + 0x01 >= arg4 >> 0xf8) {
                                (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                                revert();
                            } else {
                                (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                                require(success);
                                if (0) {
                                    if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x04) == 0x04 == 0x01) {
                                        require(var_m <= 0x8000000000000000000000000000000000000000000000000000000000000000 - uint128(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0x58) + 0x8000000000000000000000000000000000000000000000000000000000000000, "14");
                                    } else {
                                        require(0x08c379a000000000000000000000000000000000000000000000000000000000 <= 0x8000000000000000000000000000000000000000000000000000000000000000 - uint128(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0x58) + 0x8000000000000000000000000000000000000000000000000000000000000000, "14");
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xec & 0x0f) == 0x02) {
                        if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                            (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_a9059cbb{ value: 0 }(address(this)); // call
                            require(success != 0);
                            require(ret0.length == 0, "16");
                        }
                    } else {
                        require((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xec & 0x0f) == 0x03, "15");
                        if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8 & 0x01) == 0x01) {
                            address var_b = address(msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x20] >> 0x38);
                            (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe0) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_b); // call
                            require(success);
                        }
                    }
                }
            }
        }
    }
}