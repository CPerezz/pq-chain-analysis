---
id: simplemultisig-41673ae5-wallets-fixed-signers
title: "SimpleMultiSig: wallet with signers fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x41673ae53a2ffb749e9769048a36fa23ce28cf89"
  family: "cad011668f1837e70740ad945804288b"
  copies: 5
  name: "SimpleMultiSig"
  upgradeable: "no"
  rating: LOW
  value_usd: 3567
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the owners replace the owner set by a signed call while their keys are EOAs"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "setOwners is called by the wallet itself with the owners' signatures, so the owners can replace themselves while their keys are still EOAs, as with a key rotation: LOW (same as 0xc8d9b805)."
---

## Summary

SimpleMultiSig (0.6 variant): execute() needs `threshold` ecrecovered owners. setOwners is self-call only, gated by the same signatures.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig (0.6 variant): owners fixed. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Runtime differs from the dossier code.hex, but the selector set is the same (execute, nonce, owners, ownersArr, setOwners, threshold) and so is the logic: dossier source cad011… plus bytecode CALLER ADDRESS EQ guard on setOwners
- SSTOREs: nonce in execute plus the setOwners_ writes only; no proxy, no other outflow
- At 26438999: threshold 3, nonce 5, 8 owners, all EOAs with nonce 0

## Impact and exposure

- Value held at block 26,438,999: $3,567 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
