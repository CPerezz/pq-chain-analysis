---
id: 4090fff7-rotate-signer-before-migrating
title: "0x4090fff7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4090fff7b3e9557896439f877d96c320b7bf4481"
  family: "f72423e946ac7be6111f0e851da5ca63"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 23468
  last_active: 2026-11-02
fix:
  layer: onchain-config
  who_acts: "proxy owner: Safe 0xbc3407d0dfc05ff6bbe4aa53a3c48138a760a7d8 (3 of 6)"
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
  rating: LOW
  note: "Setters exist and their caller, the owner of the live proxy, is a working 3-of-6 Safe. LOW. The second copy of the code was not identified."
---

## Summary

Implementation (vault/withdrawal contract with signers, approvers, operators, callers and a withdraw whitelist) behind proxy 0x427c8dcdc56d659bc922093221aac827af7242d6. Withdrawals are checked against stored signer and approver sets by ecrecover. owner()=0 here is just the bare implementation's storage.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addApprover, addOperator, addSigner, removeApprover). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall: addApprover, removeApprover, addSigner (0xeb12d61e), removeSigner, addOperator and transferOwnership all require msg.sender == owner (slot 0).
- Proxy 0x427c8dcd… EIP-1967 implementation slot = 0x4090fff7… at block 26438999; owner() = 0xbC3407d0….
- 0xbC3407d0… is a Safe at the block: getOwners returns 6 owners, getThreshold = 3, so it is live.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 23,468 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

The Safe owner replaces any migrating signer or approver (addSigner/removeSigner, addApprover/removeApprover) before the key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
