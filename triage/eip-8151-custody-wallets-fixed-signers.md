---
id: eip-8151-custody-wallets-fixed-signers
title: "Custody wallets whose signers are fixed in code lock other people's money once enough signers take code under EIP-8151"
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- {address: "0x40f9f920ece7cce223625c088a6c1281ef396cf2", family: "41d5f6fd5664c2004bb441bf88ab4aa7", copies: 622, label: "Amina Deposit", upgradeable: "no", rating: HIGH, value_usd: 53099185, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 12, note: "622 multisig wallets holding 29,425 ETH: ordered signatures of owners (getOwners, isOwner, threshold, execute); no function name that changes the owners. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x2cc81b80a293408a89084c77a0983de0730f731a", family: "daae40664b3ee8373c01a402cdc2362c", copies: 31, upgradeable: "no", rating: HIGH, value_usd: 47981982, value_basis: "held", value_as_of: 2026-11-18, note: "31 wallets holding 26,589 ETH: signers in storage (isSigner, signers), a loop of recoveries; no function name that changes them. Bytecode and names. Update path: no proxy slot, no upgrade function."}
- {address: "0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e", family: "c8330e19b6b243e08158ce45883a5cfb", copies: 2, upgradeable: "no", rating: HIGH, value_usd: 36271820, value_basis: "held", value_as_of: 2026-11-18, note: "2 wallets holding 20,100 ETH: a loop of recoveries compared with stored signers (getSigners, THRESHOLD); no function name that changes them. Bytecode and names. Update path: no proxy slot, no upgrade function."}
- {address: "0x8e3a4a7208aa489cc0a1c7290070811b07e60c87", family: "6e908382fcad6bef9b51edcc38f32eae", copies: 83, upgradeable: "no", rating: HIGH, value_usd: 13172210, value_basis: "held", value_as_of: 2026-11-18, note: "83 wallets holding 7,299 ETH in the BitGo pattern: a stored signer other than the caller; no function name that changes signers. Bytecode and names. Update path: no proxy slot, no upgrade function."}
- {address: "0x8c33d309157553d69413d98ea853424689c0c2b1", family: "051d356810ecba1609f75aab780c552a", copies: 2, upgradeable: "no", rating: HIGH, value_usd: 9739334, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 1098, note: "2 multisig wallets holding 5,397 ETH, 1,098 recoveries in the window: ordered owner signatures (isOwner, threshold, execute); no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x14a635549fc5d087d39a0cd1339345b8b8c6fdba", family: "9ede059a8a2cfbc9e4772a1267c1fdc6", copies: 139, upgradeable: "no", rating: HIGH, value_usd: 3067149, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 121, note: "139 wallets holding 1,700 ETH: signers in a stored set (signerNum); no function name that changes them. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0xd1560b3984b7481cd9a8f40435a53c860187174d", family: "f28126df7e445a37a0f093cceab111e3", name: "WalletSimple", label: "COSS.io: Old Warm Wallet", upgradeable: "no", rating: HIGH, value_usd: 393, value_basis: "held", value_as_of: 2026-11-18, note: "BitGo WalletSimple (2017) tagged 'COSS.io: Old Warm Wallet': the second signer must be one of the wallet's signers, fixed at creation; an exchange's wallet. Read. Update path: no proxy slot, no upgrade function."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed key: custodian's wallet"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: [simplemultisig-owner-keys, unidentified-59708733-owner-keys]
reviews: []
---

## Summary

These wallets hold other people's money (exchange and bank deposit addresses, by public tags, or nearly everything in one wallet) behind signers fixed in their code. 7 code families, 880 addresses, $163.3M held, 1,231 recoveries in the study's two-week window. Rows by rating: HIGH 7. 3 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0x40f9f920ece7cce223625c088a6c1281ef396cf2` (Amina Deposit): $53.1M, HIGH, 622 addresses
- `0x2cc81b80a293408a89084c77a0983de0730f731a` (unverified): $48.0M, HIGH, 31 addresses
- `0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e` (unverified): $36.3M, HIGH, 2 addresses
- `0x8e3a4a7208aa489cc0a1c7290070811b07e60c87` (unverified): $13.2M, HIGH, 83 addresses
- `0x8c33d309157553d69413d98ea853424689c0c2b1` (unverified): $9.7M, HIGH, 2 addresses
- `0x14a635549fc5d087d39a0cd1339345b8b8c6fdba` (unverified): $3.1M, HIGH, 139 addresses
- `0xd1560b3984b7481cd9a8f40435a53c860187174d` (WalletSimple): $393, HIGH

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- 2026-11-19: 1 row added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
