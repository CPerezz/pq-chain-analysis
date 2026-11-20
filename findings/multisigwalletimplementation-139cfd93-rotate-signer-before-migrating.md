---
id: multisigwalletimplementation-139cfd93-rotate-signer-before-migrating
title: "MultiSigWalletImplementation: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3"
  family: "ac6dda8cbb1f6e19498534e48949fcd8"
  copies: 32
  name: "MultiSigWalletImplementation"
  upgradeable: "yes"
  rating: LOW
  value_usd: 4772520
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 345
  last_active: 2026-11-03
fix:
  layer: onchain-config
  who_acts: "multisig owners (3 of 8)"
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
  verdict: confirmed
  rating: LOW
  note: "LOW only as rotate-before-migrate; after migration it can lock. Reviewer attention."
---

## Summary

MultiSigWalletImplementation: sorted owner ECDSA signatures, at least `required`, with no ERC-1271. A defect leaves only transaction 0 on the direct path, so rotation needs ECDSA signatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: MultiSigWalletImplementation: sorted owner signatures, at least `required`, by ECDSA only. Read from source.
- getOwners() = 8, required() = 3 at the block
- reading ac6dda8c: owner rotation needs `required` ECDSA signatures; locks if more than 5 of 8 migrate first

## Impact and exposure

- Value held at block 26,438,999: $4.8M (ETH and 49 priced tokens, over 32 addresses).
- Activity: 345 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

Owners rotate keys through a 3-signature transaction before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
