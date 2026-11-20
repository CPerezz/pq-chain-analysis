---
id: paytounlock-b13d171b-fixed-signer
title: "PayToUnlock: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb13d171be94fd08e3100da72f6d2cad4d478b773"
  family: "49c5e182857d52e1b64ddb3edb4b7850"
  name: "PayToUnlock"
  upgradeable: "no"
  rating: LOW
  value_usd: 36
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0xfbc7…2954"
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
  rating: LOW
  note: "A setting by a live owner reopens the same unlock, and the funds are the owner's and withdrawable, so LOW. The row's HIGH is not supported."
---

## Summary

SIGNER is a constant, so unlock3D's signed price stops working once it has code. The live owner can setAllowDefaultPayment(true) plus setPrice to reopen paid unlocks, or call unlockAddressAdmin. The ETH leaves by owner withdraw() with no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PayToUnlock recoverSigner: returns the recovered address / PayToUnlock checkUnlockSignature: SIGNER, a constant, signs the unlock. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: `address public constant SIGNER = 0x918d…2912`; checkUnlockSignature uses plain ecrecover.
- unlock3DDefault is gated only by the owner-settable allowDefaultPayment/price; withdraw() is onlyOwner.
- Owner 0xfbc7…2954 is an EOA (nonce 138), and SIGNER has no code. Balance is 0.0198 ETH (the owner's sale proceeds).

## Impact and exposure

- Value held at block 26,438,999: $36 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner turns on default payment (setAllowDefaultPayment, setPrice) or unlocks addresses by hand.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
