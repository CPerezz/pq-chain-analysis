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
    address store_i; // storage slot: 0x00
    address public wNATIVE; // storage slot: 0x01
    address store_j; // storage slot: 0x05
    address store_l; // storage slot: 0x06
    address store_g; // storage slot: 0x07
    address store_o; // storage slot: 0x08
    bytes32 store_d; // storage slot: 0x08
    address public reactor; // storage slot: 0x09
    bytes32 store_e; // storage slot: 0x09
    address public swapERC20; // storage slot: 0x0a
    bytes32 store_m; // storage slot: 0x0a
    
    mapping(bytes32 => uint256) storage_map_k; // storage slot: 0x02
    mapping(bytes32 => uint256) storage_map_a; // storage slot: 0x03
    mapping(bytes32 => uint256) storage_map_h; // storage slot: 0x04
    
    
    /// @custom:selector    0x57fff378
    /// @custom:signature   cashier(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function cashier(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_a[arg0];
    }
    
    /// @custom:selector    0x47723373
    /// @custom:signature   setLimitOrderProtocol(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setLimitOrderProtocol(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Liq: onlyOwner");
        store_d = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
    }
    
    /// @custom:selector    0x58d51f0a
    /// @custom:signature   setReactor(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setReactor(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Liq: onlyOwner");
        store_e = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
    }
    
    /// @custom:selector    0x05ce7493
    /// @custom:signature   Unresolved_05ce7493(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_05ce7493(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Liq: onlyOwner");
        if (0 >= store_g) {
            store_g = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                storage_map_h[address(msg.data[0x04 + arg0 + 0x20])] = 0x01;
            }
        } else {
            if (0 < store_g) {
                storage_map_h[store_g[0].field_0] = 0;
            }
        }
    }
    
    /// @custom:selector    0x092fd7e9
    /// @custom:signature   Unresolved_092fd7e9() public view returns (bytes memory)
    function Unresolved_092fd7e9() public view returns (bytes memory) {
        require(msg.sender == store_i, "Liq: onlyOwner");
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0x13af4035
    /// @custom:signature   Unresolved_13af4035(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_13af4035(address arg0) public {
        require(true);
        require(msg.sender == store_i, "Liq: onlyOwner");
        store_i = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256) {
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(!(0x41 - var_e), "Liq: invalid signature length");
        require(var_i <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Liq: invalid signature 's' value");
        require(0x1b == uint8(var_j), "Liq: invalid signature 'v' value");
        require(memory[0x20]);
        require(address(var_q), "Liq: INVALID_SIGNER");
        if (store_i == address(var_q)) {
            if (store_i != address(var_q)) {
                return 0xffffffff00000000000000000000000000000000000000000000000000000000;
            } else {
                return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
            }
        } else {
            if (0x01 != storage_map_k[address(var_q)]) {
                return 0xffffffff00000000000000000000000000000000000000000000000000000000;
            } else {
                return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
            }
        }
    }
    
    /// @custom:selector    0x24bfeb30
    /// @custom:signature   Unresolved_24bfeb30(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_24bfeb30(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x2f0dd388
    /// @custom:signature   Unresolved_2f0dd388(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2f0dd388(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x363d94ab
    /// @custom:signature   Unresolved_363d94ab(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_363d94ab(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == store_i, "Liq: onlyOwner");
        if (0 >= store_j) {
            store_j = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                storage_map_k[address(msg.data[0x04 + arg0 + 0x20])] = 0x01;
            }
        } else {
            if (0 < store_j) {
                storage_map_k[store_j[0].field_0] = 0;
            }
        }
    }
    
    /// @custom:selector    0x56775683
    /// @custom:signature   Unresolved_56775683(uint256 arg0, uint256 arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_56775683(uint256 arg0, uint256 arg1, uint256 arg2) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x01 == storage_map_k[msg.sender], "Liq: onlyOtc");
        if (0 >= msg.data[0x04 + arg0]) {
            require(reactor.code.length);
            (bool success, bytes memory ret0) = address(reactor).Unresolved_0d7a16c3{ value: 0 }(0x20); // call
            require(success);
        } else {
            require(msg.data[0x04 + arg0 + 0x20] < 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1 + (msg.data.length - (0x04 + arg0 + 0x20)));
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)] < msg.data.length - (msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)]] <= 0xffffffffffffffff);
            require(msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)] + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)]]);
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x20] < msg.data.length - (msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x20]] <= 0xffffffffffffffff);
            require(msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x20] + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + msg.data[msg.data[0x04 + arg0 + 0x20] + (0x04 + arg0 + 0x20) + 0x20]]);
        }
    }
    
    /// @custom:selector    0x6e1a1f20
    /// @custom:signature   Unresolved_6e1a1f20(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6e1a1f20(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == store_i, "Liq: onlyOwner");
        if (0 >= store_l) {
            store_l = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                storage_map_a[address(msg.data[0x04 + arg0 + 0x20])] = 0x01;
            }
        } else {
            if (0 < store_l) {
                storage_map_a[store_l[0].field_0] = 0;
            }
        }
    }
    
    /// @custom:selector    0x6f984635
    /// @custom:signature   Unresolved_6f984635(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6f984635(address arg0) public {
        require(true);
        require(msg.sender == store_i, "Liq: onlyOwner");
        store_e = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_e;
    }
    
    /// @custom:selector    0x7667f84f
    /// @custom:signature   Unresolved_7667f84f(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7667f84f(address arg0) public {
        require(true);
        require(msg.sender == store_i, "Liq: onlyOwner");
        require(swapERC20.code.length);
        (bool success, bytes memory ret0) = address(swapERC20).Unresolved_b6a5d7de{ value: 0 }(arg0); // call
        require(success);
    }
    
    /// @custom:selector    0x8d5c93bd
    /// @custom:signature   Unresolved_8d5c93bd() public view returns (bytes memory)
    function Unresolved_8d5c93bd() public view returns (bytes memory) {
        require(msg.sender == store_i, "Liq: onlyOwner");
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0x99757fce
    /// @custom:signature   Unresolved_99757fce() public
    function Unresolved_99757fce() public {
        require(msg.sender == store_i, "Liq: onlyOwner");
        require(swapERC20.code.length);
        (bool success, bytes memory ret0) = address(swapERC20).revoke{ value: 0 }(); // call
        require(success);
    }
    
    /// @custom:selector    0x9b3b82cc
    /// @custom:signature   Unresolved_9b3b82cc(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9b3b82cc(uint256 arg0, address arg1) public {
        require(true);
        require(msg.sender == store_i, "Liq: onlyOwner");
        store_m = 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
        require(wNATIVE.code.length);
        (bool success, bytes memory ret0) = address(wNATIVE).Unresolved_2e1a7d4d{ value: 0 }(arg0); // call
        require(success);
        if (0 - address(this).balance) {
            if (arg0) {
                payable(address(arg1)).transfer(address(this).balance);
                require(success);
                store_m = 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
            }
        } else {
            store_m = 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
        }
    }
    
    /// @custom:selector    0x9cd7b6fe
    /// @custom:signature   Unresolved_9cd7b6fe(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9cd7b6fe(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            if (0x04 + arg0 + 0x20 >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(arg1 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xa090949a
    /// @custom:signature   Unresolved_a090949a(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_a090949a(uint256 arg0) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x01 == storage_map_k[msg.sender], "Liq: onlyOtc");
        payable(address(store_o)).transfer(0);
        require(success);
    }
    
    /// @custom:selector    0xadf38ba1
    /// @custom:signature   Unresolved_adf38ba1(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    function Unresolved_adf38ba1(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7) public pure {
        require(arg8 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg8] <= 0xffffffffffffffff);
        require(true);
        require(arg14 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xaf34bd8b
    /// @custom:signature   Unresolved_af34bd8b(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_af34bd8b(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            if (0x04 + arg0 + 0x20 >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(arg1 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xbbd4f294
    /// @custom:signature   Unresolved_bbd4f294(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_bbd4f294(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(0x01 == storage_map_k[msg.sender], "Liq: onlyOtc");
        require(msg.data[0x04 + arg0] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0]] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0] + 0x20 <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0]]);
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x04 + arg0 + msg.data[0x04 + arg0 + 0x20] + 0x20 <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]);
        require(reactor.code.length);
        (bool success, bytes memory ret0) = address(reactor).Unresolved_3f62192e{ value: 0 }(0x20); // call
        require(success);
    }
    
    /// @custom:selector    0xbded8813
    /// @custom:signature   Unresolved_bded8813(address arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_bded8813(address arg0, uint256 arg1, uint256 arg2) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            if (0x04 + arg1 + 0x20 >= 0x20 + (0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05))) {
                require(arg2 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg1 + 0x20] == address(msg.data[0x04 + arg1 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xc0bbfe91
    /// @custom:signature   Unresolved_c0bbfe91(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c0bbfe91(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_k[arg0];
    }
    
    /// @custom:selector    0xc2182878
    /// @custom:signature   Unresolved_c2182878() public view returns (bytes memory)
    function Unresolved_c2182878() public view returns (bytes memory) {
        require(msg.sender == store_i, "Liq: onlyOwner");
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0xdf5da507
    /// @custom:signature   Unresolved_df5da507(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_df5da507(address arg0) public {
        require(true);
        require(msg.sender == store_i, "Liq: onlyOwner");
        store_m = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_m;
    }
    
    /// @custom:selector    0x8f5e074c
    /// @custom:signature   withdrawalWhitelist(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdrawalWhitelist(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_h[arg0];
    }
    
    /// @custom:selector    0xb8ca8dd8
    /// @custom:signature   withdrawNative(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function withdrawNative(uint256 arg0, address arg1) public {
        require(true);
        require(0x01 == storage_map_a[msg.sender], "Liq: onlyCashier");
        store_m = 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
        require(0x01 == (0x01 == storage_map_h[arg1]), "Liq: withdrawal whitelist");
        require(wNATIVE.code.length);
        (bool success, bytes memory ret0) = address(wNATIVE).Unresolved_2e1a7d4d{ value: 0 }(arg0); // call
        require(success);
        if (0 - address(this).balance) {
            if (arg0) {
                payable(address(arg1)).transfer(address(this).balance);
                require(success);
                store_m = 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
            }
        } else {
            store_m = 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_m;
        }
    }
}