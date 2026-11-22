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
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_n; // storage slot: 0x00
    uint8 store_k; // storage slot: 0x00
    bytes32 store_l; // storage slot: 0x01
    address public safe; // storage slot: 0x02
    bytes32 store_o; // storage slot: 0x02
    address public unresolved_570ca735; // storage slot: 0x03
    bytes32 store_j; // storage slot: 0x03
    address public unresolved_238ac933; // storage slot: 0x04
    bytes32 store_e; // storage slot: 0x04
    address store_r; // storage slot: 0x05
    bytes32 store_s; // storage slot: 0x05
    address public vaultToken; // storage slot: 0x06
    bytes32 store_q; // storage slot: 0x06
    
    mapping(address => uint8) storage_map_a; // storage slot: 0x07
    mapping(address => uint8) storage_map_b; // storage slot: 0x08
    mapping(uint248 => bytes32) storage_map_m; // storage slot: 0x09
    mapping(uint256 => bytes32) storage_map_g; // storage slot: 0x0a
    mapping(uint256 => bytes32) storage_map_f; // storage slot: 0x0b
    
    error CallerIsNotSender();
    event Event_4f0d110e();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event Event_95acd468();
    event Event_c62c9fd8();
    event SetOperator(address);
    event SetSafe(address);
    
    /// @custom:selector    0x541d5548
    /// @custom:signature   isRelayer(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isRelayer(address arg0) public view returns (bool) {
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xf3d7d282
    /// @custom:signature   isRouter(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isRouter(address arg0) public view returns (bool) {
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x9203aa50
    /// @custom:signature   manageSigner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function manageSigner(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, CustomError_646dc6c0());
        require(unresolved_238ac933 != arg0, CustomError_5bb8206c());
        store_e = var_e | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
        emit Event_95acd468(msg.sender, arg0);
    }
    
    /// @custom:selector    0x857c7ad6
    /// @custom:signature   orderAmount(bytes32 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orderAmount(bytes32 arg0) public view returns (uint256) {
        require(!(arg0 - arg0));
        var_c = storage_map_f[arg0];
        return var_c;
    }
    
    /// @custom:selector    0x2dff692d
    /// @custom:signature   orderStatus(bytes32 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orderStatus(bytes32 arg0) public view returns (uint256) {
        require(!(arg0 - arg0));
        var_c = storage_map_g[arg0];
        return var_c;
    }
    
    /// @custom:selector    0xccec3716
    /// @custom:signature   rescueERC20(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function rescueERC20(address arg0) public payable {
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_570ca735), CustomError_d0769d8e());
        require(safe != 0, CustomError_646dc6c0());
        (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        require(success, CustomError_41b5fd69());
    }
    
    /// @custom:selector    0xb3ab15fb
    /// @custom:signature   setOperator(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setOperator(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, CustomError_646dc6c0());
        require(arg0 != unresolved_570ca735, CustomError_5bb8206c());
        store_j = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_j;
        emit SetOperator(arg0);
    }
    
    /// @custom:selector    0x01bbd2e2
    /// @custom:signature   Unresolved_01bbd2e2(uint256 arg0, address arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_01bbd2e2(uint256 arg0, address arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(!(arg11 - arg11));
        require(arg12 <= 0xffffffffffffffff);
        require(msg.data.length - (0x04 + arg12) < 0x0220);
    }
    
    /// @custom:selector    0x1cf3e2f5
    /// @custom:signature   Unresolved_1cf3e2f5(uint256 arg0, address arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    function Unresolved_1cf3e2f5(uint256 arg0, address arg1, uint256 arg2, uint256 arg3) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(msg.data.length - 0x0164 >= 0x80);
        require(arg15 <= 0xffffffffffffffff);
        require(!store_k, "Pausable: paused");
        require(store_l != 0x02, "ReentrancyGuard: reentrant call");
        store_l = 0x02 | 0 & store_l;
        require(!(arg3 - arg3));
        require(!(msg.sender - arg3), CustomError_ef30440e());
        require(!(arg14 - arg14));
        require(arg14 != 0, CustomError_41b5fd69());
        require(arg14 - arg14, CustomError_1ab7da6b());
    }
    
    /// @custom:selector    0x20800a00
    /// @custom:signature   Unresolved_20800a00() public view
    function Unresolved_20800a00() public view {
        require(!(msg.sender - unresolved_570ca735), CustomError_d0769d8e());
        require(safe != 0, CustomError_646dc6c0());
        require(address(this).balance != 0, CustomError_41b5fd69());
    }
    
    /// @custom:selector    0x2d36a9b0
    /// @custom:signature   Unresolved_2d36a9b0(uint256 arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2d36a9b0(uint256 arg0, address arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && (!(var_c + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + (msg.data[0x04 + arg0] * 0x20 + 0x20)) > 0xffffffffffffffff | var_c + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + (msg.data[0x04 + arg0] * 0x20 + 0x20)) < var_c) && 0x04 + arg0 + 0x20 >= 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] * 0x20)) {
            require(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]);
        }
    }
    
    /// @custom:selector    0x396fc311
    /// @custom:signature   Unresolved_396fc311(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_396fc311(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(!(arg11 - arg11));
        require(!store_k, "Pausable: paused");
        require(store_l != 0x02, "ReentrancyGuard: reentrant call");
        store_l = 0x02 | 0 & store_l;
        require(!(arg3 - arg3));
        require(!(msg.sender - arg3), CustomError_ef30440e());
        require(arg11 != 0, CustomError_41b5fd69());
        require(block.timestamp <= arg11, CustomError_1ab7da6b());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg0]));
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]);
        require(!(arg2 - arg2));
        require(!(arg8 - arg8));
        uint248 var_e = uint248(var_g >> 0x08);
        storage_map_m[var_e] = storage_map_m[var_e] ^ 0x01 << uint8(var_g) | 0 & storage_map_m[var_e];
        require(((storage_map_m[uint248(msg.data[0x04 + arg0] >> 0x08)] ^ 0x01 << uint8(msg.data[0x04 + arg0])) & 0x01 << uint8(msg.data[0x04 + arg0])) != 0, CustomError_756688fe());
    }
    
    /// @custom:selector    0x3dddee1f
    /// @custom:signature   Unresolved_3dddee1f(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_3dddee1f(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(arg11 - arg11);
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable
    function Unresolved_3f4ba83a() public payable {
        require(!(msg.sender - unresolved_570ca735), CustomError_d0769d8e());
        require(store_k, "Pausable: not paused");
        store_n = 0 << 0xa0 & 0xff0000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_n;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return store_k;
    }
    
    /// @custom:selector    0x5db0cb94
    /// @custom:signature   Unresolved_5db0cb94(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_5db0cb94(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, CustomError_646dc6c0());
        require(arg0 != safe, CustomError_5bb8206c());
        store_o = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_o;
        emit SetSafe(arg0);
    }
    
    /// @custom:selector    0x6727655a
    /// @custom:signature   Unresolved_6727655a(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_6727655a(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(arg11 - arg11);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        store_n = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_n;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable
    function Unresolved_8456cb59() public payable {
        require(!(msg.sender - unresolved_570ca735), CustomError_d0769d8e());
        require(!store_k, "Pausable: paused");
        store_n = 0x01 << 0xa0 & 0xff0000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_n;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0xb1a6602a
    /// @custom:signature   Unresolved_b1a6602a(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_b1a6602a(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(!(arg11 - arg11));
        require(arg12 <= 0xffffffffffffffff);
        require(!store_k, "Pausable: paused");
        require(store_l != 0x02, "ReentrancyGuard: reentrant call");
        store_l = 0x02 | 0 & store_l;
        require(!(arg3 - arg3));
        require(!(msg.sender - arg3), CustomError_ef30440e());
        require(!(msg.data[0x04 + arg12 + 0x0120] - msg.data[0x04 + arg12 + 0x0120]));
        require(msg.data[0x04 + arg12 + 0x0120] != 0, CustomError_41b5fd69());
        require(msg.data[0x04 + arg12 + 0x0120] - msg.data[0x04 + arg12 + 0x0120], CustomError_1ab7da6b());
    }
    
    /// @custom:selector    0xb44f9b52
    /// @custom:signature   Unresolved_b44f9b52(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b44f9b52(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, CustomError_646dc6c0());
        require(vaultToken != arg0, CustomError_5bb8206c());
        store_q = var_e | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_q;
        emit Event_4f0d110e(msg.sender, arg0);
    }
    
    /// @custom:selector    0xbd8049ea
    /// @custom:signature   Unresolved_bd8049ea(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    function Unresolved_bd8049ea(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(msg.data.length - 0x0164 >= 0x80);
        require(arg15 <= 0xffffffffffffffff);
        require(!(arg16 - arg16));
        require(!store_k, "Pausable: paused");
        require(store_l != 0x02, "ReentrancyGuard: reentrant call");
        store_l = 0x02 | 0 & store_l;
        require(storage_map_a[msg.sender].field_0, CustomError_86db3e42());
        require(!(arg14 - arg14));
        require(arg14 != 0, CustomError_41b5fd69());
        require(arg14 - arg14, CustomError_1ab7da6b());
    }
    
    /// @custom:selector    0xe94eab57
    /// @custom:signature   Unresolved_e94eab57(uint256 arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e94eab57(uint256 arg0, address arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && (!(var_c + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + (msg.data[0x04 + arg0] * 0x20 + 0x20)) > 0xffffffffffffffff | var_c + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + (msg.data[0x04 + arg0] * 0x20 + 0x20)) < var_c) && 0x04 + arg0 + 0x20 >= 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] * 0x20)) {
            require(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]);
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, "Ownable: new owner is the zero address");
        store_n = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_n;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xf3f45426
    /// @custom:signature   Unresolved_f3f45426(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f3f45426(address arg0) public payable {
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0 != 0, CustomError_646dc6c0());
        require(store_r != arg0, CustomError_5bb8206c());
        store_s = var_e | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
        emit Event_c62c9fd8(msg.sender, arg0);
    }
    
    /// @custom:selector    0xf8e97905
    /// @custom:signature   Unresolved_f8e97905(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_f8e97905(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - 0x24 >= 0x0140);
        require(!(arg11 - arg11));
        require(!store_k, "Pausable: paused");
        require(store_l != 0x02, "ReentrancyGuard: reentrant call");
        store_l = 0x02 | 0 & store_l;
        require(storage_map_a[msg.sender].field_0, CustomError_86db3e42());
        require(arg11 != 0, CustomError_41b5fd69());
        require(block.timestamp <= arg11, CustomError_1ab7da6b());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg0]));
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]);
        require(!(arg2 - arg2));
        require(!(arg8 - arg8));
        uint248 var_e = uint248(var_g >> 0x08);
        storage_map_m[var_e] = storage_map_m[var_e] ^ 0x01 << uint8(var_g) | 0 & storage_map_m[var_e];
        require(((storage_map_m[uint248(msg.data[0x04 + arg0] >> 0x08)] ^ 0x01 << uint8(msg.data[0x04 + arg0])) & 0x01 << uint8(msg.data[0x04 + arg0])) != 0, CustomError_756688fe());
    }
}