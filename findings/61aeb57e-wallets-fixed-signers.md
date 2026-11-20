---
id: 61aeb57e-wallets-fixed-signers
title: "0x61aeb57e: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x61aeb57e855c838ccaac064f88ad3a67932ce7bd"
  family: "288f73f34ade1eef0c9bd000ec6c178b"
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
  note: "Refuted: the co-signer check does not depend on a recoverable key. A failed recovery returns 0, and 0 is in the signer set, so the same act stays open after EIP-8151. Wrong template attribution."
---

## Summary

Not WalletSimple 2017: a BitGo-derived cold-wallet variant (sendMultiSig(address,uint256,bytes,uint256,bytes) 0x49acb2db, token send 0xc3b84aaa, cold-wallet change 0xe3537771, isColdWallet) whose signer array holds address(0), so a failed ecrecover (which returns 0) is accepted as the co-signer today; EIP-8151 making recovery fail changes nothing. value_usd not set in row, txs_90d 0, last_active null (row.copies 2).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- storage at 26438999: slot1 (signers array) length 2, element0 0xd8b8f8fce0c1324cf5ff74390fcd87a34ef325b4 (EOA, nonce 0, reth latest block ~26452855), element1 0x0; isSigner-style view 0xb895052f(0x0) returns true
- eth_call --trace at 26438999 of sendMultiSig from 0xd73b31b9608bade872d9a35c431f30ea7d75e13d (EOA, nonce 1738 at reth latest block ~26452855; allowed caller, slot2) with an all-zero 65-byte signature: ecrecover returns empty, execution proceeds to the value CALL (fails only on OutOfFunds since balance is 0); the same zero-signature call succeeds from 0xd8b8… and from cold wallet 0xc62babebab050de58078d33fcfa5514ea0506d47 (contract at reth latest block ~26452855)
- tx 0x12c2467ecb1816e7bf58ddc24608683ddd3ce8d7994053649b4beee0c0062445 (2026-02-17): a constructor contract called 0x0f9a7194, 0xe3537771 (cold wallet changed, slot3 = +30 days = 0x69bbe7f7) and sendMultiSig with signatures recovering 0xd8b8…, moving 0.02 ETH out; same sweep on wallets 0xa062a905… and 0x7574b3e1…; ETH balance 0 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for EIP-8151. Separate finding: the co-signature check is void (address(0) in the signer set), so any allowed caller moves funds alone.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
