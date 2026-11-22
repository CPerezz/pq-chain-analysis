---
id: 8768551d-rotate-signer-before-migrating
title: "0x8768551d: signer key to rotate before its account takes code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8768551d4dfc099577c6871e424b0d771c7b2328"
  family: "769a51e1981afcac22ed8c8954ea0f07"
  copies: 63
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 51430
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none: setter caller is the deploying factory, which has no forwarding function"
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
  rating: MEDIUM
  note: "LOW fails: the only setter caller is a creation-only factory. MEDIUM: affected functions die, nothing locked."
---

## Summary

PrimaBlock-style pool wrapper delegating to library 0x201c56d3…eaa2: signed deposits and the admin call need an ecrecover signature from the signer at slot 0x14 (0xaa0afc85…8777, EOA nonce 223).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a version of the b26359b4 wallets (63 addresses, 28.5 ETH); same verdict by structure. Bytecode and names.
- heimdall: wrapper 0x56e28135(address) requires msg.sender == slot 0x18 and delegatecalls the library 0xa3fee64b signer write; simulation emits 0xdaf47bd3 (signer set)
- slot 0x18 = 0xd15a48f4…399a, a factory contract (nonce 63, same 11,974-byte creation-only layout as 0x97aff5d9); random callers revert
- same structure as 0xb0813fad: withdrawals are msg.sender-only and the signed admin call sends value 0; 7.40 ETH held

## Impact and exposure

- Value held at block 26,438,999: $51,430 (ETH and 49 priced tokens, over 63 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain. Keep the signer an EOA. Contributors still withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
