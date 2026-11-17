# Review notes: lighter-plonk-verifier (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454.

- Verifier proxy `0xac3ce44b6ff4e402858c99d5699ff63131572baa`: `getTarget()` = `0x329d7d7f7b3f2879991b83e1a53bce6d7ce63e6f`
  (ZkLighterVerifier, verified on Sourcify; creator `0x06ed0b0bd3a9e0c517b6cd7c8b851cc1e8e1a90a`, one of the security
  council owners); `getMaster()` = UpgradeGatekeeper `0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67`.
- `ZkLighterVerifier.Verify(bytes proof, uint256[] public_inputs)` is a gnark PLONK verifier on BN254: the final KZG
  pairing check is `check_pairing_kzg`, `staticcall(gas(), 8, …)` (ZkLighterVerifier.sol lines 901–910); `initialize` and
  `upgrade` are empty.
- Consumer: ZkLighter proxy `0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7` storage slot 4 =
  `0x000…ac3ce44b6ff4e402858c99d5699ff63131572baa`; slot 5 = DesertVerifier `0x975210588389526a3a1def1628e7a4d7abdfd121`.
- DesertVerifier `0x97521058…` (verified on Sourcify, not proxied): another gnark PLONK verifier (26 `staticcall`s,
  including `staticcall(gas(), 8, …)`), used for desert-mode exits. Not in the census (no calls in the trace).
- UpgradeGatekeeper: master Safe `0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2` (3 of 5); security council Safe
  `0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045` (4 of 7) can cut the 3-week (1,814,400 s) notice; `managedContracts` =
  Governance `0xa464da0b…`, this verifier proxy, ZkLighter `0x3b4d794a…`. Details: `evidence/lighter-blob-kzg/notes.md`.
- Escrow: ZkLighter `0x3b4d794a…` held $907,780,551 at block 26,431,214 (11,171.69 ETH; USDC $471.2M, LIT $411.4M,
  XAUT $4.1M, …), from `evidence/lighter-blob-kzg/onchain.json`.

## Follow-up: DesertVerifier `0x975210588389526a3a1def1628e7a4d7abdfd121` (block 26,431,750)

- Verified on Sourcify (`contracts/DesertVerifier.sol`): `Verify(bytes proof, uint256[] public_inputs)` at line 188,
  gnark PLONK, pairing `staticcall(gas(), 8, …)` at line 904; `initialize`/`upgrade` empty.
- EIP-1967 implementation and admin slots are zero; `owner()` reverts; `getTarget()`/`getMaster()` revert (not a proxy).
- Created at block 26,320,128 by `0x06ed0b0bd3a9e0c517b6cd7c8b851cc1e8e1a90a` (a security council owner).
- ZkLighter `0x3b4d794a…` storage slot 5 = `0x…975210588389526a3a1def1628e7a4d7abdfd121`.
- `trace_filter` blocks 23,803,750–26,431,750 (`desertverifier-trace.json`): no calls.
