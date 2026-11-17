---
id: unidentified-7d3201fa-signer-key
title: "ERC-4337 token paymaster 0x7d3201fa (EntryPoint v0.7, operator unidentified): a quantum attacker who recovers the sponsor-signer key can have the paymaster pay gas for any UserOperation, but its EntryPoint deposit is empty and it has been idle since June 2026"
project: unidentified-7d3201fa
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x7d3201fa7a85c0a5f9fa1c0c6b9d0b784368d2ac"
  implementation: null
  name: Paymaster (EntryPoint v0.7 token paymaster)
  upgradeable: config-only
  admin: "owner Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f (3 of 6): updateSigner, updateTreasury, withdrawTo, stake; read at block 26431610"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-06-05
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "The paymaster's operator, owner Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f (3 of 6): deploy a paymaster that verifies sponsorship through ERC-1271/ERC-7913 and stop funding this one"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/unidentified-7d3201fa-signer-key/classification.jsonl
  - evidence/unidentified-7d3201fa-signer-key/onchain.json
  - evidence/unidentified-7d3201fa-signer-key/activity.json
  - evidence/unidentified-7d3201fa-signer-key/source-excerpts.md
  - evidence/unidentified-7d3201fa-signer-key/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, cast reads at block 26431610
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This ERC-4337 v0.7 paymaster sponsors a UserOperation's gas from its EntryPoint deposit when an off-chain signer EOA
(`0x5437edbb…`) has signed the operation, checked with `ecrecover` only (PQ-4); the user then pays a signed token
amount to the treasury. A quantum attacker who recovers the signer key can sign sponsorships with a zero token charge
and spend the whole deposit on gas. The deposit is 0 today and the paymaster has had no activity since 2026-06-05,
after 751,773 sponsored transactions in the year to March 2026. Rated LOW, step 5: a new deployment would be MEDIUM,
lowered one level because $0 is exposed.

## Mechanism

- `validatePaymasterUserOp` → `_validatePaymasterUserOp` (`Paymaster.sol` lines 82–108) reads (validUntil,
  validAfter, token, amount, signature) from `paymasterAndData`, requires a 65-byte signature and returns
  `SIG_VALIDATION_FAILED` unless `ECDSA.recover(toEthSignedMessageHash(getHash(userOp, …, token, amount)))` equals
  `signer`. The EntryPoint then charges the gas to the paymaster's deposit.
- `_postOp` (lines 110–120) pulls `amount` of `token` from `userOp.sender` to `treasury`. The sender is the account
  that validated the operation itself, so a forged sponsorship cannot pull another user's tokens.
- `updateSigner` (owner only) rotates the key but not the scheme. Pattern PQ-4.

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): the paths above
  ([`notes.md`](../evidence/unidentified-7d3201fa-signer-key/notes.md), [`source-excerpts.md`](../evidence/unidentified-7d3201fa-signer-key/source-excerpts.md)).
- CHECKED (cast at block 26,431,610): `signer()` = EOA `0x5437edbb…`; `treasury()` = `0x480a825b…` (`PaymasterBuffer`);
  `owner()` = Safe `0x8cef85a5…` (threshold 3, 6 owners); `entryPoint()` = v0.7 EntryPoint `0x00000000717…`;
  `getDeposit()` = 0, EntryPoint `getDepositInfo` all zero (no stake).
- CHECKED (block 26,431,214): the contract holds nothing ([`onchain.json`](../evidence/unidentified-7d3201fa-signer-key/onchain.json)).
- CHECKED (Xatu): last transaction 2026-06-05, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/unidentified-7d3201fa-signer-key/activity.json)); precompile trace, year to March
  2026: 751,773 transactions calling `ecrecover`, $784M moved in them (`curated_contracts.csv`).
- CHECKED (attribution attempts): Blockscout names and tags for the deployer (an EIP-7702 EOA `0xd87df9fd…`), treasury,
  Safe and signer; Sourcify metadata; web search. The same addresses are used on BSC, Arbitrum, Polygon and Base; no
  project is named. Operator unidentified.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7d3201fa…` Paymaster | config-only | $0 (EntryPoint deposit) | 2026-06-05 | 0 |

- Escrow: the paymaster's EntryPoint v0.7 deposit, 0 ETH at block 26,431,610. If the operator funds it again, a forged
  signer could spend all of it on gas.
- Users' token approvals to the paymaster cannot be pulled through a forged sponsorship (the sender authorises its own
  operation).

## Remediation

- Replacement: a paymaster that verifies sponsorship through ERC-1271/ERC-7913 (so a post-quantum signer account can
  approve), or an on-chain sponsorship policy; then stop funding this one.
- Who acts: the operator, owner Safe `0x8cef85a5…` (3 of 6). No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 5: EntryPoint deposit (the escrow) is 0 at block 26,431,610; idle since 2026-06-05. Signer, treasury and owner read; operator still unidentified (Blockscout, Sourcify, web search tried).
