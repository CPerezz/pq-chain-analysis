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
    bytes public constant unresolved_ffa1ad74 = 0xBytes([115, 32, 118, 97, 108, 105, 100, 97, 116, 105, 111, 110, 32, 118, 101, 114, 115, 105, 111, 110, 32, 49, 46, 49, 46, 48]);
    
    address store_h; // storage slot: 0x00
    bytes32 store_b; // storage slot: 0x00
    address public pendingAdmin; // storage slot: 0x01
    bytes32 store_c; // storage slot: 0x01
    bytes store_d; // storage slot: 0x03
    address store_i; // storage slot: 0x04
    bytes32 store_f; // storage slot: 0x04
    uint256 public maxGasPrice; // storage slot: 0x05
    
    mapping(address => bytes32) storage_map_g; // storage slot: 0x02
    
    
    /// @custom:selector    0x77f50f97
    /// @custom:signature   claimAdmin() public
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "pendingAdmin != msg.sender");
        store_b = pendingAdmin | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_b;
        store_c = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_c;
    }
    
    /// @custom:selector    0x27a099d8
    /// @custom:signature   getOperators() public view returns (bytes memory)
    function getOperators() public view returns (bytes memory) {
        uint256 var_a = var_a + (0x20 + 0x20 * store_d);
        return abi.encodePacked(0x20 + var_a - var_a, var_f);
    }
    
    /// @custom:selector    0x12f4a496
    /// @custom:signature   minNonce() public view returns (uint32)
    function minNonce() public view returns (uint32) {
        return uint32(store_f / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x0769ae77
    /// @custom:signature   operatorAllowed(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function operatorAllowed(address arg0) public view returns (bool) {
        return storage_map_g[arg0].field_0;
    }
    
    /// @custom:selector    0xac8a584a
    /// @custom:signature   removeOperator(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeOperator(address arg0) public {
        require(msg.sender == store_h, "onlyAdmin");
        require(storage_map_g[arg0].field_0, "operator is not in the operatorsGroup.");
        storage_map_g[arg0] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[arg0];
        if (0 < store_d && (0 < store_d && (store_d - 0x01 < store_d && 0 < store_d))) {
            store_d[0] = store_d[store_d - 0x01].field_0.field_0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d[0];
            if (store_d) {
                store_d[store_d - 0x01] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d[store_d - 0x01];
                store_d -= 0x01;
            }
        }
    }
    
    /// @custom:selector    0xd2fa635e
    /// @custom:signature   setMaxGasPrice(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setMaxGasPrice(uint256 arg0) public {
        require(storage_map_g[msg.sender].field_0, "onlyOperator");
        maxGasPrice = arg0;
    }
    
    /// @custom:selector    0x75829def
    /// @custom:signature   transferAdmin(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function transferAdmin(address arg0) public {
        require(msg.sender == store_h, "onlyAdmin");
        store_c = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_c;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256) {
        require(arg1 <= 0x0100000000);
        require(0x04 + arg1 + 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!(msg.data[0x04 + arg1] > 0x0100000000 | 0x20 + (0x04 + arg1) + msg.data[0x04 + arg1] > 0x04 + (msg.data.length - 0x04)));
        uint256 var_a = var_a + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
        uint256 var_c = msg.data[0x20 + (0x04 + arg1):0x20 + (0x04 + arg1) + msg.data[0x04 + arg1]];
        require(store_i != 0, "SIGNER==address(0)");
        if (var_e != 0x57) {
            if (maxGasPrice >= tx.gasprice) {
                if (var_e >= 0x45) {
                    revert("rfq order is cancalled.");
                } else {
                    revert("GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED");
                }
            } else {
                uint256 var_f = 0x20 + (0x04 + var_a) - (0x04 + var_a);
                revert("signature check error 1.");
            }
        } else {
            require(var_e >= 0x55, "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED");
            require(var_e >= 0x57, "GREATER_OR_EQUAL_TO_2_LENGTH_REQUIRED");
            require(uint16((var_j & 0xffff000000000000000000000000000000000000000000000000000000000000) >> 0xf0) < 0x2710, "FEE_FACTOR_MORE_THEN_10000");
            if (0 < var_e) {
                require(var_e >= 0x21, "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED");
                require(var_e >= 0x41, "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED");
                uint256 var_a = 0x20 + var_a;
                address var_w = ecrecover(keccak256(memory[0x20 + var_a:0x20 + var_a + var_e]), uint8(var_c >> 0xf8 << 0xf8 >> 0xf8), var_t, var_v);
                require(memory[0x20]);
                require(store_i == address(var_w), "INVALID_MMP_SIGNATURE");
                return 0xb067138100000000000000000000000000000000000000000000000000000000;
            }
        }
    }
    
    /// @custom:selector    0x582abd12
    /// @custom:signature   Unresolved_582abd12() public view returns (address)
    function Unresolved_582abd12() public view returns (address) {
        return store_i;
    }
    
    /// @custom:selector    0x6c19e783
    /// @custom:signature   Unresolved_6c19e783(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6c19e783(address arg0) public {
        require(msg.sender == store_h, "onlyAdmin");
        store_f = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
    }
    
    /// @custom:selector    0x9870d7fe
    /// @custom:signature   Unresolved_9870d7fe(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9870d7fe(address arg0) public {
        require(msg.sender == store_h, "onlyAdmin");
        require(!storage_map_g[arg0].field_0, "duplicated newOperator");
        storage_map_g[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[arg0];
        store_d += 0x01;
        store_d[store_d + 0x01 - 0x01] = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d[store_d + 0x01 - 0x01];
    }
    
    /// @custom:selector    0xea5cc585
    /// @custom:signature   Unresolved_ea5cc585(uint32 arg0) public
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_ea5cc585(uint32 arg0) public {
        require(storage_map_g[msg.sender].field_0, "onlyOperator");
        store_f = arg0 * 0x010000000000000000000000000000000000000000 | 0xffffffffffffffff00000000ffffffffffffffffffffffffffffffffffffffff & store_f;
    }
    
    /// @custom:selector    0xf851a440
    /// @custom:signature   Unresolved_f851a440() public view returns (address)
    function Unresolved_f851a440() public view returns (address) {
        return store_h;
    }
    
    /// @custom:selector    0x1b9a91a4
    /// @custom:signature   withdrawEth(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function withdrawEth(address arg0, uint256 arg1) public {
        require(msg.sender == store_h, "onlyAdmin");
        require(arg0 != 0, "_to == address(0)");
        payable(address(arg0)).transfer(arg1);
        require(success);
    }
    
    /// @custom:selector    0x01e33667
    /// @custom:signature   withdrawToken(address arg0, address arg1, uint256 arg2) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function withdrawToken(address arg0, address arg1, uint256 arg2) public {
        require(msg.sender == store_h, "onlyAdmin");
        require(arg1 != 0, "_to == address(0)");
        uint256 var_c = 0x20 + (0x20 + (0x24 + var_d)) - var_d - 0x20;
        (bool success, bytes memory ret0) = address(arg0).Unresolved_00000000{ value: 0 }(var_j); // call
        if (ret0.length == 0) {
            require(success, "ERC20(_token).transfer failed.");
            if (var_k > 0) {
                require(var_k >= 0x20);
                require(var_c, "ERC20(_token).transfer return data is false.");
            }
        } else {
            uint256 var_d = var_d + (ret0.length + 0x3f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(success, "ERC20(_token).transfer failed.");
        }
    }
}