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
    mapping(address => uint256) storage_map_a; // storage slot: 0x00
    
    error CustomError_00000000();
    event OwnerChanged(address, address, address);
    
    /// @custom:selector    0x20709efc
    /// @custom:signature   ecdsaValidatorStorage(address arg0) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function ecdsaValidatorStorage(address arg0) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x0c959556
    /// @custom:signature   Unresolved_0c959556(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_0c959556(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x14 <= msg.data[0x04 + arg0]);
        storage_map_a[msg.sender] = storage_map_a[msg.sender] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | msg.data[0x04 + arg0 + 0x20] >> 0x60;
        emit OwnerChanged(msg.sender, storage_map_a[msg.sender].field_0, msg.data[0x04 + arg0 + 0x20] >> 0x60);
        return ;
    }
    
    /// @custom:selector    0x333daf92
    /// @custom:signature   Unresolved_333daf92(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_333daf92(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_d + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_e = msg.data[0x04 + arg1];
            uint256 var_f = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + var_e];
            (bool success, bytes memory ret0) = address(var_k == 0x41 & var_i < 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1).Unresolved_00000000(0x41, var_l, var_m, var_n); // staticcall
            require(ret0.length, CustomError_8baa579f());
            return 0;
        }
    }
    
    /// @custom:selector    0x3a871cdd
    /// @custom:signature   Unresolved_3a871cdd(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_3a871cdd(uint256 arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(!(msg.data[0x04 + arg0] - address(msg.data[0x04 + arg0])));
        require(msg.data[0x04 + arg0 + 0x0140] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]]);
        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff && !(var_d + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_e = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]];
            uint256 var_f = msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]):0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]) + var_e];
            (bool success, bytes memory ret0) = address(var_k == 0x41 & var_i < 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1).Unresolved_5e410661(0x41, var_l, var_m, var_n); // staticcall
            require(ret0.length, CustomError_8baa579f());
            return 0;
        }
    }
    
    /// @custom:selector    0x8fc925aa
    /// @custom:signature   Unresolved_8fc925aa(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_8fc925aa(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        storage_map_a[msg.sender] = 0;
        return ;
    }
    
    /// @custom:selector    0x9ea9bd59
    /// @custom:signature   Unresolved_9ea9bd59(address arg0, uint256 arg1) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9ea9bd59(address arg0, uint256 arg1) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        uint256 var_c = arg0 == storage_map_a[msg.sender].field_0;
        return var_c;
    }
}