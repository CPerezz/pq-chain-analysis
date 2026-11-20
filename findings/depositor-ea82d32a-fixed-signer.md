---
id: depositor-ea82d32a-fixed-signer
title: "Depositor: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xea82d32ab1d3775380ccdbc03f8c0a5160c0c0fa"
  family: "17cf4366c76ef8cbab369476b627e861"
  name: "Depositor"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "any depositor: call the canonical ETH2 deposit contract directly"
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
  rating: LOW
  note: "Downgraded from the study's HIGH: the same act (depositing 32 ETH to the canonical contract) stays open to the affected party by a direct call that needs no signature at all -> LOW."
---

## Summary

Depositor.batchDeposit requires an outer signature from the immutable `authority`, no setter. It is a convenience wrapper that forwards msg.value straight into the canonical ETH2 DepositContract in the same call (no escrow). If `authority` gets code, batchDeposit breaks, but anyone can call the canonical DepositContract's deposit() directly with the same pubkey/signature/depositDataRoot and achieve the exact same act (becoming a validator) without going through this wrapper at all.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Depositor batchDeposit: each deposit must be signed by `authority`, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Depositor.sol:21-31: authority immutable, ecrecover(... ) == authority required before calling depositContractAddress.deposit (dossier source)
- Depositor.sol:30: depositContractAddress.deposit{value: 32 ether}(pubkey, withdrawalCredentials, signature, depositDataRoot) happens in the same call, msg.value is never held
- the ETH2 canonical deposit contract's own deposit() function requires no authority signature at all -- it is reachable directly by anyone

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Depositors bypass this wrapper and call the canonical deposit contract directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
