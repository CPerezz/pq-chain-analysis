---
id: a062a905-wallets-fixed-signers
title: "0xa062a905: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa062a9056e358c03527bb4ceec3b2ae430cd77ec"
  family: "f783e50f26aceb9a06d864a892446847"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Signer set is settable via 0xe3537771 (and was changed in 2026), and the current cold-wallet signer is already a contract -> refuted. Main reviewer: looks like a drain/takeover in Feb 2026 (zero address in signers array is suspicious); exact signing rule of e3537771 not fully decoded."
---

## Summary

Not WalletSimple: custom 'Proassetz' hot/cold wallet (name(), isColdWallet, sendMultiSig(address,uint256,bytes,uint256,bytes) 0x49acb2db, deactivateSafeMode, 0xe3537771 that rewrites the cold-wallet signer with a 30-day timer). The signer is replaceable on-chain and the wallet was already taken over.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- slot0 cold wallet changed in block 24476469 (2026-02-17) from EOA 0x5a5b165d...a7 to 0xc62babeb...6d47 via 0xe3537771, in tx 0x30b4e10e877d2598dc37ce68aefd420d535134f07b601b4f3f7cf61c87c47851 sent through contract 0xc62b, which then called 0xc3b84aaa (token sends) repeatedly (trace_filter).
- 0xc62b... is a contract (MEV/swap-callback style: uniswapV3SwapCallback, unlockCallback); isSigner/isColdWallet(0xc62b)=true; other signer 0x453e3710...6823 EOA (nonce 419); signers array holds 0xd8b8f8fc... and 0x0.
- heimdall: e3537771 stores new cold wallet into slot0 and slot3=block.timestamp+30d; updateOwner selector is the embedded forwarder's (called via 0xc039ec40).
- Balance 0 ETH at 26438999; row txs_90d=0, last_active=null.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
