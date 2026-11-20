---
id: plagueshareholders-f7c8c299-signer-upgrade-only
title: "PlagueShareholders: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf7c8c299460c717c47ba64410d277d7a63e7bbdf"
  family: "f45a30a7e0b7f2cc159280b300c5acee"
  name: "PlagueShareholders"
  upgradeable: "yes"
  admin: "proxy owner 0xeA9B1Ed511632e48dDD3E5A231cd2f5F3A3a4a9b"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner EOA 0xeA9B1Ed5"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live EOA owner can upgrade, so LOW."
---

## Summary

PlagueShareholders: mint and move need a signature by the stored _signer (no setter), but the UUPS proxy's owner is a live EOA that can upgrade.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: PlagueShareholders mint: the stored _signer must sign each mint / PlagueShareholders move: the stored _signer must sign each move of a share / PlagueShareholders _recoverSigner: returns the recovered…. Read (function text).
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- source PlagueShareholders.sol: _signer is set only in initialize; _authorizeUpgrade is onlyOwner; withdraw/withdrawAll are onlyOwner
- dossier proxy 0x0f729b59: implementation slot = row; owner() = 0xeA9B1Ed5, an EOA with nonce 553; 0.5664 ETH held (mint fees, the operator's own)
- the row is the implementation (owner() = 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner upgrades to an implementation with a signer setter.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
