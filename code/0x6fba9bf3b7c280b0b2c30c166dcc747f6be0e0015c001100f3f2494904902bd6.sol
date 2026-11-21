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
    uint256 public constant BASE_DOMAIN = 6;
    uint256 public constant tokenMessenger = 232410083228790048339504449763962118892241342301;
    uint256 public constant unresolved_3e413bee = 917551056842671309452305380979543736893630245704;
    uint256 public constant unresolved_4a636daf = 100000000;
    uint256 public constant unresolved_f7c3415d = 10000000;
    
    address public unresolved_46904840; // storage slot: 0x00
    address public unresolved_8da5cb5b; // storage slot: 0x01
    bytes32 store_h; // storage slot: 0x01
    address public unresolved_e30c3978; // storage slot: 0x02
    bytes32 store_i; // storage slot: 0x02
    address store_f; // storage slot: 0x03
    bytes32 store_e; // storage slot: 0x03
    bytes store_b; // storage slot: 0x04
    
    mapping(address => uint256) public unresolved_7ecebe00; // storage slot: 0x05
    
    event DestinationCallerUpdated(bytes32, bytes32);
    event Event_8be0079c();
    event FeeRecipientUpdated(address, address);
    event IntentCancelled(address, uint256);
    event OwnershipTransferStarted(address, address);
    event RelayerUpdated(address, address);
    event TokenRescued(address, address, uint256);
    
    /// @custom:selector    0xddefbdb3
    /// @custom:signature   cancelIntent() public payable returns (uint256)
    function cancelIntent() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (unresolved_7ecebe00[msg.sender] <= unresolved_7ecebe00[msg.sender] + 0x01) {
            unresolved_7ecebe00[msg.sender] += 0x01;
            emit IntentCancelled(msg.sender, unresolved_7ecebe00[msg.sender]);
            return ;
        }
    }
    
    /// @custom:selector    0xb04b4f98
    /// @custom:signature   destinationCaller() public view returns (uint256)
    function destinationCaller() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_b;
    }
    
    /// @custom:selector    0x5a9b0b89
    /// @custom:signature   getInfo() public view returns (bytes memory)
    function getInfo() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return abi.encodePacked(0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48, 0x28b5a0e9c621a5badaa536219b3a228c8168cf5d, unresolved_46904840, store_b);
    }
    
    /// @custom:selector    0xe5711e8b
    /// @custom:signature   rescueToken(address arg0, address arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function rescueToken(address arg0, address arg1, uint256 arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(msg.sender == unresolved_8da5cb5b, "Not owner");
        require(arg1, "Invalid recipient");
        require(arg0.code.length, "Not a token");
        if (!(var_f + 0x80 > 0xffffffffffffffff | var_f + 0x80 < var_f)) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(arg1); // call
            if (!ret0.length) {
                if (success) {
                    if (!var_i) {
                        require(0x60 + var_i + 0x20 - 0x80 >= 0x20);
                        require(0x44 - 0x44);
                    }
                } else {
                    require(success, "Rescue failed");
                    emit TokenRescued(arg0, arg1, arg2);
                    return ;
                }
            }
        }
    }
    
    /// @custom:selector    0x6885e238
    /// @custom:signature   setDestinationCaller(bytes32 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setDestinationCaller(bytes32 arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(msg.sender == unresolved_8da5cb5b, "Not owner");
        if (arg0) {
            require(!(arg0 >> 0xa0), "Invalid destination caller");
        } else {
            require(arg0, "Invalid destination caller");
        }
        store_b = arg0;
        emit DestinationCallerUpdated(store_b, arg0);
        return ;
    }
    
    /// @custom:selector    0x6548e9bc
    /// @custom:signature   Unresolved_6548e9bc(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6548e9bc(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == unresolved_8da5cb5b, "Not owner");
        require(arg0, "Invalid relayer");
        store_e = arg0 | store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit RelayerUpdated(store_f, arg0);
        return ;
    }
    
    /// @custom:selector    0x79ba5097
    /// @custom:signature   Unresolved_79ba5097() public payable returns (uint256)
    function Unresolved_79ba5097() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_e30c3978), "Not pending owner");
        store_h = msg.sender | store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        store_i = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
        emit Event_8be0079c(unresolved_8da5cb5b, msg.sender);
        return ;
    }
    
    /// @custom:selector    0x8406c079
    /// @custom:signature   Unresolved_8406c079() public view returns (address)
    function Unresolved_8406c079() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_f;
    }
    
    /// @custom:selector    0xb1f5b084
    /// @custom:signature   Unresolved_b1f5b084(address arg0, uint256 arg1, uint256 arg2, uint32 arg3, uint256 arg4, uint32 arg5, bool arg6, uint256 arg7, uint256 arg8, uint256 arg9) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint32", "bytes4", "int32"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_b1f5b084(address arg0, uint256 arg1, uint256 arg2, uint32 arg3, uint256 arg4, uint32 arg5, bool arg6, uint256 arg7, uint256 arg8, uint256 arg9) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x01a0);
        require(!(arg0 - arg0));
        require(!(arg3 - arg3));
        require(!(arg5 - arg5));
        require(!(arg7 - uint8(arg7)));
        require(arg12 <= 0xffffffffffffffff);
        require(arg12 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg12] <= 0xffffffffffffffff);
        require(arg12 + msg.data[0x04 + arg12] + 0x24 <= msg.data.length);
        require(!(msg.sender - store_f), "Not relayer");
        require(!(arg3 - 0x06), "Not Base");
        require(!(arg4 - arg0), "Not the owner's address");
        require(arg1 >= arg2, "Permit amount < bridge amount");
        require(arg2, "Bridge amount is zero");
        if (arg1 - arg2 <= arg1) {
            require(arg1 - arg2 <= 0x989680, "Wrapper fee exceeds max");
            require(block.timestamp <= arg11, "Intent expired");
            require(!(arg10 - unresolved_7ecebe00[arg0]), "Invalid nonce");
        }
    }
    
    /// @custom:selector    0xe74b981b
    /// @custom:signature   Unresolved_e74b981b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e74b981b(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == unresolved_8da5cb5b, "Not owner");
        require(arg0 != address(this), "Invalid fee recipient");
        unresolved_46904840 = arg0 | unresolved_46904840 & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit FeeRecipientUpdated(unresolved_46904840, arg0);
        return ;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Not owner");
        store_i = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_i;
        emit OwnershipTransferStarted(unresolved_8da5cb5b, arg0);
        return ;
    }
    
    /// @custom:selector    0xf698da25
    /// @custom:signature   Unresolved_f698da25() public view returns (uint256)
    function Unresolved_f698da25() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(var_g + 0xc0 > 0xffffffffffffffff | var_g + 0xc0 < var_g)) {
            uint256 var_g = var_g + 0xc0;
            var_j = keccak256(memory[var_g + 0x20:var_g + 0x20 + var_k]);
            return var_j;
        }
    }
}