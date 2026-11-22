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
    uint256 public constant PAYOUT_TYPEHASH = 37532450778387728934608532799306368050364702923315481771079848951118838788244;
    uint256 public constant proxiableUUID = e07c8dba;
    uint256 public constant REFUND_TYPEHASH = 13755749326725598640442268636294534475750072515258237373858509580262762322669;
    uint256 public constant ROLE_OPERATOR = 37192905443760113839885143854607594264370223690986671126437686896065360719372;
    uint256 public constant SETTLE_TYPEHASH = 115509742888363811056445796218865995710135472760642987090264180515787728568700;
    uint256 public constant unresolved_0c181fd8 = 78786660037640096853510701643578545524595037181817153677810769337132050581080;
    uint256 public constant unresolved_178eaee7 = 103373756574356206819893770324642793076802002044979289638744349897448824216954;
    uint256 public constant unresolved_540605b4 = 82223063945097276398718865166222922950437805441039014110854684255327272807755;
    uint256 public constant unresolved_a217fddf = 0;
    uint256 public constant unresolved_ab7a4fd5 = 19995043335963119465103634861377173251439507944022619877932039726745819431651;
    bytes public constant unresolved_ad3cb1cc = 0xBytes([53, 46, 48, 46, 48]);
    uint256 public constant unresolved_af2371e3 = 19412740327428711550772657841808089577857706254093401021584828200395234921024;
    uint256 public constant unresolved_af7ecff9 = 86521183950019854145077495798178605851424214918948498156018235428425636053694;
    uint256 public constant unresolved_b35b0d17 = 44012886089242825404661619425693509165324153288263244703690731798414564238157;
    uint256 public constant unresolved_b5470a98 = 70159515250495948824632524426815037383533658352493956186501246471280661711095;
    uint256 public constant unresolved_c60c7ecc = 63840894025396317853582771440392111842355159150948789268836302512601262331093;
    uint256 public constant unresolved_d391014b = 101111883721194797686535296169014623465011523193779125151422136512530317962306;
    uint256 public constant unresolved_d70e1ede = 26110773011063944554076775869347847167970265429588832319557527771570829320956;
    
    bytes store_ab; // storage slot: 0x019d3d0c2386ec3a05bb7001d2bbf079e6fe7bfbe6e95c923cb544f16e2385d9
    bytes store_q; // storage slot: 0x51d2c77e75fa4d7ea979836bebb592139941dd73acf569f643c01539efd328d4
    bytes store_p; // storage slot: 0x588e3be47976de1e9be56dc3bdfce9157c2131526fea89e363a4d1ed55ae1859
    bytes store_w; // storage slot: 0x615f0f9e84155bea8cc509fe18befeb1baf65611e38a6ba60964480fb29dfd44
    bytes store_a; // storage slot: 0x7373abf07576b601f64b36d74d862c7ba4181047674cccb39b488c1eee141e07
    bytes32 store_m; // storage slot: 0xa16a46d94261c7517cc8ff89f61c0ce93598e3c849801011dee649a6a557d100
    bytes store_s; // storage slot: 0xbdd4b8ad92694a910d2f7f659e0a8a4820c6dc00ed877085b9e78c9edfac1923
    bytes store_x; // storage slot: 0xcce5cadda4dca873250efd56882ba972f6be8519e5afa32ce3bf6829be0c7450
    bytes store_aa; // storage slot: 0xe11a34afe3a4322837f3b0886264216d62207d623645d1ad18c60c7172cd7a42
    address store_d; // storage slot: var_a
    bytes32 store_n; // storage slot: var_k
    bytes32 store_v; // storage slot: var_e
    uint64 store_y; // storage slot: var_a
    uint8 store_f; // storage slot: var_a
    uint8 store_z; // storage slot: var_a
    
    mapping(uint256 => bytes32) storage_map_k; // storage slot: 0x2c355a1029f7297de90b706beea350b0073a5f8d06c07726a159113e4caa7d69
    mapping(address => bytes32) storage_map_h; // storage slot: 0x2c355a1029f7297de90b706beea350b0073a5f8d06c07726a159113e4caa7d6c
    mapping(address => mapping(address => uint256)) public unresolved_82f70db4; // storage slot: 0x2c355a1029f7297de90b706beea350b0073a5f8d06c07726a159113e4caa7d6d
    mapping(address => uint8) storage_map_o; // storage slot: 0x5dfc6369ede8c1331430c00b581919993675ec010140508e8a499d5c8bfbd937
    mapping(address => uint8) storage_map_j; // storage slot: 0x5ec2739e5d83ac0ee57f9f9a8bc0de261073ceffe84d59692a58d0a7bbee3e32
    mapping(address => uint8) storage_map_e; // storage slot: 0x5f52b57fe2ea4ba064594896bf573c2cd442761f9f30104b34af5edf1d70ea72
    mapping(address => bytes32) storage_map_ad; // storage slot: 0x615f0f9e84155bea8cc509fe18befeb1baf65611e38a6ba60964480fb29dfd45
    mapping(address => uint8) storage_map_b; // storage slot: 0x78e571b7bf30584d955e1c6444a2b5147087edf9f00485d94993a04d370525ea
    mapping(address => uint8) storage_map_t; // storage slot: 0x7c25c5c5d1ec2682edbcfd7967c72eb29f6879627c076c7a887c69b96cdedff0
    mapping(address => uint8) storage_map_r; // storage slot: 0xb7db2dd08fcb62d0c9e08c51941cae53c267786a0b75803fb7960902fc8ef97d
    mapping(uint256 => uint8) storage_map_g; // storage slot: 0xbc6704768de17ac743a4c41122099f7a3464fc20363467b8527e22c7572f5d3a
    mapping(uint128 => uint8) storage_map_ac; // storage slot: 0xc1a0c9a702489f682940fb04bcd302d97ae201e4611a2e2586c8533588103801
    mapping(uint256 => bytes32) storage_map_i; // storage slot: 0xc1a0c9a702489f682940fb04bcd302d97ae201e4611a2e2586c8533588103802
    mapping(address => uint8) storage_map_l; // storage slot: 0xc1a0c9a702489f682940fb04bcd302d97ae201e4611a2e2586c8533588103803
    mapping(uint256 => mapping(address => bytes32)) storage_map_c; // storage slot: var_a
    
    error CustomError_00000000();
    event Approved(address, address, uint256);
    event Event_2f878811();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_64336c2c();
    event Event_955cface();
    event Event_bc7cd75a();
    event Event_f6391f5c();
    
    /// @custom:selector    0xa5de3619
    /// @custom:signature   admins() public view returns (bytes memory)
    function admins() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0x6f39feec
    /// @custom:signature   batchRevokeRole(bytes32 arg0, address[] arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function batchRevokeRole(bytes32 arg0, address[] arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_1e3a8d9c());
            require(msg.data[0x04 + arg1], CustomError_b0a6c30a());
            if (0 < msg.data[0x04 + arg1] && 0 < msg.data[0x04 + arg1]) {
                require(!(address(msg.data[0x04 + arg1 + 0x20]) - msg.data[0x04 + arg1 + 0x20]));
                uint256 var_a = var_a;
                require(0x01 != store_a, CustomError_df0e465e());
                uint256 var_a = var_a;
                address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                if (storage_map_c[var_a][address(msg.data[0x04 + arg1 + 0x20])].field_0) {
                    uint256 var_a = var_a;
                    address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                    storage_map_c[var_a][address(msg.data[0x04 + arg1 + 0x20])] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[var_a][address(msg.data[0x04 + arg1 + 0x20])];
                    emit Event_f6391f5c(arg0, address(msg.data[0x04 + arg1 + 0x20]), msg.sender);
                    uint256 var_a = var_a;
                    address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0xb0f479a1
    /// @custom:signature   getRouter() public view returns (address)
    function getRouter() public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_d;
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
        if ((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) != 0x5a05180f00000000000000000000000000000000000000000000000000000000) {
            if ((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) != 0x7965db0b00000000000000000000000000000000000000000000000000000000) {
                return 0x01ffc9a700000000000000000000000000000000000000000000000000000000 == (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000);
            } else {
                return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x7965db0b00000000000000000000000000000000000000000000000000000000;
            }
        } else {
            return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x5a05180f00000000000000000000000000000000000000000000000000000000;
        }
    }
    
    /// @custom:selector    0x14706849
    /// @custom:signature   Unresolved_14706849(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    function Unresolved_14706849(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0120);
        require(0xe0 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(arg7 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg7] <= 0xffffffffffffffff);
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        require(storage_map_e[msg.sender].field_0, CustomError_e2517d3f());
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg6 > block.timestamp, CustomError_4b2d84db());
        require(!(arg5 - arg5));
        require(arg5 - arg5, CustomError_ae8de312());
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_d = msg.data[0x04 + arg1];
            uint256 var_e = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + var_d];
            require(!store_f, CustomError_d93c0665());
            if (var_g > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                if (0x04 > 0x03) {
                    if (0x04 > 0x03) {
                        if (0x04 > 0x03) {
                            require(0x04 <= 0x03, CustomError_d78bce0c());
                            revert CustomError_fce698f7();
                        }
                        revert CustomError_f645eedf();
                    }
                    require(storage_map_g[0].field_0, CustomError_d855c4f4());
                    return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                }
            } else {
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0x1be1c18f
    /// @custom:signature   Unresolved_1be1c18f(address arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_1be1c18f(address arg0, uint256 arg1, uint256 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_c4c4d4e1());
            if (!arg1) {
                storage_map_h[arg0] = 0;
                storage_map_h[arg0].field_1 = 0;
            } else {
                if (!(var_e + 0x40 > 0xffffffffffffffff | var_e + 0x40 < var_e)) {
                    storage_map_h[arg0] = uint8(var_h) | storage_map_h[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
                    storage_map_h[arg0].field_1 = var_i;
                }
            }
        }
    }
    
    /// @custom:selector    0x215a17dc
    /// @custom:signature   Unresolved_215a17dc(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_215a17dc(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(uint128(arg0) - arg0));
        bytes32 var_c = storage_map_i[uint128(arg0) >> 0x08] & 0x01 << uint8(uint128(arg0));
        return var_c;
    }
    
    /// @custom:selector    0x248a9ca3
    /// @custom:signature   Unresolved_248a9ca3(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_248a9ca3(uint256 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        uint256 var_a = var_a;
        var_c = storage_map_c[var_a].field_1;
        return var_c;
    }
    
    /// @custom:selector    0x250bf93a
    /// @custom:signature   Unresolved_250bf93a(bool arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    function Unresolved_250bf93a(bool arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0100);
        require(!(arg1 - arg1));
        require(!(arg3 - arg3));
        require(!(arg5 - arg5));
        require(arg7 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg7] <= 0xffffffffffffffff);
        require(storage_map_j[msg.sender].field_0, CustomError_e2517d3f());
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg6 > block.timestamp, CustomError_4b2d84db());
        require(storage_map_h[arg1].field_0, CustomError_d334e6bd());
        require(arg2 <= storage_map_h[arg1].field_1, CustomError_f76aa3d7());
        require(!(storage_map_k[arg0 >> 0x08] & 0x01 << uint8(arg0)), CustomError_dc41af2c());
        bytes32 var_a = arg0 >> 0x08;
        storage_map_k[var_a] = storage_map_k[var_a] | 0x01 << uint8(arg0);
        require(arg3, CustomError_c4c4d4e1());
        require(arg3, CustomError_c4c4d4e1());
        require(arg1, CustomError_c4c4d4e1());
        (bool success, bytes memory ret0) = address(arg1).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
            uint256 var_g = var_g + 0x20;
            require(var_g + 0x20 - var_g < 0x20);
        }
    }
    
    /// @custom:selector    0x2a189430
    /// @custom:signature   Unresolved_2a189430(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2a189430(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_l[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x2ddda188
    /// @custom:signature   Unresolved_2ddda188(address arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_2ddda188(address arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xc0);
        require(!(uint128(arg0) - arg0));
        require(!(arg1 - arg1));
        require(!(arg3 - arg3));
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(storage_map_e[msg.sender].field_0, CustomError_e2517d3f());
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg4 > block.timestamp, CustomError_4b2d84db());
        require(arg3, CustomError_c4c4d4e1());
        require(arg2, CustomError_7a07d531());
        require(storage_map_h[arg1].field_0, CustomError_d334e6bd());
        require(arg2 <= storage_map_h[arg1].field_1, CustomError_f76aa3d7());
        if (!(var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_l)) {
            uint256 var_l = var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (storage_map_c >> 0x01 < 0x20 != (storage_map_c & 0x01) && !(var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_l)) {
                uint256 var_l = var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            }
        }
    }
    
    /// @custom:selector    0x2f2ff15d
    /// @custom:signature   Unresolved_2f2ff15d(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2f2ff15d(uint256 arg0, address arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_1e3a8d9c());
            uint256 var_a = var_a;
            if (!storage_map_c[arg1][arg1].field_0) {
                uint256 var_a = var_a;
                storage_map_c[arg1][arg1] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg1][arg1];
                emit Event_2f878811(arg0, arg1, msg.sender);
                uint256 var_a = var_a;
            }
        }
    }
    
    /// @custom:selector    0x3271ba8d
    /// @custom:signature   Unresolved_3271ba8d(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7, uint256 arg8) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    function Unresolved_3271ba8d(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7, uint256 arg8) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0120);
        require(!(arg1 - arg1));
        require(!(arg3 - arg3));
        require(!(arg5 - arg5));
        require(arg7 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg7] <= 0xffffffffffffffff);
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        if (!(var_j + 0x0120 > 0xffffffffffffffff | var_j + 0x0120 < var_j)) {
            uint256 var_j = var_j + 0x0120;
            if (store_n >> 0x01 < 0x20 != (store_n & 0x01) && !(var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                uint256 var_j = var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            }
        }
    }
    
    /// @custom:selector    0x33b5b0b5
    /// @custom:signature   Unresolved_33b5b0b5(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_33b5b0b5(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_h[arg0].field_0;
        var_d = storage_map_h[arg0].field_1;
        return abi.encodePacked(var_c, var_d);
    }
    
    /// @custom:selector    0x36568abe
    /// @custom:signature   Unresolved_36568abe(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_36568abe(uint256 arg0, address arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(!(arg1 - msg.sender), CustomError_6697b232());
        uint256 var_a = var_a;
        require(0x01 != store_a, CustomError_df0e465e());
        uint256 var_a = var_a;
        if (storage_map_c[arg1][arg1].field_0) {
            uint256 var_a = var_a;
            storage_map_c[arg1][arg1] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg1][arg1];
            emit Event_f6391f5c(arg0, arg1, msg.sender);
            uint256 var_a = var_a;
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable
    function Unresolved_3f4ba83a() public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(store_f, CustomError_8dfc202b());
            storage_map_c = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c;
            emit Event_5db9ee0a(msg.sender);
        }
    }
    
    /// @custom:selector    0x41d5e516
    /// @custom:signature   Unresolved_41d5e516(address arg0, uint256 arg1, address arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_41d5e516(address arg0, uint256 arg1, address arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg2 - arg2));
        require(storage_map_o[msg.sender].field_0, CustomError_e2517d3f());
        require(arg2, CustomError_c4c4d4e1());
        require(!(arg2 - store_d), CustomError_f37d38f3());
        require(arg0, CustomError_c4c4d4e1());
        if (0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee != arg0) {
            (bool success, bytes memory ret0) = address(var_m).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            if (success) {
                if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                    uint256 var_g = var_g + 0x20;
                    require(var_g + 0x20 - var_g < 0x20);
                }
            } else {
                address var_i = var_o;
                if (!(var_g + (var_g + 0x64 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x64 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                    (bool success, bytes memory ret0) = address(var_m).Unresolved_a9059cbb(var_i); // call
                    require(success);
                    require(!ret0.length, CustomError_5274afe7());
                    require(arg0.code.length, CustomError_5274afe7());
                    (bool success, bytes memory ret0) = address(var_m).Unresolved_70a08231(address(this)); // staticcall
                    require(success);
                    if (!success && 0 <= 0) {
                        emit Event_64336c2c(msg.sender, arg0, 0, arg2);
                    }
                }
            }
        } else {
            payable(address(arg2)).transfer(arg1);
            if (!ret0.length) {
                require(success, CustomError_3022f2e4());
                emit Event_64336c2c(msg.sender, arg0, arg1, arg2);
            }
        }
    }
    
    /// @custom:selector    0x4305f110
    /// @custom:signature   Unresolved_4305f110() public view returns (bytes memory)
    function Unresolved_4305f110() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0x46b5cb59
    /// @custom:signature   Unresolved_46b5cb59(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_46b5cb59(uint256 arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_1e3a8d9c());
            require(msg.data[0x04 + arg1], CustomError_b0a6c30a());
            if (0 < msg.data[0x04 + arg1] && 0 < msg.data[0x04 + arg1]) {
                require(!(address(msg.data[0x04 + arg1 + 0x20]) - msg.data[0x04 + arg1 + 0x20]));
                require(address(msg.data[0x04 + arg1 + 0x20]), CustomError_c4c4d4e1());
                if (0 < msg.data[0x04 + arg1]) {
                    require(!(address(msg.data[0x04 + arg1 + 0x20]) - msg.data[0x04 + arg1 + 0x20]));
                    uint256 var_a = var_a;
                    address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                    if (storage_map_c[var_a][address(msg.data[0x04 + arg1 + 0x20])].field_0) {
                        uint256 var_a = var_a;
                        address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                        if (storage_map_c[var_a].field_1[address(msg.data[0x04 + arg1 + 0x20])] < 0x010000000000000000) {
                            storage_map_c[0x4e487b7100000000000000000000000000000000000000000000000000000000].field_1[address(msg.data[0x04 + arg1 + 0x20])] += 0x01;
                        }
                    } else {
                        uint256 var_a = var_a;
                        address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                        storage_map_c[var_a][var_a] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[var_a][var_a];
                        emit Event_2f878811(arg0, var_a, msg.sender);
                        uint256 var_a = var_a;
                        address var_a = address(msg.data[0x04 + arg1 + 0x20]);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x46e48cc4
    /// @custom:signature   Unresolved_46e48cc4(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_46e48cc4(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg3 > block.timestamp, CustomError_4b2d84db());
        require(!(arg1 - arg1));
        require(storage_map_h[arg1].field_0, CustomError_d334e6bd());
        require(arg2 <= storage_map_h[arg1].field_1, CustomError_f76aa3d7());
        require(!(uint128(arg0) - arg0));
        require(!(arg1 - arg1));
        if (!(var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_l)) {
            uint256 var_l = var_l + (var_l + 0xe0 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (storage_map_c >> 0x01 < 0x20 != (storage_map_c & 0x01) && !(var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_l)) {
                uint256 var_l = var_l + (var_l + 0x20 - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            }
        }
    }
    
    /// @custom:selector    0x46f0975a
    /// @custom:signature   Unresolved_46f0975a() public view returns (bytes memory)
    function Unresolved_46f0975a() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0x4f1ef286
    /// @custom:signature   Unresolved_4f1ef286(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4f1ef286(address arg0, uint256 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg1];
            require(0xc01af02cf17f3dee5857da085d5f58c28375d5d3 == address(this), CustomError_e07c8dba());
            require(0xc01af02cf17f3dee5857da085d5f58c28375d5d3 != address(this), CustomError_e07c8dba());
            require(storage_map_r[msg.sender].field_0, CustomError_e2517d3f());
            (bool success, bytes memory ret0) = address(msg.sender).proxiableUUID(); // staticcall
            if (!success) {
                require(success, CustomError_4c9c8ce3());
                uint256 var_a = var_a;
                require(!(0 - var_a), CustomError_aa1d49a4());
                require(arg0.code.length, CustomError_4c9c8ce3());
                storage_map_c = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_c;
                emit Event_bc7cd75a(arg0);
                if (var_i) {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_c + 0x20:var_c + 0x20 + var_i]); // delegatecall
                    if (!ret0.length) {
                        if (success) {
                            if (!var_j) {
                                require(arg0.code.length, CustomError_9996b315());
                            } else {
                                require(var_j, CustomError_9996b315());
                            }
                        } else {
                            require(var_j, CustomError_d6bda275());
                        }
                    } else {
                        if (ret0.length <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                            if (success) {
                                require(arg0.code.length, CustomError_9996b315());
                            } else {
                                require(var_i, CustomError_d6bda275());
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x551512de
    /// @custom:signature   Unresolved_551512de(address arg0, uint256 arg1, address arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_551512de(address arg0, uint256 arg1, address arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg2 - arg2));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg2, CustomError_c4c4d4e1());
            if (arg1) {
                require(arg0, CustomError_c4c4d4e1());
                if (0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee != arg0) {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
                    require(success);
                    if (success) {
                        if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                            uint256 var_g = var_g + 0x20;
                            require(var_g + 0x20 - var_g < 0x20);
                        }
                    } else {
                        if (!(var_g + (var_g + 0x64 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x64 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                            (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(arg2); // call
                            require(success);
                            require(!ret0.length, CustomError_5274afe7());
                            require(arg0.code.length, CustomError_5274afe7());
                            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
                            require(success);
                        }
                    }
                } else {
                    payable(address(arg2)).transfer(arg1);
                    if (!ret0.length) {
                        require(success, CustomError_3022f2e4());
                    }
                }
            } else {
                require(arg0, CustomError_c4c4d4e1());
                (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), arg2); // staticcall
                require(success);
            }
        }
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_f;
    }
    
    /// @custom:selector    0x60f525ed
    /// @custom:signature   Unresolved_60f525ed(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_60f525ed(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_c4c4d4e1());
            storage_map_c = storage_map_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
            return ;
        }
    }
    
    /// @custom:selector    0x68ae21c2
    /// @custom:signature   Unresolved_68ae21c2(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_68ae21c2(uint256 arg0, uint256 arg1) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(msg.data[0x04 + arg0], CustomError_b0a6c30a());
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(!(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]));
                require(address(msg.data[0x04 + arg0 + 0x20]), CustomError_c4c4d4e1());
                if (0 < msg.data[0x04 + arg0]) {
                    require(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0x7446cc56
    /// @custom:signature   Unresolved_7446cc56() public view returns (bytes memory)
    function Unresolved_7446cc56() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0x79d607fe
    /// @custom:signature   Unresolved_79d607fe(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_79d607fe(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(uint128(arg0) - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg1 + msg.data[0x04 + arg1] * 0x60 + 0x24 <= msg.data.length);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(storage_map_t[msg.sender].field_0, CustomError_e2517d3f());
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg2 > block.timestamp, CustomError_4b2d84db());
        require(msg.data[0x04 + arg1], CustomError_b0a6c30a());
        require(!(storage_map_i[uint128(arg0) >> 0x08] & 0x01 << uint8(uint128(arg0))), CustomError_38354858());
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_e + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_e + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_e)) {
            uint256 var_e = var_e + (0x20 + (var_f << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_f = msg.data[0x04 + arg1];
            if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && (0 < msg.data[0x04 + arg1] && 0 < msg.data[0x04 + arg1])) {
                require(!(address(msg.data[arg1 + 0x24]) - msg.data[arg1 + 0x24]));
                if (0 < msg.data[0x04 + arg1]) {
                    require(!(address(msg.data[arg1 + 0x24 + 0x20]) - msg.data[arg1 + 0x24 + 0x20]));
                }
            }
        }
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable
    function Unresolved_8456cb59() public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        require(storage_map_o[msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        storage_map_c = storage_map_c & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view returns (uint256)
    function Unresolved_84b0196e() public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        require(!store_m, "EIP712: Uninitialized");
        if (store_v >> 0x01 < 0x20 != (store_v & 0x01) && !(var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_g = var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (store_v >> 0x01 < 0x20 != (store_v & 0x01) && !(var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                uint256 var_g = var_g + (var_g + 0x20 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                    uint256 var_g = var_g + 0x20;
                    return abi.encodePacked(0x0f00000000000000000000000000000000000000000000000000000000000000, 0xe0, (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_n) + (var_g + 0xe0) + 0x20 - var_g, block.chainid, address(this), 0, (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_n) + ((0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_n) + (var_g + 0xe0) + 0x20) + 0x20 - var_g, var_n, var_n, var_n);
                }
            }
        }
    }
    
    /// @custom:selector    0x9010d07c
    /// @custom:signature   Unresolved_9010d07c(uint256 arg0, uint256 arg1) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9010d07c(uint256 arg0, uint256 arg1) public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        uint256 var_a = var_a;
        if (arg1 < storage_map_c[var_a]) {
            var_a = keccak256(var_a, var_a);
            var_d = storage_map_c[var_a][arg1].field_0;
            return var_d;
        }
    }
    
    /// @custom:selector    0x91d14854
    /// @custom:signature   Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        uint256 var_a = var_a;
        var_c = storage_map_c[arg1][arg1].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x92a49331
    /// @custom:signature   Unresolved_92a49331(address arg0) public pure
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_92a49331(address arg0) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(uint128(arg0) - arg0));
    }
    
    /// @custom:selector    0x92cda791
    /// @custom:signature   Unresolved_92cda791(bool arg0) public view returns (bool)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_92cda791(bool arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        bytes32 var_c = storage_map_k[arg0 >> 0x08] & 0x01 << uint8(arg0);
        return var_c;
    }
    
    /// @custom:selector    0x92cea0d6
    /// @custom:signature   Unresolved_92cea0d6(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_92cea0d6(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(!(uint128(arg0) - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg4 > block.timestamp, CustomError_4b2d84db());
        require(!(msg.sender - store_d), CustomError_fb217bcd());
        (bool success, bytes memory ret0) = address(store_d).Unresolved_d737d0c7(var_e); // staticcall
        require(success);
        if (!success) {
            require(!(0 - arg1), CustomError_195fdd63());
            require(storage_map_h[arg2].field_0, CustomError_d334e6bd());
            if (!(var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_m)) {
                uint256 var_m = var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (storage_map_c >> 0x01 < 0x20 != (storage_map_c & 0x01) && !(var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_m)) {
                    uint256 var_m = var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                }
            }
        }
    }
    
    /// @custom:selector    0x963bf6bd
    /// @custom:signature   Unresolved_963bf6bd() public view returns (address)
    function Unresolved_963bf6bd() public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_d;
    }
    
    /// @custom:selector    0xa3246ad3
    /// @custom:signature   Unresolved_a3246ad3(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_a3246ad3(uint256 arg0) public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0xaffe39c1
    /// @custom:signature   Unresolved_affe39c1() public view returns (bytes memory)
    function Unresolved_affe39c1() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0xba1ea42d
    /// @custom:signature   Unresolved_ba1ea42d(address arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_ba1ea42d(address arg0, address arg1, uint256 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            unresolved_82f70db4[var_e][var_f] = arg2;
            emit Event_955cface(arg0, arg1, arg2);
        }
    }
    
    /// @custom:selector    0xc0d78655
    /// @custom:signature   Unresolved_c0d78655(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c0d78655(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_c4c4d4e1());
            storage_map_c = storage_map_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
            return ;
        }
    }
    
    /// @custom:selector    0xc21fdc8f
    /// @custom:signature   Unresolved_c21fdc8f() public view returns (bytes memory)
    function Unresolved_c21fdc8f() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0xc4d66de8
    /// @custom:signature   Unresolved_c4d66de8(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c4d66de8(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(store_y, CustomError_f92ee8a9());
        require(!address(this).code.length, CustomError_f92ee8a9());
        storage_map_c = storage_map_c & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 | 0x01;
        if (!arg0) {
            revert CustomError_c4c4d4e1();
        } else {
            revert CustomError_d7e6bcf8();
        }
    }
    
    /// @custom:selector    0xca15c873
    /// @custom:signature   Unresolved_ca15c873(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ca15c873(uint256 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        uint256 var_a = var_a;
        var_c = storage_map_c[var_a];
        return var_c;
    }
    
    /// @custom:selector    0xca799b70
    /// @custom:signature   Unresolved_ca799b70() public view returns (bytes memory)
    function Unresolved_ca799b70() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0xd547741f
    /// @custom:signature   Unresolved_d547741f(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d547741f(uint256 arg0, address arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        if (!storage_map_b[msg.sender].field_0) {
            uint256 var_a = var_a;
            revert CustomError_e2517d3f();
        } else {
            require(arg0, CustomError_1e3a8d9c());
            uint256 var_a = var_a;
            require(0x01 != store_a, CustomError_df0e465e());
            uint256 var_a = var_a;
            if (storage_map_c[arg1][arg1].field_0) {
                uint256 var_a = var_a;
                storage_map_c[arg1][arg1] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg1][arg1];
                emit Event_f6391f5c(arg0, arg1, msg.sender);
                uint256 var_a = var_a;
            }
        }
    }
    
    /// @custom:selector    0xe1f21c67
    /// @custom:signature   Unresolved_e1f21c67(address arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_e1f21c67(address arg0, address arg1, uint256 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(storage_map_o[msg.sender].field_0, CustomError_e2517d3f());
        require(!store_f, CustomError_d93c0665());
        require(arg2 <= unresolved_82f70db4[arg0][arg1], CustomError_f76aa3d7());
        address var_f = var_k;
        if (!(var_i + 0x80 > 0xffffffffffffffff | var_i + 0x80 < var_i)) {
            (bool success, bytes memory ret0) = address(var_j).Unresolved_095ea7b3(var_f); // call
            emit Approved(arg0, arg1, arg2);
        }
    }
    
    /// @custom:selector    0xe673df8a
    /// @custom:signature   Unresolved_e673df8a() public view returns (bytes memory)
    function Unresolved_e673df8a() public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        uint256 var_a = var_a;
        if (!(var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x20 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            return abi.encodePacked(0x20, var_h);
        }
    }
    
    /// @custom:selector    0xe6d2d03f
    /// @custom:signature   Unresolved_e6d2d03f(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_e6d2d03f(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(!(uint128(arg0) - arg0));
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg4 > block.timestamp, CustomError_4b2d84db());
        require(arg3, CustomError_d322c8ed());
        require(!(msg.sender - store_d), CustomError_fb217bcd());
        (bool success, bytes memory ret0) = address(store_d).Unresolved_d737d0c7(var_e); // staticcall
        require(success);
        if (!success) {
            require(!(0 - arg1), CustomError_195fdd63());
            require(storage_map_h[arg2].field_0, CustomError_d334e6bd());
            if (!(var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_m)) {
                uint256 var_m = var_m + (var_m + 0xe0 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (storage_map_c >> 0x01 < 0x20 != (storage_map_c & 0x01) && !(var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_m)) {
                    uint256 var_m = var_m + (var_m + 0x20 - var_m + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                }
            }
        }
    }
    
    /// @custom:selector    0xe8238400
    /// @custom:signature   Unresolved_e8238400(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_e8238400(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(uint128(arg0) - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(storage_map_e[msg.sender].field_0, CustomError_e2517d3f());
        require(storage_map_c != 0x02, CustomError_3ee5aeb5());
        storage_map_c = 0x02;
        require(!store_f, CustomError_d93c0665());
        require(arg2 > block.timestamp, CustomError_4b2d84db());
        if (0x07 > storage_map_ac[uint128(arg0)].field_0) {
            if (storage_map_ac[uint128(arg0)].field_0 - 0x01) {
                require(0x07 <= storage_map_ac[uint128(arg0)].field_0, CustomError_80858117());
            } else {
                require(arg1 <= storage_map_ac[uint128(arg0)].field_2, CustomError_333d1b2c());
                if (!(var_j + (var_j + 0x20 + 0x80 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x20 + 0x80 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                    uint256 var_j = var_j + (var_j + 0x20 + 0x80 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    if (storage_map_c >> 0x01 < 0x20 != (storage_map_c & 0x01) && !(var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                        uint256 var_j = var_j + (var_j + 0x20 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_r[msg.sender].field_0, CustomError_e2517d3f());
        require(arg0, CustomError_c4c4d4e1());
        require(msg.sender != arg0, CustomError_1f2f0f2a());
        uint256 var_a = var_a;
        if (storage_map_c[arg0][arg0].field_0) {
            uint256 var_a = var_a;
            if (0 == !storage_map_ad[arg0]) {
                uint256 var_a = var_a;
                if (storage_map_c[msg.sender][msg.sender].field_0) {
                    uint256 var_a = var_a;
                    storage_map_c[msg.sender][msg.sender] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[msg.sender][msg.sender];
                    emit Event_f6391f5c(0, msg.sender, msg.sender);
                    uint256 var_a = var_a;
                }
            }
        } else {
            uint256 var_a = var_a;
            storage_map_c[arg0][arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg0][arg0];
            emit Event_2f878811(0, arg0, msg.sender);
            uint256 var_a = var_a;
            uint256 var_a = var_a;
        }
    }
}