---
id: wintermute-0000006d-fixed-signer
title: "Wintermute: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000006daea1723962647b7e189d311d757fb793"
  family: "75060a3ca85ebbc67aa543019e9b8e37"
  name: "Wintermute"
  label: "Wintermute 1"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1137
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Wintermute"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path. Order signing and approvals die for good, but funds leave via drain by a direct call; the money is the operator's own → MEDIUM."
---

## Summary

ERC-1271 isValidSignature accepts only 4 constructor-set signers, and token approvals need 2 of 3 constructor-set approvers; no setter exists. drain/drainETH by the constructor-set drainer need no signature, so the firm's own funds stay reachable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Wintermute: ERC-1271 order signing and token approvals need signers set only in the constructor; drain and drainETH need no signature, so its own trading funds stay reachable (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Wintermute.sol: signers/approvers/drainers mappings are written only in the constructor
- authorizeApproval: two ecrecover results must be approvers; isValidSignature: recovered address must be in signers
- drain(tokens) and drainETH() are onlyDrainer direct calls to the constant RECIPIENT
- all 4 signers, 3 approvers and the drainer 0x000089D6… have code 0x today

## Impact and exposure

- Value held at block 26,438,999: $1,137 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Sign with these keys only while they are EOAs; move trading to a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
