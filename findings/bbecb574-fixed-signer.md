---
id: bbecb574-fixed-signer
title: "0xbbecb574: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbbecb5740005cc7b55309122810b73cea08d3026"
  family: "e3217315e1e59c4960d560f593d6db9a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/project, who would have to deploy a new contract or let whitelisted users mint through the paid mint()"
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
  note: "The other address constants (0x1858..., 0x6f6c...0033) aren't used as the signer; 0x6f6c... is metadata bytes, not an address."
---

## Summary

The signer is a compile-time constant with no setter and no ERC-1271 or code check, and it has no code today (code_bytes 0). If that account gets real code, the free whitelist mint stops working. No funds get locked: the paid mint() and the owner's withdrawAll() don't need a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Line `address private constant _SIGNER_PUBLIC_KEY = 0x5714410d6D3ECE9b78CEF0E70b8aE92b379b8136`
- whitelistMint: `require(_recoverAddress(msg.sender, amount, signature) == _SIGNER_PUBLIC_KEY)`, which uses ECDSA.recover with no 1271 path
- Row facts: constant 0x5714...8136 has code_bytes 0 and delegated false
- WHITELIST_UNIT_PRICE = 0, so no user ETH goes in through the signed path

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract (or a new whitelist mechanism) that uses a replaceable signer or SignatureChecker; whitelisted users can still use the paid mint().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
