---
id: bridgemintertimelock-fde0ba8e-fixed-signer
title: "BridgeMinterTimeLock: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfde0ba8edbb3b4350280e6ba5b3621b8d3501314"
  family: "4e1d6ba204b08c3a231d07c224161c29"
  copies: 6
  name: "BridgeMinterTimeLock"
  upgradeable: "no"
  rating: LOW
  txs_90d: 328
  last_active: 2026-11-17
  recoveries_14d: 38
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xe933a6555cd5a1ba4cc0902691396e91893737f4 (Gnosis Safe, threshold 2)"
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
  note: "A live owner can reroute minting by a setting, so LOW."
---

## Summary

BridgeMinterTimeLock mints GROW only with approver and notary signatures (immutables; no setter). The timelock owns the GROW token, and its owner can hand token ownership to a new bridge after 48h. That new owner can then setIssuer.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer /…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode PUSH32 immutables: approver/notary 0x5cfd89fb… and 0x2c46ac56… (no code), token 0x1223334444a7466fbf985b14e1f4edaf3883bca6 (GROW)
- GROW slot 0 (owner) = this contract; GROW exposes setIssuer and transferOwnership, owner-gated
- source initiateTransferTokenOwnership/completeTransferTokenOwnership are onlyOwner with a 48h delay; owner() = 0xe933a655…, a Safe with threshold 2
- this deployment's code differs from the dossier source address 0x81e28e48…, so I read it on its own (immutables instead of storage)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 328 transactions called it in the 90 days before that block; last on 2026-11-17.
- 38 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe moves GROW ownership to a new minter with fresh keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
