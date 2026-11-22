---
id: 075af085-rotate-signer-before-migrating
title: "0x075af085: signer key to rotate before its account takes code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x075af08596c26a81384e1f06757f96c96bb1e896"
  family: "d1083aa323d2dd158ab763482c13500c"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 387619
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-20
fix:
  layer: new-deployment
  who_acts: "validators (must keep their keys code-free)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "An earlier pass's HIGH holds: there is no setter for weights or the validator set, no upgrade, and no owner or rescue withdrawal, so the funds are locked if validators with more than half of the weight take code."
---

## Summary

Unverified weighted-validator custody vault (212.38 ETH, 462 LINK and 30 DAI at block). withdrawBySigns pays out only when recovered validators hold more than half of totalVoteWeight (445,000,000). Under EIP-8151 a validator whose key takes code loses its weight; if enough do, payouts stop, and the funds have no other exit.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: withdrawals by signatures weighed by vote weights. Bytecode and names.
- Own disassembly at block 26438999: the runtime has six SSTOREs, which write the slot-4 used-txid flag, the slot-1 balance mapping (×4) and slot 0 (owner). None writes the slot-2 weight mapping or slot-3 total, so weights are fixed at construction
- Value CALLs at 0x1870/0x1ae5 are reached only from the withdraw body region (0xedc–0xf66) after the weight test; other CALLs are token metadata reads (createasset), the transferFrom used by deposits, and ecrecover (0xe5b). No DELEGATECALL, no proxy
- owner()=0xecba1d33…c79c (EOA, nonce 456 at block) can only transferOwnership; balance 212.383 ETH at block

## Impact and exposure

- Value held at block 26,438,999: $387,619 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-20.

## Remediation

Validators must not put code on their keys; otherwise none on-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
