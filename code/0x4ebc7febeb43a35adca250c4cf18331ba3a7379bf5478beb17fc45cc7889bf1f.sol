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
    event Deposit(address, uint256);
    fallback() external payable {
        if (msg.data.length) {
            require(address(0x657975f60cd55b81e0c029dd0572d5e678b3a9cf).code.length);
            (bool success, bytes memory ret0) = address(0x657975f60cd55b81e0c029dd0572d5e678b3a9cf).getWalletImpl(); // staticcall
            require(success);
            uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(var_a + ret0.length - var_a >= 0x20);
            require(var_c == address(var_c));
            uint256 var_c = msg.data[0:msg.data.length];
            (bool success, bytes memory ret0) = address(var_c).Unresolved_(memory[var_a:var_a + msg.data.length]); // delegatecall
            require(success);
            return ;
        } else {
            if (msg.value) {
                emit Deposit(msg.sender, msg.value);
            }
        }
    }
    
}