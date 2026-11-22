---
id: bridgeminter-f79ab7db-fixed-signer
title: "BridgeMinter: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf79ab7dbc00ce40b3cb8e435a4c1ac37f760c913"
  family: "1736fa207032db0ef435f641743baa99"
  copies: 9
  name: "BridgeMinter"
  label: "deployed by Galvan: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 307
  last_active: 2026-11-17
  recoveries_14d: 60
fix:
  layer: onchain-config
  who_acts: "ELMT token owner Safe 0x762157037a7d8c45ada39905fdce1d458c035725 (threshold 2)"
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
  note: "Minting can be rerouted by a setting held by a live owner, so LOW."
---

## Summary

BridgeMinter (Neptune) mints ELMT only with approver and notary signatures stored with no setter. The ELMT token owner, a live Safe, can call setIssuer to install a new minter.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer /…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source bridge_minter.sol: approver/notary set only in the constructor; code matches template 0x1e8a20b3… apart from metadata
- slots: notary 0x2f62c8df…, approver 0xf2e706f3… (both without code), token 0x600d601d… (ELMT)
- ELMT slot 2 issuer = this contract; setIssuer requires msg.sender == owner; owner slot 0 = 0x76215703…, a Gnosis Safe with threshold 2

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 307 transactions called it in the 90 days before that block; last on 2026-11-17.
- 60 signature recoveries in the study's two-week trace window.

## Remediation

Token owner Safe sets a new issuer with fresh keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
