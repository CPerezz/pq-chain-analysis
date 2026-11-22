---
id: momoyumemi-66dcdd75-rotate-signer-before-migrating
title: "Momoyumemi: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x66dcdd758a4dd80c5386a2dc85997e94448719f9"
  family: "d4f6d3f2af2fefa9f80ac110a96cb1e8"
  name: "Momoyumemi"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2113
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xADF8…D2dD"
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
  note: "Setter exists and the owner is a live EOA. The row note should be corrected (wrong template)."
---

## Summary

Momoyumemi NFT (SeaDrop): executeMetadataAction needs a curator signature from the stored actionSigner (OZ SignatureChecker: ECDSA, then ERC-1271). An EOA actionSigner that gets code fails unless its new code implements 1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ad8cefc3: migrateWithSig (read whole): called by the owner with the staker's signature, checked by SignatureChecker (ECDSA or the staker's ERC-1271) / SignatureChecker on a signer…. Template.
- verified source (sourcify) Momoyumemi.sol:240 SignatureChecker.isValidSignatureNow(actionSigner, …); line 121 setActionSigner(address) onlyOwner
- owner at block 26438999 = 0xADF8f27f…D2dD, EOA nonce 297 (probed)
- the row's note is copied from template ad8cefc3 (ZtakingPool), which is a different contract; the holder signature (line 246) is also checked through SignatureChecker

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,113 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner calls setActionSigner(new) before the curator key migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
