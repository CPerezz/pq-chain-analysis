---
id: usual-usd0pp-permit
title: "Usual bUSD0 (USD0++): permit accepts only ECDSA signatures, so a quantum attacker who recovers a holder's key can approve and take that holder's tokens, even after the holder moves to post-quantum authorisation; up to $489M in holders' balances"
project: usual
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0x35d8949372d46b7a3d5a56006ae77b215fc69bc0"
  implementation: "0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b"
  name: TransparentUpgradeableProxy → Usd0PP ("Bond USD0", bUSD0)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22, owned by Safe 0xaada24358620d4638a2ee8788244c6f4b197ca16 (8 of 15), read at block 26431619"
  value_usd: 488989125
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1318
families: []
fix:
  layer: contract-upgrade
  who_acts: "Usual Safe 0xaada24358620d4638a2ee8788244c6f4b197ca16 (8 of 15), owner of ProxyAdmin 0x65a7042460932a8e7b6aa9c765c2bae5f4535c22, upgrades Usd0PP to a permit that checks account code first (ERC-1271 with the full signature)"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/usual-usd0pp-permit/classification.jsonl
  - evidence/usual-usd0pp-permit/onchain.json
  - evidence/usual-usd0pp-permit/activity.json
  - evidence/usual-usd0pp-permit/source-excerpts.md
  - evidence/usual-usd0pp-permit/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0x9f2bd21b, cast reads at block 26431619, Blockscout token data
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Usual's bUSD0 token (formerly USD0++) inherits OpenZeppelin's `ERC20PermitUpgradeable`, whose `permit` accepts only an
ECDSA signature from the holder's address (PQ-1). A quantum attacker who recovers a holder's key from a past signature
can sign a permit for the whole balance and transfer it, and this keeps working after the holder moves the address to
post-quantum account code; post-quantum accounts cannot use `permit` at all (plain `approve` still works). The upper
bound is the holders' balances, $489.0M (market cap, 2026-11-17). Rated MEDIUM, step 4: an 8-of-15 Safe can upgrade
the token.

## Mechanism

- `permit(owner, spender, value, deadline, v, r, s)` (`ERC20PermitUpgradeable.sol` lines 49–70 in the excerpt): EIP-712
  hash of the permit with the owner's nonce, `ECDSA.recover(hash, v, r, s)` must equal `owner`, then `_approve`. There
  is no `isValidSignature` path and no code check anywhere in the implementation's sources.
- `mintWithPermit` and `unlockUSD0ppWithUsualWithPermit` (`Usd0PP.sol` lines 197–206, 370–384) call `permit` on the USD0
  and USUAL tokens for `msg.sender` inside `try/catch`; those checks live in the other tokens and are not part of this
  finding.
- Pattern PQ-1 (user signature checked with ECDSA only).

## Evidence

- CHECKED (Sourcify full source of implementation `0x9f2bd21bf8012fce0d5845537c1deff3a89bc85b`, read 2026-11-17):
  `Usd0PP` inherits `ERC20PermitUpgradeable` without overriding `permit`; no source file mentions `isValidSignature` or
  `SignatureChecker` ([`source-excerpts.md`](../evidence/usual-usd0pp-permit/source-excerpts.md)).
- CHECKED (cast at block 26,431,619): EIP-1967 implementation `0x9f2bd21b…`, admin `0x65a70424…`; ProxyAdmin `owner()` =
  Safe `0xaada2435…`, threshold 8 of 15; `name()` = "Bond USD0", `symbol()` = "bUSD0"; `totalSupply()` = 500,077,104
  tokens ([`notes.md`](../evidence/usual-usd0pp-permit/notes.md)).
- CHECKED (Blockscout token data, 2026-11-17): price $0.9778, circulating market cap $488,989,125, 2,652 holders.
- CHECKED (Xatu, any function): 1,318 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/usual-usd0pp-permit/activity.json)); precompile trace, year to March 2026: 2,907
  transactions calling `ecrecover`, $53.2M moved in them (`curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x35d89493…` TransparentUpgradeableProxy → Usd0PP (bUSD0) | yes | $489.0M (market cap) | 2026-11-15 | 1,318 |

- Exposure: each holder's own balance, for holders whose key has signed on-chain; the market cap is the upper bound.
  Balances held by contracts without an ECDSA key (pools, vaults, Safes) cannot be permitted away.
- Not in this finding: the USD0 and USUAL token permits that the wrappers consume.

## Remediation

- Replacement: upgrade `Usd0PP` so `permit` checks account code first and verifies contract signers through ERC-1271
  with the full signature (OpenZeppelin `SignatureChecker`, current version, i.e. the PQ-13 pattern), and accepts
  `bytes` signatures.
- Who acts: Usual Safe `0xaada2435…` (8 of 15) through ProxyAdmin `0x65a70424…`.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for addresses that have real account code, protecting
  migrated holders without the upgrade. Holders can protect themselves today by moving bUSD0 to a fresh post-quantum
  account (a migrated address keeps its old ECDSA key here).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review12): MEDIUM -> MEDIUM, step 4: upgrade by Safe 0xaada2435 (8 of 15) via ProxyAdmin 0x65a70424. Market cap updated to $489.0M (Blockscout, 2026-11-17); token now named "Bond USD0" (bUSD0).
