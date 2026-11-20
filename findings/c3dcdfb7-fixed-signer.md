---
id: c3dcdfb7-fixed-signer
title: "0xc3dcdfb7: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc3dcdfb76ee8575e923bef9240cf58a9a7a222e0"
  family: "9736cd82ddb0a9e51ce0a6746e73b6f2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 297
  last_active: 2026-11-13
  recoveries_14d: 411
fix:
  layer: new-deployment
  who_acts: "protocol operator"
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
  note: "Minting dies for good, but nothing is locked in this contract, so MEDIUM."
---

## Summary

NFT wrapper whose wrap (mint) path needs a signature by the constant PROTOCOL_OPERATOR 0x342bf884… (no code). unwrap() is unsigned (it pays a 0.0001 ETH fee), so holders can still exit, and the contract holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly PUSH32 0x342bf88482af5e58c8e2868cd8366d4e571c0a21; decompile wrap: require(recovered == 0x342b…)
- unwrap(uint256) payable requires msg.value == 0x5af3107a4000 and forwards it to EXIT_FEE_RECIPIENT 0x81e0be6b… (an EOA); no signature
- contract ETH balance 0; signer has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 297 transactions called it in the 90 days before that block; last on 2026-11-13.
- 411 signature recoveries in the study's two-week trace window.

## Remediation

Operator deploys a new wrapper with a fresh operator key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
