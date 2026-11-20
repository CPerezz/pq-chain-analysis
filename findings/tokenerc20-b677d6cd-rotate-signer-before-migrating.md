---
id: tokenerc20-b677d6cd-rotate-signer-before-migrating
title: "TokenERC20: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb677d6cd6186c98a80f117c5c8ede0994d945d67"
  family: "d15b20cd574e159d0ebf5f0771653cc8"
  copies: 1110
  name: "TokenERC20"
  label: "Vitreus: wVTRS Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 789
  last_active: 2026-11-17
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

`TokenERC20` at `0xb677d6cd6186c98a80f117c5c8ede0994d945d67` (Etherscan tag: Vitreus: wVTRS Token), with 1,109 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: thirdweb mint request: the signer must hold MINTER_ROLE / thirdweb: returns the signer of a mint request to verify() / OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever…. Read from source.
- Reviewed through the root issue's mechanism (D-025): the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $722 (ETH and 49 priced tokens, over 1,110 addresses).
- Activity: 789 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
