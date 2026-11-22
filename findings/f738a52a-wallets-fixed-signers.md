---
id: f738a52a-wallets-fixed-signers
title: "0xf738a52a: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf738a52a5835caa35351996d45046354271c0eb6"
  family: "df387e1450d9b2be8b7dbd4df4f7f081"
  copies: 163
  upgradeable: "no"
  rating: HIGH
  value_usd: 103
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

An unverified 4373-byte BitGo WalletSimple 2017 variant: its selectors are exactly the 2017 set, the signers are fixed and there is no setter. Spending needs a signer as msg.sender plus one ecrecovered co-signer.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 163 wallets in the BitGo pattern. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors at 26438999: sendMultiSig, sendMultiSigToken, flushForwarderTokens, createForwarder, activateSafeMode, safeMode, signers(uint256), isSigner, getNextSequenceId; no setter, no 1626ba7e, no proxy slot
- heimdall decompile (scratch dec/0xf738…) shows no SSTORE path to signers outside construction
- Signers 0xe3C4E792d77066A09886E035b3e6c967BAB62A36, 0xCa5268c4336E9cCE8389bBA785698a48Db564256, 0xfE22566EaEe332EDf9f1De7592AD80fb90788694: all EOAs, no code (latest, block ~26452917); value_usd 103, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $103 (ETH and 49 priced tokens, over 163 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
