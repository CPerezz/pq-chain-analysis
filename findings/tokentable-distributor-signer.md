---
id: tokentable-distributor-signer
title: "TokenTable ECDSA distributors (Sign Protocol): a quantum attacker who recovers an airdrop's authorizedSigner key could sign claims; both clones' claim windows closed in 2025, $126 left"
project: sign-protocol
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xccbd08746816de921ca91611d277a90ab083bc7a"
  implementation: "0x85a530f3c0be16e895cfc935350480afb7215b4b"
  name: FungibleTokenWithFeesECDSADistributor 0.4.3 (EIP-1167 clone, BOS airdrop)
  upgradeable: config-only
  admin: owner 0xeab88fa6a3723749035b2579f8dcb924c9948b75 (EOA) sets authorizedSigner, token and claim window via setBaseParams; withdraw
  value_usd: 126
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-04
  txs_30d: 0
- address: "0xfe5fc40c15c67983694642f9a8711241157fdb0a"
  implementation: "0x85a530f3c0be16e895cfc935350480afb7215b4b"
  name: FungibleTokenWithFeesECDSADistributor 0.4.3 (EIP-1167 clone, YALA airdrop)
  upgradeable: config-only
  admin: owner 0xfc9c1ec0a4fc4ae45d581c5dd636386ef6b13680 (EOA) sets authorizedSigner, token and claim window via setBaseParams; withdraw
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-08-21
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: each clone's owner (0xeab88fa6a3723749035b2579f8dcb924c9948b75, 0xfc9c1ec0a4fc4ae45d581c5dd636386ef6b13680) sets authorizedSigner to a contract that verifies a post-quantum signature through ERC-1271, or withdraws the remainder
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokentable-distributor-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review03 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokentable-distributor-signer/state.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

TokenTable's ECDSA airdrop distributors release tokens to anyone holding a claim signed by the clone's
`authorizedSigner`; both signers here are EOAs, so the check is `ecrecover` against one operator key (PQ-4). A
quantum attacker who recovers that key could sign claims for the remaining balance, but both claim windows closed
in 2025 (`onlyActive` reverts) and only 9.94M BOS ($126) remains, in 0xccbd0874. Because the library checks for
code first, the owner can switch to a post-quantum ERC-1271 signer contract by one `setBaseParams` call. Rated LOW
(step 1: no activity in the last 12 months and almost nothing held; step 4 also gives LOW).

## Mechanism

- `BaseECDSADistributor.claim(recipients, userClaimIds, datas, signatures, extraDatas)` (`onlyActive`,
  `whenNotPaused`) calls `_verifyAndClaim` per recipient.
- `FungibleTokenWithFeesECDSADistributor._verifyAndClaim` builds
  `encodeHashToBeSigned(recipient, userClaimId, userClaimData)` (chain id, contract, recipient, id, data), calls
  `verify($.authorizedSigner, hash, signature)`, marks the claim used and `_send(recipient, claimableAmount)`.
- `verify` uses Solady `SignatureCheckerLib.isValidSignatureNow(signer, toEthSignedMessageHash(hash), signature)`:
  if `signer` has no code it uses `ecrecover`, otherwise it calls the signer's `isValidSignature` with the full
  signature. So the exposure is the signer key, and a contract signer avoids `ecrecover` entirely.
- `onlyActive` reverts outside `[startTime, endTime]`; the owner can reopen the window or change the signer with
  `setBaseParams`, and `withdraw` (onlyOwner) recovers the remaining tokens.

## Evidence

- CHECKED (verified source of implementation 0x85a530f3…, Blockscout; the clones themselves are unverified
  EIP-1167 proxies): functions and library as above. The drafted `source-excerpts.md` has no source because it
  looked up the clone addresses.
- CHECKED (on-chain read, block 26,431,569): both clones' runtime code is the EIP-1167 proxy to 0x85a530f3…;
  `getStorage()` returns version 0.4.3, owners 0xeab88fa6… and 0xfc9c1ec0… (no code), signers 0x4630d183… and
  0x00a98a3a… (no code), tokens BOS 0x13239c26… and YALA 0xf9707060…, windows 2025-11-01 to 2025-11-04 and
  2025-07-22 to 2025-08-21, not paused; BOS balance of 0xccbd0874 = 9,940,681, YALA balance of 0xfe5fc40c = 0
  ([`state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokentable-distributor-signer/state.json)).
- CHECKED (on-chain read, block 26,431,214): holdings $126 and $0
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokentable-distributor-signer/onchain.json)).
- CHECKED (Xatu, any function, 2026-03-18 to 2026-11-16): no transaction reached either clone
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokentable-distributor-signer/activity.json)); `last_active` is the last
  pre-quantum call in the precompile trace, matching the window ends. `txs_y1` = 42,189 and 19,984 calls in
  `curated_contracts.csv` (the claim periods).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xccbd0874…` distributor (BOS) | config-only | $126 (9.94M BOS) | 2025-11-04 | 0 |
| `0xfe5fc40c…` distributor (YALA) | config-only | $0 | 2025-08-21 | 0 |

Other TokenTable ECDSA clones from TTADeployer 0xed09c236… were not enumerated here; each has its own owner and
signer and the same fix.

## Remediation

- Post-quantum replacement: set `authorizedSigner` to a contract whose `isValidSignature` verifies a post-quantum
  signature (the library already passes the full signature), or use TokenTable's Merkle distributor, which needs no
  signer.
- Who acts: each clone's owner (EOAs 0xeab88fa6…, 0xfc9c1ec0…) with `setBaseParams`, or `withdraw` of the
  remaining BOS. Sign Protocol can make a contract signer the default in TTADeployer for new airdrops.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review03): LOW unchanged (step 1: claim windows closed 2025-11-04 and 2025-08-21, no activity since, $126 held; step 4 alone also gives LOW). Implementation, owners, signers and windows read on-chain; fix layer corrected from new-deployment to onchain-config.

# Source excerpts: tokentable-distributor-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xccbd08746816de921ca91611d277a90ab083bc7a`

No verified source on Sourcify or Blockscout.


## Contract `0xfe5fc40c15c67983694642f9a8711241157fdb0a`

No verified source on Sourcify or Blockscout.
