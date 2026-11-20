---
id: p2plendingsecuritizerefinance-a86be5bc-signer-upgrade-only
title: "P2PLendingSecuritizeRefinance: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa86be5bc8ac3e7ca06d0f9daf370e2bd09925ff3"
  family: "8f8059e520d2088cc072fb7cf7972896"
  copies: 3
  name: "P2PLendingSecuritizeRefinance"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
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
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The claim fails on both paths: the per-offer lender signer falls back to ERC-1271 once it has code, and the stored key (owner) has a live setter."
---

## Summary

Zharta P2P lending (Securitize) main contract. Lender offers check ERC-1271 when the lender has code, and the only stored-key check, the redeem-result signature, uses owner, which propose_owner/claim_ownership can replace.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: P2P lending offer (Vyper): a lender with code is asked through ERC-1271, otherwise ecrecover must equal the lender / P2P lending extension offer (Vyper): a lender with code is asked through ERC-1271,…. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x2689f1834d292d2ba8ed5b836cfb85269551d78a: no admin, no upgrade function in the implementation.
- P2PLendingSecuritizeBase.vy:283-346: if lender.is_contract -> is_valid_signature (ERC-1271), else ecrecover == lender
- Base.vy:349-356 _validate_redeem_result_sig: ecrecover == self.owner; Erc20.vy:457-484 propose_owner/claim_ownership (onlyOwner) replace it
- owner() of 0xa86be5bc = 0x5723759D (EOA n=1442); refinance_addr() = 0x70db613d (the verified facet) @26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner rotates to a fresh key before migrating its own account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
