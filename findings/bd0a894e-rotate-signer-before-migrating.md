---
id: bd0a894e-rotate-signer-before-migrating
title: "0xbd0a894e: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbd0a894e8f8919be0b9eb0f034d1db4e1ac415cf"
  family: "f2d6dbad3cf0b59e3e1f7ce70695ba42"
  copies: 4
  upgradeable: "yes"
  admin: "vault owner 0x1612 (controlled by Safe 0x36BB 2/3)"
  rating: LOW
  value_usd: 30497
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3445
  last_active: 2026-11-18
  recoveries_14d: 1561
fix:
  layer: onchain-config
  who_acts: "Safe 0x36BB (2/3) via 0x1612.setSignerByOwner"
evidence:
  level: bytecode
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
  verdict: confirmed
  rating: LOW
  note: "Live Safe-controlled setter path exists; owner also holds direct withdraw and UUPS upgrade."
---

## Summary

SolverVault UUPS proxy: execute requires an EIP-712 signature recovered to the stored signer (slot 0, 0xf822…cb6f, nonce 0). If that key takes code, signed executes fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner 0x6c19e783 is owner-only (reading.first.json); vault owner() = 0x1612…8fde, a 7711-byte admin/executor contract
- 0x1612 setSignerByOwner(address) requires msg.sender == its owner and forwards setSigner (0x6c19e783) to its targets (heimdall decompile); its generic execute explicitly blocks 0x6c19e783
- 0x1612 owner() = Safe 0x36BB…fd6f, threshold 2 of 3 owners, all EOAs with nonces 6/119/151 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $30,497 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 3,445 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,561 signature recoveries in the study's two-week trace window.

## Remediation

Safe 0x36BB calls 0x1612.setSignerByOwner(newKey) before the signer key migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
