---
id: nftentry-69bcb93d-rotate-signer-before-migrating
title: "NFTEntry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x69bcb93d13d1063335269e8602b009485abd3e87"
  family: "396acdfa884636cff2fb0cf645a3feea"
  copies: 2
  name: "NFTEntry"
  upgradeable: "no"
  rating: LOW
  value_usd: 34648
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x1b66…f969"
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
  note: "The only missing fact was whether the controlling party is live: its owner 0x1b660061a43c255c2f7397cca2af069967acf969 is a plain account (no code, nonce 7), read at the latest block (26,455,6xx; the node was down). Live by Anon's rule of 2026-11-20 (a key is presumed live unless shown lost), so it can rotate the signer or upgrade the code: LOW. Earlier doubt: the key holder (owner) rotates via transferOwnership; RPC (reth.dappnode) timed out on all nonce/codesize reads late in the run; liveness of the controlling party not verified (owner nonce/code). Missing read: cast nonce/codesize --block 26438999 0x1b660061A43C255C2F7397CCa2Af069967aCf969 (owner)."
---

## Summary

NFTEntry: mint signature must recover to owner().

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner of the contract. Read from source.
- NFTEntry.sol:52 recover(signature) == owner()
- Ownable transferOwnership replaces it
- owner() at block = 0x1b660061A43C255C2F7397CCa2Af069967aCf969

## Impact and exposure

- Value held at block 26,438,999: $34,648 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

replace the checked key via the setter before the key account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
