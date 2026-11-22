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
    bytes32 store_e; // storage slot: 0x00
    uint16 store_g; // storage slot: 0x00
    bytes32 store_f; // storage slot: 0x01
    bytes32 store_c; // storage slot: 0x03
    uint32 store_a; // storage slot: 0x03
    
    mapping(uint32 => bytes32) storage_map_b; // storage slot: 0x02
    mapping(uint256 => uint8) storage_map_d; // storage slot: 0x04
    mapping(address => uint8) storage_map_h; // storage slot: 0x05
    
    error SignatureIndexesNotAscending();
    
    /// @custom:selector    0x1cfe7951
    /// @custom:signature   getCurrentGuardianSetIndex() public view returns (uint32)
    function getCurrentGuardianSetIndex() public view returns (uint32) {
        return store_a;
    }
    
    /// @custom:selector    0xf951975a
    /// @custom:signature   getGuardianSet(uint32 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function getGuardianSet(uint32 arg0) public view returns (bytes memory) {
        require(true);
        uint256 var_a = 0x60 + (var_a + storage_map_b[arg0] * 0x20);
        return abi.encodePacked(0x20, 0x40, uint32(var_o), var_m);
    }
    
    /// @custom:selector    0xeb8d3f12
    /// @custom:signature   getGuardianSetExpiry() public view returns (uint32)
    function getGuardianSetExpiry() public view returns (uint32) {
        return uint32(store_c / 0x0100000000);
    }
    
    /// @custom:selector    0x2c3c02a4
    /// @custom:signature   governanceActionIsConsumed(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function governanceActionIsConsumed(bytes32 arg0) public view returns (bool) {
        return storage_map_d[arg0].field_0;
    }
    
    /// @custom:selector    0xfbe3c2cd
    /// @custom:signature   governanceChainId() public view returns (uint16)
    function governanceChainId() public view returns (uint16) {
        return uint16(store_e / 0x010000);
    }
    
    /// @custom:selector    0xb172b222
    /// @custom:signature   governanceContract() public view returns (uint256)
    function governanceContract() public view returns (uint256) {
        return store_f;
    }
    
    /// @custom:selector    0x04ca84cf
    /// @custom:signature   Unresolved_04ca84cf(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_04ca84cf(uint256 arg0) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = 0x40 + var_a;
            require(0x20 > type(uint256).max, "toBytes32_outOfBounds");
        }
    }
    
    /// @custom:selector    0x6606b4e0
    /// @custom:signature   Unresolved_6606b4e0(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_6606b4e0(uint256 arg0) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            require(0x01 > type(uint256).max, "toUint8_outOfBounds");
        }
    }
    
    /// @custom:selector    0x875be02a
    /// @custom:signature   Unresolved_875be02a(uint256 arg0, uint32 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    function Unresolved_875be02a(uint256 arg0, uint32 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (!(var_a + 0x0160 < var_a | var_a + 0x0160 > 0xffffffffffffffff)) {
            require(msg.data[0x04 + arg0] == uint8(msg.data[0x04 + arg0]));
            require(msg.data[0x04 + arg0 + 0x20] == uint32(msg.data[0x04 + arg0 + 0x20]));
        }
    }
    
    /// @custom:selector    0x9a8a0592
    /// @custom:signature   Unresolved_9a8a0592() public view returns (uint16)
    function Unresolved_9a8a0592() public view returns (uint16) {
        return store_g;
    }
    
    /// @custom:selector    0xa0cce1b3
    /// @custom:signature   Unresolved_a0cce1b3(uint256 arg0, uint256 arg1, uint256 arg2, bool arg3) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_a0cce1b3(uint256 arg0, uint256 arg1, uint256 arg2, bool arg3) public pure {
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f);
            if (0 >= msg.data[0x04 + arg1]) {
                require(arg2 <= 0xffffffffffffffff);
                if (!(var_a + 0x40 < var_a | var_a + 0x40 > 0xffffffffffffffff)) {
                    uint256 var_a = var_a + 0x40;
                    require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
                    require(msg.data.length > 0x04 + arg2 + msg.data[0x04 + arg2] + 0x1f);
                }
            } else {
                if (!(var_a + 0x80 < var_a | var_a + 0x80 > 0xffffffffffffffff)) {
                    require(msg.data[0x04 + arg1 + 0x20 + 0x40] == uint8(msg.data[0x04 + arg1 + 0x20 + 0x40]));
                }
            }
        }
    }
    
    /// @custom:selector    0xa9e11893
    /// @custom:signature   Unresolved_a9e11893(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_a9e11893(uint256 arg0) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            require(0x01 > type(uint256).max, "toUint8_outOfBounds");
        }
    }
    
    /// @custom:selector    0xc0fd8bde
    /// @custom:signature   Unresolved_c0fd8bde(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_c0fd8bde(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x01 == msg.data[0x20 + (0x04 + arg0)] >> 0xf8, CustomError_6ce2251a());
        uint256 var_a = 0x60 + (var_a + storage_map_b[uint32(msg.data[0x01 + (0x20 + (0x04 + arg0))] >> 0xe0)] * 0x20);
        if (uint32(var_w) != store_a) {
            require(0x05 + (msg.data[0x05 + (0x20 + (0x04 + arg0))] >> 0xf8) * 0x42 + 0x01 <= msg.data[0x04 + arg0]);
            require(msg.data[0x04 + arg0] <= msg.data[0x04 + arg0]);
            uint256 var_x = msg.data[0x05 + (msg.data[0x05 + (0x20 + (0x04 + arg0))] >> 0xf8) * 0x42 + 0x01 + (0x20 + (0x04 + arg0)):0x05 + (msg.data[0x05 + (0x20 + (0x04 + arg0))] >> 0xf8) * 0x42 + 0x01 + (0x20 + (0x04 + arg0)) + (msg.data[0x04 + arg0] - (0x05 + (msg.data[0x05 + (0x20 + (0x04 + arg0))] >> 0xf8) * 0x42 + 0x01))];
            uint256 var_a = 0x40 + var_a;
            if (0 >= msg.data[0x05 + (0x20 + (0x04 + arg0))] >> 0xf8) {
                uint256 var_a = var_a + 0x20;
            } else {
                if (msg.data[0x06 + (0x20 + (0x04 + arg0))] >> 0xf8 < var_af) {
                    require(0, CustomError_9ad79794());
                    require(uint8(msg.data[0x06 + (0x20 + (0x04 + arg0))] >> 0xf8) > 0, CustomError_9ad79794());
                    address var_am = ecrecover(var_ai, uint8((msg.data[0x06 + (0x20 + (0x04 + arg0)) + 0x41] >> 0xf8) + 0x1b), msg.data[0x06 + (0x20 + (0x04 + arg0)) + 0x01], msg.data[0x06 + (0x20 + (0x04 + arg0)) + 0x21]);
                    require(memory[0x20]);
                    if (address(var_am) == address(var_an)) {
                        uint256 var_a = var_a + 0x20;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xd60b347f
    /// @custom:signature   Unresolved_d60b347f(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d60b347f(address arg0) public view returns (bool) {
        require(true);
        return storage_map_h[arg0].field_0;
    }
}