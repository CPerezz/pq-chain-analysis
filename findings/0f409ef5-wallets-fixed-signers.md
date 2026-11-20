---
id: 0f409ef5-wallets-fixed-signers
title: "0x0f409ef5: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0f409ef5f9211576c244667a2c5d24580e4561af"
  family: "11dd1b398583e49c0ae723b489d7a253"
  copies: 22
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "none"
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
  rating: HIGH
  note: "1-of-1 fixed-owner wallet, no update path -> HIGH (22 identical copies, each with its own owner)"
---

## Summary

Original pre-EIP712 SimpleMultiSig -- minimal 4-selector dispatcher (threshold/execute/ownersArr/nonce only). Single owner, threshold=1; owner equals the contract's creator EOA. No setter, no proxy; owner still an EOA. 22 identical copies (factory-deployed, one owner per instance).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher = threshold()/execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256)/ownersArr(uint256)/nonce() only -- matches the minimal pre-712 SimpleMultiSig
- ownersArr(0) via publicnode = 0xb55f7af6e2e85d9515d6455d5e02b5290dd2c67c, matching Etherscan's ContractCreator
- threshold()=1 (scanner read, block 26438999)
- eth_getCode on publicnode (latest, block ~26488250) for the owner = 0x (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 22 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owner must migrate funds before taking code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
