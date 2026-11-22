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
    bool public constant getHookPermissions = 0xBool(false);
    uint256 public constant poolManager = 22154441650658625721468672576359056;
    uint256 public constant proxiableUUID = e07c8dba;
    uint256 public constant unresolved_54fd4d50 = 53458043598169480932047297085072851752535514648709228009908993537456700653568;
    bytes public constant unresolved_ad3cb1cc = 0xBytes([53, 46, 48, 46, 48]);
    
    bytes store_h; // storage slot: 0x02
    uint8 store_b; // storage slot: 0x02
    address public approver; // storage slot: 0x04
    address store_f; // storage slot: 0x04
    bytes32 store_i; // storage slot: 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    address public unresolved_8da5cb5b; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    bytes32 store_j; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    
    mapping(address => bytes) storage_map_d; // storage slot: 0x00
    mapping(address => bytes) storage_map_g; // storage slot: 0x01
    mapping(address => bytes32) storage_map_c; // storage slot: 0x03
    
    error CustomError_00000000();
    event Event_8be0079c();
    event Event_a34581b4();
    event Event_bc7cd75a();
    
    /// @custom:selector    0x238dafe0
    /// @custom:signature   enabled() public view returns (bool)
    function enabled() public view returns (bool) {
        return store_b;
    }
    
    /// @custom:selector    0x0cd55abf
    /// @custom:signature   nextNonce(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function nextNonce(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_c[arg0];
    }
    
    /// @custom:selector    0x80dd9a1f
    /// @custom:signature   routers(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function routers(address arg0) public view returns (bool) {
        require(true);
        return storage_map_d[arg0].field_0;
    }
    
    /// @custom:selector    0x3156560e
    /// @custom:signature   setApprover(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setApprover(address arg0) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_f = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
    }
    
    /// @custom:selector    0x92a88fa2
    /// @custom:signature   traders(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function traders(address arg0) public view returns (bool) {
        require(true);
        return storage_map_g[arg0].field_0;
    }
    
    /// @custom:selector    0x21d0ee70
    /// @custom:signature   Unresolved_21d0ee70(address arg0, uint256 arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_21d0ee70(address arg0, uint256 arg1) public view returns (uint256) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x80);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        require(store_b, CustomError_75884cda());
        return 0x21d0ee7000000000000000000000000000000000000000000000000000000000;
    }
    
    /// @custom:selector    0x259982e5
    /// @custom:signature   Unresolved_259982e5(address arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_259982e5(address arg0, uint256 arg1) public returns (uint256) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x80);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        require(store_b, CustomError_75884cda());
        if (!uint8(store_h / 0x010000)) {
            return 0x259982e500000000000000000000000000000000000000000000000000000000;
        } else {
            require(storage_map_d[arg0].field_0, CustomError_77efb076());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_d737d0c7(var_d); // staticcall
            if (!success) {
                require(success, CustomError_466d7fef());
            } else {
                uint256 var_e = var_e + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                require(var_e + ret0.length - var_e >= 0x20);
                require(var_f == address(var_f));
            }
        }
    }
    
    /// @custom:selector    0x2a18a5fb
    /// @custom:signature   Unresolved_2a18a5fb() public view returns (bool)
    function Unresolved_2a18a5fb() public view returns (bool) {
        return uint8(store_h / 0x0100);
    }
    
    /// @custom:selector    0x328d8f72
    /// @custom:signature   Unresolved_328d8f72(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_328d8f72(uint256 arg0) public {
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_h = arg0 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_h;
    }
    
    /// @custom:selector    0x3717f465
    /// @custom:signature   Unresolved_3717f465(bool arg0) public
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_3717f465(bool arg0) public {
        require(arg0 < 0x04);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        if (arg0 <= 0x03) {
            store_h = uint8(arg0) * 0x01000000 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffffff & store_h;
        }
    }
    
    /// @custom:selector    0x3b19b9b6
    /// @custom:signature   Unresolved_3b19b9b6() public view returns (bool)
    function Unresolved_3b19b9b6() public view returns (bool) {
        return uint8(store_h / 0x01000000);
    }
    
    /// @custom:selector    0x4f1ef286
    /// @custom:signature   Unresolved_4f1ef286(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4f1ef286(address arg0, uint256 arg1) public {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg1 + 0x1f);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f);
            require(0xba7b889588d6c449a30066344dd47759cfcb4fc0 == address(this), CustomError_e07c8dba());
            require(0xba7b889588d6c449a30066344dd47759cfcb4fc0 != address(this), CustomError_e07c8dba());
            require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
            (bool success, bytes memory ret0) = address(arg0).proxiableUUID(); // staticcall
            if (!success) {
                require(success, CustomError_4c9c8ce3());
                require(var_a == 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, CustomError_aa1d49a4());
                require(0 - address(0x09dd).code.length, CustomError_4c9c8ce3());
                store_i = 0x09dd | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                emit Event_bc7cd75a(0x09dd);
                if (var_e) {
                    (bool success, bytes memory ret0) = address(0x09dd).Unresolved_(memory[var_a:var_a + (var_a + var_e - var_a)]); // delegatecall
                    if (ret0.length == 0) {
                        if (success) {
                            if (var_f) {
                                require(var_f, CustomError_9996b315());
                            } else {
                                require(address(0x09dd).code.length, CustomError_9996b315());
                            }
                        } else {
                            require(var_f, CustomError_d6bda275());
                        }
                    } else {
                        uint256 var_a = var_a + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (success) {
                            require(address(0x09dd).code.length, CustomError_9996b315());
                        } else {
                            require(var_j, CustomError_d6bda275());
                        }
                    }
                }
            } else {
                uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                require(var_a + ret0.length - var_a >= 0x20);
                require(var_j == 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, CustomError_aa1d49a4());
                require(0 - arg0.code.length, CustomError_4c9c8ce3());
                store_i = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
                emit Event_bc7cd75a(arg0);
                if (var_j) {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_a:var_a + (var_a + var_j - var_a)]); // delegatecall
                    if (ret0.length == 0) {
                        if (success) {
                            if (var_f) {
                                require(var_f, CustomError_9996b315());
                            } else {
                                require(arg0.code.length, CustomError_9996b315());
                            }
                        } else {
                            require(var_f, CustomError_d6bda275());
                        }
                    } else {
                        uint256 var_a = var_a + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (success) {
                            require(arg0.code.length, CustomError_9996b315());
                        } else {
                            require(var_j, CustomError_d6bda275());
                        }
                    }
                }
                revert CustomError_4c9c8ce3();
            }
        }
    }
    
    /// @custom:selector    0x51ad3ced
    /// @custom:signature   Unresolved_51ad3ced(address arg0, uint256 arg1) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_51ad3ced(address arg0, uint256 arg1) public pure {
        revert();
    }
    
    /// @custom:selector    0x575e24b4
    /// @custom:signature   Unresolved_575e24b4(address arg0, address arg1, uint256 arg2, uint256 arg3) public returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_575e24b4(address arg0, address arg1, uint256 arg2, uint256 arg3) public returns (bytes memory) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x60);
        require(arg9 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg9] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        require(store_h, CustomError_75884cda());
        require(storage_map_d[arg0].field_0, CustomError_77efb076());
        if (!store_f) {
            if (0x20 >= 0x20 && 0x02 <= 0x03) {
                if (uint8(0x02 & store_h / 0x01000000) - 0x02) {
                    return abi.encodePacked(0x575e24b400000000000000000000000000000000000000000000000000000000, 0, 0);
                } else {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_d737d0c7(var_f); // staticcall
                    if (!success) {
                        require(success, CustomError_466d7fef());
                    } else {
                        uint256 var_g = var_g + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                        require(var_g + ret0.length - var_g >= 0x20);
                        require(var_h == address(var_h));
                    }
                }
            }
            revert();
        } else {
            require(0x24 + (msg.data.length - 0x24) - 0x24 >= 0xa0);
            if (!(var_g + 0xa0 < var_g | var_g + 0xa0 > 0xffffffffffffffff)) {
                require(true);
            }
        }
    }
    
    /// @custom:selector    0x6c2bbe7e
    /// @custom:signature   Unresolved_6c2bbe7e(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_6c2bbe7e(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bytes memory) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x80);
        require(arg12 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg12] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        return abi.encodePacked(0x6c2bbe7e00000000000000000000000000000000000000000000000000000000, arg10);
    }
    
    /// @custom:selector    0x6fe7e6eb
    /// @custom:signature   Unresolved_6fe7e6eb(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6fe7e6eb(address arg0) public pure {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_j = store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x8da995be
    /// @custom:signature   Unresolved_8da995be(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_8da995be(uint256 arg0) public {
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_h = store_h & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff | 0x010000 * arg0;
    }
    
    /// @custom:selector    0x8f3ed683
    /// @custom:signature   Unresolved_8f3ed683(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_8f3ed683(address arg0, uint256 arg1) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        storage_map_d[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_d[arg0];
        emit Event_a34581b4(arg0, arg1, 0);
    }
    
    /// @custom:selector    0x9f063efc
    /// @custom:signature   Unresolved_9f063efc(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_9f063efc(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bytes memory) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x80);
        require(arg12 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg12] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        return abi.encodePacked(0x9f063efc00000000000000000000000000000000000000000000000000000000, arg10);
    }
    
    /// @custom:selector    0xb47b2fb1
    /// @custom:signature   Unresolved_b47b2fb1(address arg0, uint256 arg1, uint256 arg2) public view returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_b47b2fb1(address arg0, uint256 arg1, uint256 arg2) public view returns (bytes memory) {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(msg.data.length - 0xc4 >= 0x60);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(0x04444c5dc75cb358380d2e3de08a90 == msg.sender, CustomError_ae18210a());
        return abi.encodePacked(0xb47b2fb100000000000000000000000000000000000000000000000000000000, 11);
    }
    
    /// @custom:selector    0xb6a8b0fa
    /// @custom:signature   Unresolved_b6a8b0fa(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    function Unresolved_b6a8b0fa(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        if (0x04444c5dc75cb358380d2e3de08a90 == msg.sender) {
            revert CustomError_0a85dc29();
        } else {
            revert CustomError_ae18210a();
        }
    }
    
    /// @custom:selector    0xca039b9a
    /// @custom:signature   Unresolved_ca039b9a(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ca039b9a(uint256 arg0) public {
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_h = store_h & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff | 0x0100 * arg0;
    }
    
    /// @custom:selector    0xd19d9ed6
    /// @custom:signature   Unresolved_d19d9ed6() public view returns (bool)
    function Unresolved_d19d9ed6() public view returns (bool) {
        return uint8(store_h / 0x010000);
    }
    
    /// @custom:selector    0xdc98354e
    /// @custom:signature   Unresolved_dc98354e(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_dc98354e(address arg0) public pure {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
    }
    
    /// @custom:selector    0xe1b4af69
    /// @custom:signature   Unresolved_e1b4af69(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    function Unresolved_e1b4af69(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(true);
        require(msg.data.length - 0x24 >= 0xa0);
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        if (0x04444c5dc75cb358380d2e3de08a90 == msg.sender) {
            revert CustomError_0a85dc29();
        } else {
            revert CustomError_ae18210a();
        }
    }
    
    /// @custom:selector    0xeed1cebd
    /// @custom:signature   Unresolved_eed1cebd(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_eed1cebd(address arg0, uint256 arg1) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        storage_map_g[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[arg0];
        emit Event_a34581b4(arg0, arg1, 0x01);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_j = arg0 | store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
}