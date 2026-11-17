---
id: layer3-distributor-signer
title: "Layer3 L3Distributor: a quantum attacker who recovers the claim-signer key can only let addresses already in the immutable merkle tree claim their own allocation; the airdrop is closed and empty"
project: layer3
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0xb9b8dca169122421ba123d23bf52175d2be755c0"
  implementation: null
  name: L3Distributor
  upgradeable: config-only
  admin: owner Safe 0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6 (3 of 5; updateSigner, emergencyWithdraw); read at block 26,431,747
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-08-30
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: nobody needs to act; Layer3 owner Safe 0x49a941d7d7d40f340fabb17d25a9e2a76b72fac6 would only matter if it refilled the contract
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/layer3-distributor-signer/classification.jsonl
  - evidence/layer3-distributor-signer/onchain.json
  - evidence/layer3-distributor-signer/activity.json
  - evidence/layer3-distributor-signer/source-excerpts.md
  - evidence/layer3-distributor-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (full Sourcify source, signer/owner/balance reads, Blockscout history)
  ref: evidence/layer3-distributor-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Layer3's L3 airdrop distributor requires, for each claim, both an ECDSA signature from one operator key (`s_signer`)
and a merkle proof against an immutable root, and both commit to the claimant's own address and amount. A quantum
attacker who recovers the signer key can therefore only let an address that is already in the tree claim its own
allocation without the operator's approval; nothing can be redirected. The distributor holds 0.087 L3 (dust) and its
last transaction was an `emergencyWithdraw` on 2025-08-30. Rated LOW (step 1: no activity in the last 12 months and
nothing held).

## Mechanism

- `claim` / `claimAndStake(amount, merkleProof, signature)` → `_claim`: `ECDSA.recover` of the eth-signed
  `keccak256(keccak256(abi.encode(msg.sender, amount)))` must equal `s_signer` (`L3Distributor.sol` lines 121–124),
  then `MerkleProof.verify` of the same leaf against `i_merkleRoot` (line 127), then `s_hasClaimed[msg.sender] = true`.
- `claimAndStake` stakes `amount` L3 for 12 months for `msg.sender` and transfers it to the staking contract;
  `claim` records the claim and emits `SmartWalletClaim`.
- `updateSigner` is `onlyOwner`. Pattern PQ-4, but the signature is an extra gate on top of the merkle proof.
  Excerpts: [`source-excerpts.md`](../evidence/layer3-distributor-signer/source-excerpts.md).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): `_claim`, `claim`, `claimAndStake`, `updateSigner` as above;
  immutable `i_merkleRoot`; no proxy ([`notes.md`](../evidence/layer3-distributor-signer/notes.md)).
- CHECKED (`cast`, block 26,431,747): `s_signer()` EOA `0x268bde7c…`; `owner()` Safe `0x49a941d7…` (3 of 5 at block
  26,431,214, [`onchain.json`](../evidence/layer3-distributor-signer/onchain.json)); L3 balance 0.087 L3; ETH 0.
- CHECKED (Blockscout): last transaction `emergencyWithdraw` on 2025-08-30; the last `ecrecover` call in the trace
  was at block 22,773,373 (2025-06-24). Xatu shows no transaction in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/layer3-distributor-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb9b8dca1…` L3Distributor | config-only | $0 (0.087 L3) | 2025-08-30 | 0 |

Even when funded, a forged signer signature released nothing beyond what the merkle tree already granted to each
claimant address; the tokens went to `msg.sender` (or were staked for it), never to an address the signer chose.

## Remediation

None needed while the distributor stays empty. A future Layer3 distribution that keeps an operator approval should
verify it with a post-quantum scheme, or rely on the merkle proof alone, which is hash-based. No protocol change is
needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-06-24) and nothing held).
- 2026-11-17 review (Review18): LOW kept, step 1 (last transaction 2025-08-30, holds dust). Impact funds-loss -> none
  and role core -> auxiliary: the signature is an extra gate on an immutable merkle tree bound to `msg.sender`, so a
  forged signature cannot redirect allocations. `last_active` corrected to 2025-08-30 (emergencyWithdraw).
