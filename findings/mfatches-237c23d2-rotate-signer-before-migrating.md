---
id: mfatches-237c23d2-rotate-signer-before-migrating
title: "mfatches: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x237c23d2a1c6320d6010338a48db3fcc29f64eed"
  family: "258c2315b5e8831d283d7ecec3fdc3b3"
  name: "mfatches"
  upgradeable: "no"
  rating: LOW
  value_usd: 12451
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-10
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xd52e7e6cfc54dc437bf5a4535766e7516e0cea25"
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
  note: "LOW: the key is replaceable by a live owner."
---

## Summary

mfatches NFT: presaleMint requires a signature recovered to owner(). If the owner takes code, presale mints fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: presale mints must be signed by the owner (presaleMint read); ownership can be transferred. Read by hand.
- mfatches.sol:59,86: recover(signature) == owner()
- transferOwnership is OZ Ownable onlyOwner
- owner 0xd52e7e6c… is an EOA with nonce 124 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $12,451 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

The owner transfers ownership to a fresh key before taking code. Public sale and withdraw stay direct.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
