---
id: multisigcommitter-2d001ccf-rotate-signer-before-migrating
title: "MultisigCommitter: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2d001ccffda16e6f1b59f94dfa1788e6ee8d8e7e"
  family: "77dfae2149f073f5a937587a791c45f0"
  copies: 3
  name: "MultisigCommitter"
  upgradeable: "no"
  rating: NONE
  txs_90d: 7889
  last_active: 2026-11-18
  recoveries_14d: 354
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
  note: "ERC-1271 accepted for the same signer."
---

## Summary

ZKsync MultisigCommitter: validator signatures are checked with OZ SignatureCheckerUpgradeable.isValidSignatureNow, which falls back to ERC-1271 for the signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ZKsync MultisigCommitter: signers must be validators of the chain or shared validators, each checked with SignatureChecker. Read from source. Executed: a real transaction reverts with code at the signer.
- MultisigCommitter.sol:256 SignatureCheckerUpgradeable.isValidSignatureNow(signers[i], digest, signatures[i])
- SignatureCheckerUpgradeable.sol:24-28: tryRecover == signer
- isValidERC1271SignatureNow(signer,…)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 7,889 transactions called it in the 90 days before that block; last on 2026-11-18.
- 354 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
