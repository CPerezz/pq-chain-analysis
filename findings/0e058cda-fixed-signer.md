---
id: 0e058cda-fixed-signer
title: "0x0e058cda: signer fixed in code"
status: confirmed
severity: CRITICAL
patterns: [PQ-17]
impact: funds-loss
contracts:
- address: "0x0e058cda6336ac3deea4a958c2f0d8cb1f500597"
  family: "f4aa55c38bfd6315640daa567df90cff"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The payer's account getting non-delegation code. The recipient cannot act."
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
  rating: CRITICAL
  note: "The study note calls this a presale, but the code is a payment channel. The signature check also requires conditionToken.balanceOf(payer) >= threshold."
---

## Summary

Only signatures from the fixed payer key are accepted, and that key is an EOA today. If the payer's account gets real code, every voucher the recipient holds stops recovering under EIP-8151, so withdraw and close revert. The payer can still start the timeout and call claimTimeout to take back the whole balance. The recipient, who provided the service in exchange for the signed vouchers, loses the money owed.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x030ba25d withdraw: require(msg.sender == 0x9caeb8f3…) and require(ecrecover(...) == 0x1704823e…)
- 0x415ffba7 close: the same ecrecover check against 0x1704823e…
- 0x5548924e: require(msg.sender == 0x1704823e…) then sets expiration = block.timestamp + store_e
- claimTimeout: after expiration, transfers the paymentToken balance to 0x1704823e…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new channel that verifies signatures with ERC-1271 or a code-aware check such as SignatureChecker. Recipients should settle their outstanding vouchers before the payer's account gets code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
