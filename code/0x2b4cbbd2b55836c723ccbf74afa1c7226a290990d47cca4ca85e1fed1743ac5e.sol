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
    bytes32 store_i; // storage slot: 0x00
    address store_j; // storage slot: 0x01
    uint256 store_d; // storage slot: 0x02
    uint256 store_e; // storage slot: 0x03
    bytes32 store_k; // storage slot: 0x08
    uint8 store_h; // storage slot: 0x08
    
    mapping(uint256 => bytes32) storage_map_c; // storage slot: 0x04
    mapping(address => bytes32) storage_map_b; // storage slot: 0x05
    mapping(uint256 => uint256) storage_map_g; // storage slot: 0x06
    mapping(uint256 => bytes32) storage_map_f; // storage slot: 0x07
    
    error CustomError_00000000();
    event DepositMade(uint256, address, uint256, (uint256,uint256), (uint256,uint256));
    event DepositPrivateMade(uint256, address, uint256, (uint256,uint256), (uint256,uint256), (uint256,uint256), uint256, uint256, bool);
    event Event_8be0079c();
    
    /// @custom:selector    0x3778431d
    /// @custom:signature   AddContractToWhitelist(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function AddContractToWhitelist(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_b[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_b[arg0];
        return ;
    }
    
    /// @custom:selector    0x96b10198
    /// @custom:signature   AvalueToDeposit(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function AvalueToDeposit(uint256 arg0) public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        if (!(var_c + 0x40 > 0xffffffffffffffff | var_c + 0x40 < var_c)) {
            var_g = storage_map_c[arg0];
            return abi.encodePacked(var_g, var_i, var_k);
        }
    }
    
    /// @custom:selector    0xb7269578
    /// @custom:signature   ContractWhitelisted(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function ContractWhitelisted(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x5d1ca631
    /// @custom:signature   getId() public view returns (uint256)
    function getId() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_d;
    }
    
    /// @custom:selector    0x16e5b7a2
    /// @custom:signature   getIdP() public view returns (uint256)
    function getIdP() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_e;
    }
    
    /// @custom:selector    0x0e611d38
    /// @custom:signature   getValue(uint256 arg0, address arg1) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function getValue(uint256 arg0, address arg1) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        var_c = storage_map_c[arg0].field_1[arg1];
        return var_c;
    }
    
    /// @custom:selector    0x39a090c9
    /// @custom:signature   Id() public view returns (uint256)
    function Id() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_d;
    }
    
    /// @custom:selector    0xad3d083e
    /// @custom:signature   IdP() public view returns (uint256)
    function IdP() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_e;
    }
    
    /// @custom:selector    0xb46c94a4
    /// @custom:signature   MakeDepositPrivateTuple(((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg0, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg1, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg2, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg3, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg4, address arg5) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    function MakeDepositPrivateTuple(((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg0, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg1, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg2, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg3, ((uint256,uint256),(uint256,uint256),(uint256,uint256),uint256,uint256)[] arg4, address arg5) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xc0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x08) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x08) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x08) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x08) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg4] << 0x08) + (0x04 + arg4) + 0x20 <= msg.data.length);
        require(!(arg5 - arg5));
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0] && storage_map_c[msg.data[0x04 + arg0 + 0x20]]) {
            require(storage_map_c[msg.data[0x04 + arg0 + 0x20]]);
        }
    }
    
    /// @custom:selector    0x79f95ee9
    /// @custom:signature   nullifierUsed(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function nullifierUsed(uint256 arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        var_c = storage_map_f[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x98b0eff6
    /// @custom:signature   proofUsed(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function proofUsed(bytes32 arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        var_c = storage_map_g[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x17f708fb
    /// @custom:signature   removeWhitelist() public view returns (bool)
    function removeWhitelist() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_h;
    }
    
    /// @custom:selector    0x0299a069
    /// @custom:signature   Unresolved_0299a069(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    function Unresolved_0299a069(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0220);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c + msg.data.length >= 0x80);
        require(!(arg8 - arg8));
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffebc + msg.data.length >= 0x60);
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe5c + msg.data.length >= 0x60);
        if (!(0x0180 > 0xffffffffffffffff | 0x0180 < 0xa0)) {
            require(memory[0x20]);
            if (storage_map_c[arg0]) {
                require(storage_map_c[arg0].field_1[arg8] >= arg9);
                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_24cc100e(arg0); // delegatecall
                require(success);
                uint256 var_a = var_a;
                storage_map_g[var_a] = storage_map_g[var_a] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                storage_map_c[arg4].field_1[arg8] = arg9;
                storage_map_c[arg4].field_1[arg8].field_2 = arg4;
                storage_map_c[arg4].field_1[arg8].field_3 = arg5;
                storage_map_c[arg4].field_1[arg8].field_1[0x03] = arg6;
                if (!(0x0180 + 0xc0 > 0xffffffffffffffff | 0x0180 + 0xc0 < 0x0180)) {
                    require(memory[0x20]);
                    if (!storage_map_c[arg4].field_1[arg8].field_1[0x03]) {
                        if (!arg9) {
                            require(!arg9);
                        }
                    } else {
                        require(!storage_map_c[arg4].field_1[arg8].field_1[0x03]);
                        uint256 var_a = var_a;
                        storage_map_g[var_a] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[var_a];
                        require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                        (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_4a622bdb(arg4); // delegatecall
                        require(success);
                        store_d = storage_map_g[var_a];
                        storage_map_g[var_a] = store_d;
                        emit DepositMade(storage_map_g[var_a], arg8, arg9, arg4, arg5, arg6, arg7);
                        storage_map_g[arg8].field_1[arg8] -= arg9;
                        return ;
                    }
                }
            } else {
                if (!storage_map_c[arg0] && !storage_map_c[arg0]) {
                    require(!storage_map_c[arg0]);
                }
            }
        }
    }
    
    /// @custom:selector    0x053c15f3
    /// @custom:signature   Unresolved_053c15f3(uint256 arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_053c15f3(uint256 arg0, address arg1) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xc0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x07) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbc + msg.data.length >= 0x60);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
            uint256 var_a = var_a + 0x40;
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
            }
        }
    }
    
    /// @custom:selector    0x0e60d4e8
    /// @custom:signature   Unresolved_0e60d4e8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, address arg7) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0e60d4e8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, address arg7) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01c0);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg4] << 0x08) + (0x04 + arg4) + 0x20 <= msg.data.length);
        require(arg5 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg5] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg5] << 0x08) + (0x04 + arg5) + 0x20 <= msg.data.length);
        require(arg6 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg6] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg6] << 0x08) + (0x04 + arg6) + 0x20 <= msg.data.length);
        require(arg7 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg7] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg7] << 0x08) + (0x04 + arg7) + 0x20 <= msg.data.length);
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg8] << 0x08) + (0x04 + arg8) + 0x20 <= msg.data.length);
        require(!(arg9 - arg9));
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffebc + msg.data.length >= 0x60);
        if (0 < msg.data[0x04 + arg4] && 0 < msg.data[0x04 + arg4]) {
            require(var_g + 0x60 > 0xffffffffffffffff | var_g + 0x60 < var_g);
        }
    }
    
    /// @custom:selector    0x1a6862e2
    /// @custom:signature   Unresolved_1a6862e2(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, address arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    /// @param              arg17 ["uint256", "bytes32", "int256"]
    function Unresolved_1a6862e2(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, address arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0240);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c + msg.data.length >= 0x0100);
        require(!(arg12 - arg12));
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe3c + msg.data.length >= 0x60);
        if (!(var_k + (var_k + 0x20 + 0xb5 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (var_k + 0x20 + 0xb5 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)) {
            bytes var_a = sha256();
            require(memory[0x20]);
            require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
            (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_24cc100e(arg0); // delegatecall
            require(success);
            if (storage_map_c[arg0]) {
                require(storage_map_c[arg0].field_1[arg12] >= arg13);
                uint256 var_a = var_a;
                storage_map_g[var_a] = storage_map_g[var_a] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                if (!storage_map_c[arg4]) {
                    require(arg13);
                } else {
                    require(!storage_map_c[arg4]);
                }
                storage_map_c[arg4].field_1[arg12] = arg13;
                storage_map_c[arg4].field_1[arg12].field_2 = arg4;
                storage_map_c[arg4].field_1[arg12].field_3 = arg5;
                storage_map_c[arg4].field_1[arg12].field_1[0x03] = arg6;
                emit DepositPrivateMade(storage_map_c[arg4].field_1[arg12].field_1[0x03], arg12, arg13, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, 0);
                store_e = storage_map_c[arg4].field_1[arg12].field_1[0x03];
                storage_map_c[arg4].field_1[arg12].field_1[0x03] = store_e;
                storage_map_c[arg4].field_1[arg12].field_1[0x03].field_1[arg12] -= arg13;
                return ;
            } else {
                if (!storage_map_c[arg0] && !storage_map_c[arg0]) {
                    require(!storage_map_c[arg0]);
                }
            }
        }
    }
    
    /// @custom:selector    0x2be31fba
    /// @custom:signature   Unresolved_2be31fba(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_2be31fba(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0140);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(!(arg4 - arg4));
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff3c + msg.data.length >= 0x60);
        storage_map_c[arg0].field_1[arg4] = arg5;
        storage_map_c[arg0].field_1[arg4].field_2 = arg0;
        storage_map_c[arg0].field_1[arg4].field_3 = arg1;
        storage_map_c[arg0].field_1[arg4].field_1[0x03] = arg2;
        if (!(var_i + 0xc0 > 0xffffffffffffffff | var_i + 0xc0 < var_i)) {
            uint256 var_i = var_i + 0xc0;
            require(memory[0x20]);
            if (!storage_map_c[arg0].field_1[arg4].field_1[0x03]) {
                if (!arg5) {
                    require(!arg5);
                }
            } else {
                require(!storage_map_c[arg0].field_1[arg4].field_1[0x03]);
                uint256 var_a = var_a;
                storage_map_g[var_a] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[var_a];
                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_4a622bdb(arg0); // delegatecall
                require(success);
                store_d = storage_map_g[var_a];
                storage_map_g[var_a] = store_d;
                if (!(var_i + 0xa0 > 0xffffffffffffffff | var_i + 0xa0 < var_i)) {
                    (bool success, bytes memory ret0) = address(arg4).Unresolved_23b872dd(msg.sender); // call
                    require(success);
                    if (ret0.length) {
                        require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
                    } else {
                        require(arg4.code.length, CustomError_5274afe7());
                    }
                    emit DepositMade(storage_map_g[0x5274afe700000000000000000000000000000000000000000000000000000000], arg4, arg5, arg0, arg1, arg2, arg3);
                    return ;
                }
            }
        }
    }
    
    /// @custom:selector    0x32445c06
    /// @custom:signature   Unresolved_32445c06(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, address arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_32445c06(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, address arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0160);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(!(arg4 - arg4));
        require(!(arg5 - arg5));
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1c + msg.data.length >= 0x60);
        if (storage_map_c[arg0]) {
            require(storage_map_c[arg0].field_1[arg4] >= arg6);
            if (!(var_k + 0xe0 > 0xffffffffffffffff | var_k + 0xe0 < var_k)) {
                require(memory[0x20]);
                require(!storage_map_g[arg4].field_0);
                uint256 var_a = var_a;
                storage_map_g[var_a] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[var_a];
                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_24cc100e(arg0); // delegatecall
                require(success);
            }
        } else {
            if (!storage_map_c[arg0]) {
                require(!storage_map_c[arg0]);
            }
        }
    }
    
    /// @custom:selector    0x419be01a
    /// @custom:signature   Unresolved_419be01a(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, uint256 arg9) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    function Unresolved_419be01a(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, uint256 arg9) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0140);
        require(0x0100 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(!(arg8 - arg8));
        if (!storage_map_c[arg0]) {
            require(!arg9);
        } else {
            require(!storage_map_c[arg0]);
            storage_map_c[arg0].field_1[arg8] = arg9;
            storage_map_c[arg0].field_1[arg8].field_2 = arg0;
            storage_map_c[arg0].field_1[arg8].field_3 = arg1;
            storage_map_c[arg0].field_1[arg8].field_1[0x03] = arg2;
            emit DepositPrivateMade(storage_map_c[arg0].field_1[arg8].field_1[0x03], arg8, arg9, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, 0x01);
            store_e = storage_map_c[arg0].field_1[arg8].field_1[0x03];
            storage_map_c[arg0].field_1[arg8].field_1[0x03] = store_e;
            if (!(var_p + 0xa0 > 0xffffffffffffffff | var_p + 0xa0 < var_p)) {
                (bool success, bytes memory ret0) = address(arg8).Unresolved_23b872dd(msg.sender, address(this), arg9, var_r); // call
                require(success);
                if (ret0.length) {
                    require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
                } else {
                    require(arg8.code.length, CustomError_5274afe7());
                }
                return ;
            }
        }
    }
    
    /// @custom:selector    0x63f99b05
    /// @custom:signature   Unresolved_63f99b05(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    function Unresolved_63f99b05(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01c0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x07) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x07) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff9c + msg.data.length >= 0x40);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5c + msg.data.length >= 0x0100);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
            uint256 var_a = var_a + 0x40;
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
                if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                    uint256 var_a = var_a + 0x40;
                    if (0 < msg.data[0x04 + arg0]) {
                        if (0 < msg.data[0x04 + arg0] && !(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                            uint256 var_a = var_a + 0x40;
                        }
                    } else {
                        require(!storage_map_f[arg3].field_0);
                        require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                        (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_ba80bb3d(0xa0); // delegatecall
                        require(success);
                        if (success) {
                            require(var_a > 0xffffffffffffffff | var_a < var_a);
                        } else {
                            storage_map_f[arg3] = storage_map_f[arg3] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                            if (!storage_map_c[arg5]) {
                                require(0);
                            } else {
                                require(!storage_map_c[arg5]);
                            }
                            storage_map_c[arg5].field_1[arg1] = 0;
                            storage_map_c[arg5].field_1[arg1].field_2 = arg5;
                            storage_map_c[arg5].field_1[arg1].field_3 = arg6;
                            storage_map_c[arg5].field_1[arg1].field_1[0x03] = arg7;
                            emit DepositPrivateMade(storage_map_c[arg5].field_1[arg1].field_1[0x03], arg1, 0, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, 0);
                            store_e = storage_map_c[arg5].field_1[arg1].field_1[0x03];
                            storage_map_c[arg5].field_1[arg1].field_1[0x03] = store_e;
                            return ;
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable returns (uint256)
    function Unresolved_715018a6() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_i = store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
        return ;
    }
    
    /// @custom:selector    0xaf996464
    /// @custom:signature   Unresolved_af996464(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, address arg5, address arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_af996464(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, address arg5, address arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0180);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(!(arg4 - arg4));
        require(!(arg5 - arg5));
        require(!(arg6 - arg6));
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffefc + msg.data.length >= 0x60);
        if (storage_map_c[arg0]) {
            require(storage_map_c[arg0].field_1[arg4] >= arg7);
            if (!(var_l + 0xe0 > 0xffffffffffffffff | var_l + 0xe0 < var_l)) {
                uint256 var_l = var_l + 0xe0;
                bytes var_a = sha256();
                require(memory[0x20]);
                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_24cc100e(arg0); // delegatecall
                require(success);
                uint256 var_a = var_a;
                storage_map_g[var_a] = storage_map_g[var_a] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                if (!(var_l + 0x80 > 0xffffffffffffffff | var_l + 0x80 < var_l)) {
                    (bool success, bytes memory ret0) = address(arg4).Unresolved_a9059cbb(store_j); // call
                    require(success);
                    require(!ret0.length, CustomError_5274afe7());
                    require(arg4.code.length, CustomError_5274afe7());
                    (bool success, bytes memory ret0) = address(store_j).Unresolved_5a837efd(arg4); // call
                    require(success);
                    if (!success) {
                        require(store_j.code.length);
                        (bool success, bytes memory ret0) = address(store_j).Unresolved_c8f2835f(arg5); // call
                        require(success);
                        storage_map_c[arg0].field_1[arg4] -= arg7;
                        storage_map_c[arg0].field_1[arg5] = storage_map_c[arg0].field_1[arg5];
                        return ;
                    }
                }
            }
        } else {
            if (!storage_map_c[arg0]) {
                require(!storage_map_c[arg0]);
            }
        }
    }
    
    /// @custom:selector    0xdafc44c4
    /// @custom:signature   Unresolved_dafc44c4(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_dafc44c4(uint256 arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_k = uint8(arg0) | store_k & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        return ;
    }
    
    /// @custom:selector    0xe33597f8
    /// @custom:signature   Unresolved_e33597f8(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_e33597f8(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01a0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x07) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x07) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff9c + msg.data.length >= 0x40);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5c + msg.data.length >= 0x80);
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffedc + msg.data.length >= 0x60);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
            uint256 var_a = var_a + 0x40;
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
                if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                    uint256 var_a = var_a + 0x40;
                    if (0 < msg.data[0x04 + arg0]) {
                        if (0 < msg.data[0x04 + arg0] && !(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                            uint256 var_a = var_a + 0x40;
                        }
                    } else {
                        require(!storage_map_f[arg3].field_0);
                        require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                        (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_ba80bb3d(0xa0); // delegatecall
                        require(success);
                        storage_map_f[arg3] = storage_map_f[arg3] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                        storage_map_c[arg5].field_1[arg1] = 0;
                        storage_map_c[arg5].field_1[arg1].field_2 = arg5;
                        storage_map_c[arg5].field_1[arg1].field_3 = arg6;
                        storage_map_c[arg5].field_1[arg1].field_1[0x03] = arg7;
                        if (!(var_a + 0xc0 > 0xffffffffffffffff | var_a + 0xc0 < var_a)) {
                            require(memory[0x20]);
                            if (!storage_map_c[arg5].field_1[arg1].field_1[0x03]) {
                                require(!0);
                            } else {
                                require(!storage_map_c[arg5].field_1[arg1].field_1[0x03]);
                                uint256 var_b = var_b;
                                storage_map_g[var_b] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_g[var_b];
                                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_4a622bdb(arg5); // delegatecall
                                require(success);
                                store_d = storage_map_g[var_b];
                                storage_map_g[var_b] = store_d;
                                emit DepositMade(storage_map_g[var_b], arg1, 0, arg5, arg6, arg7, arg8);
                                return ;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xe64f5569
    /// @custom:signature   Unresolved_e64f5569(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, address arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg9 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    /// @param              arg17 ["uint256", "bytes32", "int256"]
    /// @param              arg18 ["uint256", "bytes32", "int256"]
    /// @param              arg19 ["uint256", "bytes32", "int256"]
    function Unresolved_e64f5569(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, address arg8, address arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x0280);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c + msg.data.length >= 0x80);
        require(!(arg8 - arg8));
        require(!(arg9 - arg9));
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffebc + msg.data.length >= 0x0120);
        if (storage_map_c[arg4].field_1[arg8].field_1[arg8].field_1[0x03].field_1[0x03]) {
            if (!(var_m + 0x0120 > 0xffffffffffffffff | var_m + 0x0120 < var_m)) {
                bytes var_a = sha256();
                require(memory[0x20]);
                require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_2d642688(arg0); // delegatecall
                require(success);
            }
            revert();
        } else {
            if (!storage_map_c[arg4].field_1[arg8].field_1[arg8].field_1[0x03].field_1[0x03]) {
                require(!storage_map_c[arg4].field_1[arg8].field_1[arg8].field_1[0x03].field_1[0x03]);
            }
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_i = store_i & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        return ;
    }
    
    /// @custom:selector    0xf64676b0
    /// @custom:signature   Unresolved_f64676b0(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_f64676b0(uint256 arg0, address arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xe0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x07) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x07) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7c + msg.data.length >= 0x40);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
            uint256 var_a = var_a + 0x40;
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
                if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                    uint256 var_a = var_a + 0x40;
                    if (0 < msg.data[0x04 + arg0]) {
                        if (0 < msg.data[0x04 + arg0] && !(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                            uint256 var_a = var_a + 0x40;
                        }
                    } else {
                        require(!storage_map_f[arg4].field_0);
                        require(address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).code.length);
                        (bool success, bytes memory ret0) = address(0x04987ab8465ff6c5d4f803a5adc6638ea69316bd).Unresolved_ba80bb3d(0xa0); // delegatecall
                        require(success);
                        if (!(var_a + 0x80 > 0xffffffffffffffff | var_a + 0x80 < var_a)) {
                            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb(arg2); // call
                            require(success);
                            if (ret0.length) {
                                require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
                            } else {
                                require(arg1.code.length, CustomError_5274afe7());
                            }
                            storage_map_f[arg4] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_f[arg4];
                            return ;
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xfe4b8d71
    /// @custom:signature   Unresolved_fe4b8d71(uint256 arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_fe4b8d71(uint256 arg0, address arg1) public pure {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01c0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x07) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbc + msg.data.length >= 0x60);
        require(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5c + msg.data.length >= 0x0100);
        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
            uint256 var_a = var_a + 0x40;
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
                if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                    uint256 var_a = var_a + 0x40;
                    if (msg.data[0x04 + arg0]) {
                        require(msg.data.length - (0x04 + arg0 + 0x20) < 0x80);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xfe727025
    /// @custom:signature   Unresolved_fe727025(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_fe727025(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xc0);
        require(0x80 <= 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length);
        require(!(arg4 - arg4));
        require(arg5);
        storage_map_c[arg0].field_1[arg4] += arg5;
        if (!(var_h + 0xa0 > 0xffffffffffffffff | var_h + 0xa0 < var_h)) {
            (bool success, bytes memory ret0) = address(0x4e487b7100000000000000000000000000000000000000000000000000000000).Unresolved_23b872dd(msg.sender); // call
            require(success);
            if (ret0.length) {
                require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
            } else {
                require(arg4.code.length, CustomError_5274afe7());
            }
            return ;
        }
    }
}