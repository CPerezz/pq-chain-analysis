---
id: saitotoken-fa14fa69-fixed-signer
title: "SaitoToken: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfa14fa6958401314851a17d6c5360ca29f74b57b"
  family: "e7ec3dedd79062e3851753342d1d803f"
  name: "SaitoToken"
  label: "Saito: SAITO Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 5018
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2072
  last_active: 2026-11-18
fix:
  layer: new-deployment
  who_acts: "Saito owners"
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
  rating: MEDIUM
  note: "No update path; the dead function (minting) locks nothing."
---

## Summary

SAITO token: mint() needs signatures from three owner keys stored at construction (owner1-3, no setter). If any of them takes code, minting dies for good; existing balances and transfers are unaffected and the contract holds no pooled funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SaitoToken: minting needs three stored owner keys; no setter in the source. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SaitoToken.sol: mint requires ecrecover == owner1, owner2, owner3 (three require lines); no function writes owner1-3
- Storage at 26438999: owner1 0x41afad17…, owner2 0x5ac2f364…, owner3 0xa357d59d…; all cast code 0x
- No other money flow: ERC20 transfers and burn need no signature; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $5,018 (ETH and 49 priced tokens).
- Activity: 2,072 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Deploy a new token or bridge with rotatable keys if minting must continue.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
