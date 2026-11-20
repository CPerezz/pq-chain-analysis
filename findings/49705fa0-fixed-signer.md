---
id: 49705fa0-fixed-signer
title: "0x49705fa0: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49705fa01a7952dd1b7c2ddfe432c650520c74f9"
  family: "199b82694a03bdba208e91a1181e937a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0xad00eb5dc02e56d628d68abd144b8c223a6cf1ef) would deploy a new consumer that has a replaceable signer. The registry owner would then hand registry ownership to it."
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
  note: "The study_note's description ('Presale: deposit and claim') does not match this verified source, which is a proof-of-reserve oracle consumer. The rating is based on the code shown. The signer is RedStone's public demo key."
---

## Summary

The only accepted oracle signer is a hardcoded constant: the RedStone demo signer 0x0C39…d7eb. It is an EOA today (0 bytes of code, no delegation). The code has no setter for it, no code check and no ERC-1271 path. If that account ever gets real code, submitProof stops working. No funds are held, so only the proof-update function stops: MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MainDemoConsumerBase.getAuthorisedSignerIndex: the signer is a hardcoded literal; any other address reverts with SignerNotAuthorised
- SignatureLib.recoverSignerAddress returns the plain ecrecover(signedHash, v, r, s) result, with no ERC-1271 fallback
- Row facts: constant 0x0c39486f770b26f5527bbbf942726537986cd7eb has code_bytes 0 and delegated false
- The only setters are transferOwnership (owner) and updateRegistry (registry address); neither touches the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new consumer whose authorised signer can be changed by an admin, or override getAuthorisedSignerIndex in the new deployment. Then point the registry's ownership at the new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
