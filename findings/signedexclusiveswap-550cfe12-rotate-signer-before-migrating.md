---
id: signedexclusiveswap-550cfe12-rotate-signer-before-migrating
title: "SignedExclusiveSwap: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x550cfe1292d0d9c0d28f232b3f42edb4439b1d09"
  family: "f7175e072ab247013955e07f54398560"
  name: "SignedExclusiveSwap"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1977
  last_active: 2026-11-18
  recoveries_14d: 1903
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x7711…4ec5"
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
  verdict: confirmed
  rating: LOW
  note: "Live owner Safe can replace the controller per pool."
---

## Summary

SignedExclusiveSwap (Ekubo extension): each pool's controller signs swaps. A controller marked as an EOA is checked by ECDSA.recover only, so it fails once it gets code; contract-marked controllers use ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source. Executed: a real transaction loses its effect with code at the signer.
- source controllerAddress.sol: isEoa (bit 159 clear) → ECDSA.recover == controller, else SignatureCheckerLib.isValidERC1271SignatureNow
- SignedExclusiveSwap.sol:203 setPoolController(poolKey, controller) onlyOwner (solady Ownable)
- owner at block 26438999 = 0x7711C84f…4EC5, Safe 2-of-5 (probed)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,977 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,903 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe calls setPoolController to a new EOA, or a contract-flagged controller with ERC-1271, before the controller migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
