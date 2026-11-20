---
id: 05ecba1d-fixed-signer
title: "0x05ecba1d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x05ecba1df915b8cb4ea51055a0f1a354f9a93f24"
  family: "e43c3c8d12c7f2ddf80ca2b67c72de43"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner: withdraw the funds and redeploy, or hand out tokens off-chain"
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
  note: "The decompiler could not resolve the signature-checking function (0x963084a0) and shows it only as revert(), so the account of which functions need the signature relies on the study note."
---

## Summary

The signer is a constant in the bytecode with no setter, and that address has no code today (it is an EOA). If that account ever gets real code, signed claims stop working. This does not lock funds, because the owner's withdraw can still move every token and all ETH the contract holds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant signer = 1169877847778363457536448773020119288662823198704 (0xcceb231309fc453c7a1fd812b73502c4323edff0)
- 0xcceb231309fc453c7a1fd812b73502c4323edff0 has no code at block 26438999 (EOA)
- The only setters are transferOwnership and renounceOwnership, and they write only to owner in slot 0
- withdraw(address,address,uint256) is onlyOwner and transfers an ERC20 or ETH out

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be replaced or that accepts ERC-1271 signatures. Until then, the owner can withdraw the funds and handle settlement by hand.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
