---
id: 8cba172c-fixed-signer
title: "0x8cba172c: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8cba172c65a94892726450ff67b2027e6c352e2c"
  family: "68182234dc16d272f287ca18e4aa889b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Owner can turn on public mint through toggleSale instead; no fix is needed for funds"
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
  note: "The study note calls this a presale with signed deposit and claim. The code shows only a signed NFT allowlist mint (mintPresale). It has no deposit or claim function."
---

## Summary

The presale signer is a hardcoded address with no setter and no code today (an EOA). If it got code, only the signed presale mint would stop. Nothing is locked, because payment and mint happen in one transaction and the owner can withdraw ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _verify compares the recovered address to the literal 0x8f20d89bEe77ea2AbBaF46b5DEF3Ef109ab9d358
- No function writes the signer. The only listed setter is transferOwnership, which changes the owner
- The signer address has code_bytes 0 and is not delegated, so it is an EOA
- mintPresale is the only function that calls _verify

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

If the signer key ever gets code, the owner can open public sale with toggleSale/mint to replace the allowlist mint

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
