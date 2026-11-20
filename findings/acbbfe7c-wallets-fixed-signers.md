---
id: acbbfe7c-wallets-fixed-signers
title: "0xacbbfe7c: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xacbbfe7cc100d49a1b6837c631f7238207872404"
  family: "a7fda7e5b8e6e16c4195334cd10c2ef8"
  copies: 6
  upgradeable: "no"
  rating: HIGH
  value_usd: 209
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the wallet's signers"
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
  note: "Wallet whose fixed owners' 2-of-3 ecrecover signatures are the only way to move its funds, no update path → HIGH. safeMode only restricts destinations; forwarders only push to the wallet."
---

## Summary

Runs the BitGo WalletSimple 2017 2-of-3 check (caller must be a signer, ecrecover'd second signer must be a different signer); three EOA signers fixed at construction, no setter, no upgrade, no other exit. Funds are stuck once signer keys get real code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unverified slim WalletSimple variant: sendMultiSig 0x39125215, sendMultiSigToken 0x0dcd7a6c and a second token send 0xd2cfed96 (transfer without return check), no safeMode/forwarders; heimdall shows the same check (65-byte sig, expireTime, sequence window, isSigner(recovered), msg.sender != recovered).
- Runtime SSTOREs outside the embedded Forwarder are only safeMode and the sequence-id window; no DELEGATECALL/SELFDESTRUCT, no EIP-1967 implementation slot; main-runtime CALLs only ecrecover, the signed ETH/token sends and value-0 helper calls (forwarder flush/creation, logger).
- signers at block 26438999: 0x798cd65c34b9071a9ec415ab501e96499b6af81b (EOA, nonce 4); 0x5fc2ec092eb899a39cecb624241f1e4495f3ca13 (EOA, nonce 0); 0xdea911540ec9684ed83f398db5f8daefe4db7383 (EOA, nonce 0); cast code latest = 0x for all three (getNextSequenceId 4).
- Row: value_usd 209, txs_90d 0, last_active null, copies 6.

## Impact and exposure

- Value held at block 26,438,999: $209 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH and tokens to a new wallet (e.g. a 7702-capable or code-checking multisig) with sendMultiSig/sendMultiSigToken before any signer key gets real code; afterwards the wallet only works while two of the three EOA signers keep code-free keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
