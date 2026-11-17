# Bytecode and trace reads: unidentified-380ff867-signer-key

Contract `0x380ff86716cf5911b1d770ed53b74e524a8e5e25` (4,683 bytes; not verified on Sourcify or Blockscout; created by
`MinimalCreateDeployer` `0x1512ea5e681a100f3ba1a1f3acd1625c9d22ea0a`, creation tx
`0x5de8600c212fd846b7c44b12d9b002edb22f5d08dd6333ef01b07c101136296d`). Read 2026-11-17.

## State (latest, block 26,431,591)

| Read | Value |
|---|---|
| `signer()` | `0xdbea7a7950539f59acf8ffe1980a4e3f65334b14` (no code) |
| `operator()` | `0x5db8606f2927e7173b3cab5a4c512d9f00bbf193` |
| `owner()` | Safe `0x9287b8e84d972dd02f618bbed45b9a6d7ed16384` (3 of 5 at block 26,431,214) |
| `paused()` | false |

## Entry point (`cast disassemble`)

Selector `0x0db39b93(Call[] calls, uint256 nonce, uint256 deadline, bytes sigA, bytes sigB)` (names of the two
uint256 fields inferred from the decoded values). The routine at `0x0b76`–`0x0c16`: flips the nonce bit in a bitmap
(slot 4) and reverts if it was already used; builds an EIP-712 struct over `chainid`, `CALLER`, the two uint256
values, `address(this)` and the calls hash; then calls the shared OpenZeppelin `ECDSA` recover routine (s-bound
`0x7fff…5d576e7357a4501ddfe92f46681b20a0`, `STATICCALL` to `0x01` at `0x0d33`) twice: first against the address in
slot 1 (`signer()`), then against `CALLER`. Either mismatch reverts with `InvalidSignature()` (`0x8baa579f`).

## Traces (`debug_traceTransaction`, callTracer, eth.drpc.org)

| Tx | Block | Status | What happened |
|---|---|---|---|
| `0x14f53e2868d237e4b17ecd139de8ec046861886692fc3e67002424e67f8b45d2` | 24,883,673 | success | EOA `0x6a669e08…` (7702-delegated) calls itself (`0x9265bb9d`); its code calls `0x380ff867.0x0db39b93`; recover #1 = `0xdbea7a79…` (`signer()`), recover #2 = `0x6a669e08…` (the caller); the EOA then executes the calls (USDT approve, swap through router `0xbc1d9760…`) |
| `0x3d51d62e8dfef36ad64549531588dd3bf0740b98b2c689680d65081a0251eeab` | 24,883,655 | success | Same pattern, relayed by `0x60e97ca8…` to EOA `0x78ace9b2…`; two recoveries; USDC swap |
| `0xfdb0b10cbdfc9f0060cc6078c22ac0534bcbc7d120faa342e183ddda9abf0d4f` | 26,403,470 | reverted | First recovery gives `0xd0b0e344…` ≠ `signer()`, `InvalidSignature()` |

## Activity (Xatu call frames, `data/activity/raw/tr`, blocks 24,700,000–26,423,999)

60,627 transactions reached the contract: about 16–17k per 50,000 blocks until block ~24,884,000 (April 2026), then 10
in total, the sampled ones reverted. The EOAs seen now delegate to `0x490aac77c960b0569c8e446ac7e12490bd44ca1d`
(623 EOAs in `docs/lookup/families.json`).
