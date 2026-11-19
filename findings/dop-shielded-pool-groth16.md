---
id: dop-shielded-pool-groth16
title: "DOP (Data Ownership Protocol): a quantum attacker with the Groth16 setup trapdoor can forge unshield proofs and drain the $46k in DOP's three shielded pools"
project: dop
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, ecrecover]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x100063491afd897b58828b3d4fe738ab979e13df"
  implementation: "0x591334078a5a67f1136fedbc0bd3bc9c19003517"
  name: TransparentUpgradeableProxy → DOPSmartWallet (DOPLogic)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8593da65d55ccdb9367377231925d0688efb5007, owner Safe 0xb2e069ca34bd08eec485a9cc16f659c2ba7c18c1 (2 of 5); logic owner Safe 0x2aa82a0eec78184b6089643fef2f11c2595f46e5 (2 of 3, setVerificationKey); read at block 26,431,454"
  value_usd: 224
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-04-21
  txs_30d: 0
- address: "0x9a3152b61420ed4d5e594c0b48bb932ee41b7376"
  implementation: "0xb157dc78c2815280906a6730984a5e0dca65e247"
  name: TransparentUpgradeableProxy → DOPSmartWallet
  upgradeable: "yes"
  admin: "ProxyAdmin 0x8593da65d55ccdb9367377231925d0688efb5007, owner Safe 0xb2e069ca34bd08eec485a9cc16f659c2ba7c18c1 (2 of 5); logic owner Safe 0x2aa82a0eec78184b6089643fef2f11c2595f46e5 (2 of 3); read at block 26,431,454"
  value_usd: 45745
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-08-01
  txs_30d: 0
- address: "0x41350da0c6ca2842b567799e7dac6e24f43aca69"
  implementation: "0x18d04735d18495b5336e00cd092c5d17c9e5a0b4"
  name: TransparentUpgradeableProxy → DOPSmartWallet
  upgradeable: "yes"
  admin: "ProxyAdmin 0x005a5956c22c142175b49e7916b7e0ebfe56b34a, owner EOA 0x45faf7923bab5a5380515e055ca700519b3e4705; logic owner 0x1c027004862bbf808f4b208ef11d453e2d381c48 (EIP-7702 account); read at block 26,431,454"
  value_usd: 7
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-06-18
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "DOP: ProxyAdmin 0x8593da65d55ccdb9367377231925d0688efb5007 (owner Safe 0xb2e069ca34bd08eec485a9cc16f659c2ba7c18c1, 2 of 5) for the first two pools; ProxyAdmin 0x005a5956c22c142175b49e7916b7e0ebfe56b34a (owner EOA 0x45faf7923bab5a5380515e055ca700519b3e4705) for the third"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dop-shielded-pool-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dop-shielded-pool-groth16/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

DOP's shielded pools are Railgun-style: a transaction that spends shielded notes, including an unshield that pays tokens
out of the pool, is accepted when a Groth16 proof on BN254 verifies (PQ-7). With the setup trapdoor a quantum attacker
can prove spends of notes that do not exist and empty the pool. The three pools held $46k together on 2026-11-17.
Rated LOW: MEDIUM by step 4 (each pool is an upgradeable proxy), lowered one level by step 5 (under $50k exposed).

## Mechanism

- `DOPLogic.validateTransaction` (DOPLogic.sol line 409) rejects a transaction unless `Verifier.verify(transaction)`
  (line 457) passes; `Verifier.verify` loads the owner-set verifying key (`setVerificationKey`, Verifier.sol line 38) and
  calls `Snark.verify`, which ends in the pairing precompile `0x08` (Snark.sol line 109).
- A valid transaction's unshield notes go through `_processDecrypt` (line 705), which transfers the token from the pool
  proxy to the recipient. Shielded balances are held by the proxy itself, so the pool is its own escrow.
- The ECDSA check in the same contract (`_validateSignature`, line 742) gates `encryptApproved`/`encryptRejected`; both
  require `msg.sender` to be the depositor of that pending request, so a forged `signer` signature cannot move anyone
  else's funds. It is not counted as exposure.

## Evidence

