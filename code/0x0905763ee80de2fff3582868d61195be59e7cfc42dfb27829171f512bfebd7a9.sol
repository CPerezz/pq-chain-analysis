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
    address store_c; // storage slot: 0x00
    bytes32 store_b; // storage slot: 0x00
    address store_a; // storage slot: 0x01
    bytes32 store_e; // storage slot: 0x01
    uint256[] store_f; // storage slot: 0x02
    address store_h; // storage slot: 0x05
    address store_g; // storage slot: 0x06
    
    mapping(uint256 => bytes32) storage_map_d; // storage slot: 0x03
    
    
    /// @custom:selector    0x205282f0
    /// @custom:signature   doCall() public
    function doCall() public {
        require(0x07 > 0);
        require(0x01 <= 0xffffffffffffffff);
        if (0 < var_c) {
            require(0x20 <= 0xffffffffffffffff);
            require(0x20 <= 0xffffffffffffffff);
            if (store_a != 0) {
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                store_b = address(var_c) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
                require(store_c.code.length);
                (bool success, bytes memory ret0) = address(store_c).randomDS_getSessionPubKeyHash(); // staticcall
                require(success);
                require(ret0.length >= 0x20);
                require(0x20 <= 0xffffffffffffffff);
                require(0x08 <= 0xffffffffffffffff);
                require(var_c >= 0x08);
                if (0x38 >= 0x40) {
                    uint256 var_b = 0x80 + var_b;
                    if (store_a != 0) {
                        require(store_a.code.length);
                        (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                        require(success);
                        require(ret0.length >= 0x20);
                        require(store_a.code.length);
                        (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                        require(success);
                        require(ret0.length >= 0x20);
                        store_b = address(var_c) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
                        require(0x04 <= 0xffffffffffffffff);
                        uint256 var_b = var_b + 0xa0;
                        if (!0x04 && (0 < 0x04 && (0 < var_c && (0x01 < 0x04 && (0x01 < var_c && (0x02 < 0x04 && (0x02 < var_c && (0x03 < 0x04 && (0x03 < var_c && store_a != 0))))))))) {
                            if (address(0xa2998efd205fb9d4b4963afb70778d6354ad3a41).code.length <= 0) {
                                require(store_a.code.length);
                                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                                require(success);
                                require(ret0.length >= 0x20);
                                require(store_a.code.length);
                                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                                require(success);
                                require(ret0.length >= 0x20);
                                store_b = address(var_c) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
                                uint256 var_ac = 0x20 + (0x20 + (0x04 + var_b)) - (0x04 + var_b);
                                if (0 >= var_c) {
                                    if (!(0x1f & var_c)) {
                                        require(store_c.code.length);
                                        (bool success, bytes memory ret0) = address(store_c).Unresolved_2ef3accc{ value: 0 }(var_ac); // call
                                        require(success);
                                        require(ret0.length >= 0x20);
                                        if (var_c > 0x0de0b6b3a7640000 + tx.gasprice * 0x030d40) {
                                            require(0x08 <= 0xffffffffffffffff);
                                            uint256 var_b = var_b + 0x40;
                                            if (0x01 < 0x04 && (0 < 0x04 && var_am < 0x20)) {
                                                bytes var_c = sha256(var_ao & ~(0x0100 ** (0x20 - var_am) - 0x01) | var_c & 0x0100 ** (0x20 - var_am) - 0x01);
                                                require(memory[0x20]);
                                                require(ret0.length >= 0x20);
                                                if (0x02 < 0x04) {
                                                    uint256 var_b = var_az + (0x20 + (var_aw + (var_c + (0x20 + var_b))));
                                                    storage_map_d[0] = keccak256(memory[0x20 + var_b:0x20 + var_b + var_c]);
                                                }
                                            }
                                        }
                                    } else {
                                        require(store_c.code.length);
                                    }
                                }
                            } else {
                                store_e = 0xa2998efd205fb9d4b4963afb70778d6354ad3a41 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
                                store_f = 0x01 + (var_c + var_c);
                                if (var_c) {
                                    store_f[0] = var_v;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x27dc297e
    /// @custom:signature   Unresolved_27dc297e(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_27dc297e(uint256 arg0, uint256 arg1) public {
        require(arg1 <= 0x0100000000);
        require(0x04 + arg1 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg1] > 0x0100000000 | 0x20 + (0x04 + arg1) + msg.data[0x04 + arg1] > 0x04 + (msg.data.length - 0x04)));
        require(0 <= 0xffffffffffffffff);
        var_c = msg.data[msg.data.length:msg.data.length];
        if (store_a != 0) {
            if (address(0xa2998efd205fb9d4b4963afb70778d6354ad3a41).code.length <= 0) {
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                store_b = address(var_f) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
                require(store_c.code.length);
                (bool success, bytes memory ret0) = address(store_c).cbAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                require(msg.sender == address(var_f));
                if (0 < var_f && (0x01 < var_f && (0x02 < var_f && 0x45 < var_f))) {
                    require(0x20 <= 0xffffffffffffffff);
                    uint256 var_a = var_a + 0x40;
                    require(var_f >= 0x20);
                    if (0x20 + (0x44 + (uint8(var_i >> 0xf8 << 0xf8 >> 0xf8) + 0x02) + 0x20) >= 0x20 + (0x44 + (uint8(var_i >> 0xf8 << 0xf8 >> 0xf8) + 0x02) + 0x20) + 0x20) {
                        uint256 var_a = 0x20 + (var_f + (0x20 + var_a));
                        if (var_f < 0x20) {
                            bytes var_f = sha256(var_c & ~(0x0100 ** (0x20 - var_f) - 0x01) | var_f & 0x0100 ** (0x20 - var_f) - 0x01);
                            require(memory[0x20]);
                            require(ret0.length >= 0x20);
                            uint256 var_a = 0x20 + (0x20 + var_a);
                            uint256 var_a = var_f + (0x20 + var_a);
                            uint256 var_a = var_f + (0x20 + var_a);
                            if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000 <= address(this).balance) {
                                if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x02 != 0) {
                                    if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x02 == 0x01) {
                                        payable(address(store_g)).transfer(keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000);
                                        require(success);
                                    }
                                } else {
                                    payable(address(store_h)).transfer(keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000);
                                    revert();
                                }
                            }
                        }
                    }
                }
            } else {
                store_e = 0xa2998efd205fb9d4b4963afb70778d6354ad3a41 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
                store_f = 0x01 + (var_f + var_f);
                if (var_f) {
                    store_f[0] = var_c;
                }
            }
        }
    }
    
    /// @custom:selector    0x38bbfa50
    /// @custom:signature   Unresolved_38bbfa50(uint256 arg0, uint256 arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_38bbfa50(uint256 arg0, uint256 arg1, uint256 arg2) public {
        require(arg1 <= 0x0100000000);
        require(0x04 + arg1 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg1] > 0x0100000000 | 0x20 + (0x04 + arg1) + msg.data[0x04 + arg1] > 0x04 + (msg.data.length - 0x04)));
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_c = msg.data[0x20 + (0x04 + arg2):0x20 + (0x04 + arg2) + msg.data[0x04 + arg2]];
        if (store_a != 0) {
            if (address(0xa2998efd205fb9d4b4963afb70778d6354ad3a41).code.length <= 0) {
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                require(store_a.code.length);
                (bool success, bytes memory ret0) = address(store_a).getAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                store_b = address(var_f) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
                require(store_c.code.length);
                (bool success, bytes memory ret0) = address(store_c).cbAddress{ value: 0 }(); // call
                require(success);
                require(ret0.length >= 0x20);
                require(msg.sender == address(var_f));
                if (0 < var_f && (0x01 < var_f && (0x02 < var_f && 0x45 < var_f))) {
                    require(0x20 <= 0xffffffffffffffff);
                    uint256 var_a = var_a + 0x40;
                    require(var_f >= 0x20);
                    if (0x20 + (0x44 + (uint8(var_i >> 0xf8 << 0xf8 >> 0xf8) + 0x02) + 0x20) >= 0x20 + (0x44 + (uint8(var_i >> 0xf8 << 0xf8 >> 0xf8) + 0x02) + 0x20) + 0x20) {
                        uint256 var_a = 0x20 + (var_f + (0x20 + var_a));
                        if (var_f < 0x20) {
                            bytes var_f = sha256(var_c & ~(0x0100 ** (0x20 - var_f) - 0x01) | var_f & 0x0100 ** (0x20 - var_f) - 0x01);
                            require(memory[0x20]);
                            require(ret0.length >= 0x20);
                            uint256 var_a = 0x20 + (0x20 + var_a);
                            uint256 var_a = var_f + (0x20 + var_a);
                            uint256 var_a = var_f + (0x20 + var_a);
                            if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000 <= address(this).balance) {
                                if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x02 != 0) {
                                    if (keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x02 == 0x01) {
                                        payable(address(store_g)).transfer(keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000);
                                        require(success);
                                    }
                                } else {
                                    payable(address(store_h)).transfer(keccak256(memory[0x20 + var_a:0x20 + var_a + var_f]) % 0x0de0b6b3a7640000);
                                    revert();
                                }
                            }
                        }
                    }
                }
            } else {
                store_e = 0xa2998efd205fb9d4b4963afb70778d6354ad3a41 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
                store_f = 0x01 + (var_f + var_f);
                if (var_f) {
                    store_f[0] = var_c;
                }
            }
        }
    }
}