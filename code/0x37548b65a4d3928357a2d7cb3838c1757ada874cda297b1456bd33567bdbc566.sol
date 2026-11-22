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
    bytes public constant unresolved_54fd4d50 = 0xBytes([48, 46, 52, 46, 48]);
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_x; // storage slot: 0x00
    address store_w; // storage slot: 0x01
    bytes32 store_l; // storage slot: 0x01
    uint256 public operatorSize; // storage slot: 0x03
    bytes32 store_h; // storage slot: 0x04
    string public baseTokenURI; // storage slot: 0x05
    address public nftSingleton; // storage slot: 0x06
    bytes32 store_n; // storage slot: 0x06
    address public claimSigner; // storage slot: 0x07
    bytes32 store_m; // storage slot: 0x07
    bytes store_c; // storage slot: 0x08
    bytes store_i; // storage slot: 0x0b
    bytes store_f; // storage slot: 0x0d
    address store_r; // storage slot: 0x11
    bytes32 store_o; // storage slot: 0x11
    address public vaultAddress; // storage slot: 0x12
    bytes32 store_y; // storage slot: 0x12
    address public unresolved_0f8fe56a; // storage slot: 0x16
    address store_t; // storage slot: keccak256(memory[var_a + 0x20:var_a + 0x20 + (0x20 + var_e)])
    bytes32 baseTokenURIc; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] + var_a - var_a))])
    bytes32 store_z; // storage slot: 0xc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b + operatorSize
    bytes32[] baseTokenURIa; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (msg.data[0x04 + arg0] + var_a - var_a))])
    bytes32[] store_p; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (msg.data[0x04 + arg0] + var_a) - var_a)])
    uint8 store_v; // storage slot: keccak256(memory[var_a + 0x20:var_a + 0x20 + (0x20 + var_e)])
    
    mapping(address => bytes32) storage_map_e; // storage slot: 0x02
    mapping(address => bytes) storage_map_g; // storage slot: 0x0a
    mapping(address => address) public unresolved_262ce707; // storage slot: 0x0c
    mapping(address => address) storage_map_u; // storage slot: 0x15
    mapping(address => mapping(uint256 => bytes32)) storage_map_ab; // storage slot: keccak256(memory[0x20 + var_a:0x20 + var_a + (0x20 + var_e)])
    
    event AddOperator(address, address);
    event Event_34250d52();
    event Event_8be0079c();
    event OwnershipProposed(address, address);
    
    /// @custom:selector    0xa5929815
    /// @custom:signature   creatorAt(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function creatorAt(uint256 arg0) public view returns (address) {
        if (arg0 < store_c) {
            return store_c[arg0].field_0;
        }
    }
    
    /// @custom:selector    0x3e30838d
    /// @custom:signature   delOperator(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function delOperator(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        storage_map_e[arg0] = 0x02 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0];
        emit Event_34250d52(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0x0b791430
    /// @custom:signature   events(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function events(uint256 arg0) public view returns (bytes memory) {
        require(arg0 < store_f);
        if ((store_f[arg0] & 0x01) != (store_f[arg0] >> 0x01 < 0x20) && (store_f[arg0] & 0x01) != (store_f[arg0] >> 0x01 < 0x20)) {
            return abi.encodePacked(0x20, var_f);
        }
    }
    
    /// @custom:selector    0xc5099716
    /// @custom:signature   getNftsByCreator(address arg0) public view returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getNftsByCreator(address arg0) public view returns (bytes memory) {
        require(true);
        return abi.encodePacked(0x20, var_g);
    }
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(true);
        return 0x01 == storage_map_e[arg0].field_0;
    }
    
    /// @custom:selector    0x47ccca02
    /// @custom:signature   nft() public view returns (address)
    function nft() public view returns (address) {
        return address(store_h / 0x010000);
    }
    
    /// @custom:selector    0x265aa621
    /// @custom:signature   nfts(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function nfts(uint256 arg0) public view returns (address) {
        require(arg0 < store_i);
        return store_i[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0x13e7c9d8
    /// @custom:signature   operators(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function operators(address arg0) public view returns (bool) {
        require(true);
        return storage_map_e[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0x710bf322
    /// @custom:signature   proposeOwnership(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function proposeOwnership(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        emit OwnershipProposed(unresolved_8da5cb5b, arg0);
        store_l = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_l;
    }
    
    /// @custom:selector    0xfed80d43
    /// @custom:signature   setClaimSigner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setClaimSigner(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_m = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_m;
    }
    
    /// @custom:selector    0xf56e9c66
    /// @custom:signature   setNFT(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setNFT(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_h = store_h & 0xffffffffffffffffffff0000000000000000000000000000000000000000ffff | 0x010000 * arg0;
    }
    
    /// @custom:selector    0x405d8709
    /// @custom:signature   setNFTSinglton(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setNFTSinglton(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "EventHub: invalid nft singleton address");
        store_n = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_n;
    }
    
    /// @custom:selector    0xf798b1ba
    /// @custom:signature   setVaultStrategy(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setVaultStrategy(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_o = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_o;
    }
    
    /// @custom:selector    0xd80528ae
    /// @custom:signature   stats() public view returns (bytes memory)
    function stats() public view returns (bytes memory) {
        return abi.encodePacked(store_c, store_i, store_f);
    }
    
    /// @custom:selector    0x03c72fa3
    /// @custom:signature   Unresolved_03c72fa3(uint256 arg0) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_03c72fa3(uint256 arg0) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if ((store_p & 0x01) != (store_p >> 0x01 < 0x20)) {
            uint256 var_a = var_a + (0x20 + (0x1f + (store_p >> 0x01)) / 0x20 * 0x20);
        }
    }
    
    /// @custom:selector    0x0602ef3e
    /// @custom:signature   Unresolved_0602ef3e(uint256 arg0) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_0602ef3e(uint256 arg0) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if ((store_p & 0x01) != (store_p >> 0x01 < 0x20)) {
            uint256 var_a = var_a + (0x20 + (0x1f + (store_p >> 0x01)) / 0x20 * 0x20);
        }
    }
    
    /// @custom:selector    0x16c38b3c
    /// @custom:signature   Unresolved_16c38b3c(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_16c38b3c(uint256 arg0) public payable {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_m = store_m & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | 0x010000000000000000000000000000000000000000 * arg0;
    }
    
    /// @custom:selector    0x1bcfaa66
    /// @custom:signature   Unresolved_1bcfaa66(uint256 arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_1bcfaa66(uint256 arg0, address arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
    }
    
    /// @custom:selector    0x2306be91
    /// @custom:signature   Unresolved_2306be91(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2306be91(address arg0) public view returns (bool) {
        require(true);
        return store_r == arg0;
    }
    
    /// @custom:selector    0x2f54bf6e
    /// @custom:signature   Unresolved_2f54bf6e(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2f54bf6e(address arg0) public view returns (bool) {
        require(true);
        return arg0 == unresolved_8da5cb5b;
    }
    
    /// @custom:selector    0x30176e13
    /// @custom:signature   Unresolved_30176e13(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_30176e13(uint256 arg0) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if ((baseTokenURI & 0x01) != (baseTokenURI >> 0x01 < 0x20)) {
            baseTokenURI = 0x01 + (msg.data[0x04 + arg0] + msg.data[0x04 + arg0]);
        }
    }
    
    /// @custom:selector    0x37e3daca
    /// @custom:signature   Unresolved_37e3daca(uint256 arg0, address arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_37e3daca(uint256 arg0, address arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x39908734
    /// @custom:signature   Unresolved_39908734(address arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_39908734(address arg0, uint256 arg1, uint256 arg2) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return uint8(store_m / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x5e070a65
    /// @custom:signature   Unresolved_5e070a65(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_5e070a65(uint256 arg0) public view returns (address) {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a | var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff)) {
            return store_t;
        }
    }
    
    /// @custom:selector    0x5e4cae85
    /// @custom:signature   Unresolved_5e4cae85(address arg0) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_5e4cae85(address arg0) public view returns (address) {
        require(true);
        if (!storage_map_u[arg0].field_0) {
            return unresolved_0f8fe56a;
        } else {
            return storage_map_u[arg0].field_0.field_0;
        }
    }
    
    /// @custom:selector    0x73dc4704
    /// @custom:signature   Unresolved_73dc4704(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_73dc4704(uint256 arg0) public view returns (bool) {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a | var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff)) {
            return store_v;
        }
    }
    
    /// @custom:selector    0x79ba5097
    /// @custom:signature   Unresolved_79ba5097() public payable
    function Unresolved_79ba5097() public payable {
        require(msg.sender == store_w, "Ownable: your address is not pendingOwner");
        emit Event_8be0079c(unresolved_8da5cb5b, store_w);
        store_x = store_w | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_x;
        store_l = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_l;
    }
    
    /// @custom:selector    0x7a442a9b
    /// @custom:signature   Unresolved_7a442a9b(uint256 arg0) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_7a442a9b(uint256 arg0) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if ((store_p & 0x01) != (store_p >> 0x01 < 0x20)) {
            uint256 var_a = var_a + (0x20 + (0x1f + (store_p >> 0x01)) / 0x20 * 0x20);
        }
    }
    
    /// @custom:selector    0x81553691
    /// @custom:signature   Unresolved_81553691(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_81553691(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x85535cc5
    /// @custom:signature   Unresolved_85535cc5(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_85535cc5(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_y = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_y;
    }
    
    /// @custom:selector    0x88132f8c
    /// @custom:signature   Unresolved_88132f8c(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_88132f8c(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x9870d7fe
    /// @custom:signature   Unresolved_9870d7fe(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9870d7fe(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (!storage_map_e[arg0].field_0) {
            operatorSize += 0x01;
            store_z = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_z;
        }
        storage_map_e[arg0] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_e[arg0];
        emit AddOperator(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0x9d25094b
    /// @custom:signature   Unresolved_9d25094b(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9d25094b(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xa5599dfe
    /// @custom:signature   Unresolved_a5599dfe(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_a5599dfe(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xb8844b14
    /// @custom:signature   Unresolved_b8844b14(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_b8844b14(uint256 arg0) public view returns (bytes memory) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        uint256 var_b = msg.data[0x04 + arg0 + 0x20:0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]];
        uint256 var_a = 0x20 + (var_a + 0x20 * baseTokenURIa);
        return abi.encodePacked(0x20, var_b);
    }
    
    /// @custom:selector    0xbc4bcb85
    /// @custom:signature   Unresolved_bc4bcb85(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_bc4bcb85(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xbda24140
    /// @custom:signature   Unresolved_bda24140(uint256 arg0, address arg1, uint256 arg2) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_bda24140(uint256 arg0, address arg1, uint256 arg2) public view returns (uint256) {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a | var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(true);
            return storage_map_ab[arg1][arg2];
        }
    }
    
    /// @custom:selector    0xc370e9f4
    /// @custom:signature   Unresolved_c370e9f4(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_c370e9f4(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xcb38f407
    /// @custom:signature   Unresolved_cb38f407(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_cb38f407(uint256 arg0) public view returns (address) {
        require(arg0 < operatorSize);
        return operatorSize[arg0].field_0.field_0;
    }
    
    /// @custom:selector    0xd07c6e69
    /// @custom:signature   Unresolved_d07c6e69(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_d07c6e69(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xe2d3a0a1
    /// @custom:signature   Unresolved_e2d3a0a1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_e2d3a0a1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]);
        if ((baseTokenURIc & 0x01) != (baseTokenURIc >> 0x01 < 0x20)) {
            require(!(baseTokenURIc >> 0x01), "EventHub: already created");
            require(msg.data[0x80 + (0x04 + arg0)] >= msg.data[0x60 + (0x04 + arg0)], "EventHub: invalid start/end time");
            require(msg.data[0x04 + arg0 + 0xa0] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81);
            require(msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + 0x20] < msg.data.length - (msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + 0x20]] <= 0xffffffffffffffff);
            require(0x20 + (msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + 0x20]) <= msg.data.length - (msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + 0x20]] << 0x05));
            require(msg.data[0x04 + arg0 + 0xa0] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81);
            require(msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)] < msg.data.length - (msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)]] <= 0xffffffffffffffff);
            require(0x20 + (msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)]) > msg.data.length - (msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0) + msg.data[msg.data[0x04 + arg0 + 0xa0] + (0x04 + arg0)]] << 0x05), "EventHub: invalid bonus info");
        }
    }
    
    /// @custom:selector    0xe30c3978
    /// @custom:signature   Unresolved_e30c3978() public view returns (address)
    function Unresolved_e30c3978() public view returns (address) {
        return store_w;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        store_x = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_x;
    }
    
    /// @custom:selector    0xf4c44295
    /// @custom:signature   Unresolved_f4c44295(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f4c44295(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xe18cc13b
    /// @custom:signature   vaultStrategy() public view returns (address)
    function vaultStrategy() public view returns (address) {
        return store_r;
    }
}