---
id: de680928-fixed-signer
title: "0xde680928: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde680928e1d4104079efcb4c5b0cf0e156294585"
  family: "ea390fe3472bc31c61abdda00cc2068d"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-10-14
fix:
  layer: new-deployment
  who_acts: "future minters/claimers blocked; existing token holders unaffected"
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
  note: "No update path for the hardcoded voucher signer, but no funds are held by this contract — matches the MEDIUM 'signed NFT mint' example."
---

## Summary

NFT with pauseTransfer/unpauseTransfer and a signed-voucher path guarded by an 'Invalid voucher' revert plus an expiry timestamp check. The ecrecover result is compared to a hardcoded PUSH20 constant (0xfd98fc12...) with no setter. No payable escrow function exists; this is a mint/claim voucher, not fund custody.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode near 0x2012: STATICCALL to address 1, return EQ'd (after masking) against PUSH32-truncated constant 0x...fd98fc120459ed7dfc17963a6c0179c2e50efa83, guarded by revert string 'Invalid voucher' and a fixed unix-timestamp expiry (0x618e7360).
- cast code on 0xfd98fc12... at the pinned block is empty — no code today.
- Selector list (pauseTransfer/unpauseTransfer/safeTransferFrom/transferOwnership) has no deposit/escrow function.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-14.

## Remediation

redeploy with a replaceable voucher-signer role

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
