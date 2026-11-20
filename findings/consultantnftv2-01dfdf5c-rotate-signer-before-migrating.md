---
id: consultantnftv2-01dfdf5c-rotate-signer-before-migrating
title: "ConsultantNFTV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x01dfdf5cf681a4fd104f166db2d48d8bb88c5e51"
  family: "d8c5faf83155b4384f36b7eaf3d73762"
  name: "ConsultantNFTV2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1340
  last_active: 2026-11-05
fix:
  layer: onchain-config
  who_acts: "owner EOA"
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
  note: "Owner-only setter (by simulation) and a live EOA owner."
---

## Summary

ConsultantNFTV2 checks signatures against an owner-set trustedSigner; a trustedSigner with code would be rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setPositionManager, setTrustedSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- eth_call at block 26438999: setTrustedSigner(x) from owner 0xA120…8458 succeeds, from 0xdead reverts 0x118cdaa7 (OwnableUnauthorizedAccount)
- trustedSigner()=0x53dC9d885336D6757efBbD8fb2Ac0036Df7f87d7 at block
- owner 0xA120D9AFd1E3E7b1C43DE0DBeE47d357f2938458 is an EOA, nonce 45 (probe); heimdall output unreadable, so access was established by simulation

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,340 transactions called it in the 90 days before that block; last on 2026-11-05.

## Remediation

Owner calls setTrustedSigner with a plain key before the signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
