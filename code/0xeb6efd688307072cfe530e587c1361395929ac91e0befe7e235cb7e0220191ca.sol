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
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_e; // storage slot: 0x00
    address store_a; // storage slot: 0x01
    bytes32 store_c; // storage slot: 0x01
    uint8 store_d; // storage slot: 0x01
    
    event Event_8be0079c();
    
    /// @custom:selector    0x521e47b9
    /// @custom:signature   getVerifyingSigner() public view returns (address)
    function getVerifyingSigner() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_a;
    }
    
    /// @custom:selector    0x05b1737e
    /// @custom:signature   Unresolved_05b1737e(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_05b1737e(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return ;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c | var_c + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff)) {
            uint256 var_d = msg.data[0x04 + arg1];
            require(arg1 + msg.data[0x04 + arg1] + 0x24 <= msg.data.length);
            uint256 var_e = msg.data[arg1 + 0x24:arg1 + 0x24 + var_d];
            if (store_d < 0x03) {
                if (store_d - 0x01) {
                    if (0x02 - store_d) {
                        if (var_h > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                            require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
                        } else {
                            require(memory[0x20]);
                        }
                    } else {
                        return false;
                    }
                } else {
                    return true;
                }
            }
        }
    }
    
    /// @custom:selector    0x21175b4a
    /// @custom:signature   Unresolved_21175b4a(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_21175b4a(uint256 arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(arg0 < 0x03);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_c = store_c & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | arg0 << 0xa0 & 0xff0000000000000000000000000000000000000000;
        return ;
    }
    
    /// @custom:selector    0x295a5212
    /// @custom:signature   Unresolved_295a5212() public view returns (bool)
    function Unresolved_295a5212() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (store_d < 0x03) {
            return store_d;
        }
    }
    
    /// @custom:selector    0x441f7f5f
    /// @custom:signature   Unresolved_441f7f5f() public view returns (address)
    function Unresolved_441f7f5f() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_a;
    }
    
    /// @custom:selector    0x4b4fd03b
    /// @custom:signature   Unresolved_4b4fd03b() public view returns (bool)
    function Unresolved_4b4fd03b() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (store_d < 0x03) {
            return store_d;
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable returns (uint256)
    function Unresolved_715018a6() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
        return ;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        if (msg.sender - unresolved_8da5cb5b) {
            revert("Ownable: caller is not the owner");
        } else {
            revert("Ownership transfer is disabled");
        }
    }
}