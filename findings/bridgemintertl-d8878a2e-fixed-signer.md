---
id: bridgemintertl-d8878a2e-fixed-signer
title: "BridgeMinterTL: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd8878a2ec434d1661940d4b2591b03cbef486ca8"
  family: "8a84620cc512a9f9d83c3416137afb41"
  name: "BridgeMinterTL"
  upgradeable: "no"
  rating: LOW
  txs_90d: 36
  last_active: 2026-11-16
  recoveries_14d: 6
fix:
  layer: contract-upgrade
  who_acts: "owner (Gnosis Safe 0x90cf…)"
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
  note: "A simple update by a live owner fixes it."
---

## Summary

BridgeMinterTL: bridge() mints GREEN only with signatures from approver 0x38e2… and notary 0x04c5… (both EOAs in storage, no setter). Its owner, a live Safe, can hand token ownership to a new minter with new keys (initiateTransferTokenOwnership plus completeTransferTokenOwnership after 48 h).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer /…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: approver and notary are written only in the constructor; initiateTransferTokenOwnership/completeTransferTokenOwnership are onlyOwner
- GREEN token owner() = this contract; owner slot 0 = 0x90cf…59a5, a Safe proxy (nonce 1)
- The approver and notary have no code; the contract holds no funds (balance 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-16.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

The Safe moves token ownership to a redeployed minter with rotatable keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
