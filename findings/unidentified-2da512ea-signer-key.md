---
id: unidentified-2da512ea-signer-key
title: "Market-maker Safe 0xb7131fc8 (operator unidentified): its ERC-1271 fallback handler accepts one ECDSA hot key, so a quantum attacker who recovers that key can sign Permit2 transfers and 1inch/CoW orders that drain about $2.4M"
project: unidentified-2da512ea
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x2da512ea8cff88c046d1b402251ff37398752458"
  implementation: null
  name: unverified ERC-1271 signer / Safe fallback handler (OWNER, setSigner, authorizedSigners)
  upgradeable: config-only
  admin: OWNER() = Safe 0x11f0d0818aa278cce4b1c42240772ee48f4260cd (2 of 3) via setSigner(address,bool); maker Safe 0xb7131fc8cdc43060a6210257f537dba5fcae6aed (1 of 2 EOAs) can replace its fallback handler (read at block 26431523)
  value_usd: 2353248
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 11925
families: []
fix:
  layer: new-deployment
  who_acts: the market maker behind Safe 0xb7131fc8cdc43060a6210257f537dba5fcae6aed (owners 0x388364512b2603eb2588ea12eda201423d5f7ffe, 0x6e64095a0170b8c1721694b49fb58c974a4c45f0) deploys a post-quantum ERC-1271 handler and calls setFallbackHandler
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-2da512ea-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review22)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-2da512ea-signer-key/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9e42c98a"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

`0x2da512ea…` is the fallback handler of Safe `0xb7131fc8…`, a market maker's trading Safe. Every ERC-1271
`isValidSignature` call to that Safe is forwarded to it, and it approves any hash signed by an authorised secp256k1
key. The active key `0x95649074…` signs every fill. A quantum attacker who recovers it can sign Permit2
`permitTransferFrom` messages, or 1inch and CoW orders, that move all approved tokens out of the Safe: about $2.35M at
2026-11-17. Rated MEDIUM (step 4: the Safe owners must deploy a post-quantum ERC-1271 handler and point the Safe at it).

## Mechanism

- Safe 1.4.1 `0xb7131fc8…` stores `0x2da512ea…` in its fallback-handler slot, so calls to
  `isValidSignature(bytes32,bytes)` on the Safe reach `0x2da512ea…`.
- `0x2da512ea…` (unverified, 2,747 bytes, no proxy) exposes `isValidSignature(bytes32,bytes)`,
  `authorizedSigners(address)`, `setSigner(address,bool)` and `OWNER()`. In traces, `isValidSignature` calls
  `ecrecover(hash, v, r, s)` and returns `0x1626ba7e` when the result is an authorised signer. PQ-4: a single operator
  key authorises value.
- Consumers seen: 1inch v6 `fillContractOrder` (maker = the Safe), CoW settlement, and Permit2
  `permitTransferFrom` with the Safe as owner. All of them pull tokens from the Safe once the ERC-1271 check passes.
- `setSigner` (by `OWNER()` = Safe `0x11f0d081…`, 2 of 3) only adds or removes ECDSA keys. The maker Safe's owners can
  replace the fallback handler with `setFallbackHandler`.

## Evidence

- CHECKED (bytecode selectors; `cast run` traces of txs `0x2a3cf0b9…`, `0x4f6935d4…`, `0xc1fb250d…`, `0x13f4b7c8…`,
  `0xad01ea6f…`, `0xd756d8e6…`, `0x57fd61e8…`): maker Safe → `0x2da512ea….isValidSignature` → `ecrecover` =
  `0x95649074…` → magic value, followed by `transferFrom` or Permit2 `permitTransferFrom` from the Safe
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-2da512ea-signer-key/review-reads.json)).
- CHECKED (RPC at block 26,431,523): `OWNER()` = Safe `0x11f0d081…` (threshold 2; owners `0x5d1bb9fc…`, `0x6f8d3549…`,
  `0x6e64095a…`); `authorizedSigners(0x95649074…)` = true (an EOA); no EIP-1967 slot. Maker Safe `0xb7131fc8…`: version
  1.4.1, threshold 1, owners `0x38836451…` and `0x6e64095a…`, fallback handler `0x2da512ea…`, no guard, no modules.
- CHECKED (Blockscout token balances plus `allowance` via RPC): the Safe holds about $2.35M in about 45 tokens (WETH
  $320k, XAUT $206k, PENDLE $164k, …), all with unlimited (or 2^96) approval to Permit2 and the 1inch v6 router; 0 ETH.
- CHECKED (Blockscout): `0x2da512ea…` was created on 2026-01-29 through the CREATE2 deployer by EOA `0xcaf68554…`. The
  operator is not identified (no labels, no verified source).
- CHECKED (Xatu call frames): 11,925 transactions in 2026-10-16 to 2026-11-16 and 113,475 since block 24,700,000; all
  sampled transactions went through maker Safe `0xb7131fc8…`. There were 21,201 pre-quantum calls in the year to March
  2026 (`curated_contracts.csv` `txs_y1`).
- INFERRED: whether other Safes use `0x2da512ea…` as their fallback handler was not checked beyond the sampled traces.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2da512ea…` ERC-1271 handler | config-only (signer set; Safe can swap handler) | $2.35M (escrow: maker Safe `0xb7131fc8…` approved balances) | 2026-11-16 | 11,925 |

The handler holds nothing. The value is the maker Safe's token balance, all of it approved to Permit2 and 1inch, which
an ERC-1271 signature can move. The Safe's own owners are ECDSA EOAs with threshold 1 (PQ-12), a separate exposure of
the same funds.

## Remediation

- The maker Safe's owners deploy an ERC-1271 handler that verifies a post-quantum signature (ML-DSA or Falcon through
  an ERC-7913 verifier, or a hash-based scheme) and call `setFallbackHandler`. Until then, they can call
  `setFallbackHandler` with a handler that rejects all signatures (stopping RFQ fills) or keep approvals small.
- The Safe owners should also move to post-quantum signers. Rotating `setSigner` keys does not help.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review22): stays MEDIUM, step 4: a new handler that the maker Safe points at. Status candidate -> confirmed (`ecrecover` against `authorizedSigners` seen in traces; state read). Identified the role as Safe `0xb7131fc8`'s fallback handler and measured the escrow ($2.35M approved to Permit2 and 1inch); `alternative` set to configurable-verifier.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: unidentified-2da512ea-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x2da512ea8cff88c046d1b402251ff37398752458`

No verified source on Sourcify or Blockscout.
