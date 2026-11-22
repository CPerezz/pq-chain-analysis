---
id: 999408fd-wallets-fixed-signers
title: "0x999408fd: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x999408fd1139f8d6423d34bf728d4f82a48031a6"
  family: "300bc334c5be350f3f028dc1868d4c7c"
  copies: 13
  upgradeable: "no"
  rating: HIGH
  value_usd: 1294
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner moves the funds to a new account while its key is still an EOA"
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
  note: "A single-owner account whose owner is fixed at init: meta-transactions are its only way to move funds and need the owner's ECDSA signature, with no direct call and no setter. Once the owner key's account has code the funds lock: HIGH, as for the other fixed-owner wallets (moving out first is a migration step, not a way out)."
---

## Summary

Not a Gemini custodian. EIP-1167 clone of 0x55b6be9e (an any.sender-style ProxyAccount: init(owner) once, owner(), nonceStore, getChainID, signed forward/batch). Meta-transactions run only when ecrecover returns owner(); the owner has no setter and no direct-call path.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: delegates to a fixed address.
- cast code: 45-byte EIP-1167 proxy -> 0x55b6be9e60f56fbca38b7a029e7d8cb9d04f3d8d
- impl bytecode strings: 'Owner did not sign this meta-transaction', 'Owner is already set' (init is one-shot); the only CALLER opcode sits in metadata, so there is no msg.sender path
- owner()=0xc522acdc...4c05 (EOA, nonce 0); balance 0.545 ETH at block 26438999
- no proxy slot, no upgrade or owner-change selector (selectors: init, owner, getChainID, nonceStore, 2 forward functions)

## Impact and exposure

- Value held at block 26,438,999: $1,294 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner moves the proxy's assets out with an owner-signed forward() before the owner address gets non-delegation code; nothing can be changed afterwards.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-wallets-fixed-signers` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
