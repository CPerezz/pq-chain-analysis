---
id: unidentified-380ff867-signer-key
title: "Unidentified 7702 execution cosigner (0x380ff867): its service ECDSA key only cosigns, and each execution also needs the delegated EOA's own signature, so forging the service key takes nothing; not affected beyond the account's own key"
project: unidentified-380ff867
status: not-affected
severity: NONE
patterns: [PQ-4]
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
  links:
  - evidence/unidentified-380ff867-signer-key/classification.jsonl
  - evidence/unidentified-380ff867-signer-key/onchain.json
  - evidence/unidentified-380ff867-signer-key/activity.json
  - evidence/unidentified-380ff867-signer-key/source-excerpts.md
  - evidence/unidentified-380ff867-signer-key/bytecode-and-traces.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
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
- Read from bytecode and traces: [`bytecode-and-traces.md`](../evidence/unidentified-380ff867-signer-key/bytecode-and-traces.md).

## Evidence

- CHECKED (bytecode, `cast selectors`/`cast disassemble`, 2026-11-17): the double recovery against slot 1 (`signer()`)
  and `CALLER`, and the nonce bitmap. Not verified on Sourcify or Blockscout; `evidence.level` stays `bytecode`.
- CHECKED (traces of two successful transactions at blocks 24,883,655 and 24,883,673): the two recoveries return
  `signer()` `0xdbea7a79…` and the calling EOA; then the EOA executes its calls. A reverted call at block 26,403,470
  fails on the first recovery.
- CHECKED (on-chain reads at block 26,431,591): `signer()`, `operator()`, `owner()` = Safe `0x9287b8e8…`, not paused;
  Safe threshold 3 of 5 and no holdings at block 26,431,214 ([`onchain.json`](../evidence/unidentified-380ff867-signer-key/onchain.json)).
- CHECKED (Xatu call frames, blocks 24,700,000–26,423,999): 60,627 transactions, all but 10 before block ~24,884,000;
  1 in 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/unidentified-380ff867-signer-key/activity.json)). The
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> NONE, step 2: bytecode and traces show the service key only cosigns; every execution also needs the calling EOA's own signature (`msg.sender`), so no exposure beyond the account's own key; status candidate -> not-affected. Path dormant since 2026-04-15. Project still unidentified.
