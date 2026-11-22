---
id: 6ea26d27-wallets-fixed-signers
title: "0x6ea26d27: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6ea26d27e9f560ff92839483f9da4ec13153e46f"
  family: "d5abad91bccfe3ad6d2ca17aef71acff"
  copies: 398
  upgradeable: "no"
  rating: HIGH
  value_usd: 23
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
evidence:
  level: bytecode
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
  rating: HIGH
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

Unverified multisig wallet (spend/spendERC20/spendAny, 2 of 3 owners). Owners are fixed and signatures are recovered with an Ethereum Signed Message prefix; no setter.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 398 wallets: owners in a mapping; seven selectors, none changes owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: spend, spendERC20, spendAny (each with v[]/r[]/s[]), getOwners, getRequired, getSpendNonce, MAX_OWNER_COUNT; no owner setter, no 1626ba7e, no delegatecall
- getOwners() = 82d744…, 3b883e…, c95947…; getRequired()=2
- Signers 0x82d74445fdcbcb5c480db52d8c8299b6201053fd, 0x3b883e88a4007cd76a4f7da8e3468ca793e3c4c9, 0xc95947e552a458c3b54ef7b6658ca8e6021c18bb: all EOAs, no code (latest, block ~26452917); value_usd 23, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $23 (ETH and 49 priced tokens, over 398 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
