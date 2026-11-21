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
    string public constant unresolved_06fdde03 = "BULLSHITTOKEN";
    uint256 public constant unresolved_313ce567 = 18;
    string public constant unresolved_95d89b41 = "BULLSHIT";
    
    address store_e; // storage slot: 0x00
    bytes32 store_i; // storage slot: 0x00
    address store_g; // storage slot: 0x01
    bytes32 store_f; // storage slot: 0x01
    uint256[] store_j; // storage slot: 0x02
    bytes32 store_n; // storage slot: 0x05
    address public unresolved_8da5cb5b; // storage slot: 0x08
    uint256 store_k; // storage slot: 0x0b
    uint256 store_o; // storage slot: 0x0c
    
    mapping(uint256 => bytes32) storage_map_h; // storage slot: 0x03
    mapping(address => uint256) public unresolved_70a08231; // storage slot: 0x06
    mapping(address => mapping(address => bytes32)) storage_map_d; // storage slot: 0x07
    mapping(bytes32 => bytes32) storage_map_l; // storage slot: 0x09
    mapping(bytes32 => uint256) storage_map_m; // storage slot: 0x0a
    mapping(address => bytes32) storage_map_a; // storage slot: 0x0d
    mapping(address => uint256) storage_map_p; // storage slot: 0x0e
    
    event EthReceived(address, uint256);
    event Event_8c5be1e5();
    event Transfer(address, address, uint256);
    event Winner(address, address, uint256, uint256, uint256);
    
    /// @custom:selector    0xded2d0f4
    /// @custom:signature   awardToken(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function awardToken(address arg0, uint256 arg1) public {
        require(storage_map_a[msg.sender].field_0);
        if (address(this).balance >= 0x06f05b59d3b2000000) {
            if (address(this).balance >= 0x0de0b6b3a764000000) {
                if (address(this).balance >= 0x1bc16d674ec8000000) {
                    require(storage_map_a[msg.sender].field_0);
                    require(arg0 != 0);
                    require(unresolved_70a08231[unresolved_8da5cb5b] * arg1 * 0xe8d4a51000 <= unresolved_70a08231[unresolved_8da5cb5b]);
                    unresolved_70a08231[unresolved_8da5cb5b] -= unresolved_70a08231[unresolved_8da5cb5b] * arg1 * 0xe8d4a51000;
                    require(storage_map_d[unresolved_8da5cb5b][msg.sender] * arg1 * 0xe8d4a51000 <= storage_map_d[unresolved_8da5cb5b][msg.sender]);
                    storage_map_d[unresolved_8da5cb5b][msg.sender] -= storage_map_d[unresolved_8da5cb5b][msg.sender] * arg1 * 0xe8d4a51000;
                    require(unresolved_70a08231[arg0] + unresolved_70a08231[arg0] * arg1 * 0xe8d4a51000 >= unresolved_70a08231[arg0]);
                    unresolved_70a08231[arg0] += unresolved_70a08231[arg0] * arg1 * 0xe8d4a51000;
                    emit Transfer(unresolved_8da5cb5b, arg0, unresolved_70a08231[arg0] * arg1 * 0xe8d4a51000);
                } else {
                    require(storage_map_a[msg.sender].field_0);
                    require(arg0 != 0);
                }
            } else {
                require(storage_map_a[msg.sender].field_0);
                require(arg0 != 0);
            }
        } else {
            require(storage_map_a[msg.sender].field_0);
            require(arg0 != 0);
        }
    }
    
    /// @custom:selector    0xaacc5a17
    /// @custom:signature   getRandom() public payable
    function getRandom() public payable {
        uint256 var_a = var_a + 0x20;
        require(0x07 > 0);
        if (0 < var_k) {
            uint256 var_a = var_a + 0x40;
            if (memory.length >= var_a && store_e != 0) {
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_f = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                require(store_g.code.length);
                (bool success, bytes memory ret0) = address(store_g).randomDS_getSessionPubKeyHash{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(var_k >= 0x08);
                if (0x38 >= 0x40) {
                    uint256 var_a = var_a + 0x80;
                    uint256 var_a = var_a + 0x20;
                    if (store_e != 0) {
                        require(store_e.code.length);
                        (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        require(store_e.code.length);
                        (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        store_f = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                        if (memory.length < var_a) {
                            if (!0x04) {
                                if (0 < 0x04 && (0 < var_k && (0x01 < 0x04 && (0x01 < var_k && (0x02 < 0x04 && (0x02 < var_k && (0x03 < 0x04 && 0x03 < var_k))))))) {
                                    uint256 var_a = var_a + 0x20;
                                    if (store_e != 0) {
                                        if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                                            require(store_e.code.length);
                                            (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            require(store_e.code.length);
                                            (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            store_f = address(var_k) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                                            uint256 var_am = 0x20 + (0x20 + (0x04 + var_a)) - (0x04 + var_a);
                                            var_an = var_k;
                                            if (0 >= var_k) {
                                                if (!(0x1f & var_k)) {
                                                    require(store_g.code.length);
                                                    (bool success, bytes memory ret0) = address(store_g).Unresolved_2ef3accc{ gas: gasleft() - 0x02c6, value: 0 }(var_am, 0x0493e0); // call
                                                    require(success);
                                                    if (memory.length < var_a) {
                                                        uint256 var_a = var_a + 0x40;
                                                        if (0x01 < 0x04 && (0 < 0x04 && var_aw < 0x20)) {
                                                            bytes var_k = sha256(var_ay & ~(0x0100 ** (0x20 - var_aw) - 0x01) | var_k & 0x0100 ** (0x20 - var_aw) - 0x01);
                                                            require(memory[memory[0x40]]);
                                                            if (0x02 < 0x04) {
                                                                storage_map_h[0] = keccak256(memory[var_a:var_a + (var_bh + (0x20 + (var_be + (var_k + var_a))) - var_a)]);
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    require(store_g.code.length);
                                                    (bool success, bytes memory ret0) = address(store_g).Unresolved_00000000{ gas: gasleft() - 0x02c6, value: 0 }(var_am, var_ap / 0x0100000000000000000000000000000000000000000000000000000000, var_an, ~(0x0100 ** (0x20 - (0x1f & var_k)) - 0x01) & var_ca, var_cb); // call
                                                    require(success);
                                                }
                                            }
                                        } else {
                                            store_i = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                                            store_j = 0x01 + (var_k + var_k);
                                            if (var_k) {
                                                store_j[0] = var_ad;
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
    
    /// @custom:selector    0x386304e4
    /// @custom:signature   receiveFromGame() public view
    function receiveFromGame() public view {
        emit EthReceived(msg.sender, msg.value);
    }
    
    /// @custom:selector    0x1f7b4f30
    /// @custom:signature   roll(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function roll(uint256 arg0) public {
        require(arg0 == 0x0a);
        require(unresolved_70a08231[msg.sender] >= arg0 * 0x0de0b6b3a7640000);
        storage_map_l[store_k] = msg.sender | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_l[store_k];
        storage_map_m[store_k] = arg0;
        store_k += 0x01;
        require(unresolved_8da5cb5b != 0);
        require(arg0 * 0x0de0b6b3a7640000 <= unresolved_70a08231[msg.sender]);
        unresolved_70a08231[msg.sender] -= arg0 * 0x0de0b6b3a7640000;
        require(unresolved_70a08231[unresolved_8da5cb5b] + arg0 * 0x0de0b6b3a7640000 >= unresolved_70a08231[unresolved_8da5cb5b]);
        unresolved_70a08231[unresolved_8da5cb5b] += arg0 * 0x0de0b6b3a7640000;
        emit Transfer(msg.sender, unresolved_8da5cb5b, arg0 * 0x0de0b6b3a7640000);
        uint256 var_d = var_d + 0x20;
        require(0x07 > 0);
        if (0 < var_m) {
            uint256 var_d = var_d + 0x40;
            if (memory.length >= var_d && store_e != 0) {
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_f = address(var_m) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                require(store_g.code.length);
                (bool success, bytes memory ret0) = address(store_g).randomDS_getSessionPubKeyHash{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(var_m >= 0x08);
                if (0x38 >= 0x40) {
                    uint256 var_d = var_d + 0x80;
                    uint256 var_d = var_d + 0x20;
                    if (store_e != 0) {
                        require(store_e.code.length);
                        (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        require(store_e.code.length);
                        (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        require(success);
                        store_f = address(var_m) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                        if (memory.length < var_d) {
                            if (!0x04) {
                                if (0 < 0x04 && (0 < var_m && (0x01 < 0x04 && (0x01 < var_m && (0x02 < 0x04 && (0x02 < var_m && (0x03 < 0x04 && 0x03 < var_m))))))) {
                                    uint256 var_d = var_d + 0x20;
                                    if (store_e != 0) {
                                        if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                                            require(store_e.code.length);
                                            (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            require(store_e.code.length);
                                            (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                            require(success);
                                            store_f = address(var_m) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                                            uint256 var_ao = 0x20 + (0x20 + (0x04 + var_d)) - (0x04 + var_d);
                                            var_ap = var_m;
                                            if (0 >= var_m) {
                                                if (!(0x1f & var_m)) {
                                                    require(store_g.code.length);
                                                    (bool success, bytes memory ret0) = address(store_g).Unresolved_2ef3accc{ gas: gasleft() - 0x02c6, value: 0 }(var_ao, 0x0493e0); // call
                                                    require(success);
                                                    if (memory.length < var_d) {
                                                        uint256 var_d = var_d + 0x40;
                                                        if (0x01 < 0x04 && (0 < 0x04 && var_ay < 0x20)) {
                                                            bytes var_m = sha256(var_ba & ~(0x0100 ** (0x20 - var_ay) - 0x01) | var_m & 0x0100 ** (0x20 - var_ay) - 0x01);
                                                            require(memory[memory[0x40]]);
                                                            if (0x02 < 0x04) {
                                                                storage_map_h[0] = keccak256(memory[var_d:var_d + (var_bj + (0x20 + (var_bg + (var_m + var_d))) - var_d)]);
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    require(store_g.code.length);
                                                    (bool success, bytes memory ret0) = address(store_g).Unresolved_00000000{ gas: gasleft() - 0x02c6, value: 0 }(var_ao, var_ar / 0x0100000000000000000000000000000000000000000000000000000000, var_ap, ~(0x0100 ** (0x20 - (0x1f & var_m)) - 0x01) & var_ca, var_cb); // call
                                                    require(success);
                                                }
                                            }
                                        } else {
                                            store_i = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                                            store_j = 0x01 + (var_m + var_m);
                                            if (var_m) {
                                                store_j[0] = var_af;
                                            }
                                        }
                                    }
                                }
                            } else {
                                uint256 var_d = var_d + 0x20;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xde3bcb97
    /// @custom:signature   takeAll() public
    function takeAll() public {
        require(msg.sender == unresolved_8da5cb5b);
        payable(address(msg.sender)).transfer(address(this).balance);
        require(success);
    }
    
    /// @custom:selector    0x095ea7b3
    /// @custom:signature   Unresolved_095ea7b3(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_095ea7b3(address arg0, uint256 arg1) public returns (bool) {
        storage_map_d[msg.sender][arg0] = arg1;
        emit Event_8c5be1e5(msg.sender, arg0, arg1);
        return true;
    }
    
    /// @custom:selector    0x18160ddd
    /// @custom:signature   Unresolved_18160ddd() public view returns (uint256)
    function Unresolved_18160ddd() public view returns (uint256) {
        return store_n - unresolved_70a08231[0];
    }
    
    /// @custom:selector    0x23b872dd
    /// @custom:signature   Unresolved_23b872dd(address arg0, address arg1, uint256 arg2) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_23b872dd(address arg0, address arg1, uint256 arg2) public returns (bool) {
        require(arg1 != 0);
        require(arg2 <= unresolved_70a08231[arg0]);
        unresolved_70a08231[arg0] -= arg2;
        require(arg2 <= storage_map_d[arg0][msg.sender]);
        storage_map_d[arg0][msg.sender] -= arg2;
        require(unresolved_70a08231[arg1] + arg2 >= unresolved_70a08231[arg1]);
        unresolved_70a08231[arg1] += arg2;
        emit Transfer(arg0, arg1, arg2);
        return true;
    }
    
    /// @custom:selector    0x27dc297e
    /// @custom:signature   Unresolved_27dc297e(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_27dc297e(uint256 arg0, uint256 arg1) public {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg1):0x20 + (0x04 + arg1) + msg.data[0x04 + arg1]];
        if (memory.length < var_a && store_e != 0) {
            if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_f = address(var_g) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                require(store_g.code.length);
                (bool success, bytes memory ret0) = address(store_g).cbAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(msg.sender == address(var_g));
                if (0 < var_g && (0x01 < var_g && 0x02 < var_g)) {
                    if ((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_h / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000) {
                        if (0x45 < var_g) {
                            uint256 var_a = var_a + 0x20;
                            require(var_q >= 0x20);
                        }
                    } else {
                        require(0x01 == 0);
                        storage_map_l[store_o] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_l[store_o];
                        storage_map_m[store_o] = 0;
                        store_o += 0x01;
                        if (keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01 <= storage_map_m[store_o]) {
                            emit Winner(address(this), storage_map_m[store_o].field_0.field_0.field_0, address(this).balance, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                            require(0x02 > 0);
                            payable(address(storage_map_m[store_o].field_0.field_0)).transfer(address(this).balance / 0x02);
                            require(success);
                        }
                    }
                }
            } else {
                store_i = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                store_j = 0x01 + (var_g + var_g);
                if (var_g) {
                    store_j[0] = var_c;
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
        if (store_e != 0) {
            if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(store_e.code.length);
                (bool success, bytes memory ret0) = address(store_e).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                store_f = address(var_g) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                require(store_g.code.length);
                (bool success, bytes memory ret0) = address(store_g).cbAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                require(success);
                require(msg.sender == address(var_g));
                if (0 < var_g && (0x01 < var_g && 0x02 < var_g)) {
                    if ((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_h / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000) {
                        if (0x45 < var_g) {
                            uint256 var_a = var_a + 0x20;
                            require(var_g >= 0x20);
                        }
                    } else {
                        require(0x01 == 0);
                        storage_map_l[store_o] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_l[store_o];
                        storage_map_m[store_o] = 0;
                        store_o += 0x01;
                        if (keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01 <= storage_map_m[store_o]) {
                            emit Winner(address(this), storage_map_m[store_o].field_0.field_0.field_0, address(this).balance, keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]) % 0x0f4240 + 0x01, 0);
                            require(0x02 > 0);
                            payable(address(storage_map_m[store_o].field_0.field_0)).transfer(address(this).balance / 0x02);
                            require(success);
                        }
                    }
                }
            } else {
                store_i = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                store_j = 0x01 + (var_g + var_g);
                if (var_g) {
                    store_j[0] = var_c;
                }
            }
        }
    }
    
    /// @custom:selector    0x5dce431b
    /// @custom:signature   Unresolved_5dce431b(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_5dce431b(address arg0, uint256 arg1) public {
        require(msg.sender == unresolved_8da5cb5b);
        require(arg0 != 0);
        storage_map_a[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        storage_map_p[arg0] = arg1;
        storage_map_d[msg.sender][arg0] = store_n;
        emit Event_8c5be1e5(msg.sender, arg0, store_n);
    }
    
    /// @custom:selector    0xa9059cbb
    /// @custom:signature   Unresolved_a9059cbb(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a9059cbb(address arg0, uint256 arg1) public returns (bool) {
        require(arg0 != 0);
        require(arg1 <= unresolved_70a08231[msg.sender]);
        unresolved_70a08231[msg.sender] -= arg1;
        require(unresolved_70a08231[arg0] + arg1 >= unresolved_70a08231[arg0]);
        unresolved_70a08231[arg0] += arg1;
        emit Transfer(msg.sender, arg0, arg1);
        return true;
    }
    
    /// @custom:selector    0xdd62ed3e
    /// @custom:signature   Unresolved_dd62ed3e(address arg0, address arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_dd62ed3e(address arg0, address arg1) public view returns (uint256) {
        return storage_map_d[arg0][arg1];
    }
}