---
id: unidentified-59708733-owner-keys
title: "Unidentified custodian's 2-of-5 multisig wallets (clones of 0x0d424072): forging two of the same five ECDSA signer keys drains about USD 290M"
project: unidentified-59708733
status: confirmed
severity: MEDIUM
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x70213959a644baa94840bbfb4129550bceceb3c2"
  implementation: "0x0d424072d658e6abd92c36f8fc16fd6479ae15a0"
  name: EIP-1167 clone of unverified 0x0d424072 (init(address[]), isSigner, safeMode)
  upgradeable: "no"
  admin: none (EIP-1167 clone; five signer EOAs fixed at creation, no add/remove-signer function)
  value_usd: 83151912
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-04
  txs_30d: 6
- address: "0x59708733fbbf64378d9293ec56b977c011a08fd2"
  implementation: "0x0d424072d658e6abd92c36f8fc16fd6479ae15a0"
  name: EIP-1167 clone of unverified 0x0d424072 (init(address[]), isSigner, safeMode)
  upgradeable: "no"
  admin: none (EIP-1167 clone; five signer EOAs fixed at creation, no add/remove-signer function)
  value_usd: 143930334
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 101
families:
- code: "0x0d424072d658e6abd92c36f8fc16fd6479ae15a0"
  name: EIP-1167 clones of 0x0d424072 (factory 0xb9a336b8), excluding the two contracts above
  instances: 21
  list: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys/wallets.json
  upgradeable: "no"
  value_usd: 73240839
  value_basis: held
  value_as_of: 2026-11-17
fix:
  layer: account-migration
  who_acts: the custodian holding signer keys 0x7f6a0886e9c06635802c823b1e01fa5ace23012f, 0x6761ee52d24b4519f2ad3c7b80d6d5b57b825b74, 0x1458e52d23b531df0e5a2b0d8db43d85018069f9, 0xd59a643bbb558cdbfdc1f9747aa171218bdc3357, 0xe4af0df01622386bf1d3589ba325c66293850632 (and the signers of the other clones), by moving funds to a wallet with post-quantum signers
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl,out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review04)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys/wallets.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Two EIP-1167 multisig wallets of an unidentified custodian hold about USD 227M (91,733 ETH and 60.9M USDC) behind
the same five secp256k1 signer EOAs; each spend carries two ECDSA signatures (PQ-12). A quantum attacker who recovers
two signer keys from signatures already in calldata can send everything out. 21 more clones of the same code hold
about USD 73M (63.2M and 10M USDT in two of them). Rated MEDIUM, step 4: the signer set is fixed in code, but one
party (the custodian) can remove the exposure by moving funds to a post-quantum wallet.

## Mechanism

- The clones delegate to unverified `0x0d424072…` (7.9 KB). Its dispatcher exposes `init(address[])`,
  `signers(address)`, `isSigner(address)`, `initialized()`, `safeMode()`, `activateSafeMode()` and two unnamed
  selectors; there is no `isValidSignature`, no add/remove-signer function and no upgrade path.
- Spends go through selector `0xca34837b` with arguments `(address to, uint256 value, bytes data, uint256 expireTime,
  bytes[] signatures)`; sample transaction `0xb6ae5b84…` (block 26,428,039) carries two 65-byte signatures and is sent
  by signer `0x7f6a0886…`. The wallet calls `ecrecover` twice per transaction (precompile trace) and, INFERRED,
  checks each recovered address with `signers`. The scheme resembles BitGo's WalletSimple but the selectors differ, so
  the vendor is not BitGo's published contract.
- Pattern PQ-12 (wallet owners are ECDSA keys). No verified source exists
  ([`source-excerpts.md`](#source-excerpts-unidentified-59708733-owner-keys)).

## Evidence

- CHECKED (implementation bytecode, selector scan and 4byte lookup at block 26,431,520): the function list above;
  no signer-management, ERC-1271 or upgrade selectors.
- CHECKED (precompile trace `data/agg/y1_caller.parquet`): every clone with activity calls `ecrecover` exactly twice
  per transaction (e.g. `0x59708733…` 160 calls in 80 transactions, `0x70213959…` 52 in 26). INFERRED: threshold 2.
- CHECKED (Blockscout, creation transactions `0x6aa6908f…` block 19,146,255 and `0xf2fa7c82…` block 19,146,330):
  both wallets were created through factory `0xb9a336b8…` `createWallet(address[],bytes32)` by `0x7f6a0886…` with the
  same five signers; factory and implementation were deployed by EOA `0x34448c6b…`. No name, tag or ENS name on any of
  these addresses, so the custodian stays unidentified.
- CHECKED (`isSigner` at block 26,431,520): all five are signers of both wallets and of three more clones
  (`0xdbe46a02…`, `0x4d216d26…`, `0x54a679e8…`); all five are EOAs (nonces 310, 63, 0, 0, 0). Spends' calldata
  carries the signatures, so signers that never sent a transaction still have recoverable public keys.
- CHECKED (on-chain read at block 26,431,214): clone code and holdings ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys/onchain.json));
  family balances (ETH, USDC, USDT only) at block 26,431,520 in [`wallets.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys/wallets.json).
- CHECKED (Xatu, any function): activity 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-59708733-owner-keys/activity.json));
  EOA `0xed9ab5bc…` sends ETH into `0x59708733…` about every two hours (Blockscout, 2026-11-16/17).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x70213959…` clone of `0x0d424072` | no | $83.2M (45,899 ETH) | 2026-11-04 | 6 |
| `0x59708733…` clone of `0x0d424072` | no | $143.9M (45,833 ETH, 60.9M USDC) | 2026-11-15 | 101 |
| 21 other clones of `0x0d424072` | no | $73.2M (mainly `0x54a679e8…` 63.2M USDT, same signers; `0x9f199b93…` 10.0M USDT, other signers) | — | — |

Values are held balances (ETH at USD 1,811.62); the family figure counts ETH, USDC and USDT only. The family has 23
members in `data/caller_family.parquet` (the draft said 16); the list is in `wallets.json`.

## Remediation

- Post-quantum replacement: a multisig whose owners verify a post-quantum signature (for example a Safe with
  ERC-1271 owner contracts running ML-DSA or SLH-DSA verification). The clones cannot change their signers or scheme,
  so the funds must move.
- Who acts: the custodian controlling the five signer EOAs listed in `fix.who_acts` (and the signers of the other
  clones), by transferring balances to the new wallet and retiring these clones. This is one party's operational
  migration; no protocol change is needed. EIP-8151 would not help: the signers are EOAs whose keys are the exposure.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review04): HIGH -> MEDIUM, step 4: both wallets (and the largest other clone) share one set of five signer EOAs created by one operator, so the fix is a single custodian moving funds, not many independent owners. Family corrected to 21 further clones holding USD 73.2M; status candidate -> confirmed (bytecode plus precompile trace and spend calldata).

# Source excerpts: unidentified-59708733-owner-keys

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x70213959a644baa94840bbfb4129550bceceb3c2`

No verified source on Sourcify or Blockscout.

## Implementation `0x0d424072d658e6abd92c36f8fc16fd6479ae15a0`

No verified source on Sourcify or Blockscout.


## Contract `0x59708733fbbf64378d9293ec56b977c011a08fd2`

No verified source on Sourcify or Blockscout.

## Implementation `0x0d424072d658e6abd92c36f8fc16fd6479ae15a0`

No verified source on Sourcify or Blockscout.
