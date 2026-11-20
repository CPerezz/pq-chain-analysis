---
id: authorityplanner-326261b4-fixed-signer
title: "AuthorityPlanner: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x326261b4d820719fe0badbe8faecc090928977fb"
  family: "bb8b5f97496b743a68200c8b5663259a"
  name: "AuthorityPlanner"
  label: "deployed by Risk Labs: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 91
  last_active: 2026-11-17
  recoveries_14d: 85
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "The code accepts ERC-1271, and the key is chosen per call."
---

## Summary

AuthorityPlanner takes the authority from the caller's input and verifies it with OpenZeppelin SignatureChecker, which accepts ERC-1271. The signer is not fixed by the contract, and contract authorities work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: plans must be signed by the planner's authority (SignatureChecker, read); no function replaces it. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source AuthorityPlanner.sol: authority = address(bytes20(input[:20])), then SignatureChecker.isValidSignatureNow(authority, d, signature)
- planAcrossV5 is view and holds no funds

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 91 transactions called it in the 90 days before that block; last on 2026-11-17.
- 85 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
