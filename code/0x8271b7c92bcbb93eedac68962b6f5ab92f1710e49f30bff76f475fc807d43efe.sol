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
    address public unresolved_8da5cb5b; // storage slot: 0x34
    bytes32 store_s; // storage slot: 0x34
    address public uln; // storage slot: 0x66
    address public unresolved_741bef1a; // storage slot: 0x6d
    bytes32 store_l; // storage slot: 0x6e
    uint128 store_h; // storage slot: 0x6e
    bytes store_e; // storage slot: 0x71
    bytes32 store_i; // storage slot: 0x73
    uint64 store_m; // storage slot: 0x73
    bytes32 store_t; // storage slot: 0x76
    uint64 public allowlistSize; // storage slot: 0x76
    
    mapping(address => bytes32) storage_map_k; // storage slot: 0x67
    mapping(address => bytes32) storage_map_q; // storage slot: 0x68
    mapping(address => bytes32) storage_map_r; // storage slot: 0x69
    mapping(uint16 => bytes) storage_map_g; // storage slot: 0x6a
    mapping(uint16 => mapping(uint256 => mapping(uint256 => mapping(uint256 => bytes32)))) storage_map_o; // storage slot: 0x6c
    mapping(address => bytes32) storage_map_n; // storage slot: 0x6f
    mapping(uint256 => uint8) storage_map_u; // storage slot: 0x70
    mapping(address => bytes32) storage_map_p; // storage slot: 0x72
    mapping(address => bytes32) storage_map_a; // storage slot: 0x74
    mapping(address => bytes32) storage_map_c; // storage slot: 0x75
    
    event AdminUpdated(address, bool);
    event Event_14b979ba();
    event Event_8be0079c();
    event SetUln(address, bool);
    event ThresholdUpdated(uint16);
    event UpdateAdmin(address, bool);
    event UpdateAllowlist(address, bool);
    event UpdateDenylist(address, bool);
    event UpdatePriceFeed(address);
    event UpdatePriceMultiplierBps(uint128);
    event UpdateQuorum(uint64);
    event UpdateSigner(address, bool);
    event ValidatorUpdated(address, bool);
    event WhitelistUpdated(address, bool);
    
    /// @custom:selector    0xa7cd52cb
    /// @custom:signature   allowlist(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function allowlist(address arg0) public view returns (bool) {
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0x57d3a786
    /// @custom:signature   checkPermission(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function checkPermission(address arg0) public view returns (bool) {
        require(true);
        if (!storage_map_c[arg0].field_0) {
            if (!storage_map_a[arg0].field_0) {
                if (!allowlistSize) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return true;
            }
        } else {
            return false;
        }
    }
    
    /// @custom:selector    0x9cf4364b
    /// @custom:signature   committeeSize() public view returns (uint16)
    function committeeSize() public view returns (uint16) {
        return uint16(uln / 0x0100000000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x31d26094
    /// @custom:signature   committeeStatus() public view returns (bytes memory)
    function committeeStatus() public view returns (bytes memory) {
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        return abi.encodePacked(uint16(uln / 0x0100000000000000000000000000000000000000000000), uint16(uln / 0x010000000000000000000000000000000000000000));
    }
    
    /// @custom:selector    0x3371bfff
    /// @custom:signature   denylist(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function denylist(address arg0) public view returns (bool) {
        require(true);
        return storage_map_c[arg0].field_0;
    }
    
    /// @custom:selector    0x765a8a54
    /// @custom:signature   dstPriceLookup(uint16 arg0) public payable returns (bytes memory)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function dstPriceLookup(uint16 arg0) public payable returns (bytes memory) {
        require(true);
        require(unresolved_741bef1a.code.length);
        (bool success, bytes memory ret0) = address(unresolved_741bef1a).Unresolved_e0ad121a(arg0); // staticcall
        require(success);
        uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_a + ret0.length - var_a >= 0x60);
        if (!(var_a + 0x60 > 0xffffffffffffffff | var_a + 0x60 < var_a)) {
            require(var_f == uint128(var_f));
            require(var_h == uint64(var_h));
            require(var_j == uint32(var_j));
            return abi.encodePacked(uint128(var_f), uint128(var_n));
        }
    }
    
    /// @custom:selector    0x8644c578
    /// @custom:signature   dstPriceLookupOld(uint16 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function dstPriceLookupOld(uint16 arg0) public view returns (bytes memory) {
        require(true);
        return abi.encodePacked(storage_map_g[arg0].field_0.field_0, uint128(storage_map_g[arg0] / 0x0100000000000000000000000000000000));
    }
    
    /// @custom:selector    0x673448dd
    /// @custom:signature   isApproved(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isApproved(address arg0) public view returns (bool) {
        require(true);
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        return address(this) == arg0;
    }
    
    /// @custom:selector    0xac353e04
    /// @custom:signature   multiplierBps() public view returns (address)
    function multiplierBps() public view returns (address) {
        return store_h;
    }
    
    /// @custom:selector    0x1703a018
    /// @custom:signature   quorum() public view returns (uint64)
    function quorum() public view returns (uint64) {
        return uint64(store_i / 0x010000000000000000);
    }
    
    /// @custom:selector    0x724e78da
    /// @custom:signature   setPriceFeed(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setPriceFeed(address arg0) public payable {
        require(true);
        if (unresolved_8da5cb5b != msg.sender) {
            require(storage_map_k[msg.sender].field_0, "Oracle: not admin");
        }
        unresolved_741bef1a = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & unresolved_741bef1a;
        emit UpdatePriceFeed(arg0);
    }
    
    /// @custom:selector    0xc3b04e7f
    /// @custom:signature   setPriceMultiplierBps(uint128 arg0) public payable
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    function setPriceMultiplierBps(uint128 arg0) public payable {
        require(arg0 == uint128(arg0));
        if (unresolved_8da5cb5b != msg.sender) {
            require(storage_map_k[msg.sender].field_0, "Oracle: not admin");
        }
        store_l = uint128(arg0) | 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 & store_l;
        emit UpdatePriceMultiplierBps(uint128(arg0));
    }
    
    /// @custom:selector    0x8585c945
    /// @custom:signature   setQuorum(uint64 arg0) public payable
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function setQuorum(uint64 arg0) public payable {
        require(true);
        require(msg.sender == address(this), "MultiSigOracle: caller must be self");
        require(uint8(store_e / 0x01000000000000), "Oracle: not implemented");
        if (arg0 > store_m) {
            require(arg0 <= store_m, "MultiSig: invalid quorum");
        } else {
            require(arg0 > 0, "MultiSig: invalid quorum");
        }
        store_i = arg0 * 0x010000000000000000 | 0xffffffffffffffffffffffffffffffff0000000000000000ffffffffffffffff & store_i;
        emit UpdateQuorum(arg0);
    }
    
    /// @custom:selector    0x793e6410
    /// @custom:signature   setThreshold(uint16 arg0) public payable
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function setThreshold(uint16 arg0) public payable {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        require(arg0 <= uint16(uln / 0x0100000000000000000000000000000000000000000000), "Oracle: threshold > committee size");
        uln = arg0 * 0x010000000000000000000000000000000000000000 | 0xffffffffffffffffffff0000ffffffffffffffffffffffffffffffffffffffff & uln;
        emit ThresholdUpdated(arg0);
    }
    
    /// @custom:selector    0xfd62e750
    /// @custom:signature   signerSize() public view returns (uint64)
    function signerSize() public view returns (uint64) {
        return store_m;
    }
    
    /// @custom:selector    0x9f0707f0
    /// @custom:signature   ulns(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function ulns(address arg0) public view returns (bool) {
        require(true);
        return storage_map_n[arg0].field_0;
    }
    
    /// @custom:selector    0x01e33667
    /// @custom:signature   Unresolved_01e33667(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_01e33667(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x057f01b5
    /// @custom:signature   Unresolved_057f01b5() public view returns (bool)
    function Unresolved_057f01b5() public view returns (bool) {
        return uint8(store_e / 0x01000000000000);
    }
    
    /// @custom:selector    0x09310452
    /// @custom:signature   Unresolved_09310452(uint16 arg0) public pure
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function Unresolved_09310452(uint16 arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x1c3ca45b
    /// @custom:signature   Unresolved_1c3ca45b(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_1c3ca45b(uint256 arg0) public payable {
        if (unresolved_8da5cb5b != msg.sender) {
            require(storage_map_k[msg.sender].field_0, "Oracle: not admin");
        }
        store_e = store_e & 0xffffffffffffffffffffffffffffffffffffffffffffffffff00ffffffffffff | 0x01000000000000 * arg0;
    }
    
    /// @custom:selector    0x2f1be651
    /// @custom:signature   Unresolved_2f1be651(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bool)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_2f1be651(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bool) {
        require(true);
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        return uint8(storage_map_o[arg0][arg1][arg2][arg3] / 0x010000);
    }
    
    /// @custom:selector    0x31cb6105
    /// @custom:signature   Unresolved_31cb6105(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_31cb6105(address arg0, uint256 arg1) public payable {
        if (msg.data.length - 0x04 >= 0x40) {
            require(msg.sender == address(this), "MultiSigOracle: caller must be self");
            require(uint8(store_e / 0x01000000000000), "Oracle: not implemented");
            require(arg1 != storage_map_p[arg0].field_0, "MultiSig: signer already in that state");
            storage_map_p[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_p[arg0];
            store_i = uint64(0x01 + store_m) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_i;
            require(uint64(uint64(0x01 + store_m) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_i) >= uint64((uint64(0x01 + store_m) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_i) / 0x010000000000000000), "MultiSig: committee size < threshold");
            emit UpdateSigner(arg0, arg1);
        }
        revert();
    }
    
    /// @custom:selector    0x321ab8ad
    /// @custom:signature   Unresolved_321ab8ad() public view returns (uint16)
    function Unresolved_321ab8ad() public view returns (uint16) {
        return uint16(store_e / 0x010000);
    }
    
    /// @custom:selector    0x429b62e5
    /// @custom:signature   Unresolved_429b62e5(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_429b62e5(address arg0) public view returns (bool) {
        require(true);
        return storage_map_k[arg0].field_0;
    }
    
    /// @custom:selector    0x42cde4e8
    /// @custom:signature   Unresolved_42cde4e8() public view returns (uint16)
    function Unresolved_42cde4e8() public view returns (uint16) {
        return uint16(uln / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x4623c91d
    /// @custom:signature   Unresolved_4623c91d(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4623c91d(address arg0, uint256 arg1) public payable {
        if (msg.data.length - 0x04 >= 0x40) {
            require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
            require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
            require(arg1 != storage_map_q[arg0].field_0, "Oracle: validator already in that state");
            storage_map_q[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_q[arg0];
            uln = uln & 0xffffffffffffffff0000ffffffffffffffffffffffffffffffffffffffffffff | uint16(uint16(uln / 0x0100000000000000000000000000000000000000000000) + 0x01) * 0x0100000000000000000000000000000000000000000000;
            require(uint16(uln / 0x0100000000000000000000000000000000000000000000) >= uint16(uln / 0x010000000000000000000000000000000000000000), "Oracle: committee size < threshold");
            emit ValidatorUpdated(arg0, arg1);
        }
        revert();
    }
    
    /// @custom:selector    0x46f83b50
    /// @custom:signature   Unresolved_46f83b50(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_46f83b50(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(true);
        require(storage_map_q[msg.sender].field_0, "Oracle: not validator");
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        require(!uint8(storage_map_o[arg0][arg1][arg2][arg3] / 0x010000), "Oracle: already submitted");
        require(!storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_0, "Oracle: already approved block");
        if (uint16(uln / 0x010000000000000000000000000000000000000000) != uint16(storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_0 + 0x01)) {
            storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_1[msg.sender] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_1[msg.sender];
            storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_1[msg.sender] = uint16(storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_1[msg.sender].field_0 + 0x01) | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000 & storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender].field_1[msg.sender];
        } else {
            require(uln.code.length);
            (bool success, bytes memory ret0) = address(uln).Unresolved_704316e5{ value: 0 }(arg0, arg1, arg2, arg3); // call
            require(success);
            storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender] = 0x010000 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff & storage_map_o[arg0][arg1][arg2][arg3].field_1[msg.sender];
        }
        emit Event_14b979ba(msg.sender, arg0, arg1, arg2, arg3);
    }
    
    /// @custom:selector    0x485cc955
    /// @custom:signature   Unresolved_485cc955(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_485cc955(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x4b0bddd2
    /// @custom:signature   Unresolved_4b0bddd2(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4b0bddd2(address arg0, uint256 arg1) public payable {
        if (msg.data.length - 0x04 >= 0x40) {
            require(storage_map_k[msg.sender].field_0, "Oracle: not admin");
            if (!uint8(store_e / 0x01000000000000)) {
                storage_map_k[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[arg0];
                emit AdminUpdated(arg0, arg1);
            } else {
                require(arg1 != storage_map_k[arg0].field_0, "MultiSigOracle: admin already in that state");
                storage_map_k[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_k[arg0];
                emit UpdateAdmin(arg0, arg1);
            }
        }
        revert();
    }
    
    /// @custom:selector    0x53d6fd59
    /// @custom:signature   Unresolved_53d6fd59(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_53d6fd59(address arg0, uint256 arg1) public payable {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        storage_map_r[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_r[arg0];
        emit WhitelistUpdated(arg0, arg1);
    }
    
    /// @custom:selector    0x5553fb8e
    /// @custom:signature   Unresolved_5553fb8e(uint16 arg0) public pure
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function Unresolved_5553fb8e(uint16 arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x6200d8cd
    /// @custom:signature   Unresolved_6200d8cd() public view returns (uint16)
    function Unresolved_6200d8cd() public view returns (uint16) {
        return store_e;
    }
    
    /// @custom:selector    0x6c459a28
    /// @custom:signature   Unresolved_6c459a28(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_6c459a28(address arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg3 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x70cb3acb
    /// @custom:signature   Unresolved_70cb3acb(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_70cb3acb(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
        store_s = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
    }
    
    /// @custom:selector    0x736c0d5b
    /// @custom:signature   Unresolved_736c0d5b(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_736c0d5b(address arg0) public view returns (bool) {
        require(true);
        return storage_map_p[arg0].field_0;
    }
    
    /// @custom:selector    0x780a00bb
    /// @custom:signature   Unresolved_780a00bb(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_780a00bb(address arg0, uint256 arg1) public payable {
        require(true);
        require(msg.sender == address(this), "MultiSigOracle: caller must be self");
        require(uint8(store_e / 0x01000000000000), "Oracle: not implemented");
        require(arg1 != storage_map_n[arg0].field_0, "MultiSigOracle: uln already in that state");
        storage_map_n[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_n[arg0];
        emit SetUln(arg0, arg1);
    }
    
    /// @custom:selector    0x8fc8684d
    /// @custom:signature   Unresolved_8fc8684d(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_8fc8684d(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x9b19251a
    /// @custom:signature   Unresolved_9b19251a(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9b19251a(address arg0) public view returns (bool) {
        require(true);
        return storage_map_r[arg0].field_0;
    }
    
    /// @custom:selector    0xabf785b2
    /// @custom:signature   Unresolved_abf785b2(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4) public view returns (bool)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_abf785b2(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4) public view returns (bool) {
        require(true);
        require(true);
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        if (!uint8(storage_map_o[arg0][arg1][arg2][arg3] / 0x010000)) {
            return storage_map_o[arg0][arg1][arg2][arg3].field_1[arg4].field_0;
        } else {
            return true;
        }
    }
    
    /// @custom:selector    0xb12527f8
    /// @custom:signature   Unresolved_b12527f8(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_b12527f8(address arg0, uint256 arg1) public payable {
        require(true);
        require(msg.sender == address(this), "MultiSigOracle: caller must be self");
        require(uint8(store_e / 0x01000000000000), "Oracle: not implemented");
        require(arg1 != storage_map_a[arg0].field_0, "AccessControl: address already in that state");
        storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
        if (arg1) {
            store_t = uint64(0x01 + allowlistSize) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_t;
        } else {
            store_t = uint64(type(uint256).max + allowlistSize) | 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 & store_t;
        }
        emit UpdateAllowlist(arg0, arg1);
    }
    
    /// @custom:selector    0xb8f8bad4
    /// @custom:signature   Unresolved_b8f8bad4(uint16 arg0, address arg1) public pure
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_b8f8bad4(uint16 arg0, address arg1) public pure {
        require(true);
        require(arg1 == uint128(arg1));
    }
    
    /// @custom:selector    0xc5e193cd
    /// @custom:signature   Unresolved_c5e193cd(uint16 arg0) public pure
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function Unresolved_c5e193cd(uint16 arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xc76ae8e7
    /// @custom:signature   Unresolved_c76ae8e7(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bool)
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_c76ae8e7(uint16 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view returns (bool) {
        require(true);
        return abi.encodePacked(storage_map_o[arg0][arg1][arg2][arg3].field_0.field_0, uint8(storage_map_o[arg0][arg1][arg2][arg3] / 0x010000));
    }
    
    /// @custom:selector    0xc7a823e0
    /// @custom:signature   Unresolved_c7a823e0(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_c7a823e0(uint256 arg0, uint256 arg1) public payable {
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        if (uint64(store_i / 0x010000000000000000)) {
            require(0x41 * uint64(store_i / 0x010000000000000000) / uint64(store_i / 0x010000000000000000) == 0x41, "SafeMath: multiplication overflow");
            require(msg.data[0x04 + arg1] >= 0x41 * uint64(store_i / 0x010000000000000000), "MultiSig: signatures too short");
            if (0 < uint64(store_i / 0x010000000000000000)) {
                uint256 var_d = 0x20 + var_d;
                address var_p = ecrecover(keccak256(memory[0x20 + var_d:0x20 + var_d + var_i]), uint8(var_k), var_m, var_o);
                require(memory[0x20]);
                if (address(var_p) > 0) {
                    revert("MultiSig: signature is not from a signer");
                } else {
                    revert("MultiSig: signatures must be in ascending order");
                }
            }
        }
    }
    
    /// @custom:selector    0xe3a0fd8b
    /// @custom:signature   Unresolved_e3a0fd8b(uint16 arg0) public pure
    /// @param              arg0 ["uint16", "bytes2", "int16"]
    function Unresolved_e3a0fd8b(uint16 arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xea19a063
    /// @custom:signature   Unresolved_ea19a063() public view returns (uint16)
    function Unresolved_ea19a063() public view returns (uint16) {
        return uint16(store_e / 0x0100000000);
    }
    
    /// @custom:selector    0xf2d7e2b6
    /// @custom:signature   Unresolved_f2d7e2b6() public view returns (uint16)
    function Unresolved_f2d7e2b6() public view returns (uint16) {
        return uint16(store_l / 0x0100000000000000000000000000000000);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(true);
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
        store_s = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_s;
    }
    
    /// @custom:selector    0xf3ad31f4
    /// @custom:signature   Unresolved_f3ad31f4(address arg0, uint256 arg1, uint256 arg2) public pure returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_f3ad31f4(address arg0, uint256 arg1, uint256 arg2) public pure returns (uint256) {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        uint256 var_c = 0x34 + (msg.data[0x04 + arg1] + (0x20 + var_c));
        return keccak256(memory[0x20 + var_c:0x20 + var_c + var_g]);
    }
    
    /// @custom:selector    0xf553ccc9
    /// @custom:signature   Unresolved_f553ccc9(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f553ccc9(address arg0, uint256 arg1) public payable {
        require(true);
        require(msg.sender == address(this), "MultiSigOracle: caller must be self");
        require(uint8(store_e / 0x01000000000000), "Oracle: not implemented");
        require(arg1 != storage_map_c[arg0].field_0, "AccessControl: address already in that state");
        storage_map_c[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_c[arg0];
        emit UpdateDenylist(arg0, arg1);
    }
    
    /// @custom:selector    0xfa52c7d8
    /// @custom:signature   Unresolved_fa52c7d8(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_fa52c7d8(address arg0) public view returns (bool) {
        require(true);
        return storage_map_q[arg0].field_0;
    }
    
    /// @custom:selector    0xaef18bf7
    /// @custom:signature   usedHashes(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function usedHashes(bytes32 arg0) public view returns (bool) {
        return storage_map_u[arg0].field_0;
    }
    
    /// @custom:selector    0xfd9be522
    /// @custom:signature   withdrawFee(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function withdrawFee(address arg0, uint256 arg1) public payable {
        require(true);
        require(storage_map_k[msg.sender].field_0, "Oracle: not admin");
        require(!uint8(store_e / 0x01000000000000), "MultiSigOracle: deprecated");
        require(uln.code.length);
        (bool success, bytes memory ret0) = address(uln).Unresolved_07b18bde{ value: 0 }(arg0); // call
        require(success);
    }
}