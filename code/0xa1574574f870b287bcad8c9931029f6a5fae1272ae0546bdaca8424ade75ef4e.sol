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
    
    /// @custom:selector    0x7e4f7a8a
    /// @custom:signature   Unresolved_7e4f7a8a(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    /// @param              arg17 ["uint256", "bytes32", "int256"]
    /// @param              arg20 ["uint256", "bytes32", "int256"]
    /// @param              arg25 ["uint256", "bytes32", "int256"]
    /// @param              arg26 ["uint256", "bytes32", "int256"]
    /// @param              arg27 ["uint256", "bytes32", "int256"]
    function Unresolved_7e4f7a8a(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg0 + msg.data[0x04 + arg0] + 0x24 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24 <= msg.data.length);
        require(!(msg.data[0x04 + arg1] - 0x0e), "wrong number of public inputs");
        require(0 >= msg.data[0x04 + arg1], "inputs are bigger than r");
        require(!(0x0360 - msg.data[0x04 + arg0]), "wrong proof size");
        uint256 var_e = var_e;
        require(msg.data[arg0 + 0x24 + 0x0180] <= var_e, "openings bigger than r");
        require(msg.data[arg0 + 0x24 + 0x01a0] <= var_e, "openings bigger than r");
        require(msg.data[arg0 + 0x24 + 0x01c0] <= var_e, "openings bigger than r");
        require(msg.data[arg0 + 0x24 + 0x01e0] <= var_e, "openings bigger than r");
        require(msg.data[arg0 + 0x24 + 0x0200] <= var_e, "openings bigger than r");
        require(msg.data[arg0 + 0x24 + 0x0260] <= var_e, "openings bigger than r");
        if (0 < 0x01) {
            require(msg.data[0x0300 + (arg0 + 0x24)] <= var_e, "openings bigger than r");
        } else {
            bytes var_ab = sha256();
            require(memory[0x20], "error verify");
            bytes var_ab = sha256();
            require(memory[0x20], "error verify");
            bytes var_ab = sha256();
            require(memory[0x20], "error verify");
            bytes var_ab = sha256();
            require(memory[0x20], "error verify");
            uint256 var_e = var_e;
            uint256 var_e = var_e;
            (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_ai, var_aj, var_ak, var_al, var_am, var_an); // staticcall
            if (success) {
                uint256 var_e = var_e;
                (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_aj, var_ak, var_al, var_am, var_an, var_ap); // staticcall
                if (success) {
                    uint256 var_h = msg.data[arg0 + 0x24 + 0x0320];
                    uint256 var_i = msg.data[arg0 + 0x24 + 0x0340];
                    require(memory[0x20], "error verify");
                    bytes var_ab = sha256(0, 0x01);
                    require(memory[0x20], "error verify");
                    require(memory[0x20], "error verify");
                    uint256 var_e = var_e;
                    uint256 var_e = var_e;
                    (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_ai, 0x32, 0x32, var_al, 0x53, var_an); // staticcall
                }
            }
            revert("error mod ex");
        }
    }
}