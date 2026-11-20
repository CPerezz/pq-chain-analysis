---
id: 0b6cdc0d-fixed-signer
title: "0x0b6cdc0d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0b6cdc0d2b465883b07d26c4793965ee60717baf"
  family: "7b243c45c16604b6c304f57051f16c5b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator / owner redeploys with a new signer."
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
  note: "The body of 0x1fa7fe04 is cut off in the decompilation. MEDIUM assumes settlement in the same transaction, which the payable function plus the creaToken transferFrom suggest, with no balance held for users. The study note's 'deposit and claim' wording is generic."
---

## Summary

The quote signer is a hard-coded constant (0xa45a…7e), an EOA today, and nothing can replace it. If that account gets code, signed quotes stop recovering and sales stop. Payment and settlement happen in one transaction, so no user balance is left locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant quoteSigner = 938303469500304773065648507096710949361096596862 decodes to 0xa45afb9562eb3e0dfeed89d090c07fd5b5d41d7e, which is an EOA (no code) at block 26438999
- QUOTE_TYPEHASH constant and eip712Domain() (0x84b0196e) show EIP-712 signed quotes
- 0x1fa7fe04 checks: nonReentrant (store_f), !paused, deadline >= block.timestamp, !consumedQuotes[arg0], arg1 == msg.sender
- Only setters: transferOwnership/acceptOwnership/renounceOwnership, which write the owner slot (store_d/store_b) and never the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract with a signer that can be rotated or that supports ERC-1271, and keep the signer key as a plain EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
