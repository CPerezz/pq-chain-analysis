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
    address public unresolved_8da5cb5b; // storage slot: 0x0bc400d087a8462244563454a0b02b54a45f1fe0eb53e7c68c0963e4a0680d00
    bytes32 store_c; // storage slot: 0x0bc400d087a8462244563454a0b02b54a45f1fe0eb53e7c68c0963e4a0680d00
    
    mapping(address => bytes32) storage_map_b; // storage slot: 0x0bc400d087a8462244563454a0b02b54a45f1fe0eb53e7c68c0963e4a0680d01
    
    error CustomError_00000000();
    event Initialized(address);
    
    /// @custom:selector    0xf6a7f2c9
    /// @custom:signature   batchApprove(address arg0, address[] arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function batchApprove(address arg0, address[] arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        if (0 < msg.data[0x04 + arg1] && 0 < msg.data[0x04 + arg1]) {
            require(!(msg.data[0x04 + arg1 + 0x20] - address(msg.data[0x04 + arg1 + 0x20])));
            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg1 + 0x20])).Unresolved_095ea7b3(arg0); // call
            if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg1 + 0x20])).Unresolved_095ea7b3(arg0, 0); // call
                if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                    require(success, CustomError_5274afe7());
                    (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg1 + 0x20])).Unresolved_095ea7b3(arg0, arg2); // call
                    require(!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01), CustomError_5274afe7());
                }
                require(!success & 0x01, CustomError_5274afe7());
            }
        }
    }
    
    /// @custom:selector    0x13e7c9d8
    /// @custom:signature   operators(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function operators(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
        if ((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) != 0x01ffc9a700000000000000000000000000000000000000000000000000000000) {
            return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
        } else {
            return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x01ffc9a700000000000000000000000000000000000000000000000000000000;
        }
    }
    
    /// @custom:selector    0x0d2b9c0b
    /// @custom:signature   Unresolved_0d2b9c0b(address arg0, uint256 arg1) public pure returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_0d2b9c0b(address arg0, uint256 arg1) public pure returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(0x28 <= msg.data[0x04 + arg1]);
        address var_a = address(msg.data[0x04 + arg1 + 0x20 + 0x14] >> 0x60);
        return var_a;
    }
    
    /// @custom:selector    0x13e1a988
    /// @custom:signature   Unresolved_13e1a988(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_13e1a988(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
            storage_map_b[address(msg.data[0x04 + arg0 + 0x20])] = storage_map_b[address(msg.data[0x04 + arg0 + 0x20])] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        }
    }
    
    /// @custom:selector    0x150b7a02
    /// @custom:signature   Unresolved_150b7a02(address arg0, address arg1, uint256 arg2) public pure returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_150b7a02(address arg0, address arg1, uint256 arg2) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        return 0x150b7a0200000000000000000000000000000000000000000000000000000000;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1, uint248 arg2, uint256 arg3) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] - 0x40) {
            uint256 var_c = msg.data[0x04 + arg1 + 0x20];
            require(memory[0x20]);
        } else {
            require(0x20 <= msg.data[0x04 + arg1]);
            require(0x40 <= msg.data[0x04 + arg1]);
            if ((msg.data[0x04 + arg1 + 0x20 + 0x20] & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                if (0x03 < 0x04) {
                    if (!0x03) {
                        if (address(this) == 0) {
                            return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                        } else {
                            return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                        }
                    } else {
                        if (!0x03) {
                            return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                        } else {
                            return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                        }
                    }
                }
            } else {
                uint8 var_b = uint8((msg.data[0x04 + arg1 + 0x20 + 0x20] >> 0xff) + 0x1b);
                uint256 var_c = msg.data[0x04 + arg1 + 0x20];
                bytes32 var_d = msg.data[0x04 + arg1 + 0x20 + 0x20] & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0x34fcd5be
    /// @custom:signature   Unresolved_34fcd5be(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_34fcd5be(uint256 arg0, uint256 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] - address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]), "self-call not allowed");
        }
    }
    
    /// @custom:selector    0x769a88a5
    /// @custom:signature   Unresolved_769a88a5(address arg0, uint256 arg1) public pure returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_769a88a5(address arg0, uint256 arg1) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(0x14 <= msg.data[0x04 + arg1]);
        bytes32 var_a = msg.data[0x04 + arg1 + 0x20] >> 0x60;
        return var_a;
    }
    
    /// @custom:selector    0x8129fc1c
    /// @custom:signature   Unresolved_8129fc1c() public payable
    function Unresolved_8129fc1c() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!unresolved_8da5cb5b, "already initialized");
        require(!(msg.sender - address(this)), "only self");
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | address(this);
        emit Initialized(address(this));
    }
    
    /// @custom:selector    0x8d5ef45b
    /// @custom:signature   Unresolved_8d5ef45b(address arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_8d5ef45b(address arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(arg3 - arg3));
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        require(arg3 != address(this), "self-call not allowed");
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(arg1); // call
        if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(arg1, 0); // call
            if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                require(!success & 0x01, CustomError_5274afe7());
            } else {
                require(success, CustomError_5274afe7());
                (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(arg1, arg2); // call
                if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                    require(!success & 0x01, CustomError_5274afe7());
                } else {
                    require(success, CustomError_5274afe7());
                    payable(address(arg3)).transfer(arg4);
                    require(success);
                }
            }
        }
    }
    
    /// @custom:selector    0xb44f4a40
    /// @custom:signature   Unresolved_b44f4a40(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b44f4a40(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
            storage_map_b[address(msg.data[0x04 + arg0 + 0x20])] = storage_map_b[address(msg.data[0x04 + arg0 + 0x20])] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        }
    }
    
    /// @custom:selector    0xb61d27f6
    /// @custom:signature   Unresolved_b61d27f6(address arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_b61d27f6(address arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        require(arg0 != address(this), "self-call not allowed");
        payable(address(arg0)).transfer(arg1);
        require(success);
    }
    
    /// @custom:selector    0xbc197c81
    /// @custom:signature   Unresolved_bc197c81(address arg0, address arg1, uint256 arg2, uint256 arg3) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_bc197c81(address arg0, address arg1, uint256 arg2, uint256 arg3) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x05) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(arg3 > 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xf23a6e61
    /// @custom:signature   Unresolved_f23a6e61(address arg0, address arg1, uint256 arg2) public pure returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_f23a6e61(address arg0, address arg1, uint256 arg2) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        return 0xf23a6e6100000000000000000000000000000000000000000000000000000000;
    }
    
    /// @custom:selector    0xf4a6c760
    /// @custom:signature   Unresolved_f4a6c760(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f4a6c760(uint256 arg0, uint256 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] * 0x60 + arg0 + 0x24 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "not owner");
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(!(msg.data[arg0 + 0x24] - address(msg.data[arg0 + 0x24])));
            }
        } else {
            if (0 < msg.data[0x04 + arg1] && 0 < msg.data[0x04 + arg1]) {
                require(msg.data[0x04 + arg1 + 0x20] >= msg.data.length - (0x04 + arg1 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            }
        }
    }
    
    /// @custom:selector    0xff42b559
    /// @custom:signature   Unresolved_ff42b559(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_ff42b559(uint256 arg0, address arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(!(arg1 - arg1));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(!(arg3 - arg3));
        require(!(tx.origin - address(this)), "not self originated");
        require(msg.sender != unresolved_8da5cb5b, "not authorized");
        require(storage_map_b[msg.sender].field_0, "not authorized");
        require(arg1 != address(this), "self-call not allowed");
        require(0x14 <= msg.data[0x04 + arg2]);
        require(msg.data[0x04 + arg2] >= 0x28);
        (bool success, bytes memory ret0) = address(msg.data[0x04 + arg2 + 0x20] >> 0x60).Unresolved_dd62ed3e(address(this)); // staticcall
        require(success);
        if (success) {
            if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                uint256 var_g = var_g + 0x20;
                require(var_g + 0x20 - var_g < 0x20);
            }
        } else {
            (bool success, bytes memory ret0) = address(msg.data[0x04 + arg2 + 0x20] >> 0x60).Unresolved_095ea7b3(arg1, type(uint256).max, var_j); // call
            if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                (bool success, bytes memory ret0) = address(msg.data[0x04 + arg2 + 0x20] >> 0x60).Unresolved_095ea7b3(arg1, 0, var_j); // call
                if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                    require(!success & 0x01, CustomError_5274afe7());
                } else {
                    require(success, CustomError_5274afe7());
                    (bool success, bytes memory ret0) = address(msg.data[0x04 + arg2 + 0x20] >> 0x60).Unresolved_095ea7b3(arg1, type(uint256).max, var_j); // call
                    if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                        require(!success & 0x01, CustomError_5274afe7());
                    } else {
                        uint256 var_g = var_g;
                        require(success, CustomError_5274afe7());
                        (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg2 + 0x20 + 0x14] >> 0x60)).Unresolved_70a08231(arg3); // staticcall
                        require(success);
                        if (success) {
                            if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                                uint256 var_g = var_g + 0x20;
                                require(var_g + 0x20 - var_g >= 0x20);
                                payable(address(arg1)).transfer(0);
                                require(success);
                                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg2 + 0x20 + 0x14] >> 0x60)).Unresolved_70a08231(arg3); // staticcall
                                require(success);
                            }
                        } else {
                            payable(address(arg1)).transfer(0);
                            require(success);
                            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg2 + 0x20 + 0x14] >> 0x60)).Unresolved_70a08231(arg3, arg3); // staticcall
                            require(success);
                            if (success) {
                                if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
                                    uint256 var_g = var_g + 0x20;
                                    require(var_g + 0x20 - var_g < 0x20);
                                }
                            } else {
                                if (0 <= 0) {
                                    require(0 >= arg5, "insufficient output");
                                    return 0;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}