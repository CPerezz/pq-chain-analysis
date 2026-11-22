---
id: dc2f1f1d-fixed-signer
title: "0xdc2f1f1d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdc2f1f1da4035d3e0b8e2e2e9fbf7020f1666321"
  family: "a582a633cf541ad17c409347192cabeb"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 46
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "The owner (currently the same address as the signer) would call adminWithdraw and pay users out off-contract."
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
  note: "Rated MEDIUM, not HIGH, because the owner can rescue the funds with adminWithdraw. That rescue still needs the operator to act on users' behalf. The owner check uses msg.sender, so it keeps working even if the owner/signer account gets code."
---

## Summary

The claim function only accepts signatures from the hard-coded EOA 0xb27a…1611. No setter can change it, there is no code check or ERC-1271, and the contract cannot be upgraded. If that account gets real code, signed claims stop working. The owner can still move all stETH out with adminWithdraw, so nothing is permanently locked, but users can only be paid back off-contract by the operator.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x62846a34: require(<recovered address> == 0xb27a4bbe877615ea09b8811fe76d4ce945251611, "Invalid signature"), followed by the usedNonces check and the stETH transfer to msg.sender
- 0xb27a4bbe877615ea09b8811fe76d4ce945251611 is an EOA (no code) at block 26438999
- transferOwnership only writes slot 5 (owner); the signer is a literal in the bytecode
- adminWithdraw (0x401d4482): msg.sender == owner, calls stETH transfer to arg0

## Impact and exposure

- Value held at block 26,438,999: $46 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as a plain EOA or a 7702-delegated account. If signing breaks, the owner uses adminWithdraw to repay depositors off-contract. A redeployment with a settable signer would fix this properly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
