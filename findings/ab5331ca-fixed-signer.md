---
id: ab5331ca-fixed-signer
title: "0xab5331ca: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xab5331cafe1d35e8cde3a44088554989ad45cf32"
  family: "24e26c2132d6eac314b5f9c093ef91c2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project/owner would have to deploy a new contract, or keep the signer key free of non-delegation code."
evidence:
  level: bytecode
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
  note: "The signer address is the same as the current owner(), but the code compares the signature to the literal address, not to the owner slot. So transferring ownership does not change who can sign. Rated MEDIUM because only the signed mint of new NFTs stops and no funds are locked."
---

## Summary

The private-sale mint accepts signatures only from the hard-coded EOA 0xa6e2…e11e4, and the contract has no upgrade path. If that account gets real code, signed mints stop. No money is locked: payments are taken only when a mint succeeds, shareholder payouts (release) need no signature, and holders can still redeem and transfer their NFTs.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- In Unresolved_92eca5b4 (the mint): require(0xa6e236fb3180df394afb3c7a691993f1971e11e4 == recovered, "Invalid Signature"), followed by tokenIdCurrent += 1 and a mint to msg.sender.
- Unresolved_a0e34a75 returns whether the recovered address equals the same literal, 0xa6e236fb…e11e4.
- Verified bytecode facts: 0xa6e236fb3180df394afb3c7a691993f1971e11e4 is an EOA with no code and is not delegated.
- transferOwnership and renounceOwnership write only the owner slot 0x0c; no function writes a signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key 0xa6e2…e11e4 as an EOA or a 7702-delegated account. If signed minting has to work after the key gets code, deploy a new contract with a signer that can be replaced or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
