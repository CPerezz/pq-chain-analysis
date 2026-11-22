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
    uint256 public constant unresolved_fc0c546a = 1252669604576505943990633589931201224783811523601;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_i; // storage slot: 0x00
    address store_f; // storage slot: 0x01
    bytes32 store_b; // storage slot: 0x01
    uint8 store_d; // storage slot: 0x01
    uint256 public unresolved_d54ad2a1; // storage slot: 0x04
    uint256 store_g; // storage slot: 0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00
    
    mapping(address => bytes32) storage_map_c; // storage slot: 0x02
    mapping(address => uint256) public unresolved_04e86903; // storage slot: 0x03
    
    error CustomError_00000000();
    event AirdropEnded();
    event Event_7084f547();
    event Event_8be0079c();
    event Event_d8138f8a();
    event SignerChanged(address);
    
    /// @custom:selector    0x726b5bad
    /// @custom:signature   endAirdrop() public payable
    function endAirdrop() public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_b = 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_b;
        emit AirdropEnded();
    }
    
    /// @custom:selector    0x73b2e80e
    /// @custom:signature   hasClaimed(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function hasClaimed(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_c[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xa4fd6f56
    /// @custom:signature   isEnded() public view returns (bool)
    function isEnded() public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_d;
    }
    
    /// @custom:selector    0x238ac933
    /// @custom:signature   Unresolved_238ac933() public view returns (address)
    function Unresolved_238ac933() public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        return store_f;
    }
    
    /// @custom:selector    0x5eddd157
    /// @custom:signature   Unresolved_5eddd157(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_5eddd157(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(arg2 <= 0xffffffffffffffff);
        require(arg2 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(arg2 + msg.data[0x04 + arg2] + 0x24 <= msg.data.length);
        require(store_g != 0x02, CustomError_3ee5aeb5());
        store_g = 0x02;
        require(!store_d, CustomError_f1195438());
        require(!storage_map_c[msg.sender].field_0, CustomError_646cf558());
        require(block.timestamp <= arg1, CustomError_0819bdcd());
        if (block.timestamp <= block.timestamp + 0x012c) {
            require(arg1 <= block.timestamp + 0x012c, CustomError_0819bdcd());
            require(arg0, CustomError_a86b6512());
            if (!(var_j + 0xc0 > 0xffffffffffffffff | var_j + 0xc0 < var_j)) {
                uint256 var_j = var_j + 0xc0;
                if (!(var_j + ((msg.data[0x04 + arg2] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + ((msg.data[0x04 + arg2] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                    uint256 var_m = msg.data[0x04 + arg2];
                    uint256 var_n = msg.data[arg2 + 0x24:arg2 + 0x24 + var_m];
                    if (var_p > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                        require(0x03 >= 0x04, CustomError_d78bce0c());
                    } else {
                        var_o = keccak256(memory[0:0x3c]);
                        require(memory[0x20]);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x6c19e783
    /// @custom:signature   Unresolved_6c19e783(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6c19e783(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_a86b6512());
        store_b = store_b & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | var_c;
        emit SignerChanged(arg0);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_i = store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_i = arg0 | store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xfd0cdcdb
    /// @custom:signature   withdrawRemaining(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdrawRemaining(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_a86b6512());
        (bool success, bytes memory ret0) = address(0xdb6ba5d510f114f9b2ea08bea7d30e32eee33411).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (!success) {
            (bool success, bytes memory ret0) = address(0xdb6ba5d510f114f9b2ea08bea7d30e32eee33411).Unresolved_a9059cbb(arg0); // call
            require(success);
            if (success) {
                if (!(var_f + 0x20 > 0xffffffffffffffff | var_f + 0x20 < var_f)) {
                    uint256 var_f = var_f + 0x20;
                    require(var_f + 0x20 - var_f >= 0x20);
                    require(!(var_g - var_g));
                    require(var_g, "Transfer failed");
                    emit Event_7084f547(arg0, 0);
                }
            } else {
                require(0, "Transfer failed");
                emit Event_7084f547(0x20, 0);
            }
        }
    }
}