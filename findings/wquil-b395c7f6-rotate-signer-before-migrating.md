---
id: wquil-b395c7f6-rotate-signer-before-migrating
title: "wQUIL: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb395c7f6e936e3d6ae96ab31e3f69ad37328ceb3"
  family: "de764465c1e85ca50f85699488455986"
  copies: 2
  name: "wQUIL"
  label: "Wrapped QUIL: wQUIL Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10085
  last_active: 2026-11-18
  recoveries_14d: 3
fix:
  layer: onchain-config
  who_acts: "owner 0xcF2D5f81…326F (EOA)"
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
  note: "Owner-held setter, live EOA; permit has a direct approve path."
---

## Summary

wQUIL (thirdweb ERC20SignatureMint) mint requests must be signed by owner(); permit is a signed shortcut next to approve.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: thirdweb SignatureMintERC20.verify: the signer must be allowed to sign mint requests / thirdweb SignatureMint: returns the signer of a mint request to verify() / OpenZeppelin 4 permit (variant). Read from source. Executed: a real transaction reverts with code at the signer.
- ERC20SignatureMint._canSignMintRequest: _signer == owner(); ERC20Base._canSetOwner: msg.sender == owner() (setOwner)
- owner() = 0xcF2D5f810BBCebEED285920B08fA5f5c7C9d326F, no code, nonce 12
- Permit (OZ4 variant) leaves the standard approve open

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 10,085 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setOwner to a key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
