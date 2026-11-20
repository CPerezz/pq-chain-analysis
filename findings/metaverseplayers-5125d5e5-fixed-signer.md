---
id: metaverseplayers-5125d5e5-fixed-signer
title: "MetaversePlayers: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5125d5e55ff1f1e378c7d83db305b86719114b3d"
  family: "9e8df382589ddcfed5456fe3d3dccdc4"
  name: "MetaversePlayers"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0xb2C7…8F01"
evidence:
  level: source-read
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
  rating: LOW
  note: "A setting opens the same mint by another path: LOW."
---

## Summary

MetaversePlayers: allowlistMintNFT needs the constant ALLOWLIST_SIGNER. The owner can open the same mint through setEnablePublicSale and the sale timestamps, or giftNFT to the affected users.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: constant ALLOWLIST_SIGNER 0x303B…67e9 (no code, latest, block ~26453066)
- owner() = 0xb2C7c59f…8F01 at block 26438999 (node, first pass)
- owner is an EOA with nonce 872 (latest, block ~26453066)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner enables the public sale or gifts the tokens.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
