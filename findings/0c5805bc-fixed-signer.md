---
id: 0c5805bc-fixed-signer
title: "0x0c5805bc: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0c5805bc1cd8ac2479141b1d914e72ac17a37b94"
  family: "0243cd1fd5e14087c7417fee731fa858"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner/project (redeploy or airdrop whitelist mints)"
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
  rating: MEDIUM
  note: "Only the free mint of new NFTs is affected. No funds already held depend on the signature."
---

## Summary

The whitelist mint accepts only signatures from a signer address hardcoded as a constant, and the contract has no way to change it. That signer has no code today. If it gets non-delegation code, whitelist mints stop working. No funds get locked: the paid public mint and withdrawAll still work.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- whitelistMint: require(_recoverAddress(msg.sender, signature) == _SIGNER_PUBLIC_KEY)
- _SIGNER_PUBLIC_KEY is a private constant 0xc127A4c0...5Fd0; row facts list code_bytes 0 and delegated false
- ECDSA.recover is used, with no ERC-1271 or code check
- withdrawAll() onlyOwner sends the balance without needing a signature; mint() is not signature-gated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer the owner can change, or with ERC-1271 support. Until then, use the owner-controlled public mint path for affected users.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