- CHECKED (verified source, Sourcify): the path above in all three implementations
  ([`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dop-shielded-pool-groth16/source-excerpts.md),
  [`notes.md`](#review-notes-dop-shielded-pool-groth16-2026-11-17)).
- CHECKED (on-chain read, block 26,431,454): implementations, ProxyAdmins and their owners, logic owners and Safe
  thresholds (table in [`notes.md`](#review-notes-dop-shielded-pool-groth16-2026-11-17)).
- CHECKED (on-chain read, block 26,431,214): holdings $224, $45,745 and $7
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dop-shielded-pool-groth16/onchain.json)).
- CHECKED (Xatu, any function): no calls 2026-10-16 to 2026-11-16; last calls 2026-04-21, 2025-08-01 and 2025-06-18
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/dop-shielded-pool-groth16/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x10006349…` DOPSmartWallet (DOPLogic) | yes | $224 | 2026-04-21 | 0 |
| `0x9a3152b6…` DOPSmartWallet | yes | $45.7k | 2025-08-01 | 0 |
| `0x41350da0…` DOPSmartWallet | yes | $7 | 2025-06-18 | 0 |

Total held $46.0k (2026-11-17); the pools are their own escrow. Yearly pre-quantum counts from the census (`txs_y1`):
151, 28 and 28. The draft's family entry (148 contracts sharing the OpenZeppelin TransparentUpgradeableProxy runtime
code, listed under RedStone's EthereumMultiFeedAdapterWithoutRoundsV3) was removed: the shared code is the generic proxy, not DOP's logic.

## Remediation

- Replace the Groth16 circuits and `Snark.verify` with a hash-based proof system (STARK/FRI or WHIR verifier) and upgrade
  the implementations: ProxyAdmin `0x8593da65…` (owner Safe `0xb2e069ca…`, 2 of 5) for `0x10006349…` and `0x9a3152b6…`;
  ProxyAdmin `0x005a5956…` (owner EOA `0x45faf792…`) for `0x41350da0…`. Pools that are no longer used can instead be
  emptied and closed.
- No protocol change is needed. Users can unshield their notes.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM -> LOW, step 5: the pools are their own escrow and hold $46.0k in total (under $50k). Removed the unrelated proxy-code family (148 contracts sharing the generic proxy code). The encrypt-approval ECDSA signer cannot move other users' funds.
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Review notes: dop-shielded-pool-groth16 (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(implementation `0x591334078a5a67f1136fedbc0bd3bc9c19003517`, `contracts/logic/DOPLogic.sol`, `Verifier.sol`, `Snark.sol`).

## Proxies

| Proxy | `cast implementation` | ProxyAdmin (EIP-1967 admin slot) | ProxyAdmin `owner()` | Logic `owner()` | `signer()` |
|---|---|---|---|---|---|
| `0x100063491afd897b58828b3d4fe738ab979e13df` | `0x591334078a5a…` | `0x8593da65d55ccdb9367377231925d0688efb5007` | Safe `0xb2e069ca34bd08eec485a9cc16f659c2ba7c18c1` (2 of 5) | Safe `0x2aa82a0eec78184b6089643fef2f11c2595f46e5` (2 of 3) | `0xd50667748f34edd56d74b041c0f89bf9aa7d45cf` |
| `0x9a3152b61420ed4d5e594c0b48bb932ee41b7376` | `0xb157dc78c281…` | `0x8593da65…` | Safe `0xb2e069ca…` (2 of 5) | Safe `0x2aa82a0e…` (2 of 3) | reverts (older logic) |
| `0x41350da0c6ca2842b567799e7dac6e24f43aca69` | `0x18d04735d184…` | `0x005a5956c22c142175b49e7916b7e0ebfe56b34a` | EOA `0x45faf7923bab5a5380515e055ca700519b3e4705` | `0x1c027004862bbf808f4b208ef11d453e2d381c48` (EIP-7702 account delegated to EIP7702StatelessDeleGator) | `0xd5066774…` |

Safe `0xb2e069ca…` owners: `0x614e4ebc…`, `0xec3f6e51…`, `0x366cdf90…`, `0x3dae2efe…`, `0x554b4a63…`.
Safe `0x2aa82a0e…` owners: `0x366cdf90…`, `0x3dae2efe…`, `0x554b4a63…`.

## Code path (DOPLogic / Verifier / Snark)

- `validateTransaction` (DOPLogic.sol line 409) returns `INVALID_SNARK_PROOF` unless `Verifier.verify(transaction)`
  (line 457); `Verifier.verify` loads the verifying key for the nullifier/commitment counts and calls
  `Snark.verify` → `pairing` → `staticcall(…, 8, …)` (Snark.sol line 109), a Groth16 check on BN254. Verifying keys are set
  by the owner (`setVerificationKey`, Verifier.sol line 38).
- Decrypt (unshield): `_processDecrypt` (line 705) transfers the note's token from the proxy to the recipient
  (`token.safeTransfer(recipient, base)`). Shielded balances sit in the proxy itself.
- `Verifier.verify` returns true when `tx.origin == VERIFICATION_BYPASS` (lines 84, 118), the constant `0x…dEaD`
  (Globals.sol line 12), which no one can sign for; used for gas estimation (Railgun convention).
- Encrypt requests wait in per-request vaults from `_VAULT_FACTORY`; `encryptApproved`/`encryptRejected` require
  `msg.sender == holding.holdee` and an ECDSA signature of `signer` over `(msg.sender, index, approved)`
  (`_validateSignature`, line 742). A forged signer signature only lets a depositor approve or reject their own pending
  deposit; nothing can be taken through it.

## Holdings

`onchain.json` (block 26,431,214): `0x10006349…` $224, `0x9a3152b6…` $45,745 (USDT $24,143, WETH $20,378, …),
`0x41350da0…` $7. Total $45,976.
