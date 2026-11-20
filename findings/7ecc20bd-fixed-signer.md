---
id: 7ecc20bd-fixed-signer
title: "0x7ecc20bd: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7ecc20bd537b6fd03262cc2fbd1322a14293ef72"
  family: "8bfeb924fccea3319f5719e65c4159d4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Owner (0x325c5e207e982191a97c33748c5b8cc65244786f) via sweep"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The study note calls this a presale with deposits, but the source has no deposit function: it is a signed claim of the contract's own tokens. The signer address was matched by elimination from the bytecode values and was not read from a getter. The claim window ended at timestamp 1654041600, so claim is already inactive for unrelated reasons."
---

## Summary

The signer is an immutable with no setter and has no code today, so the claim is confirmed. If the signer key's account got code, only the signed claim would stop. The tokens are operator stock that the owner can sweep, so nothing is locked: MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner` is assigned only in the constructor
- claim: `require(ecrecover(digest, v, r, s) == cSigner)`
- The only address-shaped bytecode value besides the contract itself and 0xff..ff is 0x0aeefc3490fee05b4d14640a2a5452441fafdd1a, which is an EOA (no code) today
- sweep(dest) is onlyOwner after claimPeriodEnds=1654041600 and transfers balanceOf(address(this))

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No fix is needed. The claim period has already ended, and the owner can sweep the remaining stock.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
