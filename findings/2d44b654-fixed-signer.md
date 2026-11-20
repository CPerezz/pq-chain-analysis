---
id: 2d44b654-fixed-signer
title: "0x2d44b654: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2d44b654c81fde3c969be8daaf19be62cb39d715"
  family: "474fe8dd21a0ff49b1b5ea21d51230a8"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator would have to deploy a new contract with a new signer"
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
  note: "The SIGNER immutable value is not in the row facts, so its address and current code could not be checked. The confirmed verdict assumes it is an EOA today."
---

## Summary

SIGNER is immutable and has no setter or ERC-1271/code check. If the signer's account gets real code, signed mints stop working. No funds get locked, because withdraw() needs no signature and existing NFTs can still be transferred.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable SIGNER;` assigned only in the constructor
- mint(): `ECDSA.recover(digest,_signature)` then `if (recoverAddress != SIGNER) revert InvalidSignature();`
- No function writes SIGNER; the only setter, transferOwnership, changes the owner
- withdraw() onlyOwner pays out the full balance with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a new signer, or with a settable signer that supports ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
