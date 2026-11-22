---
id: 32fe8630-wallets-fixed-signers
title: "0x32fe8630: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x32fe8630c1f363b9f04a1421831eb44c4da0a9a9"
  family: "e373698077d1c443bab9679754efc7d5"
  upgradeable: "no"
  rating: HIGH
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet signers (move funds to a new wallet before any signer key gets code)"
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
  note: "Fixed signer set, no update path, and the owners' own funds move only with a recoverable co-signer signature, so HIGH. All three signers are EOAs today. The caller role needs no signature, so a coded signer can still be msg.sender if its code can make calls; each send still needs one other signer whose EOA key recovers."
---

## Summary

BitGo WalletSimple: sendMultiSig/sendMultiSigToken need msg.sender to be a signer plus an ecrecover'd co-signer from the fixed 3-signer set; signers fixed at construction, no setter, no other exit. Once a signer key gets real code its signatures stop recovering; when no signer other than the caller can produce a recoverable signature, the wallet's ETH/tokens are locked. value_usd 1, txs_90d 0, last_active null.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- code: later WalletSimple build (11.4 KB): template selectors sendMultiSig 0x39125215 / sendMultiSigToken 0x0dcd7a6c / signers / isSigner / flushForwarderTokens / createForwarder / activateSafeMode plus view-only hash helpers (0xa2754259, 0xd258967b, recentSequenceIds 0xed9989c1, pure 0x73bb0cb5); co-signer signature is over the eth_sign-prefixed operation hash; local anvil run of this runtime with signers set to test keys: all-zero signature reverts, valid co-signer signature executes (signature check is real)
- signers(0..2) at 26438999: same three signers as 0x39ef…: 0xE110…062e (EOA, nonce 60), 0xd4E6…c23b (EOA, nonce 0), 0xeda3…9F9f (EOA, nonce 0); signers(3) reverts; code and nonces of all three signers read on reth at latest, block ~26452855: all 0x (EOA)
- EIP-1967 implementation slot 0; no upgrade/owner/signer-setter selector in dispatcher; fallback only logs deposits, forwarders flush only to the wallet, activateSafeMode only restricts destinations

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH/tokens to a wallet whose signer set can change (or accepts ERC-1271) before any signer key is migrated to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
