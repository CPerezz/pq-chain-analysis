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
    bytes32[] store_c; // storage slot: 0x00
    
    mapping(address => mapping(uint256 => bytes)) storage_map_b; // storage slot: 0x02
    mapping(address => bytes) storage_map_a; // storage slot: 0x03
    
    error NonceTooLow();
    event Cancel(uint256, address);
    event CancelUpTo(uint256, address);
    
    /// @custom:selector    0x73103d6b
    /// @custom:signature   _signatoryMinimumNonce(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function _signatoryMinimumNonce(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_a[arg0];
    }
    
    /// @custom:selector    0x3c641910
    /// @custom:signature   cancelUpTo(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function cancelUpTo(uint256 arg0) public payable {
        storage_map_a[msg.sender] = arg0;
        emit CancelUpTo(arg0, msg.sender);
    }
    
    /// @custom:selector    0x1647795e
    /// @custom:signature   nonceUsed(address arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function nonceUsed(address arg0, uint256 arg1) public view returns (bool) {
        require(true);
        return 0x01 == (0x01 & storage_map_b[arg0][arg1 / 0x0100] >> arg1 % 0x0100);
    }
    
    /// @custom:selector    0x2e340823
    /// @custom:signature   Unresolved_2e340823(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_2e340823(uint256 arg0, uint256 arg1) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(0x01 - (0x01 & storage_map_b[msg.sender][msg.data[0x20 + (0x04 + arg0)] / 0x0100] >> msg.data[0x20 + (0x04 + arg0)] % 0x0100), CustomError_91cab504());
            storage_map_b[msg.sender][msg.data[0x20 + (0x04 + arg0)] / 0x0100] = 0x01 << msg.data[0x20 + (0x04 + arg0)] % 0x0100 | storage_map_b[msg.sender][msg.data[0x20 + (0x04 + arg0)] / 0x0100];
            emit Cancel(msg.data[0x20 + (0x04 + arg0)], msg.sender);
        }
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view returns (uint256)
    function Unresolved_84b0196e() public view returns (uint256) {
        if ((store_c & 0x01) - (store_c >> 0x01 < 0x20) && (store_c & 0x01) - (store_c >> 0x01 < 0x20)) {
            require(0x03 <= 0x1f, CustomError_b3512b0c());
            uint256 var_e = msg.data[msg.data.length:msg.data.length + 0x20];
            uint256 var_a = var_a + 0x20;
            return abi.encodePacked(0x0f00000000000000000000000000000000000000000000000000000000000000, 0xe0, 0x20 + ((0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_k) + (var_a + 0xe0)) - var_a, block.chainid, address(this), 0, 0x20 + ((0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_k) + (0x20 + ((0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_k) + (var_a + 0xe0)))) - var_a, var_k, var_k, var_k);
        }
    }
    
    /// @custom:selector    0xda00f047
    /// @custom:signature   Unresolved_da00f047(uint256 arg0, address arg1, address arg2, address arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, bool arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_da00f047(uint256 arg0, address arg1, address arg2, address arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, bool arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (bytes memory) {
        require(arg0 <= 0xffffffffffffffff);
        if (0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03 == address(this)) {
            require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
            if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff) {
                require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
                if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]]) {
                    uint256 var_g = 0x40 + var_g;
                    uint256 var_g = 0x0116 + (0x20 + var_g);
                    require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
                    require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
                    require(0x04 + arg0 + 0x40 - (0x04 + arg0 + 0x20) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                    require(0x04 + arg0 + 0x60 - (0x04 + arg0 + 0x40) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x40] == address(msg.data[0x04 + arg0 + 0x40]));
                    require(0x04 + arg0 + 0x80 - (0x04 + arg0 + 0x60) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x60] == address(msg.data[0x04 + arg0 + 0x60]));
                    require(0x04 + arg0 + 0xa0 - (0x04 + arg0 + 0x80) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x80] == address(msg.data[0x04 + arg0 + 0x80]));
                    uint256 var_g = 0x20 + var_g;
                    uint256 var_g = 0x0160 + (0x20 + var_g);
                    if (0 >= var_ac) {
                        require(msg.data[0x0120 + (0x04 + arg0) + 0x40] <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid s parameter");
                        require(0x0120 + (0x04 + arg0) + 0x20 - (0x0120 + (0x04 + arg0)) >= 0x20);
                        require(msg.data[0x0120 + (0x04 + arg0)] == uint8(msg.data[0x0120 + (0x04 + arg0)]));
                        require(0x1b == uint8(msg.data[0x0120 + (0x04 + arg0)]), "Invalid v parameter");
                        require(0x0120 + (0x04 + arg0) + 0x20 - (0x0120 + (0x04 + arg0)) >= 0x20);
                        require(msg.data[0x0120 + (0x04 + arg0)] == uint8(msg.data[0x0120 + (0x04 + arg0)]));
                        uint256 var_g = 0x20 + var_g;
                        require(memory[0x20]);
                        require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff) {
                            uint256 var_g = var_g + (0x20 + 0x20 * msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]]);
                            uint256 var_i = msg.data[msg.data.length:msg.data.length + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x20];
                            require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                            if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]]) {
                                return abi.encodePacked(address(var_aw), 0x40, var_ac);
                            } else {
                                require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                                require(0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]], "Invalid s parameter");
                            }
                        }
                    }
                } else {
                    require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
                    if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]]) {
                        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) + (msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]))) - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100])) >= 0xe0);
                        if (!(var_g + 0xe0 < var_g | var_g + 0xe0 > 0xffffffffffffffff)) {
                            uint256 var_g = var_g + 0xe0;
                            uint256 var_g = 0x0100 + (0x20 + var_g);
                            revert();
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xf6293486
    /// @custom:signature   Unresolved_f6293486(uint256 arg0, address arg1, address arg2, address arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, bool arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_f6293486(uint256 arg0, address arg1, address arg2, address arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, bool arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (bytes memory) {
        require(arg0 <= 0xffffffffffffffff);
        if (0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03 == address(this)) {
            require(block.chainid != 0x01, CustomError_c56873ba());
            require(msg.data[0xa0 + (0x04 + arg0)] > block.timestamp, CustomError_c56873ba());
            require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
            if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff) {
                require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
                if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]]) {
                    uint256 var_g = 0x40 + var_g;
                    uint256 var_g = 0x0116 + (0x20 + var_g);
                    require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
                    require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
                    require(0x04 + arg0 + 0x40 - (0x04 + arg0 + 0x20) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                    require(0x04 + arg0 + 0x60 - (0x04 + arg0 + 0x40) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x40] == address(msg.data[0x04 + arg0 + 0x40]));
                    require(0x04 + arg0 + 0x80 - (0x04 + arg0 + 0x60) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x60] == address(msg.data[0x04 + arg0 + 0x60]));
                    require(0x04 + arg0 + 0xa0 - (0x04 + arg0 + 0x80) >= 0x20);
                    require(msg.data[0x04 + arg0 + 0x80] == address(msg.data[0x04 + arg0 + 0x80]));
                    uint256 var_g = 0x20 + var_g;
                    uint256 var_g = 0x0160 + (0x20 + var_g);
                    if (0 >= var_ac) {
                        require(msg.data[0x0120 + (0x04 + arg0) + 0x40] <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid s parameter");
                        require(0x0120 + (0x04 + arg0) + 0x20 - (0x0120 + (0x04 + arg0)) >= 0x20);
                        require(msg.data[0x0120 + (0x04 + arg0)] == uint8(msg.data[0x0120 + (0x04 + arg0)]));
                        require(0x1b == uint8(msg.data[0x0120 + (0x04 + arg0)]), "Invalid v parameter");
                        require(0x0120 + (0x04 + arg0) + 0x20 - (0x0120 + (0x04 + arg0)) >= 0x20);
                        require(msg.data[0x0120 + (0x04 + arg0)] == uint8(msg.data[0x0120 + (0x04 + arg0)]));
                        uint256 var_g = 0x20 + var_g;
                        require(memory[0x20]);
                        require(address(var_aw), CustomError_37e8456b());
                        require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff) {
                            uint256 var_g = var_g + (0x20 + 0x20 * msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]]);
                            uint256 var_i = msg.data[msg.data.length:msg.data.length + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x20];
                            require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                            if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]]) {
                                require(0x01 - (0x01 & storage_map_b[address(var_aw)][msg.data[0xc0 + (0x04 + arg0)] / 0x0100] >> msg.data[0xc0 + (0x04 + arg0)] % 0x0100), CustomError_91cab504());
                                storage_map_b[address(var_aw)][msg.data[0xc0 + (0x04 + arg0)] / 0x0100] = 0x01 << msg.data[0xc0 + (0x04 + arg0)] % 0x0100 | storage_map_b[address(var_aw)][msg.data[0xc0 + (0x04 + arg0)] / 0x0100];
                                require(msg.data[0x04 + arg0 + 0xc0] >= storage_map_a[address(var_aw)], CustomError_d24d82a4());
                                return abi.encodePacked(address(var_aw), 0x40, var_ac);
                            } else {
                                require(msg.data[0x04 + arg0 + 0x0180] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] <= 0xffffffffffffffff);
                                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]] * 0x60);
                                require(0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0180]], "Invalid s parameter");
                            }
                        }
                    }
                } else {
                    require(msg.data[0x04 + arg0 + 0x0100] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]] * 0xe0);
                    if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]]) {
                        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]) + (msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100]))) - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0100])) >= 0xe0);
                        if (!(var_g + 0xe0 < var_g | var_g + 0xe0 > 0xffffffffffffffff)) {
                            uint256 var_g = var_g + 0xe0;
                            uint256 var_g = 0x0100 + (0x20 + var_g);
                            revert();
                        }
                    }
                }
            }
        }
    }
}