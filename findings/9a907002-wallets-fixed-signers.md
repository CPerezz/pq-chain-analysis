---
id: 9a907002-wallets-fixed-signers
title: "0x9a907002: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9a9070028361f7aabeb3f2f2dc07f82c4a98a02a"
  family: "0ca31f97d37a26ece5b7d0f7b2d1838d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "none (geth no longer reads it)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Oracle feed with fixed signers, nothing locked → MEDIUM."
---

## Summary

Not a wallet: verified go-ethereum CheckpointOracle. SetCheckpoint requires an admin caller plus threshold admin signatures recovered by ecrecover; admins fixed in constructor, no setter; holds no money.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SetCheckpoint: admins[msg.sender] and each ecrecover result must be admin; no admin setter (heimdall, 4byte)
- GetAllAdmin = 0x1b2c…0527, 0x78d1…9595, 0x2868…b0e7, 0xb86e…9f8e (listed twice), all EOAs; threshold slot7 = 2; latest checkpoint index 396 at block 13,016,616 (2021) (latest, block ~26452900, publicnode; admins/threshold have no setter)
- ETH 0, no proxy
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed in practice (oracle unused since 2021); a new oracle would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
