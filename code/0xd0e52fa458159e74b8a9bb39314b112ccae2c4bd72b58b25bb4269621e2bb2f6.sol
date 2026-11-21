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
    address public unresolved_a6c3e6b9; // storage slot: 0x00
    address public unresolved_384c3335; // storage slot: 0x01
    address public unresolved_6f264b2e; // storage slot: 0x02
    bytes32 store_b; // storage slot: 0x03
    bytes32 store_f; // storage slot: 0x04
    bytes32 store_a; // storage slot: 0x05
    
    mapping(bytes32 => uint256) storage_map_d; // storage slot: 0x06
    
    event Event_c51b043b();
    
    /// @custom:selector    0xb01b3e28
    /// @custom:signature   getSubscriptionHash(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function getSubscriptionHash(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure returns (uint256) {
        uint256 var_k = 0x20 + (0x20 + (0x20 + (0x14 + (0x14 + (0x14 + (0x14 + (0x01 + (0x01 + (0x20 + var_k)))))))));
        return keccak256(memory[var_k:var_k + (var_n + var_k - var_k)]);
    }
    
    /// @custom:selector    0x0ad8ad66
    /// @custom:signature   Unresolved_0ad8ad66(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_0ad8ad66(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool) {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg6]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg6):0x20 + (0x04 + arg6) + msg.data[0x04 + arg6]];
        uint256 var_a = 0x20 + (0x20 + (0x20 + (0x14 + (0x14 + (0x14 + (0x14 + (0x01 + (0x01 + (0x20 + var_a)))))))));
        if (var_o < 0x20 && uint8(var_s) >= 0x1b) {
            uint256 var_a = 0x20 + var_a;
            address var_z = ecrecover(keccak256(memory[var_a:var_a + (var_o + var_a - var_a)]), uint8(var_s), var_w, var_y);
            require(memory[(memory[0x40] - 0x20)]);
            require(arg2.code.length);
            (bool success, bytes memory ret0) = address(arg2).Unresolved_dd62ed3e{ value: 0 }(arg0, address(this), var_ac); // call
            require(success);
            require(ret0.length >= 0x20);
            require(arg2.code.length);
            (bool success, bytes memory ret0) = address(arg2).Unresolved_70a08231{ value: 0 }(arg0, address(this)); // call
            require(success);
            require(ret0.length >= 0x20);
            if (address(var_z) != arg0) {
                if (address(var_z) != arg0) {
                    if (address(var_z) != arg0) {
                        return address(var_z) == arg0;
                    } else {
                        require(arg3 + arg5 >= arg3);
                        return var_o >= arg3 + arg5;
                    }
                } else {
                    require(arg3 + arg5 >= arg3);
                }
            } else {
                return arg0 != arg1;
            }
        }
    }
    
    /// @custom:selector    0x10d92060
    /// @custom:signature   Unresolved_10d92060() public view returns (uint256)
    function Unresolved_10d92060() public view returns (uint256) {
        return store_a;
    }
    
    /// @custom:selector    0x18f321a3
    /// @custom:signature   Unresolved_18f321a3(uint256 arg0, uint256 arg1) public returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_18f321a3(uint256 arg0, uint256 arg1) public returns (address) {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg1):0x20 + (0x04 + arg1) + msg.data[0x04 + arg1]];
        if (var_g < 0x20) {
            if (var_g == 0x41) {
                if (uint8(var_i) >= 0x1b) {
                    if (uint8(var_i) == 0x1b) {
                        uint256 var_a = 0x20 + var_a;
                        address var_p = ecrecover(keccak256(memory[var_a:var_a + (var_g + var_a - var_a)]), uint8(var_i), var_m, var_o);
                        require(memory[(memory[0x40] - 0x20)]);
                        return address(var_p);
                    } else {
                        return 0;
                    }
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        }
    }
    
    /// @custom:selector    0x29d428ca
    /// @custom:signature   Unresolved_29d428ca() public view returns (uint256)
    function Unresolved_29d428ca() public view returns (uint256) {
        return store_b;
    }
    
    /// @custom:selector    0x691d9352
    /// @custom:signature   Unresolved_691d9352(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_691d9352(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool) {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg6]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg6):0x20 + (0x04 + arg6) + msg.data[0x04 + arg6]];
        uint256 var_a = 0x20 + (0x20 + (0x20 + (0x14 + (0x14 + (0x14 + (0x14 + (0x01 + (0x01 + (0x20 + var_a)))))))));
        if (var_o < 0x20 && uint8(var_s) >= 0x1b) {
            uint256 var_a = 0x20 + var_a;
            address var_z = ecrecover(keccak256(memory[var_a:var_a + (var_o + var_a - var_a)]), uint8(var_s), var_w, var_y);
            require(memory[(memory[0x40] - 0x20)]);
            require(address(var_z) == arg0, "Invalid Signature");
            require(block.timestamp >= storage_map_d[keccak256(memory[var_a:var_a + (var_o + var_a - var_a)])], "Subscription is not ready");
            require(arg1 == unresolved_384c3335);
            require(arg2 == unresolved_6f264b2e);
            require(arg3 == store_b);
            require(arg4 == store_f);
            require(arg5 == store_a);
            require(block.timestamp + arg4 >= block.timestamp);
            storage_map_d[keccak256(memory[var_a:var_a + (var_o + var_a - var_a)])] = block.timestamp + arg4;
            require(arg2.code.length);
            (bool success, bytes memory ret0) = address(arg2).Unresolved_70a08231{ value: 0 }(arg1, var_ad); // call
            require(success);
            require(ret0.length >= 0x20);
            require(arg2.code.length);
            (bool success, bytes memory ret0) = address(arg2).Unresolved_23b872dd{ value: 0 }(arg0, arg1, arg3, var_af); // call
            require(success);
            require(ret0.length >= 0x20);
            require(var_o, "Transfer Failed");
            require(arg2.code.length);
            (bool success, bytes memory ret0) = address(arg2).Unresolved_70a08231{ value: 0 }(arg1, arg1); // call
            require(success);
            require(ret0.length >= 0x20);
            require(var_o + arg3 == var_o, "Crappy ERC20 is a bad kitty.");
            emit Event_c51b043b(arg0, arg1, arg2, arg3, arg4, arg5);
            if (arg5 > 0) {
                require(arg2.code.length);
                (bool success, bytes memory ret0) = address(arg2).Unresolved_23b872dd{ value: 0 }(arg0, msg.sender, arg5, var_af); // call
                require(success);
                require(ret0.length >= 0x20);
                require(var_o, "Failed to pay gas as from account");
            }
            return true;
        }
    }
    
    /// @custom:selector    0x6b40bba1
    /// @custom:signature   Unresolved_6b40bba1() public view returns (uint256)
    function Unresolved_6b40bba1() public view returns (uint256) {
        return store_f;
    }
    
    /// @custom:selector    0xae702ba4
    /// @custom:signature   Unresolved_ae702ba4(uint256 arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ae702ba4(uint256 arg0, uint256 arg1) public view returns (bool) {
        require(storage_map_d[arg0] + arg1 >= storage_map_d[arg0]);
        return block.timestamp <= storage_map_d[arg0] + arg1;
    }
    
    /// @custom:selector    0xb57b0c7f
    /// @custom:signature   Unresolved_b57b0c7f(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_b57b0c7f(address arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public returns (bool) {
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg6]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg6):0x20 + (0x04 + arg6) + msg.data[0x04 + arg6]];
        uint256 var_a = 0x20 + (0x20 + (0x20 + (0x14 + (0x14 + (0x14 + (0x14 + (0x01 + (0x01 + (0x20 + var_a)))))))));
        if (var_o < 0x20 && uint8(var_s) >= 0x1b) {
            uint256 var_a = 0x20 + var_a;
            address var_z = ecrecover(keccak256(memory[var_a:var_a + (var_o + var_a - var_a)]), uint8(var_s), var_w, var_y);
            require(memory[(memory[0x40] - 0x20)]);
            require(address(var_z) == arg0, "Invalid Signature for subscription cancellation");
            storage_map_d[keccak256(memory[var_a:var_a + (var_o + var_a - var_a)])] = type(uint256).max;
            return true;
        }
    }
    
    /// @custom:selector    0xff59bff8
    /// @custom:signature   Unresolved_ff59bff8(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ff59bff8(uint256 arg0) public view returns (uint256) {
        return storage_map_d[arg0];
    }
}