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
    uint256 store_a; // storage slot: 0x00
    address public unresolved_8da5cb5b; // storage slot: 0x01
    bytes32 store_m; // storage slot: 0x01
    uint8 store_j; // storage slot: 0x01
    address public unresolved_f4592c73; // storage slot: 0x02
    bytes32 store_r; // storage slot: 0x02
    address store_o; // storage slot: 0x03
    bytes32 store_d; // storage slot: 0x03
    uint8 store_f; // storage slot: 0x03
    uint8 store_h; // storage slot: 0x03
    address store_k; // storage slot: 0x04
    bytes32 store_e; // storage slot: 0x04
    bytes32 store_g; // storage slot: keccak256(memory[var_g:var_g + 0x40])
    bytes32 store_n; // storage slot: keccak256(memory[var_l:var_l + 0x40])
    bytes32 store_q; // storage slot: keccak256(memory[var_d:var_d + 0x40])
    bytes32 store_t; // storage slot: keccak256(memory[var_k:var_k + 0x40])
    uint256 store_c; // storage slot: var_t
    uint256 store_l; // storage slot: var_g
    uint256 store_u; // storage slot: var_a
    uint8 store_i; // storage slot: keccak256(memory[var_g:var_g + 0x40])
    uint8 store_s; // storage slot: keccak256(memory[var_d:var_d + 0x40])
    
    event ETHWithdrawn(address, uint256, address);
    event Event_36863eb5();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event Event_c9e512d7();
    event Event_e9598c82();
    event FeesWithdrawn(address, uint256);
    event RouterUpdated(address, address);
    event TokenWithdrawn(address, address, uint256, address);
    event WhitelistUpdated(address, bool);
    
    /// @custom:selector    0x95ccea67
    /// @custom:signature   emergencyWithdraw(address arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function emergencyWithdraw(address arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(store_a != 0x02, "ReentrancyGuard: reentrant call");
        store_a = 0x02;
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        if (!(var_f + 0x80 > 0xffffffffffffffff | var_f + 0x80 < var_f)) {
            uint256 var_f = var_f + 0x80;
            if (!(var_f + 0x40 > 0xffffffffffffffff | var_f + 0x40 < var_f)) {
                uint256 var_f = var_f + 0x40;
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
                if (!ret0.length) {
                    if (!success) {
                        require(!var_k);
                        if (0 < var_o) {
                            revert("SafeERC20: low-level call failed");
                        } else {
                            revert("\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                        }
                    } else {
                        require(var_k, "Address: call to non-contract");
                        if (var_k) {
                            require(0x60 + var_k - 0x60 >= 0x20);
                            require(!(var_s - var_s));
                            require(var_s, "SafeERC20: ERC20 operation did not succeed");
                        } else {
                            require(!var_k, "SafeERC20: ERC20 operation did not succeed");
                        }
                        store_c = 0x01;
                        return ;
                    }
                } else {
                    if (ret0.length <= 0xffffffffffffffff && !(var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f)) {
                        require(success);
                        require(arg0.code.length, "Address: call to non-contract");
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x5437988d
    /// @custom:signature   setVerifier(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setVerifier(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid verifier address");
        store_d = store_d & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
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
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return ;
    }
    
    /// @custom:selector    0x6ddd1713
    /// @custom:signature   swapEnabled() public view returns (bool)
    function swapEnabled() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        return store_f;
    }
    
    /// @custom:selector    0x0c9708cb
    /// @custom:signature   Unresolved_0c9708cb(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0c9708cb(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid address");
        store_g = store_g & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit WhitelistUpdated(arg0, 0x01);
        return ;
    }
    
    /// @custom:selector    0x2e74dc94
    /// @custom:signature   Unresolved_2e74dc94(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_2e74dc94(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(store_h, "Withdraw is disabled");
        require(store_i, "Not whitelisted");
        require(store_a != 0x02, "ReentrancyGuard: reentrant call");
        store_a = 0x02;
        require(!store_j, "Pausable: paused");
        require(store_k, "Invalid withdrawRecipient");
        require(arg0, "Amount must be > 0");
        require(address(this).balance, "Amount must be > 0");
        require(address(this).balance >= address(this).balance, "Insufficient ETH");
        payable(address(store_k)).transfer(address(this).balance);
        if (!ret0.length) {
            require(success, "ETH transfer failed");
            emit ETHWithdrawn(msg.sender, store_k, address(this).balance);
            store_l = 0x01;
            return ;
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable returns (uint256)
    function Unresolved_3f4ba83a() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(store_j, "Pausable: not paused");
        store_m = store_m & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit Event_5db9ee0a(msg.sender);
        return ;
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        return store_j;
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
        require(store_i, "Not whitelisted");
        require(store_a != 0x02, "ReentrancyGuard: reentrant call");
        store_a = 0x02;
        require(!store_j, "Pausable: paused");
        require(arg0, "Invalid token address");
        require(store_k, "Invalid withdrawRecipient address");
        (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (!success) {
            if (!arg1) {
                require(arg2, "Amount must be greater than 0");
                require(arg2 <= var_g, "Insufficient token balance");
                if (!(var_j + 0x80 > 0xffffffffffffffff | var_j + 0x80 < var_j)) {
                    uint256 var_j = var_j + 0x80;
                    if (!(var_j + 0x40 > 0xffffffffffffffff | var_j + 0x40 < var_j)) {
                        uint256 var_j = var_j + 0x40;
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_k); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(!var_n);
                            } else {
                                require(var_n, "Address: call to non-contract");
                                require(!var_n, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_k, arg2);
                                store_l = 0x01;
                                return ;
                            }
                        } else {
                            if (ret0.length <= 0xffffffffffffffff && !(var_j + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                                uint256 var_j = var_j + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                                require(success);
                                require(arg0.code.length, "Address: call to non-contract");
                                require(!var_v, "SafeERC20: ERC20 operation did not succeed");
                                emit TokenWithdrawn(msg.sender, arg0, store_k, arg2);
                                store_l = 0x01;
                                return ;
                            }
                        }
                    }
                }
            } else {
                require(var_g, "No tokens available for withdrawal");
                if (!(var_j + 0x80 > 0xffffffffffffffff | var_j + 0x80 < var_j)) {
                    uint256 var_j = var_j + 0x80;
                    if (!(var_j + 0x40 > 0xffffffffffffffff | var_j + 0x40 < var_j)) {
                        uint256 var_j = var_j + 0x40;
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_k); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(!var_n);
                                if (0 < var_v) {
                                    revert("SafeERC20: low-level call failed");
                                } else {
                                    revert("\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                                }
                            } else {
                                require(var_n, "Address: call to non-contract");
                                if (var_n) {
                                    require(0x60 + var_n - 0x60 >= 0x20);
                                    require(!(var_y - var_y));
                                    require(var_y, "SafeERC20: ERC20 operation did not succeed");
                                } else {
                                    require(!var_n, "SafeERC20: ERC20 operation did not succeed");
                                }
                                emit TokenWithdrawn(msg.sender, arg0, store_k, var_g);
                                store_l = 0x01;
                                return ;
                            }
                        } else {
                            if (ret0.length <= 0xffffffffffffffff && !(var_j + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                                require(success);
                                require(arg0.code.length, "Address: call to non-contract");
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
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_m = store_m & 0xffffffffffffffffffffff0000000000000000000000000000000000000000ff;
        emit Event_8be0079c(unresolved_8da5cb5b, var_a);
        return ;
    }
    
    /// @custom:selector    0x811c463c
    /// @custom:signature   Unresolved_811c463c(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    function Unresolved_811c463c(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0100);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(!(arg2 - arg2));
        require(arg5 <= 0xffffffffffffffff);
        require(arg5 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(arg5 + msg.data[0x04 + arg5] + 0x24 <= msg.data.length);
        require(arg6 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg6] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg6] << 0x05) + (0x04 + arg6) + 0x20 <= msg.data.length);
        require(arg7 <= 0xffffffffffffffff);
        require(arg7 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg7] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg7]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg7]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg7];
            require(arg7 + 0x24 + msg.data[0x04 + arg7] <= msg.data.length);
            uint256 var_e = msg.data[arg7 + 0x24:arg7 + 0x24 + var_d];
            require(store_a != 0x02, "ReentrancyGuard: reentrant call");
            store_a = 0x02;
            require(!store_j, "Pausable: paused");
            require(store_f, "Swap is disabled");
            require(block.timestamp <= arg4, "Transaction expired");
            require(arg4 > store_n, "Stale or replayed");
            if (!(var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                uint256 var_c = var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (var_r > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
                } else {
                    var_s = keccak256(memory[var_l:var_l + 0x3c]);
                    require(memory[0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable returns (uint256)
    function Unresolved_8456cb59() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(!store_j, "Pausable: paused");
        store_m = store_m & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit Event_62e78cea(msg.sender);
        return ;
    }
    
    /// @custom:selector    0x978dc00d
    /// @custom:signature   Unresolved_978dc00d(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_978dc00d(address arg0) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        return store_q;
    }
    
    /// @custom:selector    0x9ec004a2
    /// @custom:signature   Unresolved_9ec004a2(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_9ec004a2(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_d = store_d & 0xffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffffff | arg0 << 0xa8 & 0xff000000000000000000000000000000000000000000;
        emit Event_e9598c82(arg0);
        return ;
    }
    
    /// @custom:selector    0xb31d26eb
    /// @custom:signature   Unresolved_b31d26eb(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b31d26eb(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid address");
        store_g = store_g & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit WhitelistUpdated(arg0, var_g);
        return ;
    }
    
    /// @custom:selector    0xbc3fc39c
    /// @custom:signature   Unresolved_bc3fc39c(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_bc3fc39c(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x01e0);
        require(store_a != 0x02, "ReentrancyGuard: reentrant call");
        store_a = 0x02;
        require(!store_j, "Pausable: paused");
        require(store_f, "Swap is disabled");
        require(msg.data[arg0 + 0x84] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x84]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]]);
        if (msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]] <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_a = msg.data[0x04 + arg0 + msg.data[arg0 + 0x84]];
            if (block.timestamp > msg.data[arg0 + 0x44]) {
                revert("Transaction expired");
            } else {
                revert("Stale or replayed");
            }
        }
    }
    
    /// @custom:selector    0xbc7589a7
    /// @custom:signature   Unresolved_bc7589a7(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_bc7589a7(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid router");
        require(arg0 != unresolved_f4592c73, "Same router");
        store_r = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_r;
        emit RouterUpdated(unresolved_f4592c73, arg0);
        return ;
    }
    
    /// @custom:selector    0xc0696e1b
    /// @custom:signature   Unresolved_c0696e1b(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c0696e1b(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        return store_s;
    }
    
    /// @custom:selector    0xd5f8f782
    /// @custom:signature   Unresolved_d5f8f782(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    function Unresolved_d5f8f782(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0100);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(!(arg2 - arg2));
        require(arg5 <= 0xffffffffffffffff);
        require(arg5 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(arg5 + msg.data[0x04 + arg5] + 0x24 <= msg.data.length);
        require(arg6 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg6] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg6] << 0x05) + (0x04 + arg6) + 0x20 <= msg.data.length);
        require(arg7 <= 0xffffffffffffffff);
        require(arg7 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg7] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg7]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg7]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg7];
            require(arg7 + 0x24 + msg.data[0x04 + arg7] <= msg.data.length);
            uint256 var_e = msg.data[arg7 + 0x24:arg7 + 0x24 + var_d];
            require(store_a != 0x02, "ReentrancyGuard: reentrant call");
            store_a = 0x02;
            require(!store_j, "Pausable: paused");
            require(store_f, "Swap is disabled");
            require(block.timestamp <= arg4, "Transaction expired");
            require(arg4 > store_t, "Stale or replayed");
            if (!(var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                uint256 var_c = var_c + (var_c + 0x20 + 0x48 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (var_q > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
                } else {
                    var_r = keccak256(memory[var_k:var_k + 0x3c]);
                    require(memory[0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0xe01af92c
    /// @custom:signature   Unresolved_e01af92c(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_e01af92c(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_d = store_d & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | arg0 << 0xa0 & 0xff0000000000000000000000000000000000000000;
        emit Event_36863eb5(arg0);
        return ;
    }
    
    /// @custom:selector    0xf174cbe0
    /// @custom:signature   Unresolved_f174cbe0(uint256 arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f174cbe0(uint256 arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        if (var_e < msg.data[0x04 + arg0]) {
            require(!(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)] - address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)])));
            (bool success, bytes memory ret0) = address(0x22d473030f116ddee9f6b43ac78ba3).Unresolved_927da105(address(this)); // staticcall
            require(success);
            if (!success) {
                require(address(0x22d473030f116ddee9f6b43ac78ba3).code.length);
                address var_b = address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)]);
                (bool success, bytes memory ret0) = address(0x22d473030f116ddee9f6b43ac78ba3).Unresolved_87517c45{ value: var_e }(var_b); // call
                require(success);
                if (success) {
                    if (var_g <= 0xffffffffffffffff) {
                        var_g = var_g;
                        require(var_e);
                    }
                } else {
                    emit Event_c9e512d7(address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)]), unresolved_f4592c73, address(var_e));
                    (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)])).Unresolved_dd62ed3e(address(this)); // staticcall
                    require(success);
                    if (!success && !(var_g + 0x80 > 0xffffffffffffffff | var_g + 0x80 < var_g)) {
                        uint256 var_g = var_g + 0x80;
                        if (!(var_g + 0x40 > 0xffffffffffffffff | var_g + 0x40 < var_g)) {
                            uint256 var_g = var_g + 0x40;
                            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)])).Unresolved_095ea7b3{ value: 0 }(0x22d473030f116ddee9f6b43ac78ba3); // call
                            if (!ret0.length) {
                                if (!success) {
                                    require(!var_m);
                                    if (0 < var_q) {
                                        revert("SafeERC20: low-level call failed");
                                    } else {
                                        revert("\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                                    }
                                } else {
                                    require(var_m, "Address: call to non-contract");
                                    require(var_m, "SafeERC20: ERC20 operation did not succeed");
                                    require(0x60 + var_m - 0x60 >= 0x20);
                                    require(var_u - var_u, "SafeERC20: ERC20 operation did not succeed");
                                }
                            } else {
                                if (ret0.length <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                                    require(success);
                                    require(address(msg.data[0x04 + arg0 + 0x20 + (var_e << 0x05)]).code.length, "Address: call to non-contract");
                                }
                            }
                        }
                    }
                }
            }
        } else {
            return ;
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
        store_m = store_m & 0xffffffffffffffffffffff0000000000000000000000000000000000000000ff | arg0 << 0x08 & 0xffffffffffffffffffffffffffffffffffffffff00;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        return ;
    }
    
    /// @custom:selector    0x2b7ac3f3
    /// @custom:signature   verifier() public view returns (address)
    function verifier() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        return store_o;
    }
    
    /// @custom:selector    0x2287e96a
    /// @custom:signature   withdrawEnabled() public view returns (bool)
    function withdrawEnabled() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        return store_h;
    }
    
    /// @custom:selector    0x476343ee
    /// @custom:signature   withdrawFees() public payable returns (uint256)
    function withdrawFees() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(store_a != 0x02, "ReentrancyGuard: reentrant call");
        store_a = 0x02;
        require(address(this).balance, "No fees available to withdraw");
        payable(address(msg.sender)).transfer(address(this).balance);
        require(success);
        emit FeesWithdrawn(msg.sender, address(this).balance);
        store_u = 0x01;
        return ;
    }
    
    /// @custom:selector    0xdcbe353f
    /// @custom:signature   withdrawRecipient() public view returns (address)
    function withdrawRecipient() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= var_a);
        return store_k;
    }
}