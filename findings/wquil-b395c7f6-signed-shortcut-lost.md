---
id: wquil-b395c7f6-signed-shortcut-lost
title: "wQUIL: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
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
  layer: offchain
  who_acts: "owner / holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct twins exist for both signed paths; the owner is live. Value $5414, txs_90d 10085 (not rating inputs)."
---

## Summary

wQUIL (thirdweb ERC20SignatureMint): mint requests must be signed by owner(); permit is OZ-style. If the owner gets code, it can still mint directly, and holders approve directly.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: thirdweb SignatureMintERC20.verify: the signer must be allowed to sign mint requests / thirdweb SignatureMint: returns the signer of a mint request to verify() / OpenZeppelin 4 permit (variant). Read from source. Executed: a real transaction reverts with code at the signer.
- source @thirdweb-dev base/ERC20SignatureMint.sol:75 _canSignMintRequest(signer) == owner(); ERC20Base.sol:49 mintTo requires _canMint() (owner)
- owner() at block = 0xcF2D5f81… (EOA, nonce 12)

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 10,085 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

The owner uses mintTo; holders use approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
