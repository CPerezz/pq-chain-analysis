---
id: c97c01ab-rotate-signer-before-migrating
title: "0xc97c01ab: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc97c01ab261abeee8c633065e560cf46b09ea5a1"
  family: "04f45214f6eed1989c741de3c2cc02cf"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4
  last_active: 2026-11-05
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "the congress address replaces the signatory"
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
  rating: LOW
  note: "Not a fixed signer: the signatory in slot 0 has a setter, 0xb80caf54(address), callable by the congress address in slot 1, so it rotates before the key takes code: LOW under the rotation root issue. Not read: whether the congress address is live at block 26,438,999."
---

## Summary

The stored signatory (slot 0) has a setter: 0xb80caf54(address) is callable by the congress address in slot 1, ChainportCongress. The contract is a pure verifier (verifySignature returns a bool) and holds nothing. Its caller pulls the user's own tokens in the same tx.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: four selectors: one stored signatory, no setter. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompile: b80caf54 does require(msg.sender==congress(slot1)); require(arg!=signatory); then writes slot 0. daca6f78 verifySignature returns recovered==signatory.
- Slots at block 26438999: slot0 = 0x75187213 (EOA, nonce 0, no code), slot1 = 0xb6b4c7ac (12,657-byte ChainportCongress: propose/execute arbitrary actions via a members registry and quorum).
- Trace of tx 0xbb94bbc9: the caller 0xc2b3debf staticcalls daca6f78 (returns true), then transferFroms WBTC from the user and swaps it via LiFi. No funds rest in c97c01ab.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-05.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Congress replaces the signatory with b80caf54 (to a new ECDSA key, or a fix by upgrading the caller) before 0x75187213 takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-rotate-signer-before-migrating` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
