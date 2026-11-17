---
id: caldera-airdrop-signer
title: "Caldera: the closed ERA airdrop (CalderaAirdrop) trusts one githubSigner ECDSA key; with it a quantum attacker could claim unclaimed GitHub allocations only if the owner Safe reopened the claim period"
project: caldera
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xe6961dca8d597136fad600cf9ae4be2eb6254b30"
  implementation: "0x2f4a01b9de95889f8c6dadda579a3b7dddef600e"
  name: ERC1967Proxy → CalderaAirdrop
  upgradeable: "yes"
  admin: UUPS, owner() Safe 0xf50ca866cdf7e810c17b267553595656ad78f606 (3 of 5, Ownable2Step), read at block 26431594
  value_usd: 2212
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-07-31
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Caldera's Safe 0xf50ca866cdf7e810c17b267553595656ad78f606 (3 of 5), owner of the UUPS proxy and the airdrop vault, can revoke the vault's ERA allowance to the airdrop, or upgrade before any reopening
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/caldera-airdrop-signer/classification.jsonl
  - evidence/caldera-airdrop-signer/onchain.json
  - evidence/caldera-airdrop-signer/activity.json
  - evidence/caldera-airdrop-signer/source-excerpts.md
  - evidence/caldera-airdrop-signer/claim-state.json
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

`CalderaAirdrop` (`0xe6961dca…4b30`) paid out the ERA airdrop from 2025-07-17 to 2025-07-31. GitHub allocations
(`githubClaim`, `combinedClaim`) require an ECDSA signature from one backend key, `githubSigner` `0xfc6e83ba…dd68`,
binding a GitHub username to the claiming address (PQ-4); with that key a quantum attacker could claim any unclaimed
GitHub allocation to their own address. The claim period has ended, so nothing can be claimed unless the owner Safe
reopens it; the vault behind it now holds 29,744 ERA (about USD 2.2k). Rated LOW (step 1): no activity in the last
12 months and the contract holds nothing.

## Mechanism

- `_requireValidGithubOwnershipVerificationSignature` (excerpt lines 456–471): recovers the signer of the eth-signed
  message `getGithubClaimVerificationMessage(msg.sender, githubUsername)` and requires it to equal `githubSigner`.
- `_githubClaim` (source lines 403–426) then checks a Merkle proof for `(githubUsername, amount)` and moves `amount`
  ERA from `airdropVault` (by `transferFrom`) to `msg.sender`, part of it staked through `CalderaStaking.stakeFor`. The
  leaf does not include an address, so whoever holds a `githubSigner` signature for a username takes its allocation.
- `_requireValidAddressSignature` (line 447): every claim also needs `ecrecover(addressClaimMessage) == msg.sender`.
  That signature adds no forgery beyond the sender's own key, but it locks contract accounts (and so post-quantum
  accounts) out of claiming.
- All claims are gated by `whenWithinClaimPeriod` (`startTime`..`endTime`); the owner can move both with
  `setStartTime`/`setEndTime` and can replace `githubSigner` with another ECDSA key (`setGithubSigner`).
- Pattern PQ-4. Excerpts: [`source-excerpts.md`](../evidence/caldera-airdrop-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify `exact_match` for implementation `0x2f4a01b9…600e`, read 2026-11-17): the functions
  above.
- CHECKED (on-chain read at block 26,431,594): `startTime` 2025-07-17 14:30 UTC, `endTime` 2025-07-31 00:00 UTC, not
  paused; `token()` = ERA `0xe2ad0bf7…de2a`; `airdropVault()` and `owner()` = Safe `0xf50ca866…f606` (3 of 5, read at
  block 26,431,214); `githubSigner()` = EOA `0xfc6e83ba…dd68` (nonce 0, signs off-chain; its signatures are in claim
  calldata); vault ERA allowance to the airdrop 48,809,752 ERA, vault ERA balance 29,744.33
  ([`claim-state.json`](../evidence/caldera-airdrop-signer/claim-state.json)).
- CHECKED (on-chain read at block 26,431,214): the proxy holds no ETH or tokens
  ([`onchain.json`](../evidence/caldera-airdrop-signer/onchain.json)).
- CHECKED (Xatu): last call 2025-07-31, none 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/caldera-airdrop-signer/activity.json));
  48,842 pre-quantum calls in the year to March 2026 (`txs_y1`), all within the July 2025 claim window.

## Impact and exposure

| Contract | Upgradeable | Releasable (vault) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe6961dca…` ERC1967Proxy → CalderaAirdrop | yes (UUPS, Safe) | 29,744 ERA, USD 2,212 (2026-11-17) | 2025-07-31 | 0 |

- Escrow: what a forged `githubSigner` signature could move is the vault Safe's ERA, capped by its allowance to the
  airdrop: 29,744 ERA at USD 0.074364 (Blockscout), USD 2,212. Only reachable if the Safe reopens the claim period.
- The airdrop proxy itself holds nothing.

## Remediation

- Post-quantum replacement, if the airdrop is ever reopened: a GitHub attestation verified by a post-quantum scheme
  (ERC-7913 verifier), or the username-to-address binding committed in the Merkle leaf; drop the `msg.sender`
  ECDSA signature or accept ERC-1271 so contract accounts can claim.
- Who must act: Caldera's Safe `0xf50ca866…f606` (3 of 5): revoke the vault's ERA allowance to the airdrop, or upgrade
  before reopening. No protocol change needed. Users: nothing to do.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-07-31) and nothing held).
- 2026-11-17 review (Review21): LOW kept, step 1: no activity since 2025-07-31 and nothing held; claim period closed.
  Exposure measured: vault ERA within the allowance, USD 2,212 (escrow).
