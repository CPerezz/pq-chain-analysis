---
id: c5423af4-fixed-signer
title: "0xc5423af4: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc5423af471a38fb4a7525fda3fc52fcd107aaf3e"
  family: "71acdd0bb3a03ca214d44708fa2c1e17"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator: redeploy with a new signer, and recover the stock through the 3-of-5 withdrawREAL path"
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
  rating: MEDIUM
  note: "The study note calls this a presale with deposit and claim, but the code is a free airdrop dispenser with only claimREAL. No user funds are held."
---

## Summary

The claim signer is an immutable EOA with no setter and no ERC-1271 or code check. If that key's account gets real code, free claims stop. Nothing is locked, because the 3-of-5 multisig withdrawREAL path can still move the operator's stock out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constructor: signerAddress = 0x11743fe35A2BF1754F8397596AD52e3309468b69 (immutable); bytecode facts show it is an EOA (no code) today
- _verifySignature compares the ECDSA.recover result to signerAddress; there is no isValidSignature call and no code check
- claimREAL requires _verifySignature(messageHash, signature)
- withdrawREAL is gated by onlySigner (msg.sender is in signers[]), needs 3 approvals and a 7-day WITHDRAWAL_TIMELOCK, and sends REAL to mainDepositWallet without any ecrecover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new dispenser whose signer can be updated or that accepts ERC-1271 signatures, use withdrawREAL to move the remaining REAL out, and fund the new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
