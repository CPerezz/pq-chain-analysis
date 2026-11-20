---
id: levelstakingpool-7fda203f-rotate-signer-before-migrating
title: "LevelStakingPool: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7fda203f6f77545548e984133be62693bcd61497"
  family: "7353bc706d6e13ab247ac5b08a9acc7c"
  name: "LevelStakingPool"
  label: "Level Money : Level Staking Pool"
  upgradeable: "no"
  rating: NONE
  value_usd: 9564
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 21
  last_active: 2026-11-14
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The ERC-1271 fallback handles a signer with code (if it implements 1271), so the claim is refuted."
---

## Summary

LevelStakingPool migrateWithSig checks the staker and levelSigner signatures through OZ SignatureChecker.isValidSignatureNow, which falls back to ERC-1271 when ECDSA fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: migrateWithSig (read whole): called by the owner with the staker's signature, checked by SignatureChecker (ECDSA or the staker's ERC-1271) / SignatureChecker on a signer kept in storage (ECDSA, or…. Read from source.
- LevelStakingPool.sol:150 and :202 use SignatureChecker.isValidSignatureNow(_user / levelSigner, …)
- SignatureChecker.sol:22-26: ECDSA match
- isValidERC1271SignatureNow(signer, …)
- setLevelSigner is onlyOwner (line 286); owner 0x343ACce7… is a Safe, 3 of 6 owners

## Impact and exposure

- Value held at block 26,438,999: $9,564 (ETH and 49 priced tokens).
- Activity: 21 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

None needed. A signer with code signs through ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
