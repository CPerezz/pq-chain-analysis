---
id: 53a44954-fixed-signer
title: "0x53a44954: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x53a449540d792dc8f848d8a050e003ef63e348cc"
  family: "6c6906387a9e59e08ca708044601f340"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 7353
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x0000db5c…0000 (EOA)"
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
  note: "No update path; signed payouts die, but the owner's direct withdraw() takes the money out (operator's own money)."
---

## Summary

Unverified payout contract: the fallback pays the caller an amount signed by the constant owner 0x0000db5c8b030ae20308ac975898e09741e70000 (eth_signed_message). If that key takes code, signed payouts stop; the owner can still sweep the ETH with withdraw().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: one selector, withdraw, behind a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: ecrecover STATICCALL at pc 0x361; the result is compared with PUSH18 0xdb5c8b030ae20308ac975898e09741e70000 at pc 0x393; the CALL to CALLER with value follows at 0xa6
- withdraw() (0x3ccfd60b): require(msg.sender == 0x0000db5c…0000) then transfer(address(this).balance); a direct call, no signature
- Owner address cast code 0x (EOA); balance 4.07456 ETH at 26438999; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $7,353 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sweeps with withdraw() and redeploys with a replaceable or PQ-safe signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
