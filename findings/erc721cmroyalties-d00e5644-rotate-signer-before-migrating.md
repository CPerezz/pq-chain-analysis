---
id: erc721cmroyalties-d00e5644-rotate-signer-before-migrating
title: "ERC721CMRoyalties: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd00e564408752b68cfd41bfe79403fb11abca0ea"
  family: "b30e96b972957b05b55dcf9f4333c609"
  copies: 7
  name: "ERC721CMRoyalties"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1725
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner 0x579D1A40 (EOA, nonce 0)"
evidence:
  level: bytecode
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
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: The setter exists and is owner-gated, but the owner has never transacted, so whether it is live cannot be verified. If it is, LOW."
---

## Summary

ERC721CMRoyalties (Magic Eden-style cosigned mint). A cosigned mint requires the stored cosigner's signature. Under EIP-8151 a cosigner with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (addAuthorizedMinter, removeAuthorizedMinter, setCosigner, setTransferValidator). Whoever holds it must replace it before that account…. Rule: stored-key.
- setCosigner selector 0x02045138 present; heimdall shows it requires msg.sender == owner (0x118cdaa7)
- owner()=0x579D1A40, an EOA with nonce 0 at 26438999 and still 0 at latest: it has never sent a transaction, so it cannot be confirmed live

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 1,725 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls setCosigner with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
