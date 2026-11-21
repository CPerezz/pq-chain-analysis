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
    
    /// @custom:selector    0xc89e4361
    /// @custom:signature   delegate() public payable returns (uint256)
    function delegate() public payable returns (uint256) {
        require(0x9b288bb8e08a3b943023557387fbed83c2f8cc4b == msg.sender);
        (bool success, bytes memory ret0) = address(address(msg.data[0] >> 0x40)).Unresolved_(memory[0:msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe8]); // delegatecall
        require(success);
        return ;
    }
    
    /// @custom:selector    0x0965d04b
    /// @custom:signature   Unresolved_0965d04b() public payable
    function Unresolved_0965d04b() public payable {
        require(msg.sender == 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b | msg.sender == 0xceeffb0cb54aa4632656d9356fdb17242fbca994 | (msg.sender == 0x513dc1c68ac9261208983bed602792fad121785f | msg.sender == 0x05fe57198ed5480fad0348a31f705e75e4d4b459) | (msg.sender == 0x1ca794ee6edf831df728925ccf1923a8f83af3b7 | msg.sender == 0x8a1cd5999d5dd8d8040350662cce41abfec20a7f | (msg.sender == 0xccc1db67d4f3c9dd29602ceeb8192eaa610a331b | msg.sender == 0x80dab768791d2074c34166635fcc99d843e6b3c9)), "10");
        (bool success, bytes memory ret0) = address(0xa88800cd213da5ae406ce248380802bd53b47647).Unresolved_08c379a0{ value: 0 }(var_d); // call
        require(success);
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint248", "bytes31", "int248"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256) {
        if (arg2 == 0x41) {
            if (0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1 > var_d) {
                address var_e = ecrecover(arg0, arg5);
                if (var_e == 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b) {
                    return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }
    
    /// @custom:selector    0x1944799f
    /// @custom:signature   Unresolved_1944799f(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg18446744073709551615 ["uint256", "bytes32", "int256"]
    function Unresolved_1944799f(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(!(msg.sender - 0xa88800cd213da5ae406ce248380802bd53b47647), "20");
        require(arg0 == 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b | arg0 == 0xceeffb0cb54aa4632656d9356fdb17242fbca994 | (arg0 == 0x513dc1c68ac9261208983bed602792fad121785f | arg0 == 0x05fe57198ed5480fad0348a31f705e75e4d4b459) | (arg0 == 0x1ca794ee6edf831df728925ccf1923a8f83af3b7 | arg0 == 0x8a1cd5999d5dd8d8040350662cce41abfec20a7f | (arg0 == 0xccc1db67d4f3c9dd29602ceeb8192eaa610a331b | arg0 == 0x80dab768791d2074c34166635fcc99d843e6b3c9)), "10");
        require(tx.origin == 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b | tx.origin == 0xceeffb0cb54aa4632656d9356fdb17242fbca994 | (tx.origin == 0x513dc1c68ac9261208983bed602792fad121785f | tx.origin == 0x05fe57198ed5480fad0348a31f705e75e4d4b459) | (tx.origin == 0x1ca794ee6edf831df728925ccf1923a8f83af3b7 | tx.origin == 0x8a1cd5999d5dd8d8040350662cce41abfec20a7f | (tx.origin == 0xccc1db67d4f3c9dd29602ceeb8192eaa610a331b | tx.origin == 0x80dab768791d2074c34166635fcc99d843e6b3c9)), "10");
        if (0x01 == msg.data[arg2 + 0x24] >> 0xf8) {
            if (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x20) == 0x20) && ((0x80 & msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8) == 0x80 == 0x01 && (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x40) == 0x40) && (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x40) == 0x40) && uint8(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xe8))))) {
                (bool success, bytes memory ret0) = address(msg.data[arg2 + 0x27 + uint8(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
                require(success);
                require(0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x80) == 0x80), "14");
                require(0x8000000000000000000000000000000000000000000000000000000000000000 - uint128(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0x68) + 0x8000000000000000000000000000000000000000000000000000000000000000 >= 0x2000000000000000000000000000000000000000000000000000000000, "14");
                if ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x08) - 0x08) {
                    if (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x20) == 0x20)) {
                        if (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x10) == 0x10)) {
                            (bool success, bytes memory ret0) = address(msg.data[arg2 + 0x27 + uint8(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_a9059cbb{ value: 0 }(address(this)); // call
                            require(!success, "16");
                        } else {
                            if (0x01 == ((msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0xf8 & 0x80) == 0x80)) {
                                (bool success, bytes memory ret0) = address(msg.data[arg2 + 0x27 + uint8(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                            } else {
                                uint128 var_d = uint128(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0x68);
                                (bool success, bytes memory ret0) = address(msg.data[arg2 + 0x27 + uint8(msg.data[arg2 + 0x27 + 0x14 * uint8(msg.data[arg2 + 0x24] >> 0xf0)] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_d); // call
                            }
                            revert();
                        }
                    }
                } else {
                    (bool success, bytes memory ret0) = address(msg.data[0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc4 + arg2]).Unresolved_a9059cbb{ value: 0 }(0xa88800cd213da5ae406ce248380802bd53b47647); // call
                    require(success);
                    if (ret0.length) {
                        require(!(type(uint256).max + 0xa9059cbb00000000000000000000000000000000000000000000000000000000), "17");
                    }
                }
            }
        } else {
            require(!(0x02 - (msg.data[arg2 + 0x24] >> 0xf8)), "19");
            (bool success, bytes memory ret0) = address(0xeefba1e63905ef1d7acba5a8513c70307c1ce441).Unresolved_(memory[0:type(uint256).max + msg.data[arg2 + 0x04]]); // delegatecall
            revert();
        }
    }
    
    /// @custom:selector    0xfa461e33
    /// @custom:signature   Unresolved_fa461e33(uint256 arg0) public payable
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_fa461e33(uint256 arg0) public payable {
        require(tx.origin == 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b | tx.origin == 0xceeffb0cb54aa4632656d9356fdb17242fbca994 | (tx.origin == 0x513dc1c68ac9261208983bed602792fad121785f | tx.origin == 0x05fe57198ed5480fad0348a31f705e75e4d4b459) | (tx.origin == 0x1ca794ee6edf831df728925ccf1923a8f83af3b7 | tx.origin == 0x8a1cd5999d5dd8d8040350662cce41abfec20a7f | (tx.origin == 0xccc1db67d4f3c9dd29602ceeb8192eaa610a331b | tx.origin == 0x80dab768791d2074c34166635fcc99d843e6b3c9)), "10");
        if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf8 & 0x20) == 0x20 == 0x01 && ((0x80 & msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf8) == 0x80 == 0x01 && (0x01 == (0x40 == (0x40 & msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf8)) && (0x40 == (0x40 & msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf8) == 0x01 && uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xe8))))) {
            (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf0) * 0x14] >> 0x60).Unresolved_128acb08{ value: 0 }(address(this)); // call
            require(success);
            if ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8)] >> 0xf8 & 0x08) - 0x08 && (0 < uint8(arg4 >> 0xf0) && 0x01 == ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0xf8 & 0x20) == 0x20))) {
                if (0x01 == ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0xf8 & 0x10) == 0x10)) {
                    (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_a9059cbb{ value: 0 }(address(this)); // call
                    require(!success, "16");
                } else {
                    if (0x01 == ((msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0xf8 & 0x80) == 0x80)) {
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(0); // call
                    } else {
                        uint128 var_d = uint128(msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0x68);
                        (bool success, bytes memory ret0) = address(msg.data[0x86 + uint8(msg.data[0x86 + 0x14 * (arg4 >> 0xf8) + 0x13] >> 0x68 >> 0x88) * 0x14] >> 0x60).Unresolved_022c0d9f{ value: 0 }(var_d); // call
                    }
                    revert();
                }
            }
        }
    }
}