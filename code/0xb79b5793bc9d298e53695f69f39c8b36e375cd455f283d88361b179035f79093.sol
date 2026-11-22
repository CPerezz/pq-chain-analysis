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
    
    /// @custom:selector    0xea50d0e4
    /// @custom:signature   Unresolved_ea50d0e4(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ea50d0e4(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg1 + 0x1f);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
    }
}