---
id: capsulecoin-bc319743-signed-shortcut-lost
title: "CapsuleCoin: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbc3197431326bd9f0065abb9b9ab7f0c80de958b"
  family: "2597e810a8f87006136420ea077e851a"
  copies: 2
  name: "CapsuleCoin"
  label: "Ternoa: CAPS Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1806
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Direct twin exists. Value $4692, txs_90d 1806 (not rating inputs)."
---

## Summary

CapsuleCoin (Ternoa): claimOffchainGrant moves `from`'s tokens with its signature; `from` can transfer itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: CapsuleCoin claimOffchainGrant: `from` signs a grant that moves its tokens. Read from source.
- source CapsuleCoin.sol:68 claimOffchainGrant: recover(proof) == from, then _transfer(from,to,amount)
- OpenZeppelin ERC20 transfer/approve present

## Impact and exposure

- Value held at block 26,438,999: $4,692 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,806 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

`from` calls transfer directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
