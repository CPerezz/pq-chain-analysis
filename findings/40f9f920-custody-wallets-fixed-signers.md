---
id: 40f9f920-custody-wallets-fixed-signers
title: "0x40f9f920 (tagged Amina Deposit): custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x40f9f920ece7cce223625c088a6c1281ef396cf2"
  family: "41d5f6fd5664c2004bb441bf88ab4aa7"
  copies: 622
  label: "Amina Deposit"
  upgradeable: "no"
  rating: HIGH
  value_usd: 53099185
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 54
  last_active: 2026-11-17
  recoveries_14d: 12
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
  note: "owners and threshold read; all owners are EOAs today; no setter, no upgrade path; custody by Etherscan tag only"
---

## Summary

Contract `0x40f9f920ece7cce223625c088a6c1281ef396cf2` (Etherscan tag: Amina Deposit), with 621 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 622 multisig wallets holding 29,425 ETH: ordered signatures of owners (getOwners, isOwner, threshold, execute); no function name that changes the owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (5,201 bytes, no verified source) exposes execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256), getOwners, isOwner, threshold, nonce, domainSeparator: an EIP-712 SimpleMultiSig-style wallet. No function changes the owners or the threshold; no proxy slot, no upgrade function.
- State at block 26,438,999: 7 owners, all EOAs today, threshold 3, so it locks once 5 of the 7 owners take code.
- The other 621 addresses run the same code, each with its own owners.

## Impact and exposure

- Value held at block 26,438,999: $53.1M (ETH and 49 priced tokens, over 622 addresses).
- Activity: 54 transactions called it in the 90 days before that block; last on 2026-11-17.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
