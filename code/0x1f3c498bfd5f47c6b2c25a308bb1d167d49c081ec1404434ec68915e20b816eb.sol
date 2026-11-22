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
    uint256 public constant proxiableUUID = e07c8dba;
    bytes public constant unresolved_34baeab9 = ;
    uint256 public constant unresolved_a217fddf = 0;
    bytes public constant unresolved_ad3cb1cc = 0xBytes([53, 46, 48, 46, 48]);
    uint256 public constant USER_ROLE = 9276340973522676567620990596795115421562205486361047220548588695934065051848;
    
    bytes store_a; // storage slot: 0x1e37a1c77141546f2f4f46f3044fc6b4b5dcb31d473b2bd15537c37698fd6201
    bytes store_b; // storage slot: 0x1e37a1c77141546f2f4f46f3044fc6b4b5dcb31d473b2bd15537c37698fd6202
    bytes store_d; // storage slot: 0x1e37a1c77141546f2f4f46f3044fc6b4b5dcb31d473b2bd15537c37698fd6204
    bytes32 store_m; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    uint64 store_l; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    bytes32 storage_map_g; // storage slot: var_e
    bytes32 store_c; // storage slot: var_d
    bytes32 store_i; // storage slot: 0x01 + var_a
    bytes32 store_n; // storage slot: var_j
    uint256 storage_map_e; // storage slot: var_a
    uint256 store_k; // storage slot: var_a + 0x01
    uint8 store_f; // storage slot: var_a
    
    mapping(uint256 => bytes32) storage_map_j; // storage slot: 0x1e37a1c77141546f2f4f46f3044fc6b4b5dcb31d473b2bd15537c37698fd6205
    mapping(uint256 => bytes32) storage_map_h; // storage slot: var_a + 0x05
    
    error CustomError_00000000();
    event Event_2f878811();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_78ecd20d();
    event Event_b13925cb();
    event Event_bc7cd75a();
    event Event_c7f505b2();
    event Event_d6c79c9c();
    event Event_f6391f5c();
    event RoleAdminChanged(bytes32, bytes32, bytes32);
    
    /// @custom:selector    0x6d95a6ba
    /// @custom:signature   initialBlockMetadata() public view returns (bytes memory)
    function initialBlockMetadata() public view returns (bytes memory) {
        return abi.encodePacked(var_g, var_i);
    }
    
    /// @custom:selector    0x994b7857
    /// @custom:signature   latestBlockMetadata() public view returns (bytes memory)
    function latestBlockMetadata() public view returns (bytes memory) {
        return abi.encodePacked(var_h, var_j);
    }
    
    /// @custom:selector    0x901129c2
    /// @custom:signature   setImageId(bytes32 arg0) public returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setImageId(bytes32 arg0) public returns (bool) {
        uint256 var_a = var_a;
        require(storage_map_e[var_e][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        require(arg0, CustomError_f72e3c6c());
        storage_map_e = arg0;
        emit Event_78ecd20d(msg.sender, arg0);
        return true;
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool) {
        require(arg0 == (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000));
        if (0x7965db0b00000000000000000000000000000000000000000000000000000000 == (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000)) {
            return 0x7965db0b00000000000000000000000000000000000000000000000000000000 == (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000);
        } else {
            return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x01ffc9a700000000000000000000000000000000000000000000000000000000;
        }
    }
    
    /// @custom:selector    0x248a9ca3
    /// @custom:signature   Unresolved_248a9ca3(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_248a9ca3(uint256 arg0) public view returns (uint256) {
        uint256 var_a = var_a;
        return storage_map_e[var_a].field_1;
    }
    
    /// @custom:selector    0x2be4a903
    /// @custom:signature   Unresolved_2be4a903(uint256 arg0, address arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2be4a903(uint256 arg0, address arg1) public view returns (bool) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        uint256 var_a = var_a;
        require(storage_map_e[var_d][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        if (0 >= msg.data[0x04 + arg0]) {
            return true;
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
                uint256 var_a = var_a;
                address var_a = address(msg.data[0x20 + (0x04 + arg0)]);
                require(storage_map_e[var_a][address(msg.data[0x20 + (0x04 + arg0)])].field_0, CustomError_cf90c26e());
                uint256 var_a = var_a;
                address var_a = address(msg.data[0x20 + (0x04 + arg0)]);
            }
        }
    }
    
    /// @custom:selector    0x2f2ff15d
    /// @custom:signature   Unresolved_2f2ff15d(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2f2ff15d(uint256 arg0, address arg1) public {
        require(true);
        uint256 var_a = var_a;
        uint256 var_a = var_a;
        require(storage_map_e[msg.sender][msg.sender].field_0, CustomError_e2517d3f());
        uint256 var_a = var_a;
        if (!storage_map_e[arg1][arg1].field_0) {
            storage_map_e[arg0][arg1] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0][arg1];
            emit Event_2f878811(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0x36568abe
    /// @custom:signature   Unresolved_36568abe(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_36568abe(uint256 arg0, address arg1) public {
        require(true);
        require(msg.sender == arg1, CustomError_6697b232());
        uint256 var_a = var_a;
        if (storage_map_e[arg1][arg1].field_0) {
            storage_map_e[arg0][arg1] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0][arg1];
            emit Event_f6391f5c(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public
    function Unresolved_3f4ba83a() public {
        uint256 var_a = var_a;
        require(storage_map_e[var_d][msg.sender].field_0, CustomError_e2517d3f());
        require(store_f, CustomError_8dfc202b());
        require(store_f, CustomError_8dfc202b());
        storage_map_e = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e;
        emit Event_5db9ee0a(var_d);
    }
    
    /// @custom:selector    0x4209fff1
    /// @custom:signature   Unresolved_4209fff1(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_4209fff1(address arg0) public view returns (bool) {
        require(true);
        uint256 var_a = var_a;
        return storage_map_e[arg0][arg0].field_0;
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
            require(0x93d20f8b2798392db91b7cf9ebc111fe2e596378 == address(this), CustomError_e07c8dba());
            require(0x93d20f8b2798392db91b7cf9ebc111fe2e596378 != address(this), CustomError_e07c8dba());
            uint256 var_e = var_e;
            require(storage_map_g[var_i][msg.sender].field_0, CustomError_e2517d3f());
            (bool success, bytes memory ret0) = address(arg0).proxiableUUID(); // staticcall
            if (!success) {
                require(success, CustomError_4c9c8ce3());
                uint256 var_e = var_e;
                require(var_a == var_e, CustomError_aa1d49a4());
                require(0 - address(0x0d66).code.length, CustomError_4c9c8ce3());
                storage_map_g = 0x0d66 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_g;
                emit Event_bc7cd75a(0x0d66);
                if (var_g) {
                    (bool success, bytes memory ret0) = address(0x0d66).Unresolved_(memory[var_a:var_a + (var_g + var_a - var_a)]); // delegatecall
                    if (ret0.length == 0) {
                        if (success) {
                            if (var_h) {
                                require(var_h, CustomError_9996b315());
                            } else {
                                require(address(0x0d66).code.length, CustomError_9996b315());
                            }
                        } else {
                            require(var_h, CustomError_d6bda275());
                        }
                    } else {
                        uint256 var_a = var_a + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (success) {
                            require(address(0x0d66).code.length, CustomError_9996b315());
                        } else {
                            require(var_l, CustomError_d6bda275());
                        }
                    }
                }
            } else {
                uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & ret0.length + 0x1f);
                require(var_a + ret0.length - var_a >= 0x20);
                uint256 var_e = var_e;
                require(var_l == var_e, CustomError_aa1d49a4());
                require(0 - arg0.code.length, CustomError_4c9c8ce3());
                storage_map_g = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_g;
                emit Event_bc7cd75a(arg0);
                if (var_l) {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_a:var_a + (var_l + var_a - var_a)]); // delegatecall
                    if (ret0.length == 0) {
                        if (success) {
                            if (var_h) {
                                require(var_h, CustomError_9996b315());
                            } else {
                                require(arg0.code.length, CustomError_9996b315());
                            }
                        } else {
                            require(var_h, CustomError_d6bda275());
                        }
                    } else {
                        uint256 var_a = var_a + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (success) {
                            require(arg0.code.length, CustomError_9996b315());
                        } else {
                            require(var_l, CustomError_d6bda275());
                        }
                    }
                }
                revert CustomError_4c9c8ce3();
            }
        }
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return store_f;
    }
    
    /// @custom:selector    0x700c9474
    /// @custom:signature   Unresolved_700c9474(uint256 arg0, address arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_700c9474(uint256 arg0, address arg1) public view returns (bool) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        uint256 var_a = var_a;
        require(storage_map_e[var_e][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        if (0 >= msg.data[0x04 + arg0]) {
            return true;
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
                uint256 var_a = var_a;
                address var_a = address(msg.data[0x20 + (0x04 + arg0)]);
                require(!storage_map_e[var_a][address(msg.data[0x20 + (0x04 + arg0)])].field_0, CustomError_f379269e());
                if (0 < msg.data[0x04 + arg0]) {
                    require(0x20 + (0x04 + arg0) + 0x20 - (0x20 + (0x04 + arg0)) >= 0x20);
                    require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
                    require(address(msg.data[0x20 + (0x04 + arg0)]), CustomError_d92e233d());
                    uint256 var_a = var_a;
                    address var_a = address(msg.data[0x20 + (0x04 + arg0)]);
                }
            }
        }
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public
    function Unresolved_8456cb59() public {
        uint256 var_a = var_a;
        require(storage_map_e[var_d][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        require(!store_f, CustomError_d93c0665());
        storage_map_e = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e;
        emit Event_62e78cea(var_d);
    }
    
    /// @custom:selector    0x91d14854
    /// @custom:signature   Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool) {
        require(true);
        uint256 var_a = var_a;
        return storage_map_e[arg1][arg1].field_0;
    }
    
    /// @custom:selector    0x9acdd62b
    /// @custom:signature   Unresolved_9acdd62b(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool)
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_9acdd62b(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool) {
        require(msg.data.length - 0x0104 >= 0x80);
        uint256 var_a = var_a;
        require(storage_map_e[var_t][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        require(storage_map_h[arg8].field_1, CustomError_ccc0f44e());
        require(arg9 == storage_map_h[arg8], CustomError_5d088f78());
        require(storage_map_h[arg8].field_1 == arg10, CustomError_d17edac4());
        require(storage_map_h[arg8].field_2 == arg11, CustomError_b1fab5f7());
        bytes var_j = sha256();
        require(memory[0x20]);
        uint256 var_h = var_h + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_h + ret0.length - var_h >= 0x20);
        (bool success, bytes memory ret0) = address(address(this)).Unresolved_a4344bf4(var_p, var_q); // staticcall
        require(success);
        uint256 var_h = var_h + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_h + ret0.length - var_h >= 0x20);
        require(var_j, CustomError_439cc0cd());
        storage_map_h[arg8].field_1 = 0;
        emit Event_b13925cb(arg8, arg9, arg10, arg11, storage_map_e);
        return true;
    }
    
    /// @custom:selector    0xa4344bf4
    /// @custom:signature   Unresolved_a4344bf4(uint256 arg0, uint256 arg1) public
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_a4344bf4(uint256 arg0, uint256 arg1) public {
        if (!msg.value) {
            uint256 var_a = 0x40 + var_a;
            uint256 var_a = 0x40 + var_a;
            bytes var_r = sha256(0x72697363302e4f75747075740000000000000000000000000000000000000000);
            if (memory[0x20]) {
                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            }
        }
        revert();
    }
    
    /// @custom:selector    0xa4c4a0ae
    /// @custom:signature   Unresolved_a4c4a0ae(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_a4c4a0ae(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool) {
        uint256 var_a = var_a;
        require(storage_map_e[var_e][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        require(arg0 == storage_map_e, CustomError_ccc0f44e());
        require(arg1 == store_i, CustomError_5d088f78());
        require(arg2 > arg0, CustomError_d17edac4());
        require(!storage_map_j[arg0].field_1, CustomError_6df6aa8f());
        storage_map_j[arg0] = arg1;
        storage_map_j[arg0].field_1 = arg2;
        storage_map_j[arg0].field_2 = arg3;
        storage_map_e = arg2;
        store_k = arg3;
        emit Event_d6c79c9c(arg0, arg1, arg2, arg3);
        return true;
    }
    
    /// @custom:selector    0xd547741f
    /// @custom:signature   Unresolved_d547741f(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d547741f(uint256 arg0, address arg1) public {
        require(true);
        uint256 var_a = var_a;
        uint256 var_a = var_a;
        require(storage_map_e[msg.sender][msg.sender].field_0, CustomError_e2517d3f());
        uint256 var_a = var_a;
        if (storage_map_e[arg1][arg1].field_0) {
            storage_map_e[arg0][arg1] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0][arg1];
            emit Event_f6391f5c(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0xe091b1d2
    /// @custom:signature   Unresolved_e091b1d2(uint256 arg0, uint256 arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_e091b1d2(uint256 arg0, uint256 arg1, uint256 arg2) public {
        require(msg.data.length - 0x04 + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0x40);
        if (!(var_a + 0x40 < var_a | var_a + 0x40 > 0xffffffffffffffff) && store_l) {
            if (0x01 != store_l) {
                require(!store_l, CustomError_f92ee8a9());
                store_m = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_m;
                if (var_d) {
                    revert("blockHash is 0x0");
                } else {
                    revert("blockHeight is 0");
                }
            } else {
                require(store_l, CustomError_f92ee8a9());
                require(!address(this).code.length, CustomError_f92ee8a9());
                store_m = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_m;
                require(var_d, "blockHeight is 0");
                require(var_i, "blockHash is 0x0");
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                require(arg0, CustomError_f72e3c6c());
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                require(uint8(store_m / 0x010000000000000000), CustomError_d7e6bcf8());
                store_n = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_n;
                uint256 var_j = var_j;
                uint256 var_j = var_j;
                uint256 var_j = var_j;
                store_n[var_j].field_1 = 0;
                emit RoleAdminChanged(var_j, store_n[var_j].field_1, 0);
                store_n = arg0;
                store_a = var_d;
                store_b = var_i;
                store_n = var_d;
                store_d = var_i;
                if (!uint8(store_m / 0x010000000000000000)) {
                    store_m = 0xffffffffffffffffffffffffffffffffffffffffffffff00ffffffffffffffff & store_m;
                    emit Event_c7f505b2(0x01);
                }
            }
        }
    }
    
    /// @custom:selector    0xe21962c8
    /// @custom:signature   Unresolved_e21962c8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool)
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_e21962c8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public returns (bool) {
        require(msg.data.length - 0x0104 >= 0x80);
        uint256 var_a = var_a;
        require(storage_map_e[var_t][msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        uint256 var_a = var_a;
        require(arg8 == storage_map_e, CustomError_ccc0f44e());
        require(arg9 == store_i, CustomError_5d088f78());
        require(arg10 > arg8, CustomError_d17edac4());
        bytes var_j = sha256();
        require(memory[0x20]);
        uint256 var_h = var_h + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_h + ret0.length - var_h >= 0x20);
        (bool success, bytes memory ret0) = address(address(this)).Unresolved_a4344bf4(var_p, var_q); // staticcall
        require(success);
        uint256 var_h = var_h + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_h + ret0.length - var_h >= 0x20);
        require(var_j, CustomError_439cc0cd());
        storage_map_e = arg10;
        store_k = arg11;
        emit Event_b13925cb(arg8, arg9, arg10, arg11, storage_map_e);
        return true;
    }
}