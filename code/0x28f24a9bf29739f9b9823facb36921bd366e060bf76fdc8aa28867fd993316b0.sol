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
    uint256 store_g; // storage slot: 0x00
    bytes32[] store_f; // storage slot: 0x01
    address public unresolved_8da5cb5b; // storage slot: 0x03
    bytes32 store_d; // storage slot: 0x03
    bytes32 store_e; // storage slot: 0x06
    uint256 store_c; // storage slot: 0x07
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x04
    mapping(uint256 => uint8) storage_map_h; // storage slot: 0x05
    
    error CustomError_00000000();
    event Event_1721c796();
    event Event_efc76d15();
    event OwnerUpdated(address);
    event SignersChanged(address[]);
    
    /// @custom:selector    0x4c5261aa
    /// @custom:signature   counterparty(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function counterparty(address arg0) public view returns (bool) {
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0x37791233
    /// @custom:signature   setDiff(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setDiff(uint256 arg0) public {
        require(msg.sender == unresolved_8da5cb5b, CustomError_6db2465f());
        store_c = arg0;
        emit Event_1721c796(arg0);
    }
    
    /// @custom:selector    0x13af4035
    /// @custom:signature   Unresolved_13af4035(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_13af4035(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_6db2465f());
        require(arg0, CustomError_d92e233d());
        store_d = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
        emit OwnerUpdated(arg0);
    }
    
    /// @custom:selector    0x2079fb9a
    /// @custom:signature   Unresolved_2079fb9a(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_2079fb9a(uint256 arg0) public view returns (address) {
        require(arg0 < store_e);
        return store_e[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0x20ff430b
    /// @custom:signature   Unresolved_20ff430b(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_20ff430b(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x2645a82f
    /// @custom:signature   Unresolved_2645a82f(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_2645a82f(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_6db2465f());
        storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        emit Event_efc76d15(arg0, arg1);
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view returns (uint256)
    function Unresolved_84b0196e() public view returns (uint256) {
        if ((store_f & 0x01) - (store_f >> 0x01 < 0x20) && (store_f & 0x01) - (store_f >> 0x01 < 0x20)) {
            require(0x01 <= 0x1f, CustomError_b3512b0c());
            uint256 var_a = var_a + 0x20;
            return abi.encodePacked(0x0f00000000000000000000000000000000000000000000000000000000000000, 0xe0, var_a + 0xe0 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, block.chainid, address(this), 0, var_a + 0xe0 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, var_k, var_k, var_k);
        }
    }
    
    /// @custom:selector    0xa3772662
    /// @custom:signature   Unresolved_a3772662(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a3772662(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(msg.sender == unresolved_8da5cb5b, CustomError_6db2465f());
                if (0 >= var_c) {
                    store_e = var_c;
                    emit SignersChanged(0x20, var_c);
                } else {
                    require(0 >= var_c, CustomError_d92e233d());
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0xb5b50906
    /// @custom:signature   Unresolved_b5b50906(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_b5b50906(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4) public payable {
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 + (msg.data.length - 0x04) >= 0x0100);
        require(arg9 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg9] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg9] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg9] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg9] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f);
            require(store_g - 0x02, CustomError_3ee5aeb5());
            store_g = 0x02;
            require(storage_map_a[msg.sender].field_0, CustomError_5c427cd9());
            require(arg0, CustomError_b0815ef5());
            if (0x2710 <= store_c + 0x2710 && (store_c + 0x2710 == (store_c + 0x2710) * arg4 / arg4 | !arg4 && arg0 == arg0 * 0x2710 / 0x2710 | !0x2710)) {
                require(arg0 * 0x2710 <= (store_c + 0x2710) * arg4, CustomError_b0815ef5());
                require(0x24 + (msg.data.length - 0x24) - 0x24 >= 0x0100);
                if (!(var_a + 0x0100 < var_a | var_a + 0x0100 > 0xffffffffffffffff)) {
                    require(true);
                    require(true);
                }
            }
        }
    }
    
    /// @custom:selector    0x409fa6b8
    /// @custom:signature   usedQuote(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function usedQuote(bytes32 arg0) public view returns (bool) {
        return storage_map_h[arg0].field_0;
    }
}