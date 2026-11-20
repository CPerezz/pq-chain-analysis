---
id: adae0dda-fixed-signer
title: "0xadae0dda (tagged Pixelmon: ES Token): signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xadae0ddaf90170a44adebcfb8eede12041d13220"
  family: "bb43845522c3bfcb8bd9f26ead25ea92"
  label: "Pixelmon: ES Token"
  upgradeable: "no"
  rating: NONE
  txs_90d: 33
  last_active: 2026-11-13
fix:
  layer: none
  who_acts: "n/a"
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
  verdict: refuted
  rating: NONE
  note: "A contract address has no private key, so no genuine ECDSA signature could ever recover to it; this claim path was already unusable before EIP-8151, matching the refuted criterion 'the expected signer already has real code today'."
---

## Summary

ERC1155-style claim/transfer contract whose signature check compares the ecrecover result against a fixed PUSH20 constant (0x813f10ab...) that is itself a 171-byte deployed contract today, not an EOA.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode at 0x5f8 and 0xb7f: PUSH20 0x813f10aba9624d2f4b3130a1ecd26da2bb2d09d4, compared via EQ right after the STATICCALL-to-1 ecrecover block gating claim().
- cast code on 0x813f10ab... at block 26438999 returns 171 bytes of ordinary contract code, not an EIP-7702 delegation indicator.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 33 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
