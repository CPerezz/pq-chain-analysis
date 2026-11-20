---
id: ownablevalidator-00000000-rotate-signer-before-migrating
title: "OwnableValidator: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x000000000013fdb5234e4e3162a810f54d9f7e98"
  family: "2a9c05d7bd9cc4f5ca1e480ff3f47de6"
  name: "OwnableValidator"
  label: "Rhinestone: Ownable Validator"
  upgradeable: "no"
  rating: NONE
  txs_90d: 19604
  last_active: 2026-11-18
  recoveries_14d: 4978
fix:
  layer: none
  who_acts: "none"
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
  note: "Contract signers are handled by the ERC-1271 branch; the study's note admits that branch was not followed."
---

## Summary

Rhinestone OwnableValidator, an ERC-7579 module with per-account owners and a threshold. Signatures go through CheckNSignatures.recoverNSignatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Rhinestone OwnableValidator (stateless check): the recovered signers must hold at least the threshold of the given owners; the library's contract-signature branch was not followed / Rhinestone…. Read from source. Executed: a real transaction reverts with code at the signer.
- CheckNSignatures.sol:49: v==0 is a contract signature; it calls ISignatureValidator(signer).isValidSignature (ERC-1271), the Safe-style branch
- OwnableValidator._validateSignatureWithConfig and validateSignatureWithData both use recoverNSignatures, so an owner with code can sign by ERC-1271
- Owners can also be changed by the account itself: addOwner/removeOwner use msg.sender as the account (OwnableValidator.sol:182,214)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 19,604 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,978 signature recoveries in the study's two-week trace window.

## Remediation

An owner that migrates to code signs in the v=0 contract-signature format, or the account rotates the owner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
