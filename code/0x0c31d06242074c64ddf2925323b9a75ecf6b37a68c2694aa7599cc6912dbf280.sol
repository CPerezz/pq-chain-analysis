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
    address public unresolved_997a4b76; // storage slot: 0x00
    bytes32 store_d; // storage slot: 0x00
    uint256 store_c; // storage slot: 0x02
    uint32 store_r; // storage slot: 0x02
    uint256 store_f; // storage slot: 0x03
    uint8 store_e; // storage slot: 0x3d
    uint8 store_j; // storage slot: 0x3d
    bytes store_l; // storage slot: 0x3e
    address public unresolved_b2bfbd0c; // storage slot: 0x3f
    address store_t; // storage slot: 0x3f
    address store_m; // storage slot: 0x73
    bytes32 store_i; // storage slot: 0x73
    uint256 public unresolved_3856e20d; // storage slot: 0xa7
    bytes32 store_q; // storage slot: 0xa8
    uint8 store_u; // storage slot: 0xa8
    bytes32 store_s; // storage slot: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff + (store_c + keccak256(0x02))
    
    mapping(address => bytes32) storage_map_b; // storage slot: 0x01
    mapping(bytes32 => mapping(bytes32 => uint256)) storage_map_g; // storage slot: 0x04
    mapping(uint256 => bytes32) storage_map_k; // storage slot: 0x40
    mapping(uint8 => mapping(address => bytes32)) storage_map_o; // storage slot: 0x74
    mapping(uint8 => mapping(uint256 => bytes32)) storage_map_n; // storage slot: 0xa9
    
    event ApproveKey(bytes32, address, bool);
    event Event_000dfb6a();
    event Event_02a399cb();
    event Event_09468836();
    event Event_6d1c8617();
    event Event_76dc03d7();
    event Event_7a8ab0ad();
    event Event_8973fd3c();
    event Event_8db9847a();
    event Event_c9e125aa();
    event Event_df9c84d8();
    event Event_f4a21e5d();
    event Event_f8ab414b();
    event ResetGlobal(address);
    event ResetKey(bytes32, address);
    
    /// @custom:selector    0x2fb22868
    /// @custom:signature   acceptBridgeManager() public payable
    function acceptBridgeManager() public payable {
        require(msg.sender == unresolved_997a4b76, "BridgeManager: only proposed manager");
        require(!storage_map_b[unresolved_997a4b76].field_0, "BridgeManager: already a manager");
        require(0xffffffff > store_c, "LibIndexedMapping: Data length overflow");
        store_c += 0x01;
        store_c[store_c] = unresolved_997a4b76 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_c[store_c];
        storage_map_b[unresolved_997a4b76] = uint32(0x01 + store_c) | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & storage_map_b[unresolved_997a4b76];
        emit Event_6d1c8617(unresolved_997a4b76, 0x01);
        store_d = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
    }
    
    /// @custom:selector    0x238dafe0
    /// @custom:signature   enabled() public view returns (bool)
    function enabled() public view returns (bool) {
        return uint8(store_e / 0x0100);
    }
    
    /// @custom:selector    0x48aefc32
    /// @custom:signature   isApproved(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function isApproved(bytes32 arg0) public view returns (bool) {
        return storage_map_g[store_f][arg0].field_1[storage_map_g[store_f][arg0]] >= 0x02;
    }
    
    /// @custom:selector    0x23d49a3e
    /// @custom:signature   returnERC20(address arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function returnERC20(address arg0, address arg1, uint256 arg2) public payable {
        if (storage_map_b[msg.sender].field_0) {
            require(unresolved_b2bfbd0c != arg0, "EnjinBridge: token is ENJ");
            uint256 var_e = 0x44 + (var_f - var_f);
            uint256 var_f = var_f + 0x64;
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg0.codehash, "SafeERC20: call to non-contract");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 != arg0.codehash, "SafeERC20: call to non-contract");
            (bool success, bytes memory ret0) = address(arg0).Unresolved_00000000{ value: 0 }(var_l); // call
            if (ret0.length == 0) {
                require(success, "SafeERC20: low-level call failed");
                if (var_m) {
                    require(var_m >= 0x20);
                    require(var_e, "SafeERC20: ERC20 operation did not succeed");
                }
            } else {
                require(success, "SafeERC20: low-level call failed");
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x36a7abd3
    /// @custom:signature   setERC1155(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setERC1155(address arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            if (uint8(store_e / 0x0100)) {
                require(arg0.code.length);
                (bool success, bytes memory ret0) = address(arg0).Unresolved_01ffc9a7(0xd9b67a2600000000000000000000000000000000000000000000000000000000); // staticcall
                require(success);
                require(ret0.length >= 0x20);
                require(var_f, "AssetCreatorOperations: invalid ERC1155 address");
                store_i = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                emit Event_000dfb6a(arg0);
            } else {
                address var_a = var_a;
                revert("EnjinBridge: Bridge disabled");
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x35330885
    /// @custom:signature   thisChainID() public view returns (bool)
    function thisChainID() public view returns (bool) {
        return store_j;
    }
    
    /// @custom:selector    0x6479a9fc
    /// @custom:signature   transferCompleted(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function transferCompleted(bytes32 arg0) public view returns (bool) {
        return storage_map_k[arg0].field_0;
    }
    
    /// @custom:selector    0xb8ed12a4
    /// @custom:signature   transferNonce() public view returns (uint256)
    function transferNonce() public view returns (uint256) {
        return store_l;
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool) {
        if ((0xffffffff00000000000000000000000000000000000000000000000000000000 & arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x01ffc9a700000000000000000000000000000000000000000000000000000000) {
            return (0xffffffff00000000000000000000000000000000000000000000000000000000 & arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x01ffc9a700000000000000000000000000000000000000000000000000000000;
        } else {
            return (0xffffffff00000000000000000000000000000000000000000000000000000000 & arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x4e2312e000000000000000000000000000000000000000000000000000000000;
        }
    }
    
    /// @custom:selector    0x11228f62
    /// @custom:signature   Unresolved_11228f62(uint256 arg0, uint32 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_11228f62(uint256 arg0, uint32 arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x44;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).Unresolved_da8f728d{ value: 0 }(arg1, arg0, var_y); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x12ffd09f
    /// @custom:signature   Unresolved_12ffd09f(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_12ffd09f(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(arg3 <= 0x0100000000);
        require(0x04 + arg3 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg3] > 0x0100000000 | 0x20 + (0x04 + arg3) + msg.data[0x04 + arg3] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_e = var_e + 0x74;
            require(0x41 == var_h, "BridgeManager: invalid signature length");
            require(var_m <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_n), "BridgeManager: invalid signature 'v' value");
            uint256 var_e = var_e + 0x20;
            require(memory[0x20]);
            require(address(var_u), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_u)].field_0, "BridgeManager: invalid signature");
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).setValue{ value: 0 }(arg1, arg2); // call
            require(success);
        } else {
            address var_v = var_v;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x158c80c0
    /// @custom:signature   Unresolved_158c80c0(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_158c80c0(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x60;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).setTransferFee{ value: 0 }(arg0, arg1); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x21d9c2b4
    /// @custom:signature   Unresolved_21d9c2b4(bool arg0, uint256 arg1) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_21d9c2b4(bool arg0, uint256 arg1) public payable {
        if (uint8(store_e / 0x0100)) {
            require(store_j != uint8(arg0), "EnjinAssetBridge: cannot transfer to current chain");
            store_l += 0x01;
            uint256 var_b = this.code[this.code.length:this.code.length + 0x40];
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).Unresolved_4aa8ade5(arg1); // staticcall
            require(success);
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
            require(ret0.length >= 0x0180);
            require(var_b <= 0x0100000000);
            require(var_a + var_b + 0x20 <= var_a + ret0.length);
            require(!(var_a + ret0.length < var_e + (var_a + var_b + 0x20) | var_e > 0x0100000000));
            uint256 var_a = 0x20 + (var_e + (0x20 + var_a) - (0x1f & var_e));
            uint256 var_a = var_a + 0x42;
            uint256 var_a = 0x01 + (0x02 + (0x40 + (0xe0 + (var_b + (0x20 + (0x20 + var_a))))));
            storage_map_n[uint8(arg0)][var_z] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_n[uint8(arg0)][var_z];
            emit Event_df9c84d8(var_z, keccak256(memory[0x20 + var_a:0x20 + var_a + var_b]), store_l, uint8(arg0));
        } else {
            uint8 var_x = var_x;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x223ad7cc
    /// @custom:signature   Unresolved_223ad7cc(bool arg0, address arg1, address arg2) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_223ad7cc(bool arg0, address arg1, address arg2) public payable {
        if (storage_map_b[msg.sender].field_0) {
            if (uint8(store_e / 0x0100)) {
                storage_map_o[uint8(arg0)][arg1] = arg2 | storage_map_o[uint8(arg0)][arg1] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
                emit Event_8973fd3c(uint8(arg0), arg1, arg2);
            } else {
                address var_a = var_a;
                revert("EnjinBridge: Bridge disabled");
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x242d553d
    /// @custom:signature   Unresolved_242d553d(bool arg0, address arg1) public view returns (address)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_242d553d(bool arg0, address arg1) public view returns (address) {
        return storage_map_o[uint8(arg0)][arg1].field_0.field_0;
    }
    
    /// @custom:selector    0x259af5f6
    /// @custom:signature   Unresolved_259af5f6(uint256 arg0, bool arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_259af5f6(uint256 arg0, bool arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            if (uint8(arg1) <= 0x02) {
                uint256 var_d = 0x01 + (0x20 + (0x20 + var_d));
                require(0x41 == var_g, "BridgeManager: invalid signature length");
                require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
                require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
                uint256 var_d = var_d + 0x20;
                require(memory[0x20]);
                require(address(var_t), "BridgeManager: invalid signature");
                require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
                if (uint8(arg1) <= 0x02) {
                    require(store_m.code.length);
                    (bool success, bytes memory ret0) = address(store_m).setTransferable{ value: 0 }(arg0, uint8(arg1)); // call
                    require(success);
                }
            }
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x2c97871b
    /// @custom:signature   Unresolved_2c97871b(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_2c97871b(uint256 arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            if (uint8(store_e / 0x0100)) {
                require(0xf6 == arg0, "EnjinAssetBridge: only 245, 246");
                unresolved_3856e20d = store_j << arg0;
            } else {
                address var_a = var_a;
                revert("EnjinBridge: Bridge disabled");
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x30be741c
    /// @custom:signature   Unresolved_30be741c(uint256 arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_30be741c(uint256 arg0, address arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x54;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).Unresolved_2665bc1c{ value: 0 }(arg0, arg1, var_y); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x328d8f72
    /// @custom:signature   Unresolved_328d8f72(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_328d8f72(uint256 arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            store_e = store_e & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff | arg0 * 0x0100;
            emit Event_8db9847a(arg0);
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x38ebade9
    /// @custom:signature   Unresolved_38ebade9(uint256 arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_38ebade9(uint256 arg0, address arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x54;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).assign{ value: 0 }(arg0, arg1); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x3aa19e68
    /// @custom:signature   Unresolved_3aa19e68(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_3aa19e68(address arg0) public view returns (bool) {
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x3c3aa281
    /// @custom:signature   Unresolved_3c3aa281(bool arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_3c3aa281(bool arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable {
        require(arg3 <= 0x0100000000);
        require(0x04 + arg3 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg3] > 0x0100000000 | 0x20 + (0x04 + arg3) + msg.data[0x04 + arg3] * 0x20 > 0x04 + (msg.data.length - 0x04)));
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] * 0x20 > 0x04 + (msg.data.length - 0x04)));
        require(arg5 <= 0x0100000000);
        require(0x04 + arg5 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg5] > 0x0100000000 | 0x20 + (0x04 + arg5) + msg.data[0x04 + arg5] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_e = var_e + 0x42;
        require(!storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])].field_0, "EnjinAssetBridge: cannot be processed twice");
        if (0 < var_g) {
            uint256 var_e = var_e + (0x20 + 0x20 * var_g);
            uint256 var_j = this.code[this.code.length:this.code.length + var_g * 0x20];
            if (0 >= var_g) {
                uint256 var_e = 0x20 * var_g + (0x20 * var_g + (0x14 + (0x20 + (0x20 + (0x20 + var_e)))));
                uint256 var_j = msg.data[0x20 + (0x04 + arg5):0x20 + (0x04 + arg5) + msg.data[0x04 + arg5]];
                require(0x41 == var_g, "BridgeManager: invalid signature length");
                require(var_v <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
                require(0x1b == uint8(var_w), "BridgeManager: invalid signature 'v' value");
                uint256 var_e = var_e + 0x20;
                require(memory[0x20]);
                require(address(var_ad), "BridgeManager: invalid signature");
                require(storage_map_b[address(var_ad)].field_0, "BridgeManager: invalid signature");
                storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])];
                if ((var_j & 0xffffffffffffffff000000000000000000000000000000000000000000000000 & 0x60000000000000000000000000000000000000000000000000000000000000) == unresolved_3856e20d) {
                    require(store_m.code.length);
                } else {
                    uint256 var_e = var_e + msg.data[0x04 + arg3] * 0x20 + 0x20;
                    uint256 var_j = this.code[this.code.length:this.code.length + msg.data[0x04 + arg3] * 0x20];
                    if (0 >= msg.data[0x04 + arg3]) {
                        if (var_j & 0xffffffffffffffff000000000000000000000000000000000000000000000000 & 0x80000000000000000000000000000000000000000000000000000000000000) {
                            require(store_m.code.length);
                            (bool success, bytes memory ret0) = address(store_m).Unresolved_7e2c20ad{ value: 0 }(var_j & 0xffffffffffffffff000000000000000000000000000000000000000000000000, 0x60, var_g * 0x20 + (0x84 + var_e) - (var_e + 0x04)); // call
                        } else {
                            require(store_m.code.length);
                            (bool success, bytes memory ret0) = address(store_m).Unresolved_fb2b9992{ value: 0 }(var_j & 0xffffffffffffffff000000000000000000000000000000000000000000000000, 0x20 + (0x20 + (0x20 + (0x04 + var_e))) - (0x04 + var_e), 0x20 * var_g + (0x20 + (0x20 + (0x20 + (0x20 + (0x04 + var_e))))) - (0x04 + var_e)); // call
                        }
                        require(success);
                        emit Event_c9e125aa(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
                    }
                }
            } else {
                if (0 < var_g) {
                    if (0 < var_g && 0 < var_g) {
                        require(0 >= var_g, "EnjinAssetBridge: embeddedData is not supported");
                    }
                    revert("EnjinAssetBridge: diff base IDs");
                }
            }
        }
    }
    
    /// @custom:selector    0x3cbbf99c
    /// @custom:signature   Unresolved_3cbbf99c(uint256 arg0, uint16 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_3cbbf99c(uint256 arg0, uint16 arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x42;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).setMeltFee{ value: 0 }(arg0, arg1); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x40eed063
    /// @custom:signature   Unresolved_40eed063(uint32 arg0) public view returns (address)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_40eed063(uint32 arg0) public view returns (address) {
        if (arg0 < store_c) {
            return store_c[arg0].field_0.field_0;
        }
    }
    
    /// @custom:selector    0x47c0c62b
    /// @custom:signature   Unresolved_47c0c62b(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_47c0c62b(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(arg1 <= 0x0100000000);
        require(0x04 + arg1 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg1] > 0x0100000000 | 0x20 + (0x04 + arg1) + msg.data[0x04 + arg1] > 0x04 + (msg.data.length - 0x04)));
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_b = 0x20 + (0x20 + var_b) + msg.data[0x04 + arg1];
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_b = var_b + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).setURI{ value: 0 }(arg0, 0x40); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x498ac868
    /// @custom:signature   Unresolved_498ac868(bool arg0) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_498ac868(bool arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            if (uint8(store_e / 0x0100)) {
                require(store_j != uint8(arg0), "EnjinAssetBridge: cannot transfer to current chain");
                store_q = uint8(arg0) | store_q & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
                emit Event_f8ab414b(uint8(arg0));
            } else {
                address var_a = var_a;
                revert("EnjinBridge: Bridge disabled");
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x50962f84
    /// @custom:signature   Unresolved_50962f84(address arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_50962f84(address arg0, address arg1, uint256 arg2) public payable {
        if (storage_map_b[msg.sender].field_0) {
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).Unresolved_42842e0e{ value: 0 }(address(this)); // call
            require(success);
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x54bc3cb1
    /// @custom:signature   Unresolved_54bc3cb1(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_54bc3cb1(address arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            require(store_r > 0x02, "BridgeManager: should be more than APPROVAL_THRESHOLD to remove");
            uint256 var_f = var_f + 0x50;
            require(!storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_0, "LibThresholdApproval: Sender has already approved");
            storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender];
            require(0x01 + storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]] >= storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]], "SafeMath: add overflow");
            storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]]] += 0x01;
            emit ApproveKey(keccak256(memory[0x20 + var_f:0x20 + var_f + var_g]), msg.sender, 0x01);
            emit Event_7a8ab0ad(arg0, msg.sender, 0);
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x5806e0b4
    /// @custom:signature   Unresolved_5806e0b4(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_5806e0b4(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(arg1 <= 0x0100000000);
        require(0x04 + arg1 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg1] > 0x0100000000 | 0x20 + (0x04 + arg1) + msg.data[0x04 + arg1] > 0x04 + (msg.data.length - 0x04)));
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_b = 0x20 + (0x20 + var_b) + msg.data[0x04 + arg1];
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_b = var_b + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).updateName{ value: 0 }(arg0, 0x40); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x5fcf462e
    /// @custom:signature   Unresolved_5fcf462e(bool arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_5fcf462e(bool arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_d = 0x22 + (var_e - var_e);
        uint256 var_e = var_e + 0x42;
        require(!storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])].field_0, "EnjinBridge: transfer cannot be processed twice");
        uint256 var_e = var_e + 0x74;
        uint256 var_q = msg.data[0x20 + (0x04 + arg4):0x20 + (0x04 + arg4) + msg.data[0x04 + arg4]];
        require(0x41 == var_g, "BridgeManager: invalid signature length");
        require(var_s <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
        require(0x1b == uint8(var_t), "BridgeManager: invalid signature 'v' value");
        uint256 var_e = var_e + 0x20;
        require(memory[0x20]);
        require(address(var_aa), "BridgeManager: invalid signature");
        require(storage_map_b[address(var_aa)].field_0, "BridgeManager: invalid signature");
        storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])];
        uint256 var_e = var_e + 0x64;
        require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == unresolved_b2bfbd0c.codehash, "SafeERC20: call to non-contract");
        require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 != unresolved_b2bfbd0c.codehash, "SafeERC20: call to non-contract");
        (bool success, bytes memory ret0) = address(unresolved_b2bfbd0c).Unresolved_00000000{ value: 0 }(var_ae); // call
        if (ret0.length == 0) {
            require(success, "SafeERC20: low-level call failed");
            if (var_af) {
                require(var_af >= 0x20);
                require(var_d, "SafeERC20: ERC20 operation did not succeed");
            }
        } else {
            uint256 var_e = var_e + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(success, "SafeERC20: low-level call failed");
        }
        emit Event_09468836(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
    }
    
    /// @custom:selector    0x67ce2157
    /// @custom:signature   Unresolved_67ce2157(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_67ce2157(address arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            uint256 var_f = var_f + 0x51;
            require(!storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_0, "LibThresholdApproval: Sender has already approved");
            storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender];
            require(0x01 + storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]] >= storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]], "SafeMath: add overflow");
            storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_2[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]][msg.sender]][msg.sender]]] += 0x01;
            emit ApproveKey(keccak256(memory[0x20 + var_f:0x20 + var_f + var_g]), msg.sender, 0x01);
            emit Event_7a8ab0ad(arg0, msg.sender, 0x01);
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x6de2b0c3
    /// @custom:signature   Unresolved_6de2b0c3(bool arg0, uint256 arg1, uint0 arg2, address arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint0", "bytes0", "int0"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_6de2b0c3(bool arg0, uint256 arg1, uint0 arg2, address arg3, uint256 arg4, uint256 arg5) public payable {
        require(arg5 <= 0x0100000000);
        require(0x04 + arg5 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg5] > 0x0100000000 | 0x20 + (0x04 + arg5) + msg.data[0x04 + arg5] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_e = var_e + 0x42;
        require(!storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])].field_0, "EnjinAssetBridge: cannot be processed twice");
        require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg3.codehash, "EnjinAssetBridge: cannot transfer to contract");
        require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg3.codehash, "EnjinAssetBridge: cannot transfer to contract");
        require(!uint128(arg2 >> 0x40), "EnjinAssetBridge: embeddedData is not supported");
        uint256 var_e = 0x20 + (0x20 + (0x14 + (0x20 + (0x20 + (0x20 + var_e)))));
        uint256 var_s = msg.data[0x20 + (0x04 + arg5):0x20 + (0x04 + arg5) + msg.data[0x04 + arg5]];
        require(0x41 == var_g, "BridgeManager: invalid signature length");
        require(var_u <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
        require(0x1b == uint8(var_v), "BridgeManager: invalid signature 'v' value");
        uint256 var_e = var_e + 0x20;
        require(memory[0x20]);
        require(address(var_ac), "BridgeManager: invalid signature");
        require(storage_map_b[address(var_ac)].field_0, "BridgeManager: invalid signature");
        storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g])];
        if ((arg2 & 0x60000000000000000000000000000000000000000000000000000000000000) == unresolved_3856e20d) {
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).Unresolved_f242432a{ value: 0 }(address(this), arg3, arg2, arg4); // call
            require(success);
            emit Event_c9e125aa(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
        } else {
            if (0 < var_g) {
                if (arg2 & 0x80000000000000000000000000000000000000000000000000000000000000) {
                    uint256 var_e = 0x40 + var_e;
                    if (0 < var_g && (0 >= var_g * 0x20 && 0 >= 0x20 * var_g)) {
                        require(store_m.code.length);
                        (bool success, bytes memory ret0) = address(store_m).Unresolved_7e2c20ad{ value: 0 }(arg2 & 0xffffffffffffffff000000000000000000000000000000000000000000000000); // call
                        require(success);
                        emit Event_c9e125aa(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
                    }
                } else {
                    uint256 var_e = 0x40 + var_e;
                    if (0 < var_g && (0 >= var_g * 0x20 && 0 >= 0x20 * var_g)) {
                        require(store_m.code.length);
                        (bool success, bytes memory ret0) = address(store_m).Unresolved_fb2b9992{ value: 0 }(arg2 & 0xffffffffffffffff000000000000000000000000000000000000000000000000); // call
                        require(success);
                        emit Event_c9e125aa(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x6f2436cc
    /// @custom:signature   Unresolved_6f2436cc() public view returns (address)
    function Unresolved_6f2436cc() public view returns (address) {
        return store_m;
    }
    
    /// @custom:selector    0x723d0d6a
    /// @custom:signature   Unresolved_723d0d6a(bool arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_723d0d6a(bool arg0, uint256 arg1) public view returns (bool) {
        return storage_map_n[uint8(arg0)][arg1].field_0;
    }
    
    /// @custom:selector    0x739d48e1
    /// @custom:signature   Unresolved_739d48e1(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_739d48e1(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4) public payable {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_f = var_f + 0x69;
            require(0x41 == var_i, "BridgeManager: invalid signature length");
            require(var_n <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_o), "BridgeManager: invalid signature 'v' value");
            uint256 var_f = var_f + 0x20;
            require(memory[0x20]);
            require(address(var_v), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_v)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).Unresolved_e6e21c75{ value: 0 }(arg0, arg1, arg2, arg3); // call
            require(success);
        } else {
            address var_w = var_w;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x7f053349
    /// @custom:signature   Unresolved_7f053349() public payable
    function Unresolved_7f053349() public payable {
        require(msg.sender == unresolved_997a4b76, "BridgeManager: only proposed manager");
        emit Event_6d1c8617(unresolved_997a4b76, 0x03);
        store_d = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
    }
    
    /// @custom:selector    0x94f500cb
    /// @custom:signature   Unresolved_94f500cb(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_94f500cb(address arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            uint256 var_f = var_f + 0x51;
            require(storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]] >= 0x02, "proposeBridgeManager is not approved");
            require(0x01 + storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])] >= storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])], "SafeMath: add overflow");
            storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])] += 0x01;
            emit ResetKey(keccak256(memory[0x20 + var_f:0x20 + var_f + var_g]), msg.sender);
            store_d = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
            emit Event_6d1c8617(arg0, 0);
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x9651f3e5
    /// @custom:signature   Unresolved_9651f3e5(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9651f3e5(address arg0) public payable {
        if (storage_map_b[msg.sender].field_0) {
            uint256 var_f = var_f + 0x50;
            require(storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])].field_1[storage_map_g[store_f][keccak256(memory[0x20 + var_f:0x20 + var_f + var_g])]] >= 0x02, "removeBridgeManager is not approved");
            require(0x01 + store_f >= store_f, "SafeMath: add overflow");
            store_f += 0x01;
            emit ResetGlobal(msg.sender);
            require(storage_map_b[arg0].field_0, "BridgeManager: not a manager");
            if (store_c + type(uint256).max < store_c && uint32(storage_map_b[arg0].field_0 + type(uint256).max) < store_c) {
                store_c[uint32(storage_map_b[arg0].field_0 + type(uint256).max)] = store_c[store_c + type(uint256).max].field_0.field_0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_c[uint32(storage_map_b[arg0].field_0 + type(uint256).max)];
                storage_map_b[store_c[store_c + type(uint256).max].field_0.field_0] = storage_map_b[store_c[store_c + type(uint256).max].field_0.field_0].field_0.field_0 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & storage_map_b[store_c[store_c + type(uint256).max].field_0.field_0];
                storage_map_b[arg0] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 & storage_map_b[arg0];
                if (store_c) {
                    store_s = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
                    store_c += type(uint256).max;
                    emit Event_6d1c8617(arg0, 0x02);
                }
            }
        } else {
            address var_a = var_a;
            revert("BridgeManager: only manager");
        }
    }
    
    /// @custom:selector    0x9e2ac9fa
    /// @custom:signature   Unresolved_9e2ac9fa(bool arg0, address arg1, uint256 arg2) public payable returns (bytes memory)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_9e2ac9fa(bool arg0, address arg1, uint256 arg2) public payable returns (bytes memory) {
        if (uint8(store_e / 0x0100)) {
            require(store_e != uint8(arg0), "EnjinBridge: Cannot transfer to current chain");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg1.codehash, "EnjinBridge: cannot transfer to contract");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg1.codehash, "EnjinBridge: cannot transfer to contract");
            store_l += 0x01;
            uint256 var_d = 0x22 + (var_e - var_e);
            uint256 var_e = var_e + 0x42;
            uint256 var_e = var_e + 0x74;
            uint256 var_e = var_e + 0x84;
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == store_t.codehash, "SafeERC20: call to non-contract");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 != store_t.codehash, "SafeERC20: call to non-contract");
            (bool success, bytes memory ret0) = address(store_t).Unresolved_00000000{ value: 0 }(var_s); // call
            if (ret0.length == 0) {
                require(success, "SafeERC20: low-level call failed");
                if (var_t) {
                    require(var_t >= 0x20);
                    require(var_d, "SafeERC20: ERC20 operation did not succeed");
                }
            } else {
                uint256 var_e = var_e + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(success, "SafeERC20: low-level call failed");
            }
            emit Event_76dc03d7(keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]), store_l, uint8(arg0), arg1, arg2);
            return abi.encodePacked(keccak256(memory[var_e + 0x20:var_e + 0x20 + var_g]), keccak256(memory[0x20 + var_e:0x20 + var_e + var_g]));
        } else {
            uint256 var_af = var_af;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0x9f1bee91
    /// @custom:signature   Unresolved_9f1bee91() public view returns (uint32)
    function Unresolved_9f1bee91() public view returns (uint32) {
        return store_r;
    }
    
    /// @custom:selector    0xa35420f3
    /// @custom:signature   Unresolved_a35420f3(address arg0) public view returns (uint32)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a35420f3(address arg0) public view returns (uint32) {
        require(storage_map_b[arg0].field_0, "LibIndexedMapping: _address is 0");
        return uint32(type(uint256).max + storage_map_b[arg0].field_0);
    }
    
    /// @custom:selector    0xbc197c81
    /// @custom:signature   Unresolved_bc197c81(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_bc197c81(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable returns (uint256) {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] * 0x20 > 0x04 + (msg.data.length - 0x04)));
        require(arg3 <= 0x0100000000);
        require(0x04 + arg3 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg3] > 0x0100000000 | 0x20 + (0x04 + arg3) + msg.data[0x04 + arg3] * 0x20 > 0x04 + (msg.data.length - 0x04)));
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            require(msg.sender == store_m, "EnjinAssetBridge: not cryptoItems");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg1.codehash, "EnjinAssetBridge: cannot transfer to contract");
            require(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 == arg1.codehash, "EnjinAssetBridge: cannot transfer to contract");
            require(msg.data[0x04 + arg4] >= 0x20);
            require(store_e != uint8(msg.data[0x20 + (0x04 + arg4)]), "EnjinAssetBridge: cannot transfer to current chain");
            if (msg.data[0x04 + arg2] && storage_map_n[uint8(msg.data[0x20 + (0x04 + arg4)])][msg.data[0x20 + (0x04 + arg2)] & 0xffffffffffffffff000000000000000000000000000000000000000000000000].field_0) {
                if (storage_map_n[uint8(msg.data[0x20 + (0x04 + arg4)])][msg.data[0x20 + (0x04 + arg2)] & 0xffffffffffffffff000000000000000000000000000000000000000000000000].field_0) {
                    store_l += 0x01;
                    if (0 < var_l) {
                        uint256 var_g = var_g + (0x20 + 0x20 * var_l);
                        uint256 var_i = this.code[this.code.length:this.code.length + var_l * 0x20];
                        if (0 >= var_l) {
                            uint256 var_g = 0x20 * var_l + (0x20 * var_l + (0x14 + (0x20 + (0x20 + (0x20 + var_g)))));
                            if (0 < msg.data[0x04 + arg2]) {
                                if ((msg.data[0x20 + (0x04 + arg2)] & 0x60000000000000000000000000000000000000000000000000000000000000) != unresolved_3856e20d) {
                                    uint256 var_aa = msg.data[0x04 + arg2];
                                    uint256 var_ad = 0x64 + var_g + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2] * 0x20) - (var_g + 0x04);
                                    uint256 var_ac = msg.data[0x04 + arg3];
                                    require(store_m.code.length);
                                    (bool success, bytes memory ret0) = address(store_m).Unresolved_3941412b{ value: 0 }(0x40, var_ad, var_aa, var_ac, 0); // call
                                    require(success);
                                }
                                emit Event_02a399cb(keccak256(memory[0x20 + var_g:0x20 + var_g + var_l]), store_l, uint8(msg.data[0x20 + (0x04 + arg4)]), arg1, 0x20 + (0x20 + (0x20 + (0x20 + var_g))) - var_g, 0x20 + (0x20 + (0x20 + (0x20 + (0x20 + var_g)))) + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + 0x20 * msg.data[0x04 + arg2]) - var_g, msg.data[0x04 + arg2], msg.data[0x04 + arg3]);
                                return 0xbc197c8100000000000000000000000000000000000000000000000000000000;
                            }
                        } else {
                            require(0 >= var_l, "EnjinAssetBridge: diff base IDs");
                            revert("EnjinAssetBridge: diff base IDs");
                        }
                    }
                } else {
                    if (0 < msg.data[0x04 + arg2]) {
                        if (uint8(store_e / 0x0100)) {
                            require(store_e != uint8(msg.data[0x20 + (0x04 + arg4)]), "EnjinAssetBridge: cannot transfer to current chain");
                            store_l += 0x01;
                            uint256 var_l = this.code[this.code.length:this.code.length + 0x40];
                            uint256 var_ak = msg.data[0x20 + (0x04 + arg2)];
                            require(store_m.code.length);
                            (bool success, bytes memory ret0) = address(store_m).Unresolved_4aa8ade5(var_ak); // staticcall
                            require(success);
                            uint256 var_g = var_g + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                            require(ret0.length >= 0x0180);
                            require(var_l <= 0x0100000000);
                            require(var_g + var_l + 0x20 <= var_g + ret0.length);
                            require(!(var_g + ret0.length < var_al + (var_g + var_l + 0x20) | var_al > 0x0100000000));
                            uint256 var_g = 0x20 + (var_al + (0x20 + var_g) - (0x1f & var_al));
                            uint256 var_g = var_g + 0x42;
                        } else {
                            uint8 var_a = var_a;
                            revert("EnjinBridge: Bridge disabled");
                        }
                    }
                }
            }
        } else {
            uint8 var_a = var_a;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0xd661c154
    /// @custom:signature   Unresolved_d661c154(uint256 arg0, bool arg1, bool arg2, uint16 arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg3 ["uint16", "bytes2", "int16"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    function Unresolved_d661c154(uint256 arg0, bool arg1, bool arg2, uint16 arg3, uint256 arg4, uint256 arg5) public payable {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        require(arg14 <= 0x0100000000);
        require(0x04 + arg14 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg14] > 0x0100000000 | 0x20 + (0x04 + arg14) + msg.data[0x04 + arg14] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_a = 0x40 + var_a;
        uint256 var_b = this.code[this.code.length:this.code.length + 0x40];
        uint256 var_a = var_a + 0x42;
        require(!storage_map_k[keccak256(memory[var_a + 0x20:var_a + 0x20 + var_b])].field_0, "EnjinAssetBridge: cannot be processed twice");
        uint256 var_k = msg.data[0x20 + (0x04 + arg4):0x20 + (0x04 + arg4) + msg.data[0x04 + arg4]];
        uint256 var_a = 0x40 + var_a;
        uint256 var_b = msg.data[0x0184:0x0184 + 0x40];
        uint256 var_a = 0x01 + (0x02 + (0x40 + (0xe0 + (var_b + (0x20 + (0x20 + var_a))))));
        uint256 var_q = msg.data[0x20 + (0x04 + arg14):0x20 + (0x04 + arg14) + msg.data[0x04 + arg14]];
        require(0x41 == var_b, "BridgeManager: invalid signature length");
        require(var_ac <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
        require(0x1b == uint8(var_ad), "BridgeManager: invalid signature 'v' value");
        uint256 var_a = var_a + 0x20;
        require(memory[0x20]);
        require(address(var_aj), "BridgeManager: invalid signature");
        require(storage_map_b[address(var_aj)].field_0, "BridgeManager: invalid signature");
        storage_map_k[var_b] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[var_b];
        uint256 var_b = this.code[this.code.length:this.code.length + 0x60];
        uint256 var_a = var_a + 0x60;
        if (0 < 0x60 && (0 < var_b && 0x1f & var_b)) {
            require(store_m.code.length);
        }
    }
    
    /// @custom:selector    0xdec3dba7
    /// @custom:signature   Unresolved_dec3dba7(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_dec3dba7(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x60;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).decreaseMaxTransferFee{ value: 0 }(arg0, arg1); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0xe2a8eeb9
    /// @custom:signature   Unresolved_e2a8eeb9(uint256 arg0, uint16 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_e2a8eeb9(uint256 arg0, uint16 arg1, uint256 arg2) public payable {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            uint256 var_d = var_d + 0x42;
            require(0x41 == var_g, "BridgeManager: invalid signature length");
            require(var_l <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "BridgeManager: invalid signature 's' value");
            require(0x1b == uint8(var_m), "BridgeManager: invalid signature 'v' value");
            uint256 var_d = var_d + 0x20;
            require(memory[0x20]);
            require(address(var_t), "BridgeManager: invalid signature");
            require(storage_map_b[address(var_t)].field_0, "BridgeManager: invalid signature");
            require(store_m.code.length);
            (bool success, bytes memory ret0) = address(store_m).decreaseMaxMeltFee{ value: 0 }(arg0, arg1); // call
            require(success);
        } else {
            address var_u = var_u;
            revert("EnjinBridge: Bridge disabled");
        }
    }
    
    /// @custom:selector    0xec6ce86e
    /// @custom:signature   Unresolved_ec6ce86e() public view returns (bool)
    function Unresolved_ec6ce86e() public view returns (bool) {
        return store_u;
    }
    
    /// @custom:selector    0xf23a6e61
    /// @custom:signature   Unresolved_f23a6e61(address arg0, address arg1, uint0 arg2, uint256 arg3, uint256 arg4) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint0", "bytes0", "int0"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_f23a6e61(address arg0, address arg1, uint0 arg2, uint256 arg3, uint256 arg4) public payable returns (uint256) {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        if (uint8(store_e / 0x0100)) {
            require(msg.sender == store_m, "EnjinAssetBridge: not cryptoItems");
            require(msg.data[0x04 + arg4] >= 0x20);
            require(store_e != uint8(msg.data[0x20 + (0x04 + arg4)]), "EnjinAssetBridge: cannot transfer to current chain");
            if (storage_map_n[uint8(msg.data[0x20 + (0x04 + arg4)])][arg2 & 0xffffffffffffffff000000000000000000000000000000000000000000000000].field_0) {
                store_l += 0x01;
                uint256 var_g = var_g + 0x42;
                require(!uint128(arg2 >> 0x40), "EnjinAssetBridge: embeddedData is not supported");
                uint256 var_g = 0x20 + (0x20 + (0x14 + (0x20 + (0x20 + (0x20 + var_g)))));
                if ((arg2 & 0x60000000000000000000000000000000000000000000000000000000000000) == unresolved_3856e20d) {
                    emit Event_f4a21e5d(keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]), store_l, uint8(msg.data[0x20 + (0x04 + arg4)]), arg2, arg1, arg3);
                    return 0xf23a6e6100000000000000000000000000000000000000000000000000000000;
                } else {
                    uint256 var_s = this.code[this.code.length:this.code.length + 0x20];
                    if (0 < var_i) {
                        uint256 var_g = 0x40 + var_g;
                        uint256 var_t = this.code[this.code.length:this.code.length + 0x20];
                        if (0 < var_i && (0 >= var_i * 0x20 && 0 >= 0x20 * var_i)) {
                            require(store_m.code.length);
                            (bool success, bytes memory ret0) = address(store_m).Unresolved_3941412b{ value: 0 }(0x40); // call
                            require(success);
                            emit Event_f4a21e5d(keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]), store_l, uint8(msg.data[0x20 + (0x04 + arg4)]), arg2, arg1, arg3);
                            return 0xf23a6e6100000000000000000000000000000000000000000000000000000000;
                        }
                    }
                }
            } else {
                if (uint8(store_e / 0x0100)) {
                    require(store_e != uint8(msg.data[0x20 + (0x04 + arg4)]), "EnjinAssetBridge: cannot transfer to current chain");
                    store_l += 0x01;
                    uint256 var_i = this.code[this.code.length:this.code.length + 0x40];
                    require(store_m.code.length);
                    (bool success, bytes memory ret0) = address(store_m).Unresolved_4aa8ade5(arg2); // staticcall
                    require(success);
                    uint256 var_g = var_g + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                    require(ret0.length >= 0x0180);
                    require(var_i <= 0x0100000000);
                    require(var_g + var_i + 0x20 <= var_g + ret0.length);
                    require(!(var_g + ret0.length < var_aj + (var_g + var_i + 0x20) | var_aj > 0x0100000000));
                    uint256 var_g = 0x20 + (var_aj + (0x20 + var_g) - (0x1f & var_aj));
                    uint256 var_g = var_g + 0x42;
                    uint256 var_g = 0x01 + (0x02 + (0x40 + (0xe0 + (var_i + (0x20 + (0x20 + var_g))))));
                    storage_map_n[uint8(msg.data[0x20 + (0x04 + arg4)])][var_s] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_n[uint8(msg.data[0x20 + (0x04 + arg4)])][var_s];
                    emit Event_df9c84d8(var_s, keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]), store_l, uint8(msg.data[0x20 + (0x04 + arg4)]));
                    store_l += 0x01;
                    uint256 var_g = var_g + 0x42;
                    require(!uint128(arg2 >> 0x40), "EnjinAssetBridge: embeddedData is not supported");
                    uint256 var_g = 0x20 + (0x20 + (0x14 + (0x20 + (0x20 + (0x20 + var_g)))));
                    emit Event_f4a21e5d(keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]), store_l, uint8(msg.data[0x20 + (0x04 + arg4)]), arg2, arg1, arg3);
                    return 0xf23a6e6100000000000000000000000000000000000000000000000000000000;
                } else {
                    uint8 var_a = var_a;
                    revert("EnjinBridge: Bridge disabled");
                }
            }
        } else {
            uint8 var_a = var_a;
            revert("EnjinBridge: Bridge disabled");
        }
    }
}