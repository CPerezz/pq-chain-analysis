---
id: amlokprojectwallet-f4565a4e-fixed-signer
title: "AmlokProjectWallet: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf4565a4e080d348e91a632419c3d72d93e6b9715"
  family: "0d40925510b7f31240a9edb9fed1b3eb"
  copies: 24
  name: "AmlokProjectWallet"
  upgradeable: "no"
  rating: HIGH
  value_usd: 748
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "Amlok platform signer"
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
  rating: HIGH
  note: "No update path; the project owner's raised USDC can't leave without that signature → HIGH."
---

## Summary

AmlokProjectWallet (EIP-1167 clone of 0x152e…ce6c) releases its USDC only through withdrawal(), which needs onlyOwner plus a platform signature recovered to _signer. _signer is set in initialize with no setter.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: AmlokProjectWallet withdrawal: the owner needs a signature of the platform signer, set at initialisation with no setter in the wallet; 24 project wallets. Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- AmlokProjectWallet.sol: _signer written only in initialize; withdrawal requires messageHash.recover(signature) == _signer
- clone code delegates to the hard-coded 0x152e97bd9c8d5091db049aea84ec0d8bf416ce6c (no upgrade)
- _signer = 0x76E9…73E1 (code 0x), owner = 0x7985…C1c9, getIsLocked = false, token = USDC at 26438999
- no other token-moving function

## Impact and exposure

- Value held at block 26,438,999: $748 (ETH and 49 priced tokens, over 24 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Platform signs withdrawals for every project wallet before its key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
