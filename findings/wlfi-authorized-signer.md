---
id: wlfi-authorized-signer
title: "WLFI token: a quantum attacker who recovers the authorizedSigner key can sign account-activation and vesting-election vouchers, letting legacy holders unlock their own allocation without World Liberty's approval; no one else's tokens can be taken"
project: world-liberty
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: auxiliary
contracts:
- address: "0xda5e1988097297dcdc1f90d4dfe7909e847cbef6"
  implementation: "0x73fe14ff5a25e4363a72828cccd8444f0748fde7"
  name: TransparentUpgradeableProxy -> WorldLibertyFinancialV4
  upgradeable: "yes"
  admin: "ProxyAdmin 0x7f533afa9e994b7e44673188034f9ce52886a0c0, owner Safe 0x5be9a4959308a0d0c7bc0870e319314d8d957dbb (3 of 5), which is also the token owner (ownerSetAuthorizedSigner)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 31017
families: []
fix:
  layer: contract-upgrade
  who_acts: "World Liberty Financial: Safe 0x5be9a4959308a0d0c7bc0870e319314d8d957dbb (3 of 5) upgrades the implementation through ProxyAdmin 0x7f533afa9e994b7e44673188034f9ce52886a0c0"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wlfi-authorized-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/wlfi-authorized-signer.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

The WLFI token accepts vouchers signed by one secp256k1 key, `authorizedSigner`, for two actions a legacy (presale)
holder takes on its own account: `activateAccount` (unlocks transfers and starts vesting of its allocation) and
`electVestingUpdate`. A quantum attacker who recovers that key can let any legacy holder activate or elect without
World Liberty's approval, bypassing its eligibility gate, but each voucher only acts on `msg.sender`'s own account and
blacklisted accounts stay blocked, so no one else's tokens can be taken. Rated LOW (step 4: the check guards a gate
through which nothing can be taken; the fix is an upgrade by a 3-of-5 Safe).

## Mechanism

- `activateAccount(signature)` and `activateAccountAndClaimVest(signature)` (`WorldLibertyFinancialV2.sol` 221–235)
  call `_validateSignatureForAccountActivationAndActivate(msg.sender, sig)` (466–474): EIP-712 hash of
  `(ACTIVATION_TYPEHASH, account)`, `authorizedSigner() == ECDSA.recover(hash, sig)`, then `_activateAccount`, which
  activates the account in the Registry and starts its vest for its own registered allocation. Until activated, a
  legacy account cannot send or receive WLFI (`_update`, 344–388).
- `electVestingUpdate(deadline, signature)` (`WorldLibertyFinancialV3.sol` 66–79): same signer over
  `(ELECTION_TYPEHASH, account, deadline)`; moves the caller's own vesting category (burning 10% of a non-retail
  allocation).
- The owner can do both without a signature (`ownerActivateAccount`, `ownerElectVestingUpdatesFor`) and can rotate the
  key (`ownerSetAuthorizedSigner`).

Pattern PQ-4 (operator key; here it gates eligibility, not value). Excerpt:
[`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wlfi-authorized-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x73fe…fde7`): the paths above; `notBlacklisted` on `_update`.
- CHECKED (block 26,431,555, [`onchain-review.md`](#on-chain-reads-review15-2026-11-17)): EIP-1967
  implementation `0x73fe14ff…`, admin ProxyAdmin `0x7f533afa…` whose `owner()` is Safe `0x5be9…7dbb` (threshold 3 of
  5, `onchain.json`); token `owner()` is the same Safe; `authorizedSigner()` = `0x006dad584e68225dae2a45731224b3b48ac57184`
  (code size 0, nonce 0: an off-chain signing key).
- CHECKED (precompile trace to March 2026): `ecrecover`, 64,177 pre-quantum calls in the last year
  (`curated_contracts.csv`; this count covers every `ecrecover` made by the token across all its implementations).
- CHECKED (Xatu, any function): 31,017 transactions 2026-10-16 to 2026-11-16; last active 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wlfi-authorized-signer/activity.json)).
- INFERRED: the signer's vouchers are in activation calldata on-chain, so its public key is known.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xda5e1988…` WLFI (V4) | yes (3-of-5 Safe) | none releasable through the voucher | 2026-11-16 | 31,017 |

A forged voucher unlocks only the caller's own registered allocation, which World Liberty may have meant to withhold
(eligibility checks); it moves nothing from other holders, the Vester or the Safe. The USD 12.6k of other tokens the
WLFI contract holds (`onchain.json`) is reachable only by `ownerRescueTokens`, so `value_usd` is left empty.

The token has no other user-signature path: the current implementation's dispatcher has no `permit` selector
(`0xd505accf`), `DOMAIN_SEPARATOR()` reverts, and `delegateBySig` always reverts in V4 (`DelegationMovedToSnapshot`).
The `ERC20Permit` lines in `source-excerpts.md` come from the proxy's Sourcify compilation bundle (which also holds an
`ERC721V1` contract), not from the WLFI implementation.

## Remediation

- World Liberty upgrades the implementation so activation and election vouchers are verified with a post-quantum
  signature (ERC-7913 verifier), or replaces vouchers with an on-chain allow-list written by the owner (the existing
  `ownerActivateAccount` already does this). Safe `0x5be9…7dbb` acts through ProxyAdmin `0x7f53…a0c0`.
- Rotating `authorizedSigner` does not help. No protocol change needed. The Safe owners are ECDSA keys and should move
  to post-quantum signers.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review15): MEDIUM -> LOW, step 4: the voucher only activates or elects for the caller's own account, so nothing can be taken (impact funds-loss -> none, role core -> auxiliary). Held USD 12.6k removed as not the exposure. Checked that the token has no `permit` (no selector in implementation 0x73fe14ff).

# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, block 26,431,555. Proxy `0xda5e1988097297dcdc1f90d4dfe7909e847cbef6`.

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x73fe14ff5a25e4363a72828cccd8444f0748fde7` |
| EIP-1967 admin slot | `0x7f533afa9e994b7e44673188034f9ce52886a0c0` |
| ProxyAdmin `owner()` | `0x5be9a4959308a0d0c7bc0870e319314d8d957dbb` |
| token `owner()` | `0x5be9a4959308a0d0c7bc0870e319314d8d957dbb` |
| Safe `getThreshold()` | 3 (5 owners, `onchain.json`) |
| `authorizedSigner()` | `0x006dad584e68225dae2a45731224b3b48ac57184` (code size 0, nonce 0) |
| `VESTER()` / `REGISTRY()` | `0x74b4f6a2e579d730aacb9dd23cfbbaeb95029583` / `0x4f61a99e42e21ea3c3eaf9b1b30fb80a7900d3ce` |
| `totalSupply()` | 96,722,743,250.5 WLFI |
