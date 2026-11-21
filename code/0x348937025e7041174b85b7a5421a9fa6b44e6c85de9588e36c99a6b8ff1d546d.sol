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
    address store_j; // storage slot: 0x00
    bytes32 store_s; // storage slot: 0x00
    address store_l; // storage slot: 0x01
    bytes32 store_k; // storage slot: 0x01
    bytes32[] store_m; // storage slot: 0x02
    address public unresolved_8da5cb5b; // storage slot: 0x05
    bytes32 store_d; // storage slot: 0x06
    uint256 public ticketsBought; // storage slot: 0x07
    uint256 public buyerNumber; // storage slot: 0x08
    bytes32 store_e; // storage slot: 0x09
    bytes32 store_i; // storage slot: 0x0a
    bytes32 store_p; // storage slot: 0x0b
    bytes32 store_n; // storage slot: 0x0c
    bytes32 store_g; // storage slot: 0x0d
    bytes32 store_f; // storage slot: 0x0e
    bytes32 store_q; // storage slot: 0x0f
    address public unresolved_fc0c546a; // storage slot: 0x10
    address public unresolved_76cdb03b; // storage slot: 0x11
    address public bonus; // storage slot: 0x12
    
    mapping(uint256 => bytes32) storage_map_t; // storage slot: 0x03
    mapping(uint256 => address) storage_map_o; // storage slot: 0x13
    
    event Jackpot(address, address, uint256);
    event LedgerFailed(string);
    event Winner(address, address, uint256, uint256, uint256);
    
    /// @custom:selector    0x67dd74ca
    /// @custom:signature   buyTicket(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function buyTicket(uint256 arg0) public payable {
        require(ticketsBought <= store_d);
        if (arg0 <= store_d - ticketsBought) {
            require(ticketsBought < store_d);
        } else {
            require(ticketsBought <= store_d);
            require(store_d - ticketsBought <= arg0);
            if (arg0 - (store_d - ticketsBought)) {
                require((arg0 - (store_d - ticketsBought)) * store_e / (arg0 - (store_d - ticketsBought)) == store_e);
                payable(address(msg.sender)).transfer((arg0 - (store_d - ticketsBought)) * store_e);
                require(success);
                require(ticketsBought < store_d);
            }
        }
    }
    
    /// @custom:selector    0x0604ce27
    /// @custom:signature   jackpotChance() public view returns (uint256)
    function jackpotChance() public view returns (uint256) {
        return store_f;
    }
    
    /// @custom:selector    0x7e7fa223
    /// @custom:signature   jackpotCut() public view returns (uint256)
    function jackpotCut() public view returns (uint256) {
        return store_g;
    }
    
    /// @custom:selector    0xde3bcb97
    /// @custom:signature   takeAll() public
    function takeAll() public {
        require(msg.sender == unresolved_8da5cb5b);
        payable(address(msg.sender)).transfer(address(this).balance);
        require(success);
    }
    
    /// @custom:selector    0x3ad72714
    /// @custom:signature   ticketPool() public view returns (uint256)
    function ticketPool() public view returns (uint256) {
        return store_d;
    }
    
    /// @custom:selector    0x1209b1f6
    /// @custom:signature   Unresolved_1209b1f6() public view returns (uint256)
    function Unresolved_1209b1f6() public view returns (uint256) {
        return store_e;
    }
    
    /// @custom:selector    0x2017aa2f
    /// @custom:signature   Unresolved_2017aa2f() public view returns (uint256)
    function Unresolved_2017aa2f() public view returns (uint256) {
        return store_i;
    }
    
    /// @custom:selector    0x27dc297e
    /// @custom:signature   Unresolved_27dc297e(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_27dc297e(uint256 arg0, uint256 arg1) public {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg1):0x20 + (0x04 + arg1) + msg.data[0x04 + arg1]];
        if (memory.length < var_a && store_j != 0) {
            if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_k = address(var_g) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                require(store_l.code.length);
                (bool success, bytes memory ret0) = address(store_l).cbAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(msg.sender == address(var_g));
                if (0 < var_g && (0x01 < var_g && 0x02 < var_g)) {
                    if ((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_h / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000) {
                        if (0x45 < var_g) {
                            uint256 var_a = var_a + 0x20;
                            require(var_q >= 0x20);
                        }
                    } else {
                        if (0x01 != 0) {
                            emit LedgerFailed(0x20 + var_a - var_a, 0x08, 0x53746f7070696e67000000000000000000000000000000000000000000000000);
                        } else {
                            require(ticketsBought == store_d);
                            if (store_d) {
                                require((keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01) % store_d + 0x01 >= (keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01) % store_d);
                                buyerNumber = 0;
                                ticketsBought = 0;
                                if (store_f) {
                                    require(store_f * 0x0f4240 / store_f == 0x0f4240);
                                    require(0x64 > 0);
                                    if (store_n <= 0) {
                                        emit Winner(address(this), storage_map_o[0].field_0.field_0.field_0, store_i, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                                        payable(address(storage_map_o[0].field_0.field_0)).transfer(store_i);
                                        require(success);
                                        require(store_p + store_q >= store_p);
                                        require(store_p + store_q <= address(this).balance);
                                        require(unresolved_76cdb03b.code.length);
                                        (bool success, bytes memory ret0) = address(unresolved_76cdb03b).receiveFromGame{ gas: gasleft() - 0x25ee, value: address(this).balance - (store_p + store_q) }(); // call
                                        require(success);
                                        require(bonus.code.length);
                                        (bool success, bytes memory ret0) = address(bonus).receiveFromGame{ gas: gasleft() - 0x25ee, value: store_q }(); // call
                                        require(success);
                                    } else {
                                        emit Winner(address(this), storage_map_o[0].field_0.field_0.field_0, store_i, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                                        if (store_p) {
                                            require(store_p * store_n / store_p == store_n);
                                            require(0x64 > 0);
                                            emit Jackpot(address(this), storage_map_o[0].field_0.field_0.field_0, store_p * store_n / 0x64);
                                            if (store_p) {
                                                require(store_p * store_n / store_p == store_n);
                                                require(0x64 > 0);
                                                require(store_i + store_p * store_n / 0x64 >= store_i);
                                                payable(address(storage_map_o[0].field_0.field_0)).transfer(store_i + store_p * store_n / 0x64);
                                                require(success);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                store_s = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
                store_m = 0x01 + (var_g + var_g);
                if (var_g) {
                    store_m[0] = var_c;
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
        uint256 var_c = msg.data[0x20 + (0x04 + arg2):0x20 + (0x04 + arg2) + msg.data[0x04 + arg2]];
        if (store_j != 0) {
            if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_k = address(var_g) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                require(store_l.code.length);
                (bool success, bytes memory ret0) = address(store_l).cbAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(msg.sender == address(var_g));
                if (0 < var_g && (0x01 < var_g && 0x02 < var_g)) {
                    if ((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_h / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000) {
                        if (0x45 < var_g) {
                            uint256 var_a = var_a + 0x20;
                            require(var_g >= 0x20);
                        }
                    } else {
                        if (0x01 != 0) {
                            emit LedgerFailed(0x20 + var_a - var_a, 0x08, 0x53746f7070696e67000000000000000000000000000000000000000000000000);
                        } else {
                            require(ticketsBought == store_d);
                            if (store_d) {
                                require((keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01) % store_d + 0x01 >= (keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01) % store_d);
                                buyerNumber = 0;
                                ticketsBought = 0;
                                if (store_f) {
                                    require(store_f * 0x0f4240 / store_f == 0x0f4240);
                                    require(0x64 > 0);
                                    if (store_n <= 0) {
                                        emit Winner(address(this), storage_map_o[0].field_0.field_0.field_0, store_i, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                                        payable(address(storage_map_o[0].field_0.field_0)).transfer(store_i);
                                        require(success);
                                        require(store_p + store_q >= store_p);
                                        require(store_p + store_q <= address(this).balance);
                                        require(unresolved_76cdb03b.code.length);
                                        (bool success, bytes memory ret0) = address(unresolved_76cdb03b).receiveFromGame{ gas: gasleft() - 0x25ee, value: address(this).balance - (store_p + store_q) }(); // call
                                        require(success);
                                        require(bonus.code.length);
                                        (bool success, bytes memory ret0) = address(bonus).receiveFromGame{ gas: gasleft() - 0x25ee, value: store_q }(); // call
                                        require(success);
                                    } else {
                                        emit Winner(address(this), storage_map_o[0].field_0.field_0.field_0, store_i, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                                        if (store_p) {
                                            require(store_p * store_n / store_p == store_n);
                                            require(0x64 > 0);
                                            emit Jackpot(address(this), storage_map_o[0].field_0.field_0.field_0, store_p * store_n / 0x64);
                                            if (store_p) {
                                                require(store_p * store_n / store_p == store_n);
                                                require(0x64 > 0);
                                                require(store_i + store_p * store_n / 0x64 >= store_i);
                                                payable(address(storage_map_o[0].field_0.field_0)).transfer(store_i + store_p * store_n / 0x64);
                                                require(success);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                store_s = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
                store_m = 0x01 + (var_g + var_g);
                if (var_g) {
                    store_m[0] = var_c;
                }
            }
        }
    }
    
    /// @custom:selector    0x6b31ee01
    /// @custom:signature   Unresolved_6b31ee01() public view returns (uint256)
    function Unresolved_6b31ee01() public view returns (uint256) {
        return store_p;
    }
    
    /// @custom:selector    0x8156c6d8
    /// @custom:signature   Unresolved_8156c6d8() public view returns (uint256)
    function Unresolved_8156c6d8() public view returns (uint256) {
        return store_q;
    }
    
    /// @custom:selector    0x90c3e8bf
    /// @custom:signature   Unresolved_90c3e8bf() public view returns (uint256)
    function Unresolved_90c3e8bf() public view returns (uint256) {
        return store_n;
    }
    
    /// @custom:selector    0xcbc9023c
    /// @custom:signature   Unresolved_cbc9023c() public
    function Unresolved_cbc9023c() public {
        require(msg.sender == unresolved_8da5cb5b);
        uint256 var_a = var_a + 0x20;
        require(0x07 > 0);
        if (0 < var_k) {
            uint256 var_a = var_a + 0x40;
            if (memory.length >= var_a && store_j != 0) {
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_j.code.length);
                (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_k = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                require(store_l.code.length);
                (bool success, bytes memory ret0) = address(store_l).randomDS_getSessionPubKeyHash{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(var_k >= 0x08);
                if (0x38 >= 0x40) {
                    uint256 var_a = var_a + 0x80;
                    uint256 var_a = var_a + 0x20;
                    if (store_j != 0) {
                        require(store_j.code.length);
                        (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        require(store_j.code.length);
                        (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        store_k = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                        if (memory.length < var_a) {
                            if (!0x04) {
                                if (0 < 0x04 && (0 < var_k && (0x01 < 0x04 && (0x01 < var_k && (0x02 < 0x04 && (0x02 < var_k && (0x03 < 0x04 && 0x03 < var_k))))))) {
                                    uint256 var_a = var_a + 0x20;
                                    if (store_j != 0) {
                                        if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                                            require(store_j.code.length);
                                            (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            require(store_j.code.length);
                                            (bool success, bytes memory ret0) = address(store_j).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            store_k = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                                            uint256 var_am = 0x20 + (0x20 + (0x04 + var_a)) - (0x04 + var_a);
                                            var_an = var_k;
                                            if (0 >= var_k) {
                                                if (!(0x1f & var_k)) {
                                                    require(store_l.code.length);
                                                    (bool success, bytes memory ret0) = address(store_l).Unresolved_2ef3accc{ gas: gasleft() - 0x02c6, value: 0 }(var_am, 0x03d090); // call
                                                    require(success);
                                                    if (memory.length < var_a) {
                                                        uint256 var_a = var_a + 0x40;
                                                        if (0x01 < 0x04 && (0 < 0x04 && var_aw < 0x20)) {
                                                            bytes var_k = sha256(var_ay & ~(0x0100 ** (0x20 - var_aw) - 0x01) | var_k & 0x0100 ** (0x20 - var_aw) - 0x01);
                                                            require(memory[memory[0x40]]);
                                                            if (0x02 < 0x04) {
                                                                storage_map_t[0] = keccak256(memory[var_a:var_a + (var_bh + (0x20 + (var_be + (var_k + var_a))) - var_a)]);
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    require(store_l.code.length);
                                                    (bool success, bytes memory ret0) = address(store_l).Unresolved_00000000{ gas: gasleft() - 0x02c6, value: 0 }(var_am, var_ap / 0x0100000000000000000000000000000000000000000000000000000000, var_an, ~(0x0100 ** (0x20 - (0x1f & var_k)) - 0x01) & var_ca, var_cb); // call
                                                    require(success);
                                                }
                                            }
                                        } else {
                                            store_s = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
                                            store_m = 0x01 + (var_k + var_k);
                                            if (var_k) {
                                                store_m[0] = var_ad;
                                            }
                                        }
                                    }
                                }
                            } else {
                                uint256 var_a = var_a + 0x20;
                            }
                        }
                    }
                }
            }
        }
    }
}