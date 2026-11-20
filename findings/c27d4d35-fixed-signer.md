---
id: c27d4d35-fixed-signer
title: "0xc27d4d35: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc27d4d350be3dfb83b13dee076ba158442aaeb71"
  family: "44431c2615e1693b07931e6d75b05742"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "n/a — contract is already abandoned"
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
  note: "Deposit dies for good once the signer has code, but the contract holds no ETH today and never had a path to return any that was deposited, so nothing new is locked by EIP-8151 here."
---

## Summary

ETH presale-deposit contract with a literal Solidity ecrecover() call gating its only deposit function, compared against a hardcoded SIGNER (0x7db29fc4...) with no setter. Ownership is already renounced (owner()==0) and no claim/withdraw function ever existed for depositors or an operator, so whatever ETH is in the contract is already stuck independent of EIP-8151; current balance is 0.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Heimdall decompile shows, verbatim: `address var_r = ecrecover(...); require(address(var_r) == 0x7db29fc4c61436eece59b3540e2ee4f0e5376024, "INVALID_SIGNATURE")` inside the only payable function.
- owner() returns the zero address (renounced) and no withdraw/claim selector exists anywhere in the 9-selector ABI.
- cast balance on this contract at the pinned block returns 0; cast code on the SIGNER constant is empty.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none meaningful — contract has no admin and no exit path regardless of EIP-8151

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
