---
id: recoverysignerfactory-353d2817-wallets-fixed-signers
title: "RecoverySignerFactory: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x353d28177bab012a569f51e2b737b82bf1c373bc"
  family: "f408b4ab0496b7e13136507412ae6496"
  name: "RecoverySignerFactory"
  upgradeable: "no"
  rating: NONE
  txs_90d: 9
  last_active: 2026-11-14
  recoveries_14d: 6
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Factory, and the expected signer may be a contract via ERC-1271: refuted on both counts."
---

## Summary

RecoverySignerFactory (Coinbase Smart Wallet) is a factory. It checks the guardian with Solady SignatureCheckerLib, which accepts ERC-1271 for a guardian that has code; the clones it deploys use the same check.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: recovery signers for smart wallets: each is bound to one guardian whose signature (ECDSA or ERC-1271) is needed for every change of owners (read). Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source RecoverySignerFactory.sol: _deploy -> SignatureCheckerLib.isValidSignatureNowCalldata(guardian, ...) then clone.initialize
- RecoverySigner._checkSignature also uses isValidSignatureNowCalldata (ECDSA or ERC-1271); wallet owners can remove the recovery signer
- Bytecode contains selector 1626ba7e and EXTCODESIZE checks

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-11-14.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
