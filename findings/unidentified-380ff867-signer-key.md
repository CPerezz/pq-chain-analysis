---
id: unidentified-380ff867-signer-key
title: "Unidentified 7702 execution cosigner (0x380ff867): its service ECDSA key only cosigns, and each execution also needs the delegated EOA's own signature, so forging the service key takes nothing; not affected beyond the account's own key"
project: unidentified-380ff867
status: not-affected
severity: NONE
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: none
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0x380ff86716cf5911b1d770ed53b74e524a8e5e25"
  implementation: null
  name: unverified execution cosigner (selector 0x0db39b93; signer(), operator(), isNonceUsed)
  upgradeable: config-only
  admin: owner Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 (3 of 5 at block 26,431,214; setSigner, setOperator, pause); signer 0xdbea7a7950539f59acf8ffe1980a4e3f65334b14, operator 0x5db8606f2927e7173b3cab5a4c512d9f00bbf193 (read at block 26,431,591)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: 1
families: []
fix:
  layer: none
  who_acts: none needed; owner Safe 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 can rotate or pause the cosigner
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-380ff867-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families df9b0d74"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

`0x380ff867…` is called from the delegated code of EIP-7702 EOAs before they execute a batch of calls. It requires two
ECDSA signatures over the same EIP-712 digest: one from a service key (`signer()`) and one from the calling EOA itself
(`msg.sender`). A CRQC holder who recovers the service key still cannot execute anything from a user's EOA without
that EOA's key, and the EOA's key controls the account anyway. So there is no exposure beyond the account's own key:
NONE. The path has been dormant since 2026-04-15; the later calls seen revert. The deploying project was not
identified.

## Mechanism

- `0x0db39b93(Call[] calls, uint256, uint256, bytes sigA, bytes sigB)`: marks the nonce used in a bitmap (reverts on
  reuse), hashes `chainid`, `msg.sender`, the two uint256 values, `address(this)` and the calls under EIP-712, then
  requires OpenZeppelin `ECDSA` recovery of `sigA` to equal `signer()` and of `sigB` to equal `msg.sender`; otherwise
  `InvalidSignature()`.
- The caller is the EOA's delegated code; after the check returns, that code executes the calls (approve, swaps).
- Pattern PQ-4 in form (one service key), but the service key is a cosigner, not an authority on its own.
- Read from bytecode and traces: [`bytecode-and-traces.md`](#bytecode-and-trace-reads-unidentified-380ff867-signer-key).

## Evidence

- CHECKED (bytecode, `cast selectors`/`cast disassemble`, 2026-11-17): the double recovery against slot 1 (`signer()`)
  and `CALLER`, and the nonce bitmap. Not verified on Sourcify or Blockscout; `evidence.level` stays `bytecode`.
- CHECKED (traces of two successful transactions at blocks 24,883,655 and 24,883,673): the two recoveries return
  `signer()` `0xdbea7a79…` and the calling EOA; then the EOA executes its calls. A reverted call at block 26,403,470
  fails on the first recovery.
- CHECKED (on-chain reads at block 26,431,591): `signer()`, `operator()`, `owner()` = Safe `0x9287b8e8…`, not paused;
  Safe threshold 3 of 5 and no holdings at block 26,431,214 ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-380ff867-signer-key/onchain.json)).
- CHECKED (Xatu call frames, blocks 24,700,000–26,423,999): 60,627 transactions, all but 10 before block ~24,884,000;
  1 in 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-380ff867-signer-key/activity.json)). The
  precompile trace counts 231,883 transactions with an `ecrecover` call in the year to March 2026 (`txs_y1`).
- INFERRED: the delegated code always calls this check before executing (seen in every sampled transaction; the
  delegate `0xa845c743…`/`0x490aac77…` code was not read). Deployer and project not identified (created through a
  `MinimalCreateDeployer` `0x1512ea5e…`; delegate and router unverified).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x380ff867…` unverified execution cosigner | config-only | — | 2026-11-13 (reverted) | 1 |

The contract holds nothing. The users' EOAs hold their own funds, reachable only with their own keys. The yearly
`usd_tx_y1` figure (USD 854M) is the value moved in those users' transactions, not value the service key controls.

## Remediation

None needed. Users who want post-quantum control must leave EIP-7702 delegation for real account code (EIP-8141 or
EIP-8298), which also removes this path.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> NONE, step 2: bytecode and traces show the service key only cosigns; every execution also needs the calling EOA's own signature (`msg.sender`), so no exposure beyond the account's own key; status candidate -> not-affected. Path dormant since 2026-04-15. Project still unidentified.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code.

# Source excerpts: unidentified-380ff867-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x380ff86716cf5911b1d770ed53b74e524a8e5e25`

No verified source on Sourcify or Blockscout.

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
