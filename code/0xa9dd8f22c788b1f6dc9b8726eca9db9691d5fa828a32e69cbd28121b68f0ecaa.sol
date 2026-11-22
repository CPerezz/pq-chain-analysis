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
    uint256 public constant endpoint = 149950853274462145569822531066857990848566424204;
    uint256 public constant ENDPOINT_ID = 30101;
    uint256 public constant MAX_FILLS_PER_SETTLE = 100;
    bytes public constant oAppVersion = 00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_l; // storage slot: 0x00
    uint256 store_h; // storage slot: 0x02
    bytes32 store_k; // storage slot: 0x03
    uint8 store_i; // storage slot: 0x03
    uint256 store_j; // storage slot: 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff + (keccak256(keccak256(address(arg1), keccak256(uint32(arg0), 0x09))) + storage_map_g[uint32(arg0)][address(arg1)])
    
    mapping(uint32 => uint256) public peers; // storage slot: 0x01
    mapping(address => mapping(address => bytes32)) storage_map_m; // storage slot: 0x04
    mapping(uint256 => bytes32) storage_map_d; // storage slot: 0x05
    mapping(uint256 => bytes32) storage_map_e; // storage slot: 0x06
    mapping(address => bytes32) storage_map_b; // storage slot: 0x07
    mapping(address => bytes32) storage_map_c; // storage slot: 0x08
    mapping(uint32 => mapping(address => uint256)) storage_map_g; // storage slot: 0x09
    
    error NoPeer(uint32);
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event Event_f4358078();
    event PeerSet(uint32, bytes32);
    event Withdraw(address, address, uint256);
    
    /// @custom:selector    0xedb25d81
    /// @custom:signature   addAllowedHook(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addAllowedHook(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_b[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[arg0];
    }
    
    /// @custom:selector    0x595490c8
    /// @custom:signature   addAllowedSolver(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addAllowedSolver(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_c[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg0];
    }
    
    /// @custom:selector    0x95ccea67
    /// @custom:signature   emergencyWithdraw(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function emergencyWithdraw(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        if (!address(this).balance) {
            if (arg1) {
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(unresolved_8da5cb5b); // call
                require(success);
                if (!ret0.length) {
                    require(arg0.code.length, CustomError_5274afe7());
                } else {
                    require(0x01 == var_i, CustomError_5274afe7());
                }
            }
        } else {
            payable(address(unresolved_8da5cb5b)).transfer(address(this).balance);
            revert("Ether withdrawal failed");
        }
    }
    
    /// @custom:selector    0x344ba6fd
    /// @custom:signature   isAllowedHook(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isAllowedHook(address arg0) public view returns (bool) {
        require(true);
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x7de63734
    /// @custom:signature   isAllowedSolver(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isAllowedSolver(address arg0) public view returns (bool) {
        require(true);
        return storage_map_c[arg0].field_0;
    }
    
    /// @custom:selector    0x7d25a05e
    /// @custom:signature   nextNonce(uint32 arg0, bytes32 arg1) public pure returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function nextNonce(uint32 arg0, bytes32 arg1) public pure returns (uint256) {
        require(true);
        return 0;
    }
    
    /// @custom:selector    0x9c3f1e90
    /// @custom:signature   orders(bytes32 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orders(bytes32 arg0) public view returns (bytes memory) {
        return abi.encodePacked(storage_map_d[arg0].field_0.field_0, uint128(storage_map_d[arg0] / 0x0100000000000000000000000000000000), storage_map_d[arg0].field_1.field_0.field_0, storage_map_d[arg0].field_2.field_0.field_0, uint32(storage_map_d[arg0].field_2 / 0x010000000000000000000000000000000000000000), uint32(storage_map_d[arg0].field_2 / 0x01000000000000000000000000000000000000000000000000), uint32(storage_map_d[arg0].field_2 / 0x0100000000000000000000000000000000000000000000000000000000), storage_map_d[arg0].field_3.field_0.field_0, address(storage_map_d[arg0].field_3 / 0x0100000000), storage_map_d[arg0].field_4.field_0.field_0);
    }
    
    /// @custom:selector    0x2dff692d
    /// @custom:signature   orderStatus(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orderStatus(bytes32 arg0) public view returns (bool) {
        if (storage_map_e[arg0].field_0 < 0x05) {
            return storage_map_e[arg0].field_0;
        }
    }
    
    /// @custom:selector    0x6b624fdb
    /// @custom:signature   removeAllowedHook(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeAllowedHook(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_b[arg0] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[arg0];
    }
    
    /// @custom:selector    0x1e2c273e
    /// @custom:signature   removeAllowedSolver(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeAllowedSolver(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        storage_map_c[arg0] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg0];
    }
    
    /// @custom:selector    0xca5eb5e1
    /// @custom:signature   setDelegate(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setDelegate(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(address(0x1a44076050125825900e736c501f859c50fe728c).code.length);
        (bool success, bytes memory ret0) = address(0x1a44076050125825900e736c501f859c50fe728c).Unresolved_ca5eb5e1{ value: 0 }(arg0); // call
        require(success);
    }
    
    /// @custom:selector    0x3400288b
    /// @custom:signature   setPeer(uint32 arg0, bytes32 arg1) public
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function setPeer(uint32 arg0, bytes32 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        peers[arg0] = arg1;
        emit PeerSet(arg0, arg1);
    }
    
    /// @custom:selector    0x0c89a13d
    /// @custom:signature   srcEidToFillerFills(uint32 arg0, address arg1, uint256 arg2) public view returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function srcEidToFillerFills(uint32 arg0, address arg1, uint256 arg2) public view returns (uint256) {
        require(true);
        require(true);
        require(arg2 < storage_map_g[arg0][arg1]);
        return storage_map_g[arg0][arg1][arg2];
    }
    
    /// @custom:selector    0x05ef94ba
    /// @custom:signature   Unresolved_05ef94ba(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_05ef94ba(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x13137d65
    /// @custom:signature   Unresolved_13137d65(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_13137d65(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4) public pure {
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require(true);
        require(arg6 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x2c85455b
    /// @custom:signature   Unresolved_2c85455b(uint32 arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_2c85455b(uint32 arg0, address arg1, uint256 arg2) public payable {
        require(true);
        require(true);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(storage_map_g[arg0][arg1], "No orders provided");
        if (0x0c97 <= 0xffffffff && 0x0c97 <= 0xffffffffffffffff) {
            store_j = 0;
            storage_map_g[arg0][arg1] -= 0x64;
            uint256 var_h = msg.data[0x04 + arg2 + 0x20:0x04 + arg2 + 0x20 + msg.data[0x04 + arg2]];
            uint256 var_d = 0x40 + var_d;
            require(msg.value == var_p, CustomError_9f704120());
            if (!var_q) {
                uint256 var_d = 0xa0 + var_d;
                revert CustomError_f6ff4fb7();
            } else {
                (bool success, bytes memory ret0) = address(0x1a44076050125825900e736c501f859c50fe728c).Unresolved_(memory[var_d:var_d + (0x04 + var_d - var_d)]); // staticcall
                require(success);
                uint256 var_d = var_d + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_d + ret0.length - var_d >= 0x20);
                require(var_p == address(var_p));
                require(address(var_p), CustomError_5373352a());
                payable(address(address(var_p))).transfer(0);
                require(success);
                require(!ret0.length, CustomError_5274afe7());
                require(address(var_p).code.length, CustomError_5274afe7());
                uint256 var_d = 0xa0 + var_d;
                require(peers[arg0], CustomError_f6ff4fb7());
                uint256 var_am = 0x04 + var_d + 0xe0 + (var_ak + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - (0x04 + var_d) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc0;
                (bool success, bytes memory ret0) = address(0x1a44076050125825900e736c501f859c50fe728c).Unresolved_00000000{ value: var_p }(0x40, msg.sender, uint32(var_p), var_q, 0xa0, var_am, var_as, var_ak, var_au, var_av, var_aw, var_ax); // call
                require(success);
                uint256 var_d = var_d + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_d + ret0.length - var_d >= 0x80);
                if (!(var_d + 0x60 < var_d | var_d + 0x60 > 0xffffffffffffffff)) {
                    uint256 var_d = var_d + 0x60;
                    require(var_q == uint64(var_q));
                    require(var_d + ret0.length - (var_d + 0x40) >= 0x40);
                }
            }
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public
    function Unresolved_3f4ba83a() public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(store_i, CustomError_8dfc202b());
        store_k = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_k;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x555c3898
    /// @custom:signature   Unresolved_555c3898(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, address arg9, uint256 arg10, uint256 arg11) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint32", "bytes4", "int32"]
    /// @param              arg5 ["uint32", "bytes4", "int32"]
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["uint32", "bytes4", "int32"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_555c3898(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, address arg9, uint256 arg10, uint256 arg11) public payable {
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(arg11 <= 0xffffffffffffffff);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(0x04 + arg11 + 0x20 - (0x04 + arg11) >= 0x20);
        require(msg.data[0x04 + arg11] == address(msg.data[0x04 + arg11]));
        require(address(msg.data[0x04 + arg11]) != 0, "Missing hook");
        require(0x20 >= 0x20);
        require(arg0 == uint128(arg0));
        require(0x20 >= 0x20);
        require(arg1 == uint128(arg1));
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        uint256 var_o = 0x40 + var_o;
        var_o = keccak256(memory[var_o + 0x20:var_o + 0x20 + var_t]);
        require(arg0 == uint128(arg0));
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return store_i;
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_l = store_l & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x7ce5e33e
    /// @custom:signature   Unresolved_7ce5e33e(address arg0) public payable
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7ce5e33e(address arg0) public payable {
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(0x20 >= 0x20);
        require(true);
        require(arg8, "Invalid offerer");
        require(0x20 >= 0x20);
    }
    
    /// @custom:selector    0x82413eac
    /// @custom:signature   Unresolved_82413eac(uint256 arg0, uint256 arg1, address arg2) public pure returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_82413eac(uint256 arg0, uint256 arg1, address arg2) public pure returns (bool) {
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(true);
        return address(this) == arg4;
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public
    function Unresolved_8456cb59() public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(!store_i, CustomError_d93c0665());
        store_k = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_k;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view returns (uint256)
    function Unresolved_84b0196e() public view returns (uint256) {
        uint256 var_a = 0x40 + var_a;
        return abi.encodePacked(0x0f00000000000000000000000000000000000000000000000000000000000000, 0xe0, var_a + 0xe0 + (var_i + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, block.chainid, address(this), 0, var_a + 0xe0 + (var_i + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + (var_i + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, var_i, var_i, var_s);
    }
    
    /// @custom:selector    0x983f7fd1
    /// @custom:signature   Unresolved_983f7fd1(uint256 arg0, uint32 arg1, address arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint32", "bytes4", "int32"]
    /// @param              arg9 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_983f7fd1(uint256 arg0, uint32 arg1, address arg2, uint256 arg3) public payable {
        require(msg.data.length - 0x24 >= 0x0140);
        require(arg11 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg11] <= 0xffffffffffffffff);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(0x20 >= 0x20);
        require(true);
        require(arg8 == 0x7595, "Not on destination chain");
        (bool success, bytes memory ret0) = address(address(this)).Unresolved_2dff692d(arg0); // staticcall
        require(success);
        uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_c + ret0.length - var_c >= 0x20);
        require(var_d < 0x05);
        if (var_d <= 0x04) {
            require(var_d == 0, "Order not active");
            (bool success, bytes memory ret0) = address(address(this)).Unresolved_7de63734(msg.sender); // staticcall
            if (success) {
                uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (var_c + ret0.length - var_c >= 0x20) {
                    require(0x20 >= 0x20);
                    require(false, "Only whitelisted solver or offerer(after expiry) can cancel");
                }
            }
            revert();
        }
    }
    
    /// @custom:selector    0x996628a0
    /// @custom:signature   Unresolved_996628a0(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, address arg9, uint256 arg10) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint32", "bytes4", "int32"]
    /// @param              arg5 ["uint32", "bytes4", "int32"]
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["uint32", "bytes4", "int32"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_996628a0(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, address arg9, uint256 arg10) public payable {
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(0x20 >= 0x20);
        require(arg0 == uint128(arg0));
        require(0x20 >= 0x20);
        require(arg1 == uint128(arg1));
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        uint256 var_o = 0x40 + var_o;
        var_o = keccak256(memory[var_o + 0x20:var_o + 0x20 + var_t]);
        require(arg0 == uint128(arg0));
    }
    
    /// @custom:selector    0xa9a683ba
    /// @custom:signature   Unresolved_a9a683ba(uint32 arg0, uint32 arg1, address arg2, uint256 arg3) public payable
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["uint32", "bytes4", "int32"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_a9a683ba(uint32 arg0, uint32 arg1, address arg2, uint256 arg3) public payable {
        require(arg10 <= 0xffffffffffffffff);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(0x20 >= 0x20);
        require(true);
        require(0x20 >= 0x20);
        require(true);
        require(arg6 != arg7, "Use fill() without hook for single-chain swaps");
        require(0x20 >= 0x20);
        require(true);
        require(arg8, "Invalid offerer");
        require(0x20 >= 0x20);
    }
    
    /// @custom:selector    0xb410f122
    /// @custom:signature   Unresolved_b410f122(address arg0) public pure
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_b410f122(address arg0) public pure {
        require(arg0 == uint128(arg0));
    }
    
    /// @custom:selector    0xc4d252f5
    /// @custom:signature   Unresolved_c4d252f5(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_c4d252f5(uint256 arg0) public {
        require(!store_i, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Only whitelisted solver can cancel from the source chain");
        if (storage_map_e[arg0].field_0 <= 0x04) {
            require(storage_map_e[arg0].field_0 == 0x01, "Can only cancel active orders");
            storage_map_e[arg0] = 0x03 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0];
            require(storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_0 >= storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_0.field_0, "Insufficient locked balance");
            if (storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_0.field_0 + storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_128 <= 0xffffffffffffffffffffffffffffffff) {
                storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)] = storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_0.field_0 + storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_128 << 0x80 | storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)] - storage_map_m[address(storage_map_d[arg0].field_3 / 0x0100000000)][address(var_n)].field_0;
                emit Event_f4358078(arg0);
            }
        }
    }
    
    /// @custom:selector    0xcd774887
    /// @custom:signature   Unresolved_cd774887(uint32 arg0, bool arg1, uint256 arg2, uint256 arg3) public pure
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_cd774887(uint32 arg0, bool arg1, uint256 arg2, uint256 arg3) public pure {
        revert();
    }
    
    /// @custom:selector    0xe86dfbbf
    /// @custom:signature   Unresolved_e86dfbbf(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e86dfbbf(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_l = arg0 | store_l & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xff7bd03d
    /// @custom:signature   Unresolved_ff7bd03d(uint32 arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ff7bd03d(uint32 arg0, uint256 arg1) public view returns (bool) {
        require(0x20 >= 0x20);
        require(true);
        return peers[arg0] == arg1;
    }
    
    /// @custom:selector    0x51cff8d9
    /// @custom:signature   withdraw(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdraw(address arg0) public {
        require(true);
        require(store_h - 0x02, CustomError_3ee5aeb5());
        store_h = 0x02;
        require(!store_i, CustomError_d93c0665());
        require(uint128(storage_map_m[msg.sender][arg0] / 0x0100000000000000000000000000000000), "Non-zero balance required");
        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
        require(success);
        if (!ret0.length) {
            require(arg0.code.length, CustomError_5274afe7());
        } else {
            require(0x01 == arg0, CustomError_5274afe7());
        }
        storage_map_m[msg.sender][arg0] = storage_map_m[msg.sender][arg0].field_0;
        emit Withdraw(msg.sender, arg0, uint128(storage_map_m[msg.sender][arg0] / 0x0100000000000000000000000000000000));
        store_h = 0x01;
    }
}