---
id: liquoricesettlement-43dcd658-rotate-signer-before-migrating
title: "LiquoriceSettlement: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x43dcd6586e6209ee7235a21bdc4aa301e5bc44e8"
  family: "879d988d575db30d6f1b7792b0b5f463"
  name: "LiquoriceSettlement"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2216
  last_active: 2026-11-17
  recoveries_14d: 27
fix:
  layer: none
  who_acts: "order signer (maker/taker) picks the EIP1271 signature type"
evidence:
  level: source-read
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
  verdict: refuted
  rating: NONE
  note: "Refuted for the settlement path: ERC-1271 is accepted for the same signer. Residual: the contract's own isValidSignature (LiquoriceSettlement.sol:222) only recovers ECDSA and requires a maker, without a 1271 fallback; it is replaceable by changing makers in the authenticator. Reviewer may prefer confirmed LOW."
---

## Summary

LiquoriceSettlement RFQ settlement. Maker and taker signatures go through validateSignature, which accepts EIP712, ETHSIGN or EIP1271 per signature, so a signer with code is handled by the 1271 type.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Liquorice ERC-1271: the signer must be a maker in the authenticator contract / Liquorice validateSignature (variant): EIP-712 or eth_sign must equal the address named, or its ERC-1271 is asked /…. Read from source. Executed: a real transaction reverts with code at the signer.
- source Signing.sol:180-200 validateSignature: Type.EIP1271 calls IERC1271(_validationAddress).isValidSignature
- Signing.sol:235,238,259,279: every maker/taker check in settle/settleSingle uses validateSignature
- Makers are an allowlist in AUTHENTICATOR 0x017A3294c8Ea3710D0BD2ef5e8de8288c26585Dd (addMaker/removeMaker in IAllowListAuthentication)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,216 transactions called it in the 90 days before that block; last on 2026-11-17.
- 27 signature recoveries in the study's two-week trace window.

## Remediation

Signers with code sign orders with the EIP1271 type; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
