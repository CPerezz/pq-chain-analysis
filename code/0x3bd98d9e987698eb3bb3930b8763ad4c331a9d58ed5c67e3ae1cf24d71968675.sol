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
    uint256 store_f; // storage slot: 0x00
    address public unresolved_8da5cb5b; // storage slot: 0x01
    bytes32 store_j; // storage slot: 0x01
    address store_g; // storage slot: 0x02
    bytes32 store_b; // storage slot: 0x02
    uint8 store_d; // storage slot: 0x02
    uint8 store_h; // storage slot: 0x02
    address store_i; // storage slot: 0x03
    bytes32 store_c; // storage slot: 0x03
    
    mapping(address => bytes32) storage_map_e; // storage slot: 0x04
    
    event Event_36863eb5();
    event Event_8be0079c();
    event Event_e9598c82();
    event FeesWithdrawn(address, uint256);
    event TokenWithdrawn(address, address, uint256, address);
    event WhitelistUpdated(address, bool);
    
    /// @custom:selector    0x5437988d
    /// @custom:signature   setVerifier(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setVerifier(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid verifier address");
        store_b = store_b & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return ;
    }
    
    /// @custom:selector    0xc0bb38ff
    /// @custom:signature   setWithdrawRecipient(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setWithdrawRecipient(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid recipient address");
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return ;
    }
    
    /// @custom:selector    0x6ddd1713
    /// @custom:signature   swapEnabled() public view returns (bool)
    function swapEnabled() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_d;
    }
    
    /// @custom:selector    0x0c9708cb
    /// @custom:signature   Unresolved_0c9708cb(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0c9708cb(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid address");
        storage_map_e[arg0] = storage_map_e[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit WhitelistUpdated(arg0, 0x01);
        return ;
    }
    
    /// @custom:selector    0x347ae8d2
    /// @custom:signature   Unresolved_347ae8d2(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_347ae8d2(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xe0);
        require(!(arg0 - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(!(arg4 - arg4));
        require(arg6 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg6] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg6];
            uint256 var_e = msg.data[0x04 + arg6 + 0x20:0x04 + arg6 + 0x20 + var_d];
            require(store_f != 0x02, "ReentrancyGuard: reentrant call");
            store_f = 0x02;
            require(store_d, "Swap is disabled");
            require(block.timestamp <= arg5, "Transaction expired");
            if (!(var_c + 0x80 > 0xffffffffffffffff | var_c + 0x80 < var_c)) {
                uint256 var_c = var_c + 0x80;
                if (var_o > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
                } else {
                    var_p = keccak256(memory[0:0x3c]);
                    require(memory[0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0x6209b13d
    /// @custom:signature   Unresolved_6209b13d(address arg0, uint256 arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_6209b13d(address arg0, uint256 arg1, uint256 arg2) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(store_h, "Withdraw is disabled");
        require(storage_map_e[msg.sender].field_0, "Not whitelisted");
        require(store_f != 0x02, "ReentrancyGuard: reentrant call");
        store_f = 0x02;
        require(arg0, "Invalid token address");
        require(store_i, "Invalid withdrawRecipient address");
        (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (!success) {
            if (!arg1) {
                require(arg2, "Amount must be greater than 0");
                require(arg2 <= 0, "Insufficient token balance");
                if (!(var_i + 0x80 > 0xffffffffffffffff | var_i + 0x80 < var_i)) {
                    uint256 var_i = var_i + 0x80;
                    if (!(var_i + 0x40 > 0xffffffffffffffff | var_i + 0x40 < var_i)) {
                        uint256 var_i = var_i + 0x40;
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_i); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(!var_m);
                            } else {
                                require(var_m, "Address: call to non-contract");
                                require(!var_m, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_i, arg2);
                                store_f = 0x01;
                                return ;
                            }
                        } else {
                            if (ret0.length <= 0xffffffffffffffff && !(var_i + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_i + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i)) {
                                uint256 var_i = var_i + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                require(success);
                                require(arg0.code.length, "Address: call to non-contract");
                                require(!var_u, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_i, arg2);
                                store_f = 0x01;
                                return ;
                            }
                        }
                    }
                }
            } else {
                require(0, "No tokens available for withdrawal");
                if (!(var_i + 0x80 > 0xffffffffffffffff | var_i + 0x80 < var_i)) {
                    uint256 var_i = var_i + 0x80;
                    if (!(var_i + 0x40 > 0xffffffffffffffff | var_i + 0x40 < var_i)) {
                        uint256 var_i = var_i + 0x40;
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_i); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(!var_m);
                                if (0 < var_u) {
                                    revert("SafeERC20: low-level call failed");
                                } else {
                                    revert("\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                                }
                            } else {
                                require(var_m, "Address: call to non-contract");
                                require(0x60 + var_m - 0x60 >= 0x20);
                                require(!(0x44 - 0x44));
                                require(0x44, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_i, 0);
                                store_f = 0x01;
                                return ;
                            }
                        } else {
                            if (ret0.length <= 0xffffffffffffffff && !(var_i + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_i + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i)) {
                                require(success);
                                require(arg0.code.length, "Address: call to non-contract");
                                require(!var_u, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_i, 0);
                                store_f = 0x01;
                                return ;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable returns (uint256)
    function Unresolved_715018a6() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_j = store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
        return ;
    }
    
    /// @custom:selector    0x9ec004a2
    /// @custom:signature   Unresolved_9ec004a2(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_9ec004a2(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_b = store_b & 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff | arg0 << 0xa8 & 0xff000000000000000000000000000000000000000000;
        emit Event_e9598c82(arg0);
        return ;
    }
    
    /// @custom:selector    0xa28c0efa
    /// @custom:signature   Unresolved_a28c0efa(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_a28c0efa(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xe0);
        require(!(arg0 - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(!(arg4 - arg4));
        require(arg6 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg6] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg6];
            uint256 var_e = msg.data[0x04 + arg6 + 0x20:0x04 + arg6 + 0x20 + var_d];
            require(store_f != 0x02, "ReentrancyGuard: reentrant call");
            store_f = 0x02;
            require(store_d, "Swap is disabled");
            require(block.timestamp <= arg5, "Transaction expired");
            if (!(var_c + 0x80 > 0xffffffffffffffff | var_c + 0x80 < var_c)) {
                uint256 var_c = var_c + 0x80;
                if (var_o > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
                } else {
                    var_p = keccak256(memory[0:0x3c]);
                    require(memory[0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0xb31d26eb
    /// @custom:signature   Unresolved_b31d26eb(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b31d26eb(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid address");
        storage_map_e[arg0] = storage_map_e[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit WhitelistUpdated(arg0, 0);
        return ;
    }
    
    /// @custom:selector    0xc0696e1b
    /// @custom:signature   Unresolved_c0696e1b(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c0696e1b(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_e[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xe01af92c
    /// @custom:signature   Unresolved_e01af92c(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_e01af92c(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_b = store_b & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | arg0 << 0xa0 & 0xff0000000000000000000000000000000000000000;
        emit Event_36863eb5(arg0);
        return ;
    }
    
    /// @custom:selector    0xf2f53993
    /// @custom:signature   Unresolved_f2f53993(address arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_f2f53993(address arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(!(arg0 - arg0));
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg5] << 0x05) + (0x04 + arg5) + 0x20 <= msg.data.length);
        require(arg6 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg6] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg6] << 0x05) + (0x04 + arg6) + 0x20 <= msg.data.length);
        require(!(arg7 - arg7));
        require(!(arg9 - arg9));
        require(arg10 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg10] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg10]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg10]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_d = msg.data[0x04 + arg10];
            require(store_f != 0x02, "ReentrancyGuard: reentrant call");
            store_f = 0x02;
            if (!store_d) {
                revert("Swap is disabled");
            } else {
                revert("Transaction expired");
            }
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_j = store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        return ;
    }
    
    /// @custom:selector    0xfb3a6007
    /// @custom:signature   Unresolved_fb3a6007(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_fb3a6007(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xe0);
        require(!(arg0 - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(!(arg4 - arg4));
        require(arg6 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg6] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg6]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_d = msg.data[0x04 + arg6];
            require(store_f != 0x02, "ReentrancyGuard: reentrant call");
            store_f = 0x02;
            if (!store_d) {
                revert("Swap is disabled");
            } else {
                revert("Transaction expired");
            }
        }
    }
    
    /// @custom:selector    0x2b7ac3f3
    /// @custom:signature   verifier() public view returns (address)
    function verifier() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_g;
    }
    
    /// @custom:selector    0x2287e96a
    /// @custom:signature   withdrawEnabled() public view returns (bool)
    function withdrawEnabled() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_h;
    }
    
    /// @custom:selector    0x476343ee
    /// @custom:signature   withdrawFees() public payable returns (uint256)
    function withdrawFees() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(store_f != 0x02, "ReentrancyGuard: reentrant call");
        store_f = 0x02;
        require(address(this).balance, "No fees available to withdraw");
        payable(address(msg.sender)).transfer(address(this).balance);
        require(success);
        emit FeesWithdrawn(msg.sender, address(this).balance);
        store_f = 0x01;
        return ;
    }
    
    /// @custom:selector    0xdcbe353f
    /// @custom:signature   withdrawRecipient() public view returns (address)
    function withdrawRecipient() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_i;
    }
}