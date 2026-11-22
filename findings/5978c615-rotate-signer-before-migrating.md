---
id: 5978c615-rotate-signer-before-migrating
title: "0x5978c615: signer key to rotate before its account takes code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5978c6153a06b141cd0935569f600a83eb44aeaa"
  family: "6022f261f96f1d4ad41dcb1aea7e96fc"
  upgradeable: "no"
  rating: HIGH
  value_usd: 737885
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 354
  last_active: 2026-11-16
  recoveries_14d: 17
fix:
  layer: new-deployment
  who_acts: "operator (must keep the slot-0x0b withdrawal signer code-free)"
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
  rating: HIGH
  note: "An earlier pass's HIGH holds: the named setter writes a different slot from the signer that is checked, there is no proxy or upgrade, and user withdrawals have no path without that signature, so the funds would be locked."
---

## Summary

Unverified custodial deposit/withdraw vault (381.58 ETH plus 0.766 WBTC at block). withdraw and withdrawERC need one signature from the address in storage slot 0x0b. Under EIP-8151, if that key takes code, every withdrawal reverts and the funds have no other way out.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changePubKey). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- Own disassembly at block 26438999: slot 0x0b is only read (pc 0x53f getter, pc 0xc20 validation); no SSTORE writes it. changePubKey (0x8b93f545) is admin-only (immutable 0x96996f23…87f3), allowed only 180 days (0xed4e00) after the slot-7 activity timestamp, and writes the bytes at slot 0x0a, not slot 0x0b
- Only two value-moving CALLs: pc 0x427 (ETH, in withdraw, after the validation jump at 0x389) and pc 0x1502 (SafeERC20, reached from depositERC and from withdrawERC after the validation at 0xa1b). The admin can only pause, resume, reset the limit and changePubKey; there is no rescue path
- At block: slot 0x0b = 0x1620e292…7abb (EOA, nonce 0); admin 0x96996f23… EOA, nonce 19; balance 381.578 ETH; WBTC 0.7657

## Impact and exposure

- Value held at block 26,438,999: $737,885 (ETH and 49 priced tokens).
- Activity: 354 transactions called it in the 90 days before that block; last on 2026-11-16.
- 17 signature recoveries in the study's two-week trace window.

## Remediation

The withdrawal key must stay code-free (an EIP-7702 delegation is fine). Otherwise none on-chain: the admin cannot change slot 0x0b.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
