---
id: sponsoredcctpdstperiphery-214c19fb-rotate-signer-before-migrating
title: "SponsoredCCTPDstPeriphery: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x214c19fbcdfb683f2c726b4bbaf24ab483bfadf3"
  family: "fa0a174403d1af1d63344a599864a2a2"
  name: "SponsoredCCTPDstPeriphery"
  label: "Across: Sponsored CCTP Dst Periphery CCTP USDC"
  upgradeable: "no"
  rating: NONE
  txs_90d: 17527
  last_active: 2026-11-18
  recoveries_14d: 2105
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
  note: "SignatureChecker falls back to ERC-1271 for that signer."
---

## Summary

Across SponsoredCCTPDstPeriphery. Quotes are checked against a stored signer with OpenZeppelin SignatureChecker.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source.
- SponsoredCCTPQuoteLib.sol:223 calls SignatureChecker.isValidSignatureNow(signer,…) (OZ v4: ECDSA, else ERC-1271)
- setSigner is onlyRole(DEFAULT_ADMIN_ROLE) (SponsoredCCTPDstPeriphery.sol:115)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 17,527 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,105 signature recoveries in the study's two-week trace window.

## Remediation

None needed. A signer with code that implements ERC-1271 keeps working.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
