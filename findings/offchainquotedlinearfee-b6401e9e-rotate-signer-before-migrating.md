---
id: offchainquotedlinearfee-b6401e9e-rotate-signer-before-migrating
title: "OffchainQuotedLinearFee: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb6401e9e43f4fcab6a0ca7412cfe9de8d07e2e3d"
  family: "f788eae479187b2b0a36448c993a65dd"
  copies: 183
  name: "OffchainQuotedLinearFee"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1303
  last_active: 2026-11-18
  recoveries_14d: 24
fix:
  layer: onchain-config
  who_acts: "owner 0x8Ff4c563f26db00e65bD93d9f662A51c304C09b0"
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
  note: "A live owner can call the setter, so a config call fixes it: LOW."
---

## Summary

OffchainQuotedLinearFee checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setter addQuoteSigner/removeQuoteSigner(address) onlyOwner in verified source (f788eae479187b2b0a36448c993a65dd/source)
- owner() at block 26438999 = 0x8Ff4c563f26db00e65bD93d9f662A51c304C09b0 Safe 2-of-[0xa7ECcdb9Be08178f896c26b7BbD8C3D4E844d9Ba, 0xc3E966E79eF1aA4751221F55fB8A36589C24C0cA, 0x852d3D5dc1B8C8cFf3bebD033025e54fA366fA94, 0x003DDD9eEAb62013b7332Ab4CC6B10077a8ca961, 0xD7C3cc05e4311286e8E837EF6a8add9A54488B1e, 0x5b73A98165778BCCE72979B4EE3faCdb31728b8E, 0x47Bbac4147c330c8FAD542d1A52f1bB97716826b]
- txs_90d=1303, last_active=2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 183 addresses).
- Activity: 1,303 transactions called it in the 90 days before that block; last on 2026-11-18.
- 24 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
