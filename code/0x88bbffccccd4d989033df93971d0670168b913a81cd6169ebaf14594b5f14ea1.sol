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
    address public wrappedNativeToken; // storage slot: 0x00
    bytes32 store_c; // storage slot: 0x01
    address public unresolved_8787914d; // storage slot: 0x05
    bytes32 store_i; // storage slot: 0x05
    address public unresolved_8da5cb5b; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    bytes32 store_h; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x02
    mapping(address => bytes32) storage_map_b; // storage slot: 0x03
    mapping(address => bytes32) storage_map_e; // storage slot: 0x04
    
    error CustomError_00000000();
    event Event_8be0079c();
    event OperatorSet(address, bool);
    event WhitelistSet(address, bool);
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0xc683630d
    /// @custom:signature   isWhitelist(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isWhitelist(address arg0) public view returns (bool) {
        require(true);
        return storage_map_b[arg0].field_0;
    }
    
    /// @custom:selector    0x4dfdc21f
    /// @custom:signature   maxNum() public view returns (uint256)
    function maxNum() public view returns (uint256) {
        return store_c;
    }
    
    /// @custom:selector    0x79a1c157
    /// @custom:signature   multiSend(address[] arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function multiSend(address[] arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        require(msg.data[0x04 + arg0], "empty tokens");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
            require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            if (!address(msg.data[0x04 + arg0 + 0x20])) {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_a9059cbb(arg1); // call
                require(!success, CustomError_5274afe7());
            } else {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_70a08231(address(this), arg1); // staticcall
                require(success);
                uint256 var_d = var_d + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_d + ret0.length - var_d >= 0x20);
                if (address(msg.data[0x04 + arg0 + 0x20])) {
                    (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_a9059cbb(arg1); // call
                    require(!success, CustomError_5274afe7());
                } else {
                    payable(address(arg1)).transfer(var_j);
                    revert();
                }
            }
        }
    }
    
    /// @custom:selector    0x0befee98
    /// @custom:signature   Unresolved_0befee98(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_0befee98(uint256 arg0) public {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        if (storage_map_e[msg.sender].field_0.field_0 + 0x0708 <= 0xffffffffffffffff) {
            require(block.timestamp >= uint64(storage_map_e[msg.sender].field_0.field_0 + 0x0708), "unwrap too frequently");
            require(arg0 <= store_c, "amount exceeds");
            storage_map_e[msg.sender] = uint64(block.timestamp) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & storage_map_e[msg.sender];
            require(wrappedNativeToken.code.length);
            (bool success, bytes memory ret0) = address(wrappedNativeToken).Unresolved_2e1a7d4d(arg0); // call
            require(success);
            payable(address(msg.sender)).transfer(arg0);
            require(success);
        }
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256) {
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            require(var_e >= 0x41, "at least 65 sig");
            uint256 var_c = msg.data[0x64:0x64 + 0x41];
            if (0x41 - var_e) {
                if (0x02 <= 0x03) {
                    if (0x02 <= 0x03) {
                        require(0x02 > 0x03, CustomError_fce698f7());
                        revert CustomError_f645eedf();
                    }
                    if (storage_map_a[0].field_0) {
                        return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                    } else {
                        return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                    }
                }
            } else {
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0x1f6eddba
    /// @custom:signature   Unresolved_1f6eddba(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1f6eddba(address arg0, uint256 arg1) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        uint256 var_d = var_d + 0x64;
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_8787914d); // call
        if (!success && !success) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_8787914d); // call
            require(success);
            require(!ret0.length, CustomError_5274afe7());
            require(arg0.code.length, CustomError_5274afe7());
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3(unresolved_8787914d); // call
            require(success);
            if (!ret0.length) {
                require(arg0.code.length, CustomError_5274afe7());
            } else {
                require(0x01 == var_m, CustomError_5274afe7());
            }
        }
    }
    
    /// @custom:selector    0x2ecc1126
    /// @custom:signature   Unresolved_2ecc1126(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2ecc1126(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x53d6fd59
    /// @custom:signature   Unresolved_53d6fd59(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_53d6fd59(address arg0, uint256 arg1) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        storage_map_b[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[arg0];
        emit WhitelistSet(arg0, arg1);
    }
    
    /// @custom:selector    0x558a7297
    /// @custom:signature   Unresolved_558a7297(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_558a7297(address arg0, uint256 arg1) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        emit OperatorSet(arg0, arg1);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_h = store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0xafab28ff
    /// @custom:signature   Unresolved_afab28ff(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_afab28ff(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xb2c8d664
    /// @custom:signature   Unresolved_b2c8d664(address arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_b2c8d664(address arg0, uint256 arg1, uint256 arg2) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            require(0x20 + ((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1)) <= msg.data.length);
            if (0x04 + arg1 + 0x20 >= 0x20 + ((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1))) {
                require(arg2 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg1 + 0x20] == address(msg.data[0x04 + arg1 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xb6f0a95e
    /// @custom:signature   Unresolved_b6f0a95e(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_b6f0a95e(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xba71dc70
    /// @custom:signature   Unresolved_ba71dc70(address arg0) public view returns (uint64)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_ba71dc70(address arg0) public view returns (uint64) {
        require(true);
        return storage_map_e[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0xd9caed12
    /// @custom:signature   Unresolved_d9caed12(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d9caed12(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xdaebe679
    /// @custom:signature   Unresolved_daebe679(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_daebe679(address arg0) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        store_i = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
    }
    
    /// @custom:selector    0xea598cb0
    /// @custom:signature   Unresolved_ea598cb0(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ea598cb0(uint256 arg0) public payable {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(wrappedNativeToken.code.length);
        (bool success, bytes memory ret0) = address(wrappedNativeToken).Unresolved_d0e30db0{ value: arg0 }(var_d); // call
        require(success);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_h = arg0 | store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xf71d7ab8
    /// @custom:signature   Unresolved_f71d7ab8(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f71d7ab8(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, "not permitted");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            uint256 var_d = msg.data[0x04 + arg0 + 0x20];
            if (unresolved_8787914d.code.length) {
                (bool success, bytes memory ret0) = address(unresolved_8787914d).Unresolved_825caba1(var_d); // call
            }
            revert();
        }
    }
    
    /// @custom:selector    0xde0e9a3e
    /// @custom:signature   unwrap(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function unwrap(uint256 arg0) public {
        require(storage_map_a[msg.sender].field_0, "not permitted");
        require(wrappedNativeToken.code.length);
        (bool success, bytes memory ret0) = address(wrappedNativeToken).Unresolved_2e1a7d4d(arg0); // call
        require(success);
    }
}