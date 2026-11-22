---
id: 9476a7ee-fixed-signer
title: "0x9476a7ee: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9476a7eebb2382169ec48e90fb05c33d96cea7f2"
  family: "d1492378bd460b7e0b826f99411b573d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-10-14
fix:
  layer: onchain-config
  who_acts: "Owner, by switching to the public sale (toggleSale) instead of the signed presale"
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
  note: "Rated MEDIUM because only the minting of new NFTs stops. Nothing already held is locked."
---

## Summary

The presale mint signer is a hardcoded constant address and nothing can replace it. That address has no code today. If it ever gets real code, signed presale mints stop working. No funds get locked: the owner can still withdraw ETH, holders can still transfer their NFTs, and the public mint() needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _verify compares the recovered address to the literal 0x8f20d89bEe77ea2AbBaF46b5DEF3Ef109ab9d358
- The row facts give code_bytes = 0 and delegated = false for that constant
- No setter exists for the signer; the only setter listed is transferOwnership, which changes the owner
- mintPresale requires _verify(_hash(msg.sender), signature)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-14.

## Remediation

If the signer address gets code, the owner can turn off the presale and turn on the public sale with toggleSale(). Adding a signer setter would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
