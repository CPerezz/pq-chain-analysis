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
    uint256 public constant proxiableUUID = e07c8dba;
    bytes public constant unresolved_ad3cb1cc = 0xBytes([53, 46, 48, 46, 48]);
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_f; // storage slot: 0x00
    address public unresolved_84acd1bb; // storage slot: 0x01
    address public transceiver; // storage slot: 0x02
    uint256 public emitterAddress; // storage slot: 0x03
    uint256 public authorizedRelayerCount; // storage slot: 0x06
    bytes32 store_g; // storage slot: 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    
    mapping(uint256 => uint8) storage_map_i; // storage slot: 0x04
    mapping(address => bytes32) storage_map_a; // storage slot: 0x05
    
    error CustomError_00000000();
    event Event_5c17e096();
    event Event_bc7cd75a();
    event RelayerAuthorized(address, bool);
    event Swept(address, uint256);
    
    /// @custom:selector    0xcfad9ca8
    /// @custom:signature   authorizedRelayer(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function authorizedRelayer(address arg0) public view returns (bool) {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(true);
        return storage_map_a[arg0].field_0;
    }
    
    /// @custom:selector    0x6ea056a9
    /// @custom:signature   sweep(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function sweep(address arg0, uint256 arg1) public {
        if (!msg.value && 0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40) {
            require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
            payable(address(arg0)).transfer(arg1);
            require(success, CustomError_f4b3b1bc());
            emit Swept(arg0, arg1);
        }
        revert();
    }
    
    /// @custom:selector    0x13af4035
    /// @custom:signature   Unresolved_13af4035(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_13af4035(address arg0) public {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        store_f = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
    }
    
    /// @custom:selector    0x485cc955
    /// @custom:signature   Unresolved_485cc955(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_485cc955(address arg0) public pure {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40);
        require(true);
    }
    
    /// @custom:selector    0x4f1ef286
    /// @custom:signature   Unresolved_4f1ef286(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4f1ef286(address arg0, uint256 arg1) public payable {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40);
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(0x04 + arg1 + 0x1f < 0x04 + (msg.data.length - 0x04));
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_a + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a)) {
            uint256 var_a = var_a + ((msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] <= 0x04 + (msg.data.length - 0x04));
            require(address(this) == 0xe764b4d69465455a4fead62c0a6937bec8323c3f, CustomError_e07c8dba());
            require(address(this) != 0xe764b4d69465455a4fead62c0a6937bec8323c3f, CustomError_e07c8dba());
            require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
            (bool success, bytes memory ret0) = address(arg0).proxiableUUID(); // staticcall
            if (!success) {
                require(success, CustomError_4c9c8ce3());
                require(var_a == 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, CustomError_aa1d49a4());
                require(address(0x0648).code.length, CustomError_4c9c8ce3());
                store_g = 0x0648 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_g;
                emit Event_bc7cd75a(0x0648);
                if (var_e <= 0) {
                    require(msg.value <= 0, CustomError_b398979f());
                } else {
                    (bool success, bytes memory ret0) = address(0x0648).Unresolved_(memory[arg0 + 0x20:arg0 + 0x20 + var_e]); // delegatecall
                    if (!success) {
                        if (!success) {
                            require(!success, CustomError_9996b315());
                            require(ret0.length > 0, CustomError_d6bda275());
                        } else {
                            uint256 var_a = var_a + (0x20 + ret0.length);
                        }
                    }
                }
            } else {
                uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_a + ret0.length - var_a >= 0x20);
                require(var_g == 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, CustomError_aa1d49a4());
                require(arg0.code.length, CustomError_4c9c8ce3());
                store_g = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_g;
                emit Event_bc7cd75a(arg0);
                if (var_g <= 0) {
                    require(msg.value <= 0, CustomError_b398979f());
                } else {
                    (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_a + 0x20:var_a + 0x20 + var_g]); // delegatecall
                    if (!success) {
                        if (!success) {
                            require(!success, CustomError_9996b315());
                            require(ret0.length > 0, CustomError_d6bda275());
                        } else {
                            uint256 var_a = var_a + (0x20 + ret0.length);
                        }
                    }
                }
                revert CustomError_4c9c8ce3();
            }
        }
    }
    
    /// @custom:selector    0x6455cbd7
    /// @custom:signature   Unresolved_6455cbd7(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_6455cbd7(uint256 arg0, uint256 arg1) public pure {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x1f < 0x04 + (msg.data.length - 0x04));
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] <= 0x04 + (msg.data.length - 0x04));
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x9011e5f9
    /// @custom:signature   Unresolved_9011e5f9(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9011e5f9(address arg0, uint256 arg1) public {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x40);
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        if (storage_map_a[arg0].field_0 - arg1) {
            storage_map_a[arg0] = arg1 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_a[arg0];
            if (arg1) {
                if (authorizedRelayerCount - type(uint256).max) {
                    authorizedRelayerCount += 0x01;
                    emit RelayerAuthorized(arg0, arg1);
                }
            } else {
                if (authorizedRelayerCount) {
                    authorizedRelayerCount -= 0x01;
                    emit RelayerAuthorized(arg0, arg1);
                }
            }
        }
    }
    
    /// @custom:selector    0xbe279715
    /// @custom:signature   Unresolved_be279715(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_be279715(uint256 arg0) public {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        require(msg.sender == unresolved_8da5cb5b, CustomError_30cd7471());
        emitterAddress = arg0;
        emit Event_5c17e096(arg0);
    }
    
    /// @custom:selector    0xc1f0808a
    /// @custom:signature   Unresolved_c1f0808a(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_c1f0808a(uint256 arg0) public view returns (bool) {
        require(0x04 + (msg.data.length - 0x04) - 0x04 >= 0x20);
        return storage_map_i[arg0].field_0;
    }
}