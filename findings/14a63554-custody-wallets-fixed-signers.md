---
id: 14a63554-custody-wallets-fixed-signers
title: "0x14a63554: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x14a635549fc5d087d39a0cd1339345b8b8c6fdba"
  family: "9ede059a8a2cfbc9e4772a1267c1fdc6"
  copies: 139
  upgradeable: "no"
  rating: HIGH
  value_usd: 3067149
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1201
  last_active: 2026-11-17
  recoveries_14d: 121
fix:
  layer: new-deployment
  who_acts: "the custodian moves funds to wallets it can change before its signers take code"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-custody-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "signer count read; no setter, no upgrade path"
---

## Summary

Contract `0x14a635549fc5d087d39a0cd1339345b8b8c6fdba`, with 138 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 139 wallets holding 1,700 ETH: signers in a stored set (signerNum); no function name that changes them. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (6,505 bytes, no verified source) exposes initialize(address[],uint256), signerNum, spendNonce, generateMessageToSign(address,address,uint256,uint256), transfer, ERC-721 and ERC-223 receivers: a wallet whose signers are set once at initialize. No function changes them; no proxy slot, no upgrade function.
- State at block 26,438,999: signerNum 2. In the study's two-week trace window it recovered three distinct signers.
- The other 138 addresses run the same code; the family's best-known address carries Etherscan's tag GMO Coin.

## Impact and exposure

- Value held at block 26,438,999: $3.1M (ETH and 49 priced tokens, over 139 addresses).
- Activity: 1,201 transactions called it in the 90 days before that block; last on 2026-11-17.
- 121 signature recoveries in the study's two-week trace window.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
