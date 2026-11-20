---
id: 859f912e-fixed-signer
title: "0x859f912e: signer fixed in code"
status: confirmed
severity: CRITICAL
patterns: [PQ-17]
impact: funds-loss
contracts:
- address: "0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae"
  family: "354598d4dfa46f57470f533d99ff0c1a"
  copies: 7
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 2727
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "channel signator 0xd2ff…21d5 (do not give it code)"
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
  rating: CRITICAL
  note: "CRITICAL: no update path, and the counterparty, who relied on signed payments and did nothing, loses them once the payer's address gets code; this is the relied-on-signature case. Main reviewer: check whether you prefer HIGH (deposit locked) and eip-8151-signature-rechecked as the root issue."
---

## Summary

A one-way payment channel: every exit (two counterparty settlements, and withdraw after 387 idle days) requires a message signed by the signator stored at construction (slot 1, no setter). If the signator's address takes code, the counterparty cannot redeem payments it was already given, and the remaining deposit is stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a pausable withdrawal contract (7 addresses, 1.5 ETH). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: 29f1c849 and f54d8539 require msg.sender == counterparty and recovered == signator ('Message signer must be signator to this channel'); withdraw(address,address,uint256,uint256,bytes) needs the same recovery after a 387-day wait
- No function writes the signator; the pause functions only pause
- Storage at 26438999: signator 0xd2ffe8f8…21d5, counterparty 0x3ef230bc…c859, both without code; balance 1 ETH

## Impact and exposure

- Value held at block 26,438,999: $2,727 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The signator settles or closes the channel before its address takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
