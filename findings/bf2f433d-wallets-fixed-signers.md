---
id: bf2f433d-wallets-fixed-signers
title: "0xbf2f433d: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf2f433d62456ca53e386d3dfd3000e4c497d377"
  family: "4db4cbb70fbf7b6a00b327489efe4304"
  copies: 5
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "StarkEx operator/governor of the consumer contract"
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
  note: "Fixed signer set and no update path, but it is a fact registry with no money: if the member key migrates, registering facts dies for good while nothing in this contract is locked → MEDIUM. Whether a live StarkEx deployment still depends on it was not checked. Its governor would swap verifiers there."
---

## Summary

This is not SimpleMultiSig. It is the StarkWare data-availability committee ('StarkWare_Committee_2019_1', identify()), which registers availability facts only when signaturesRequired member signatures recover to members fixed in the constructor. There is no setter. It holds no funds.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompiled: verifyAvailabilityProof-style 0x504f7f6f ecrecovers each 65-byte sig, requires member (mapping slot 3) and ascending order ('NON_SORTED_SIGNATURES','AVAILABILITY_PROVER_NOT_IN_COMMITTEE'); no SSTORE to members/threshold outside constructor
- Creation tx 0x86eccd4b…bec (block 9539581, deployer 0x524f70e5…): constructor args members=[0xb2849cbc25853685bfc4815ab51d28e810606a48], signaturesRequired=1; slot2=1 at block 26438999
- Member 0xb2849cbc… has no code today (EOA, nonce 0); contract ETH balance 0 at 26438999; slot1 flag=1 (a fact was registered once)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The consumer (a StarkEx contract's governor) registers a new committee or availability verifier. This committee cannot be changed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
