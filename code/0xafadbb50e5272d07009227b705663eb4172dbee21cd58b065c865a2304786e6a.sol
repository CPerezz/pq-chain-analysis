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
    bytes32 store_d; // storage slot: 0x01
    uint8 store_f; // storage slot: 0x01
    address store_e; // storage slot: 0x02
    bytes store_c; // storage slot: 0x03
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x00
    mapping(address => bytes) storage_map_b; // storage slot: 0x04
    
    event Event_5db9ee0a();
    event Event_62e78cea();
    event PauserAdded(address);
    event PauserRemoved(address);
    event Settle(address, uint256, uint256, uint256);
    event Withdraw(address, uint256, address, uint256);
    
    /// @custom:selector    0x82dc1ec4
    /// @custom:signature   addPauser(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addPauser(address arg0) public {
        require(msg.sender, "Roles: account is the zero address");
        require(storage_map_a[msg.sender].field_0, "PauserRole: caller does not have the Pauser role");
        require(arg0, "Roles: account is the zero address");
        require(!storage_map_a[arg0].field_0, "Roles: account already has role");
        storage_map_a[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        emit PauserAdded(arg0);
    }
    
    /// @custom:selector    0x1f69565f
    /// @custom:signature   getTokenInfo(address arg0) public returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getTokenInfo(address arg0) public returns (bytes memory) {
        if (arg0) {
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            require(ret0.length >= 0x20);
            return abi.encodePacked(var_f, storage_map_b[arg0], store_c);
        } else {
            var_g = storage_map_b[arg0];
            return abi.encodePacked(address(this).balance, var_g, store_c);
        }
    }
    
    /// @custom:selector    0x46fbf68e
    /// @custom:signature   isPauser(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isPauser(address arg0) public view returns (bool) {
        require(arg0, "Roles: account is the zero address");
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0x6ef8d66d
    /// @custom:signature   renouncePauser() public
    function renouncePauser() public {
        require(msg.sender, "Roles: account is the zero address");
        require(storage_map_a[msg.sender].field_0, "Roles: account does not have role");
        storage_map_a[msg.sender] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[msg.sender];
        emit PauserRemoved(msg.sender);
    }
    
    /// @custom:selector    0x074540da
    /// @custom:signature   Unresolved_074540da(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_074540da(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg4]) / 0x20 * 0x20);
        require(block.timestamp > 0x01fe3480 + store_c, "You must wait until the channel is unused for 387 days");
        uint256 var_a = var_a + 0x88;
        if (var_m >= 0x1b) {
            uint256 var_a = var_a + 0x20;
            var_o = keccak256(memory[0x20 + var_a:0x20 + var_a + var_k]);
            require(memory[0x20]);
            require(address(store_d / 0x0100) == address(var_v), "Message signer must be signator to this channel");
            require(arg3 > storage_map_b[arg0], "Outdated nonce");
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), var_z); // staticcall
            require(success);
            require(ret0.length >= 0x20);
            if (var_k >= arg2) {
                require(arg0.code.length);
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_e, arg2, var_aa); // call
                require(success);
                require(ret0.length >= 0x20);
                require(var_k, "Token send error");
                store_c = block.timestamp;
                storage_map_b[arg0] = arg3;
                require(arg0.code.length);
                (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), arg2); // staticcall
                require(success);
                require(ret0.length >= 0x20);
                emit Settle(arg0, arg3, arg2, var_k);
                if (var_k) {
                    if (arg0) {
                        require(arg0.code.length);
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(arg1, var_k, var_aa); // call
                        require(success);
                        require(ret0.length >= 0x20);
                        require(var_k, "Token send error");
                    } else {
                        payable(address(arg1)).transfer(var_k);
                        require(success);
                    }
                    store_c = block.timestamp;
                }
                emit Withdraw(arg0, arg3, arg1, var_k);
            } else {
                address var_w = var_w;
                revert("Not enough funds to pay payments");
            }
        } else {
            uint256 var_a = var_a + 0x20;
            var_o = keccak256(memory[0x20 + var_a:0x20 + var_a + var_k]);
            revert();
        }
    }
    
    /// @custom:selector    0x29f1c849
    /// @custom:signature   Unresolved_29f1c849(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_29f1c849(address arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4) public {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg4]) / 0x20 * 0x20);
        require(msg.sender == store_e, "Can only be settled by counterparty");
        uint256 var_a = var_a + 0x88;
        if (var_m >= 0x1b) {
            uint256 var_a = var_a + 0x20;
            var_o = keccak256(memory[0x20 + var_a:0x20 + var_a + var_k]);
            require(memory[0x20]);
            require(address(store_d / 0x0100) == address(var_v), "Message signer must be signator to this channel");
            require(arg3 > storage_map_b[arg0], "Outdated nonce");
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), var_z); // staticcall
            require(success);
            require(ret0.length >= 0x20);
            if (var_k >= arg2) {
                require(arg0.code.length);
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_e, arg2, var_aa); // call
                require(success);
                require(ret0.length >= 0x20);
                require(var_k, "Token send error");
                store_c = block.timestamp;
                storage_map_b[arg0] = arg3;
                require(arg0.code.length);
                (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), arg2); // staticcall
                require(success);
                require(ret0.length >= 0x20);
                emit Settle(arg0, arg3, arg2, var_k);
                if (var_k) {
                    if (arg0) {
                        require(arg0.code.length);
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(arg1, var_k, var_aa); // call
                        require(success);
                        require(ret0.length >= 0x20);
                        require(var_k, "Token send error");
                    } else {
                        payable(address(arg1)).transfer(var_k);
                        require(success);
                    }
                    store_c = block.timestamp;
                }
                emit Withdraw(arg0, arg3, arg1, var_k);
            } else {
                address var_w = var_w;
                revert("Not enough funds to pay payments");
            }
        } else {
            uint256 var_a = var_a + 0x20;
            var_o = keccak256(memory[0x20 + var_a:0x20 + var_a + var_k]);
            revert();
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public
    function Unresolved_3f4ba83a() public {
        require(msg.sender, "Roles: account is the zero address");
        require(storage_map_a[msg.sender].field_0, "PauserRole: caller does not have the Pauser role");
        require(store_f, "Pausable: not paused");
        store_d = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return store_f;
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public
    function Unresolved_8456cb59() public {
        require(msg.sender, "Roles: account is the zero address");
        require(storage_map_a[msg.sender].field_0, "PauserRole: caller does not have the Pauser role");
        require(!store_f, "Pausable: paused");
        store_d = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0xe4860339
    /// @custom:signature   Unresolved_e4860339(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e4860339(address arg0) public view returns (uint256) {
        return storage_map_b[arg0];
    }
    
    /// @custom:selector    0xf54d8539
    /// @custom:signature   Unresolved_f54d8539(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_f54d8539(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public {
        require(arg3 <= 0x0100000000);
        require(0x04 + arg3 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg3] > 0x0100000000 | 0x20 + (0x04 + arg3) + msg.data[0x04 + arg3] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg3]) / 0x20 * 0x20);
        require(msg.sender == store_e, "Can only be settled by counterparty");
        uint256 var_a = var_a + 0x74;
        if (var_l >= 0x1b) {
            uint256 var_a = var_a + 0x20;
            var_n = keccak256(memory[0x20 + var_a:0x20 + var_a + var_j]);
            require(memory[0x20]);
            require(address(store_d / 0x0100) == address(var_u), "Message signer must be signator to this channel");
            require(arg2 > storage_map_b[arg0], "Outdated nonce");
            require(arg0.code.length);
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), var_y); // staticcall
            require(success);
            require(ret0.length >= 0x20);
            if (var_j >= arg1) {
                if (arg0) {
                    require(arg0.code.length);
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(store_e, arg1, var_z); // call
                    require(success);
                    require(ret0.length >= 0x20);
                    require(var_j, "Token send error");
                    store_c = block.timestamp;
                    storage_map_b[arg0] = arg2;
                    if (arg0) {
                        require(arg0.code.length);
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this), arg1); // staticcall
                        require(success);
                        require(ret0.length >= 0x20);
                        emit Settle(arg0, arg2, arg1, var_j);
                    } else {
                        emit Settle(arg0, arg2, arg1, address(this).balance);
                    }
                } else {
                    payable(address(store_e)).transfer(arg1);
                    revert();
                }
            } else {
                address var_v = var_v;
                revert("Not enough funds to pay payments");
            }
        } else {
            uint256 var_a = var_a + 0x20;
            var_n = keccak256(memory[0x20 + var_a:0x20 + var_a + var_j]);
            revert();
        }
    }
}