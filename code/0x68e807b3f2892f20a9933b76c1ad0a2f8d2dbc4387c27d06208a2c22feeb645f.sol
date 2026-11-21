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
    
    mapping(address => bytes32) storage_map_b; // storage slot: 0x00
    
    event Event_0909e8f7();
    
    /// @custom:selector    0x158ef93e
    /// @custom:signature   Unresolved_158ef93e() public view returns (bool)
    function Unresolved_158ef93e() public view returns (bool) {
        return uint8(store_a / 0x0100);
    }
    
    /// @custom:selector    0x72276991
    /// @custom:signature   Unresolved_72276991(address arg0, uint256 arg1) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_72276991(address arg0, uint256 arg1) public pure {
        revert();
    }
    
    /// @custom:selector    0x736c0d5b
    /// @custom:signature   Unresolved_736c0d5b(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_736c0d5b(address arg0) public view returns (bool) {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(true);
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x7df73e27
    /// @custom:signature   Unresolved_7df73e27(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7df73e27(address arg0) public view returns (bool) {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(true);
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
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x1f < 0x04 + (msg.data.length - 0x04));
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] * 0x20 <= 0x04 + (msg.data.length - 0x04));
        require(!uint8(store_a / 0x0100), "Contract already initialized");
        require(msg.data[0x04 + arg0] == 0x05, "Invalid number of signers");
        if (0 >= msg.data[0x04 + arg0]) {
            store_a = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_a;
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                require(address(msg.data[0x04 + arg0 + 0x20]) != 0, "Invalid signer");
                if (0 < msg.data[0x04 + arg0]) {
                    require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                    storage_map_b[address(msg.data[0x04 + arg0 + 0x20])] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[address(msg.data[0x04 + arg0 + 0x20])];
                }
            }
        }
    }
    
    /// @custom:selector    0xca34837b
    /// @custom:signature   Unresolved_ca34837b(address arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_ca34837b(address arg0, uint256 arg1, uint256 arg2) public pure {
        if (!msg.value && 0x04 + (msg.data.length - 0x04) - 0x04 >= 0xa0) {
            require(arg2 <= 0xffffffffffffffff);
            require(0x04 + arg2 + 0x1f < 0x04 + (msg.data.length - 0x04));
            require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
            require(0x04 + arg2 + 0x20 + msg.data[0x04 + arg2] <= 0x04 + (msg.data.length - 0x04));
        }
        revert();
    }
    
    /// @custom:selector    0xfc0f392d
    /// @custom:signature   Unresolved_fc0f392d() public
    function Unresolved_fc0f392d() public {
        require(storage_map_b[msg.sender].field_0, "Non-signer in onlySigner method");
        store_a = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_a;
        emit Event_0909e8f7(msg.sender);
    }
}