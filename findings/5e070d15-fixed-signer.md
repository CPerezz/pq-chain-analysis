---
id: 5e070d15-fixed-signer
title: "0x5e070d15 (tagged deployed by Blockparty: Deployer 1): signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5e070d15c14e5d6731adbdd930d55b4c9d1b8e40"
  family: "f99a7cd27862ebb0f4eb2479b274bf45"
  label: "deployed by Blockparty: Deployer 1"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "Whoever controls the hotwallet key: they must keep the account an EOA or a 7702-delegated account and never give it other code."
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
  rating: HIGH
  note: "Any ETH already in Reserved bids can only be released with hotwallet signatures. A new contract deployment cannot recover it."
---

## Summary

The signer is a hard-coded constant EOA with no setter. If that account gets non-delegation code, ecrecover stops matching it, cancelBid and claimBid always revert, and the ETH in Reserved bids stays locked because there is no other exit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address constant hotwallet = 0xf3F7...ABE6`, and the row facts show code_bytes 0 for it today (not delegated)
- isSigned compares the ecrecover result to hotwallet, with no ERC-1271 path and no code check
- cancelBid and claimBid are the only functions that send ETH, and both `require(isSigned(...))`
- The owner can only call setFee and transferOwnership; there is no withdraw function

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the hotwallet key holder's account free of non-delegation code. For new deployments, make the signer replaceable or add a timeout refund path that needs no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
