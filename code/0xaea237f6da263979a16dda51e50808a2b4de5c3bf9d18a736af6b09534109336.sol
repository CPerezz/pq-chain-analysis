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
    uint256 public constant unresolved_b0d691fe = 547733466371960611141041528242004465362790066057;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_e; // storage slot: 0x00
    address store_f; // storage slot: 0x01
    bytes32 store_c; // storage slot: 0x01
    
    mapping(address => bytes32) storage_map_b; // storage slot: 0x02
    mapping(uint256 => bytes32) storage_map_d; // storage slot: 0x03
    
    event Event_8be0079c();
    
    /// @custom:selector    0x0396cb60
    /// @custom:signature   addStake(uint32 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function addStake(uint32 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).code.length);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).Unresolved_0396cb60{ value: msg.value }(arg0); // call
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0x3b3858f2
    /// @custom:signature   removeOrigin(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeOrigin(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid origin");
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        return ;
    }
    
    /// @custom:selector    0xbb9fe6bf
    /// @custom:signature   unlockStake() public payable returns (uint256)
    function unlockStake() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).code.length);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).unlockStake{ value: 0 }(); // call
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0x05b1737e
    /// @custom:signature   Unresolved_05b1737e(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_05b1737e(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        return ;
    }
    
    /// @custom:selector    0x15271b67
    /// @custom:signature   Unresolved_15271b67(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_15271b67(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_d[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x1b0f5c0a
    /// @custom:signature   Unresolved_1b0f5c0a(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_1b0f5c0a(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_d[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x205c2878
    /// @custom:signature   Unresolved_205c2878(address arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_205c2878(address arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).code.length);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).Unresolved_205c2878{ value: 0 }(arg0); // call
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0x22e6482f
    /// @custom:signature   Unresolved_22e6482f(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    /// @param              arg2 ["uint48", "bytes6", "int48"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    function Unresolved_22e6482f(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(msg.data[0x04 + arg0 + 0x40] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]);
        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff && !(var_c + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + ((var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]];
            require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]);
            if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff && !(var_c + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                uint256 var_c = var_c + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                uint256 var_f = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]];
                if (!(var_c + 0x01e0 > 0xffffffffffffffff | var_c + 0x01e0 < var_c)) {
                    uint256 var_c = var_c + 0x01e0;
                    var_w = keccak256(memory[var_c + 0x20:var_c + 0x20 + var_k]);
                    return var_w;
                }
            }
        }
    }
    
    /// @custom:selector    0x4da29415
    /// @custom:signature   Unresolved_4da29415(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_4da29415(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
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
    
    /// @custom:selector    0x94d4ad60
    /// @custom:signature   Unresolved_94d4ad60(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3) public pure returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    /// @param              arg2 ["uint48", "bytes6", "int48"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_94d4ad60(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3) public pure returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x74 <= msg.data[0x04 + arg0]);
        require(!(msg.data[0x04 + arg0 + 0x20 + 0x14] - uint48(msg.data[0x04 + arg0 + 0x20 + 0x14])));
        require(!(msg.data[0x04 + arg0 + 0x20 + 0x34] - uint48(msg.data[0x04 + arg0 + 0x20 + 0x34])));
        uint48 var_a = uint48(msg.data[0x04 + arg0 + 0x20 + 0x14]);
        uint48 var_b = uint48(msg.data[0x04 + arg0 + 0x20 + 0x34]);
        uint256 var_e = msg.data[0x04 + arg0] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8c;
        return abi.encodePacked(var_a, var_b);
    }
    
    /// @custom:selector    0xa9a23409
    /// @custom:signature   Unresolved_a9a23409(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a9a23409(uint256 arg0, uint256 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg0 < 0x03);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        if (msg.sender - 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789) {
            revert("Sender not EntryPoint");
        } else {
            revert("must override");
        }
    }
    
    /// @custom:selector    0xc399ec88
    /// @custom:signature   Unresolved_c399ec88() public payable returns (uint256)
    function Unresolved_c399ec88() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (success) {
            if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                uint256 var_c = var_c + 0x20;
                require(var_c + 0x20 - var_c >= 0x20);
                return var_g;
            }
        } else {
            return 0;
        }
    }
    
    /// @custom:selector    0xcee02f5d
    /// @custom:signature   Unresolved_cee02f5d(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_cee02f5d(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_d + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_e = msg.data[0x04 + arg1];
            uint256 var_f = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + var_e];
            if (var_h > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                require(0x03 >= 0x05, "ECDSA: invalid signature 's' value");
            } else {
                var_g = keccak256(memory[0:0x3c]);
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0xd0e30db0
    /// @custom:signature   Unresolved_d0e30db0() public payable returns (uint256)
    function Unresolved_d0e30db0() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).code.length);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).Unresolved_b760faf9{ value: msg.value }(address(this)); // call
        require(success);
        if (success) {
            if (var_c <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        return ;
    }
    
    /// @custom:selector    0xf465c77e
    /// @custom:signature   Unresolved_f465c77e(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    /// @param              arg2 ["uint48", "bytes6", "int48"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_f465c77e(uint256 arg0, uint48 arg1, uint48 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(!(msg.sender - 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789), "Sender not EntryPoint");
        require(storage_map_b[tx.origin].field_0, "Invalid tx origin");
        require(msg.data[0x04 + arg0 + 0x0120] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]]);
        require(0x74 <= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]]);
        require(!(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) + 0x14] - uint48(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) + 0x14])));
        require(!(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) + 0x34] - uint48(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) + 0x34])));
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8c == 0x40, "VerifyingPaymaster: invalid signature length in paymasterAndData");
        require(msg.data[0x04 + arg0 + 0x40] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]]);
        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] <= 0xffffffffffffffff && !(var_i + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_i + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i)) {
            uint256 var_i = var_i + ((0x08c379a000000000000000000000000000000000000000000000000000000000 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x40]];
            require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]);
            if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff && !(var_i + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_i + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i)) {
                uint256 var_i = var_i + ((msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                uint256 var_k = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]];
            }
        }
    }
    
    /// @custom:selector    0xfb6dd7ff
    /// @custom:signature   Unresolved_fb6dd7ff(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_fb6dd7ff(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(arg0, "Invalid origin");
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        return ;
    }
    
    /// @custom:selector    0x23d9ac9b
    /// @custom:signature   verifyingSigner() public view returns (address)
    function verifyingSigner() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_f;
    }
    
    /// @custom:selector    0xc23a5cea
    /// @custom:signature   withdrawStake(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdrawStake(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), "Ownable: caller is not the owner");
        require(address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).code.length);
        (bool success, bytes memory ret0) = address(0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789).Unresolved_c23a5cea{ value: 0 }(arg0); // call
        require(success);
        if (success) {
            if (var_e <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
}