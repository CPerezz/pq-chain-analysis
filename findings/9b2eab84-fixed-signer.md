---
id: 9b2eab84-fixed-signer
title: "0x9b2eab84: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9b2eab84ab7115b9d568ade9ab6f75919693b8aa"
  family: "d786dfdeb1a5eef1b926e946e17d0fbc"
  copies: 6
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "collection owner 0x8fc00b61061f783512b555e5e2fc36f21369992a (redeploy) / launchpad operator"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "MEDIUM: no update path, mint function dies, nothing held (proceeds forwarded on mint). Code differs from DogZone template."
---

## Summary

Koala-launchpad ERC721 clone (not DogZone): the only mint function requires a signature from launchpad constant 0x4aea7b69…5775 ("Not authorized to mint"); proceeds are forwarded at mint time. If that key gets code, minting dies for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled.sol: mint compares recovered address to constant 0x4aea7b69abb482e34bdd1d8c7a6b8dca44f65775; fee 5% to 0xd17237…348a, rest to owner, in the same call
- signer 0x4aea…5775: cast code = 0x (EOA) at block 26438999; setters = transferOwnership only, no proxy
- no owner/public mint without signature (owner functions: setMaxSupply, setPause, reveal, burn/setPrice only)
- balance 0 at block 26438999; txs_90d=0, last_active=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Launchpad keeps signer 0x4aea… an EOA; otherwise collection redeploys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
