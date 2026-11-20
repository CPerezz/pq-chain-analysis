---
id: a39d1e9c-fixed-signer
title: "0xa39d1e9c (tagged deployed by ACO Factory: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa39d1e9cbecdb17901bfa87a5b306d67f15a2391"
  family: "9990d40fae72fe6749e168d5b955b77b"
  label: "deployed by ACO Factory: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0xc25a...9155) withdraws the stock and redeploys with a new signer"
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
  note: "The signed claims are operator-funded distributions and the owner can rescue the stock. Only the claim function stops."
---

## Summary

The signer is immutable and is an EOA today. If its account gets real code, claims stop. The tokens are not locked, because the owner can take them out with withdrawToken.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address immutable public signer`, set only in the constructor
- isValidMessage: `require(signer == ecrecover(...))`, with no code check and no ERC-1271 path
- No function writes signer; the contract is not upgradeable
- signer 0xe52d0cf0a254c66e1259495b116bd48ab47c0924 is an EOA with no code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before the signer key gets code, the owner withdraws the tokens with withdrawToken and redeploys with an ERC-1271-aware or replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
