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
    bytes32 store_a; // storage slot: 0x01
    uint8 store_c; // storage slot: 0x01
    
    mapping(address => uint8) storage_map_b; // storage slot: 0x00
    
    event Event_0909e8f7();
    event Event_59bed9ab();
    
    /// @custom:selector    0x158ef93e
    /// @custom:signature   Unresolved_158ef93e() public view returns (bool)
    function Unresolved_158ef93e() public view returns (bool) {
        return uint8(store_a / 0x0100);
    }
    
    /// @custom:selector    0x49acb2db
    /// @custom:signature   Unresolved_49acb2db(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_49acb2db(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public {
        require(arg2 <= 0x0100000000);
        require(0x04 + arg2 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg2] > 0x0100000000 | 0x20 + (0x04 + arg2) + msg.data[0x04 + arg2] > 0x04 + (msg.data.length - 0x04)));
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        require(storage_map_b[msg.sender].field_0, "Non-signer in onlySigner method");
        uint256 var_c = 0x40 + var_c;
        require(var_j == 0x41, "Invalid signature - wrong length");
        require(var_r <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "ECDSA: invalid signature 's' value");
        uint256 var_c = 0x20 + var_c;
        address var_y = ecrecover(keccak256(memory[0x20 + var_c:0x20 + var_c + var_j]), uint8(var_u), var_w, var_r);
        require(memory[0x20]);
        require(store_c, "External transfer in safe mode");
        require(storage_map_b[arg0].field_0, "External transfer in safe mode");
        require(arg3 >= block.timestamp, "Transaction expired");
        require(storage_map_b[address(var_y)].field_0, "Invalid signer");
        require(address(var_y) != msg.sender, "Signers cannot be equal");
        uint256 var_j = msg.data[0x20 + (0x04 + arg2):0x20 + (0x04 + arg2) + msg.data[0x04 + arg2]];
        payable(address(arg0)).transfer(arg1);
        require(success, "Call execution failed");
        emit Event_59bed9ab(msg.sender, address(var_y), keccak256(memory[0x20 + var_c:0x20 + var_c + var_j]), arg0, arg1, 0x20 + (0x20 + (0x20 + (0x20 + (0x20 + (0x20 + var_c))))) - var_c, msg.data[0x04 + arg2]);
    }
    
    /// @custom:selector    0x736c0d5b
    /// @custom:signature   Unresolved_736c0d5b(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_736c0d5b(address arg0) public view returns (bool) {
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x7df73e27
    /// @custom:signature   Unresolved_7df73e27(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7df73e27(address arg0) public view returns (bool) {
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0xabe3219c
    /// @custom:signature   Unresolved_abe3219c() public view returns (bool)
    function Unresolved_abe3219c() public view returns (bool) {
        return store_c;
    }
    
    /// @custom:selector    0xc6044c46
    /// @custom:signature   Unresolved_c6044c46(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c6044c46(uint256 arg0, address arg1) public {
        require(arg0 <= 0x0100000000);
        require(0x04 + arg0 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg0] > 0x0100000000 | 0x20 + (0x04 + arg0) + msg.data[0x04 + arg0] * 0x20 > 0x04 + (msg.data.length - 0x04)));
        require(!uint8(store_a / 0x0100), "Contract already initialized");
        require(msg.data[0x04 + arg0] == 0x05, "Invalid number of signers");
        if (0 >= msg.data[0x04 + arg0]) {
            store_a = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_a;
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(address(msg.data[0x20 + (0x04 + arg0)]) != 0, "Invalid signer");
            }
        }
    }
    
    /// @custom:selector    0xd9b4914d
    /// @custom:signature   Unresolved_d9b4914d(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_d9b4914d(address arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public {
        require(arg4 <= 0x0100000000);
        require(0x04 + arg4 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg4] > 0x0100000000 | 0x20 + (0x04 + arg4) + msg.data[0x04 + arg4] > 0x04 + (msg.data.length - 0x04)));
        require(storage_map_b[msg.sender].field_0, "Non-signer in onlySigner method");
        uint256 var_c = 0x40 + var_c;
        uint256 var_g = msg.data[0x20 + (0x04 + arg4):0x20 + (0x04 + arg4) + msg.data[0x04 + arg4]];
        require(var_j == 0x41, "Invalid signature - wrong length");
        require(var_r <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "ECDSA: invalid signature 's' value");
        uint256 var_c = 0x20 + var_c;
        address var_y = ecrecover(keccak256(memory[0x20 + var_c:0x20 + var_c + var_j]), uint8(var_u), var_w, var_r);
        require(memory[0x20]);
        require(store_c, "External transfer in safe mode");
        require(storage_map_b[arg0].field_0, "External transfer in safe mode");
        require(arg3 >= block.timestamp, "Transaction expired");
        require(storage_map_b[address(var_y)].field_0, "Invalid signer");
        require(address(var_y) != msg.sender, "Signers cannot be equal");
        (bool success, bytes memory ret0) = address(arg2).Unresolved_00000000{ value: 0 }(var_ad); // call
        if (ret0.length == 0) {
            if (!success) {
                require(success, "TransferHelper::safeTransfer: transfer failed");
            } else {
                if (var_ag != 0) {
                    require(var_ag >= 0x20);
                }
            }
        } else {
            uint256 var_c = var_c + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (!success) {
                require(success, "TransferHelper::safeTransfer: transfer failed");
            } else {
                require(var_j == 0, "TransferHelper::safeTransfer: transfer failed");
            }
        }
    }
    
    /// @custom:selector    0xfc0f392d
    /// @custom:signature   Unresolved_fc0f392d() public
    function Unresolved_fc0f392d() public {
        require(storage_map_b[msg.sender].field_0, "Non-signer in onlySigner method");
        store_a = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_a;
        emit Event_0909e8f7(msg.sender);
    }
}