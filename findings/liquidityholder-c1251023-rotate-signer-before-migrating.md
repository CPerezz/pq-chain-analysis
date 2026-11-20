---
id: liquidityholder-c1251023-rotate-signer-before-migrating
title: "LiquidityHolder: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc1251023f4a5863503d68e0dbdf9c65ff1cbf05c"
  family: "a4475c1389270c31e8546a7d9fdc58fd"
  name: "LiquidityHolder"
  upgradeable: "no"
  rating: LOW
  value_usd: 13354
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 121
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "the verifier key 0x1d1b2189e7d71d4ab81962b71cfe393231024295 itself"
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
  note: "LOW: the key holder can rotate itself. If that key were lost there would be no other path, but that is not an EIP-8151 effect."
---

## Summary

LiquidityHolder: buyback params need EIP712Verifier.recover == verifier. A verifier with code stops buybacks.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address, or compares it with an address its caller passes in. Read from source.
- LiquidityHolder.sol:127-128: signer == verifier
- LiquidityHolder.sol:114-116: updateVerifier requires msg.sender == verifier (self-rotation only)
- verifier 0x1d1b21… is a codeless address with nonce 0 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $13,354 (ETH and 49 priced tokens).
- Activity: 121 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The verifier calls updateVerifier(newKey) from its own account before taking code. A 7702 delegation also keeps working.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
