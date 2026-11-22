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
    address store_b; // storage slot: 0x183cde5d4f6bb7b445b8fc2f7f15d0fd1d162275aded24183babbffee7cd4923
    
    mapping(bytes32 => bytes32) storage_map_a; // storage slot: 0x183cde5d4f6bb7b445b8fc2f7f15d0fd1d162275aded24183babbffee7cd491f
    
    fallback() external payable {
        if (msg.data.length) {
            if (storage_map_a[0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]] >> 0x60) {
                require(storage_map_a[0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0]].field_96, "Barz: Function does not exist");
                (bool success, bytes memory ret0) = address(storage_map_a[var_e] >> 0x60).Unresolved_(memory[0:msg.data.length]); // delegatecall
                require(success);
                return var_e;
            } else {
                bytes32 var_e = 0xffffffff00000000000000000000000000000000000000000000000000000000 & msg.data[0];
                (bool success, bytes memory ret0) = address(store_b).Unresolved_cdffacc6(var_e); // staticcall
                require(success);
                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_a + ret0.length - var_a >= 0x20);
                require(var_h == address(var_h));
            }
        }
    }
    
}