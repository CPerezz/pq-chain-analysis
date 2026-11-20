---
id: multisig2of3-dcaab14b-wallets-fixed-signers
title: "MultiSig2of3: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xdcaab14b7073eec774dc1cf9e235ce656fc09bf4"
  family: "59a9bd0d15960ac5016b33d00fc3bd3c"
  copies: 58
  name: "MultiSig2of3"
  upgradeable: "no"
  rating: HIGH
  value_usd: 43
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

MultiSig2of3 (Unchained-style): spend needs two distinct ecrecovered owners out of three fixed in the constructor.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: MultiSig2of3 _validSignature: two distinct owners of three fixed at deployment. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source MultiSig2of3.sol: owners mapping written only in the constructor; spend needs 2 ecrecovered distinct owners
- Runtime selectors at 26438999 are the same 5 as Trezor (no withdrawAirdrop)
- Constructor args (creation tx 0xa42119bd…, block 6604244): owners 4094a7…, 1a57b4…, 9d70d9…
- Signers 0x4094a7737772767a3f4026a919d707ffdb1927a6, 0x1a57b4b16c22f1ddfbe277e192c9276701db1e8e, 0x9d70d9c3354bc372c6eb41a9d2a7a9d2deb6f63e: all EOAs, no code (latest, block ~26452917); value_usd 43, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $43 (ETH and 49 priced tokens, over 58 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
