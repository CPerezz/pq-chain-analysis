---
id: 9543eff0-wallets-fixed-signers
title: "0x9543eff0: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9543eff02a75b13734ac23d198c2e7f16c946016"
  family: "1922fb8e3b4303d148420f66e83b17c1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 9
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
- Unverified bytecode with the WalletSimple 2017 selectors (sendMultiSig 0x39125215, sendMultiSigToken 0x0dcd7a6c, signers, isSigner, safeMode/activateSafeMode, createForwarder, flushForwarderTokens) and the embedded Forwarder; heimdall shows the same verifyMultiSig flow (onlySigner, 65-byte sig, expireTime, sequence window of 10/+10000, isSigner(recovered), recovered != msg.sender).
- Runtime SSTOREs outside the embedded Forwarder are only safeMode and the sequence-id window; no DELEGATECALL/SELFDESTRUCT, no EIP-1967 implementation slot; main-runtime CALLs only ecrecover, the signed ETH/token sends and value-0 helper calls (forwarder flush/creation, logger).
- signers at block 26438999: 0xbc17029c2fdac6176ff42090914980a07a396d57 (EOA, nonce 3); 0xb79ff94b53a4dc526095b2c12d2157d4bf61f9d0 (EOA, nonce 0); 0x420493d79fb6bfc1e7d6de4654f1ad5f35063375 (EOA, nonce 0); cast code latest = 0x for all three (getNextSequenceId 1).
- Row: value_usd 9, txs_90d 0, last_active null, copies 1.

## Impact and exposure

- Value held at block 26,438,999: $9 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH and tokens to a new wallet (e.g. a 7702-capable or code-checking multisig) with sendMultiSig/sendMultiSigToken before any signer key gets real code; afterwards the wallet only works while two of the three EOA signers keep code-free keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
