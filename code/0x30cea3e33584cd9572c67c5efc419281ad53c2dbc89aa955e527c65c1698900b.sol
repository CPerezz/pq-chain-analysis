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
    uint256 public constant unresolved_2eb4a7ab = 110498418760284225034512376697346454807304719229481079963779119919343231890190;
    uint256 public constant unresolved_fc0c546a = 289481817211035374819923729791460004705193816942;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_c; // storage slot: 0x00
    address public unresolved_f74d5480; // storage slot: 0x01
    bytes32 store_f; // storage slot: 0x01
    uint256 store_d; // storage slot: 0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00
    
    mapping(address => uint8) storage_map_b; // storage slot: 0x02
    
    error CustomError_00000000();
    event Event_8be0079c();
    event TokensWithdrawn(address, uint256);
    event TrustedSignerUpdated(address, address);
    
    /// @custom:selector    0x6382d9ad
    /// @custom:signature   emergencyWithdraw(address arg0, address arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function emergencyWithdraw(address arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg1, CustomError_9c8d2cd2());
        (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (success) {
            if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                uint256 var_c = var_c + 0x20;
                require(var_c + 0x20 - var_c >= 0x20);
                require(var_f, CustomError_fba5154e());
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(arg1); // call
                require(success);
                if (!success) {
                    require(0, CustomError_045c4b02());
                    emit TokensWithdrawn(arg1, var_f);
                }
            }
        } else {
            require(0, CustomError_fba5154e());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(arg1, 0); // call
            require(success);
            if (success) {
                if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                    uint256 var_c = var_c + 0x20;
                    require(var_c + 0x20 - var_c >= 0x20);
                    require(!(var_f - var_f));
                    require(var_f, CustomError_045c4b02());
                    emit TokensWithdrawn(arg1, 0);
                }
            } else {
                require(0, CustomError_045c4b02());
                emit TokensWithdrawn(arg1, 0);
            }
        }
    }
    
    /// @custom:selector    0x73b2e80e
    /// @custom:signature   hasClaimed(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function hasClaimed(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x8cc08025
    /// @custom:signature   isClaimed(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isClaimed(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x877634db
    /// @custom:signature   Unresolved_877634db(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_877634db(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(!(arg2 - arg2));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(arg4 <= 0xffffffffffffffff);
        require(arg4 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require(0x24 + (arg4 + msg.data[0x04 + arg4]) <= msg.data.length);
        require(store_d != 0x02, CustomError_3ee5aeb5());
        store_d = 0x02;
        require(arg2, CustomError_9c8d2cd2());
        require(!storage_map_b[msg.sender].field_0, CustomError_5fc95708());
        if (!(var_j + 0xc0 > 0xffffffffffffffff | var_j + 0xc0 < var_j)) {
            uint256 var_j = var_j + 0xc0;
            if (!(var_j + 0xc0 + ((msg.data[0x04 + arg4] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + 0xc0 + ((msg.data[0x04 + arg4] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j + 0xc0)) {
                uint256 var_j = var_j + 0xc0 + ((var_n + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                uint256 var_n = msg.data[0x04 + arg4];
                if (var_q > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    require(0x03 >= 0x04, CustomError_d78bce0c());
                } else {
                    var_p = keccak256(memory[0:0x3c]);
                    require(memory[0x20]);
                }
            }
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_c = store_c & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0x7530625f
    /// @custom:signature   updateTrustedSigner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function updateTrustedSigner(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_e6c4247b());
        store_f = store_f & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit TrustedSignerUpdated(unresolved_f74d5480, arg0);
    }
    
    /// @custom:selector    0x707b6fe6
    /// @custom:signature   verifyProof(bytes32 arg0, uint256 arg1, bytes32[] arg2) public pure returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function verifyProof(bytes32 arg0, uint256 arg1, bytes32[] arg2) public pure returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x05) + (0x04 + arg2) + 0x20 <= msg.data.length);
        if (!(var_d + 0x60 > 0xffffffffffffffff | var_d + 0x60 < var_d)) {
            uint256 var_d = var_d + 0x60;
            if (msg.data[0x04 + arg2] <= 0xffffffffffffffff && !(var_d + ((msg.data[0x04 + arg2] << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + ((msg.data[0x04 + arg2] << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                uint256 var_d = var_d + ((var_g << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (0 >= var_h) {
                    return keccak256(memory[var_d + 0x20:var_d + 0x20 + var_h]) == 0xf44be381119d4505a0a8d929f8fdfe6b6362922485ced85f278889ea8734f30e;
                }
            }
        }
    }
    
    /// @custom:selector    0x5affbd97
    /// @custom:signature   withdrawRemainingTokens(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdrawRemainingTokens(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_9c8d2cd2());
        (bool success, bytes memory ret0) = address(0x32b4d049fe4c888d2b92eecaf729f44df6b1f36e).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (success) {
            if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                uint256 var_c = var_c + 0x20;
                require(var_c + 0x20 - var_c >= 0x20);
                require(var_f, CustomError_fba5154e());
                (bool success, bytes memory ret0) = address(0x32b4d049fe4c888d2b92eecaf729f44df6b1f36e).Unresolved_a9059cbb(arg0); // call
                require(success);
                if (!success) {
                    require(0, CustomError_045c4b02());
                    emit TokensWithdrawn(arg0, var_f);
                }
            }
        } else {
            require(0, CustomError_fba5154e());
            (bool success, bytes memory ret0) = address(0x32b4d049fe4c888d2b92eecaf729f44df6b1f36e).Unresolved_a9059cbb(arg0, 0); // call
            require(success);
            if (success) {
                if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                    uint256 var_c = var_c + 0x20;
                    require(var_c + 0x20 - var_c >= 0x20);
                    require(!(var_f - var_f));
                    require(var_f, CustomError_045c4b02());
                    emit TokensWithdrawn(arg0, 0);
                }
            } else {
                require(0, CustomError_045c4b02());
                emit TokensWithdrawn(arg0, 0);
            }
        }
    }
}