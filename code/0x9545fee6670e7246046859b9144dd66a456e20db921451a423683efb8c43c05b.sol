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
    uint256 public constant LIMIT_AMOUNT_BETS = 100;
    
    address store_g; // storage slot: 0x00
    bytes32 store_k; // storage slot: 0x00
    address store_i; // storage slot: 0x01
    bytes32 store_h; // storage slot: 0x01
    bytes32[] store_l; // storage slot: 0x02
    bytes32 store_d; // storage slot: 0x06
    uint256 public unresolved_fe5e1853; // storage slot: 0x07
    uint256 public numberOfBets; // storage slot: 0x08
    bytes32 store_b; // storage slot: 0x09
    bytes32 store_m; // storage slot: 0x0a
    address[] public unresolved_f71d96cb; // storage slot: 0x0b
    
    mapping(uint256 => bytes32) storage_map_j; // storage slot: 0x03
    mapping(uint256 => bytes32) storage_map_c; // storage slot: 0x0c
    mapping(address => uint256) storage_map_e; // storage slot: 0x0d
    
    
    /// @custom:selector    0x7365870b
    /// @custom:signature   bet(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function bet(uint256 arg0) public payable {
        if (numberOfBets < store_b && storage_map_c[arg0].field_0.field_0 != 0 && (0x01 == 0 && arg0 >= 0x01 && (arg0 <= 0x0b && msg.value >= store_d))) {
            storage_map_e[msg.sender] = arg0;
            storage_map_c[arg0] = msg.sender | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_c[arg0];
            numberOfBets += 0x01;
            unresolved_fe5e1853 += msg.value;
            if (numberOfBets >= store_b && numberOfBets >= store_b) {
                uint256 var_c = var_c + 0x20;
                require(0x07 != 0);
                if (0 < var_j) {
                    uint256 var_c = var_c + 0x0420;
                    if (memory.length >= var_c && (store_g != 0 && store_g.code.length)) {
                        (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                        if (success) {
                            store_h = address(var_j) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                            if (store_i.code.length) {
                                (bool success, bytes memory ret0) = address(store_i).randomDS_getSessionPubKeyHash{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                if (success) {
                                    uint256 var_c = var_c + 0x60;
                                    uint256 var_c = var_c + 0x20;
                                    if (store_g != 0 && store_g.code.length) {
                                        (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                        if (success) {
                                            store_h = address(var_j) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                                            if (memory.length < var_c) {
                                                if (!0x03) {
                                                    if (0 < 0x03 && (0 < var_j && (0x01 < 0x03 && (0x01 < var_j && (0x02 < 0x03 && 0x02 < var_j))))) {
                                                        uint256 var_c = var_c + 0x20;
                                                        if (store_g != 0) {
                                                            if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                                                                if (store_g.code.length) {
                                                                    (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                                                    if (success) {
                                                                        store_h = address(var_j) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                                                                        uint256 var_af = 0x20 + (0x20 + (0x04 + var_c)) - (0x04 + var_c);
                                                                        if (var_j == 0) {
                                                                            if (!(0x1f & var_j)) {
                                                                                if (store_i.code.length) {
                                                                                    (bool success, bytes memory ret0) = address(store_i).Unresolved_2ef3accc{ gas: gasleft() - 0x02c6, value: 0 }(var_af, 0x030d40); // call
                                                                                    if (success && (0x01 < 0x03 && (0 < 0x03 && var_ah < 0x20))) {
                                                                                        bytes var_j = sha256(var_ai & ~(0x0100 ** (0x20 - var_ah) - 0x01) | var_j & 0x0100 ** (0x20 - var_ah) - 0x01);
                                                                                        if (memory[memory[0x40]] && 0x02 < 0x03) {
                                                                                            storage_map_j[0] = keccak256(memory[var_c:var_c + (var_aq + (0x20 + (var_an + (0x08 + var_c))) - var_c)]);
                                                                                        }
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                if (store_i.code.length) {
                                                                                    (bool success, bytes memory ret0) = address(store_i).Unresolved_00000000{ gas: gasleft() - 0x02c6, value: 0 }(var_af, 0x030d40); // call
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            } else {
                                                                store_k = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                                                                store_l = 0x01 + (var_j + var_j);
                                                                if (var_j) {
                                                                    store_l[0] = var_y;
                                                                }
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    uint256 var_c = var_c + 0x20;
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
    }
    
    /// @custom:selector    0x7ac482c7
    /// @custom:signature   checkNumberExists(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function checkNumberExists(uint256 arg0) public view returns (bool) {
        if (!msg.value) {
            if (storage_map_c[arg0].field_0.field_0 == 0) {
                return false;
            } else {
                return true;
            }
        }
    }
    
    /// @custom:selector    0x7ce52eb6
    /// @custom:signature   distributePrizes() public
    function distributePrizes() public {
        if (!msg.value && numberOfBets >= store_b) {
            payable(address(storage_map_c[store_m].field_0.field_0)).transfer(unresolved_fe5e1853);
            if (success) {
                unresolved_fe5e1853 = 0;
                numberOfBets = 0;
            }
        }
    }
    
    /// @custom:selector    0x567990d3
    /// @custom:signature   fixedBet() public view returns (uint256)
    function fixedBet() public view returns (uint256) {
        if (!msg.value) {
            return store_d;
        }
    }
    
    /// @custom:selector    0x0a50e361
    /// @custom:signature   generateNumberWinner() public payable
    function generateNumberWinner() public payable {
        if (numberOfBets >= store_b) {
            uint256 var_a = var_a + 0x20;
            require(0x07 != 0);
            if (0 < var_h) {
                uint256 var_a = var_a + 0x0420;
                if (memory.length >= var_a && (store_g != 0 && store_g.code.length)) {
                    (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                    if (success) {
                        store_h = address(var_h) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                        if (store_i.code.length) {
                            (bool success, bytes memory ret0) = address(store_i).randomDS_getSessionPubKeyHash{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                            if (success) {
                                uint256 var_a = var_a + 0x60;
                                uint256 var_a = var_a + 0x20;
                                if (store_g != 0 && store_g.code.length) {
                                    (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                    if (success) {
                                        store_h = address(var_h) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                                        if (memory.length < var_a) {
                                            if (!0x03) {
                                                if (0 < 0x03 && (0 < var_h && (0x01 < 0x03 && (0x01 < var_h && (0x02 < 0x03 && 0x02 < var_h))))) {
                                                    uint256 var_a = var_a + 0x20;
                                                    if (store_g != 0) {
                                                        if (address(0x146500cfd35b22e4a392fe0adc06de1a1368ed48).code.length <= 0) {
                                                            if (store_g.code.length) {
                                                                (bool success, bytes memory ret0) = address(store_g).getAddress{ gas: gasleft() - 0x02c6, value: 0 }(); // call
                                                                if (success) {
                                                                    store_h = address(var_h) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
                                                                    uint256 var_ad = 0x20 + (0x20 + (0x04 + var_a)) - (0x04 + var_a);
                                                                    if (var_h == 0) {
                                                                        if (!(0x1f & var_h)) {
                                                                            if (store_i.code.length) {
                                                                                (bool success, bytes memory ret0) = address(store_i).Unresolved_2ef3accc{ gas: gasleft() - 0x02c6, value: 0 }(var_ad, 0x030d40); // call
                                                                                if (success && (0x01 < 0x03 && (0 < 0x03 && var_af < 0x20))) {
                                                                                    bytes var_h = sha256(var_ag & ~(0x0100 ** (0x20 - var_af) - 0x01) | var_h & 0x0100 ** (0x20 - var_af) - 0x01);
                                                                                    if (memory[memory[0x40]] && 0x02 < 0x03) {
                                                                                        storage_map_j[0] = keccak256(memory[var_a:var_a + (var_ao + (0x20 + (var_al + (0x08 + var_a))) - var_a)]);
                                                                                    }
                                                                                }
                                                                            }
                                                                        } else {
                                                                            if (store_i.code.length) {
                                                                                (bool success, bytes memory ret0) = address(store_i).Unresolved_00000000{ gas: gasleft() - 0x02c6, value: 0 }(var_ad, 0x030d40); // call
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else {
                                                            store_k = 0x146500cfd35b22e4a392fe0adc06de1a1368ed48 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                                                            store_l = 0x01 + (var_h + var_h);
                                                            if (var_h) {
                                                                store_l[0] = var_w;
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
            }
        }
    }
    
    /// @custom:selector    0xe08a96cd
    /// @custom:signature   maxAmountOfBets() public view returns (uint256)
    function maxAmountOfBets() public view returns (uint256) {
        if (!msg.value) {
            return store_b;
        }
    }
    
    /// @custom:selector    0x9a6a68e9
    /// @custom:signature   numberWinner() public view returns (uint256)
    function numberWinner() public view returns (uint256) {
        if (!msg.value) {
            return store_m;
        }
    }
    
    /// @custom:selector    0x27dc297e
    /// @custom:signature   Unresolved_27dc297e(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_27dc297e(uint256 arg0, uint256 arg1) public view {
        if (!msg.value && (0 < var_e && (0x01 < var_e && 0x02 < var_e))) {
            require((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_f / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000);
            if (0x45 < var_e) {
                require(var_q >= 0x20);
            }
        }
    }
    
    /// @custom:selector    0x38bbfa50
    /// @custom:signature   Unresolved_38bbfa50(uint256 arg0, uint256 arg1, uint256 arg2) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_38bbfa50(uint256 arg0, uint256 arg1, uint256 arg2) public view {
        if (!msg.value && (0 < var_e && (0x01 < var_e && 0x02 < var_e))) {
            require((0xff00000000000000000000000000000000000000000000000000000000000000 & 0x0100000000000000000000000000000000000000000000000000000000000000 * (var_f / 0x0100000000000000000000000000000000000000000000000000000000000000)) == 0x0100000000000000000000000000000000000000000000000000000000000000);
            if (0x45 < var_e) {
                require(var_e >= 0x20);
            }
        }
    }
}