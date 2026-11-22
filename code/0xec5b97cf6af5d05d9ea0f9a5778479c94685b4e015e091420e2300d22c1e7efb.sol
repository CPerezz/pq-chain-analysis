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
    uint256 public constant unresolved_117803e3 = 102423185387828826030172414826348858094032937165;
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x00
    
    error CustomError_00000000();
    event SignerUpdated(address, bool);
    
    /// @custom:selector    0x5d2b6a4e
    /// @custom:signature   authorizedSigners(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function authorizedSigners(address arg0) public view returns (bool) {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        if (0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40) {
            require(arg1 <= 0xffffffffffffffff);
            require(0x04 + arg1 + 0x1f < 0x04 + (msg.data.length - 0x04));
            if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_a + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a)) {
                require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] <= 0x04 + (msg.data.length - 0x04));
                uint256 var_c = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]];
                if (var_e <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(memory[0x20]);
                } else {
                    if (0 <= 0x03 && 0x03 <= 0x03) {
                        if (!0x03) {
                            if (!storage_map_a[0].field_0) {
                                return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                            } else {
                                return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                            }
                        } else {
                            if (0x01 <= 0x03 && 0x03 <= 0x03) {
                                if (0x02 <= 0x03 && 0x03 <= 0x03) {
                                    if (0x03 <= 0x03) {
                                        require(0x03 > 0x03, CustomError_d78bce0c());
                                    }
                                    revert CustomError_fce698f7();
                                }
                                revert CustomError_f645eedf();
                            }
                        }
                    }
                }
            }
        }
        revert();
    }
    
    /// @custom:selector    0x31cb6105
    /// @custom:signature   Unresolved_31cb6105(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_31cb6105(address arg0, uint256 arg1) public payable {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40);
        require(true);
        require(msg.sender == 0x11f0d0818aa278cce4b1c42240772ee48f4260cd, "Only owner");
        storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        emit SignerUpdated(arg0, arg1);
    }
}