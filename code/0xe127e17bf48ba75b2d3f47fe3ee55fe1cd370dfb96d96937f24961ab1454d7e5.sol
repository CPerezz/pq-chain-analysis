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
    bytes32 store_c; // storage slot: 0x0e | arg0 << 0x60 >> 0x60 << 0x82 | msg.sender << 0x82 >> 0x7e
    bytes32 store_h; // storage slot: 0x0e | arg0 << 0x82 | arg1 << 0x82 >> 0x7e
    uint256 store_a; // storage slot: 0x0f | arg0 << 0x60
    uint256 store_b; // storage slot: 0x0f | msg.sender << 0x60
    uint256 store_d; // storage slot: 0x0f | arg1 << 0x60
    uint256 store_e; // storage slot: 0x0e | msg.sender << 0x82 | arg0 << 0x60 >> 0x60 << 0x82 >> 0x7e
    uint256 store_f; // storage slot: 0x0d | arg0 << 0x60
    uint256 store_g; // storage slot: 0x0e | arg0 << 0x60 >> 0x60 << 0x82 | arg1 << 0x60 >> 0x60 << 0x82 >> 0x7e
    
    error CustomError_00000000();
    event Event_8c5be1e5();
    event Transfer(address, address, uint256);
    fallback() external payable {
        require(!(msg.value > memory.length | !msg.data[memory.length]));
        if (0x70a08231 == msg.data[memory.length] >> 0xe0) {
            return store_a;
        } else {
            if (0xa9059cbb == msg.data[memory.length] >> 0xe0) {
                require(store_b >= arg1, CustomError_f4d678b8());
                store_b -= arg1;
                store_a += arg1;
                emit Transfer(msg.sender, arg0 << 0x60 >> 0x60, arg1);
                return 0x01;
            } else {
                if (0x23b872dd == msg.data[memory.length] >> 0xe0) {
                    require(type(uint256).max == store_c, CustomError_3f726eac());
                    require(store_a >= arg2, CustomError_f4d678b8());
                    store_a -= arg2;
                    store_d += arg2;
                    emit Transfer(arg0 << 0x60 >> 0x60, arg1 << 0x60 >> 0x60, arg2);
                    return 0x01;
                } else {
                    if (0x095ea7b3 == msg.data[memory.length] >> 0xe0) {
                        store_e = arg1;
                        emit Event_8c5be1e5(msg.sender, arg0 << 0x60 >> 0x60, arg1);
                        return 0x01;
                    } else {
                        if (0xd505accf == msg.data[memory.length] >> 0xe0) {
                            require(block.timestamp <= arg3, CustomError_1ab7da6b());
                            address var_a = ecrecover(keccak256(memory[0:0x42]));
                            require(!(arg0 << 0x60 >> 0x60 != var_a | (!var_a | !memory[0x20])), CustomError_8baa579f());
                            store_f += 0x01;
                            store_g = arg2;
                            emit Event_8c5be1e5(arg0 << 0x60 >> 0x60, arg1 << 0x60 >> 0x60, arg2);
                            return ;
                        } else {
                            if (0xdd62ed3e == msg.data[memory.length] >> 0xe0) {
                                return store_h;
                            } else {
                                if (0x18160ddd == msg.data[memory.length] >> 0xe0) {
                                    return 0x033b2e3c9fd0803ce8000000;
                                } else {
                                    if (0x06fdde03 == msg.data[memory.length] >> 0xe0) {
                                        return 0x20;
                                    } else {
                                        if (0x95d89b41 == msg.data[memory.length] >> 0xe0) {
                                            return 0x20;
                                        } else {
                                            if (0x313ce567 == msg.data[memory.length] >> 0xe0) {
                                                return 0x12;
                                            } else {
                                                if (0x3644e515 == msg.data[memory.length] >> 0xe0) {
                                                    if (address(this) == 0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e & block.chainid == 0x01) {
                                                        return 0xe48f2c0787b91fd7646fae5cf21cac46e6c416b034a89deceb11bfcf17a5bf32;
                                                    } else {
                                                        return keccak256(memory[0:memory.length]);
                                                    }
                                                } else {
                                                    require(0x7ecebe00 == msg.data[memory.length] >> 0xe0);
                                                    return store_f;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}