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
    string public constant NAME = 0xBytes([77, 117, 108, 116, 105, 99, 104, 97, 105, 110, 32, 80, 97, 115, 115, 75, 101, 121, 115, 32, 79, 119, 110, 101, 114, 115, 104, 105, 112, 32, 82, 101, 103, 105, 115, 116, 114, 121, 32, 77, 111, 100, 117, 108, 101]);
    uint256 public constant unresolved_a600845b = 747405151408484225089543595517260196485848294620;
    bytes public constant unresolved_ffa1ad74 = 0xBytes([48, 46, 50, 46, 48]);
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x00
    
    error NoOwnerRegisteredForSmartAccount(address);
    event OwnershipTransferred(address, address, address);
    
    /// @custom:selector    0xfa544161
    /// @custom:signature   getOwner(address arg0) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getOwner(address arg0) public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_a[arg0].field_0, CustomError_f4fffd4c());
        var_c = storage_map_a[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x2ede3bc0
    /// @custom:signature   initForSmartAccount(address arg0) public payable returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function initForSmartAccount(address arg0) public payable returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!storage_map_a[msg.sender].field_0, CustomError_b137edf4());
        require(arg0, CustomError_3f0bcf48());
        storage_map_a[msg.sender] = storage_map_a[msg.sender] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return address(this);
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg1];
            uint256 var_e = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + var_d];
            require(var_c + var_g + 0x20 - (var_c + 0x20) >= 0x40);
            require(var_e <= 0xffffffffffffffff);
            require(var_c + 0x20 + var_e + 0x1f < var_c + var_g + 0x20);
            if (var_h <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_h) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_h) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_h) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_c + 0x20 + var_e + var_h + 0x20 <= var_c + var_g + 0x20);
                if (0 >= var_h) {
                    require(var_j > 0xffffffffffffffff);
                }
            }
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable returns (uint256)
    function Unresolved_715018a6() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        storage_map_a[msg.sender] = storage_map_a[msg.sender] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit OwnershipTransferred(msg.sender, storage_map_a[msg.sender].field_0, 0);
        return ;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!arg0.code.length, CustomError_77817ac3());
        require(arg0, CustomError_3f0bcf48());
        storage_map_a[msg.sender] = storage_map_a[msg.sender] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit OwnershipTransferred(msg.sender, storage_map_a[msg.sender].field_0, arg0);
        return ;
    }
    
    /// @custom:selector    0xf44c339d
    /// @custom:signature   Unresolved_f44c339d(uint256 arg0, uint256 arg1, address arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f44c339d(uint256 arg0, uint256 arg1, address arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg1];
            require(!(arg2 - arg2));
            require(storage_map_a[arg2].field_0, CustomError_f4fffd4c());
            require(var_i >= 0x41, CustomError_5763538a());
            if (var_k > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
            } else {
                var_f = keccak256(memory[0:0x3c]);
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0xfff35b72
    /// @custom:signature   Unresolved_fff35b72(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_fff35b72(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(msg.data[0x04 + arg0 + 0x0140] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + 0x20 <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]]);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] - (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]) >= 0x40);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + 0x20] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + 0x20] + 0x20 + 0x1f < 0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] + 0x20);
    }
}