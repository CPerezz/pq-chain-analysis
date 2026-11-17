# Review reads (Review15, 2026-11-17)

Proxy `0x25ab3efd52e6470681ce037cd546dc60726948d3` (ProxyToMeson, verified on Sourcify as `contracts/Flattened.sol`,
which also contains the original `UpgradableMeson` implementation deployed by its constructor).

## Storage (RPC eth.drpc.org, block 26,431,608)

| Read | Result |
|---|---|
| EIP-1967 implementation slot (publicnode, block 26,431,550) | `0xf7dace615099950410bd07f52427a0448429518a` (unverified) |
| EIP-1967 admin slot | 0 (UUPS: `_authorizeUpgrade` is `onlyOwner`) |
| slot 308 (`MesonManager._owner`, layout computed from the verified source) | `0x000039ddcf1f63cf3555e62a8d32a11bd1e7e1e1` (EOA, nonce 237; also the proxy's deployer per Blockscout) |
| slot 309 (`_premiumManager`) | `0x666d6b8a44d226150ca9058beebafe0e3ac065a2` (23 bytes of code: an EIP-7702 delegated EOA, nonce 161,230) |
| `ownerOfPool(1)` | `0x0014eb4ac6dd1473b258d088e6ef214b2bcdc53c` (EOA) |

Layout: Initializable (slot 0), two OZ `__gap[50]` (1–100), MesonTokens (101–152), MesonStates (153–205), MesonSwap
(206–256), MesonPools (257–307), MesonManager `_owner` 308, `_premiumManager` 309.

## Current implementation bytecode (20,195 bytes)

Dispatcher selectors resolved with openchain.xyz include `postSwapWithSignature(uint256,bytes32,bytes32,address,uint40)`,
`postSwap(uint256,address,uint40)`, `postSwapFromInitiator(uint256,uint200)`, `lock(uint256,bytes32,bytes32,address)`,
`release(uint256,bytes32,bytes32,address,address)`, `executeSwap(uint256,bytes32,bytes32,address,bool)`,
`directSwap(uint256,address,bytes32,bytes32)`, `directRelease(uint256,bytes32,bytes32,address,address)`,
`upgradeTo(address)`, `transferOwnership(address)`. Signatures are `(r, yParityAndS)`, 64 bytes. Five `STATICCALL`s to
precompile `0x01`; the ERC-1271 selector `0x1626ba7e` does not occur.
