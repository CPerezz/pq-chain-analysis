---
id: automintererc721a-80873024-rotate-signer-before-migrating
title: "AutoMinterERC721A: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x808730240f0c7f650ad0fd33cd355ef422df59ce"
  family: "84893169132ef33bf86027550a074292"
  copies: 124
  name: "AutoMinterERC721A"
  label: "deployed by AutoMinter Pro Pass: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 70
  last_active: 2026-11-14
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`AutoMinterERC721A` at `0x808730240f0c7f650ad0fd33cd355ef422df59ce` (Etherscan tag: deployed by AutoMinter Pro Pass: Deployer), with 123 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner or a stored whitelist signer. Read from source.
- Reviewed through the root issue's mechanism (D-025): the owner is the checked signer, and this address's code holds transferOwnership, so the owner hands over before its key takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $1,624 (ETH and 49 priced tokens, over 124 addresses).
- Activity: 70 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
