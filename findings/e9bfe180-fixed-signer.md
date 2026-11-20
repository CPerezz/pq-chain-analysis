---
id: e9bfe180-fixed-signer
title: "0xe9bfe180: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe9bfe180c5696dd97db29791b1fa48ac833613ec"
  family: "75b590794d8de4c8303f0d8cc584b4e2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 18
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner (set mintPhase to 2 so publicMint serves as alternative)"
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
  note: "The study note says this is a presale with signed deposit and claim. The code is actually an NFT allowlist mint."
---

## Summary

The signer is a hardcoded constant, 0x9c1f...875a. It is also the owner, and it has no code today. If that account gets real code, allowlistMint stops working. Only new allowlist mints are lost, and nothing is locked. The owner can open public minting by setting mintPhase to 2, and withdraw() needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _validSignature: require(signer == 0x9c1fC608ca7a97052536E25d03933bE48FD8875a)
- constants: 0x9c1f...875a code_bytes 0, not delegated; also owner()
- No signer setter; upgradeable: no
- publicMint() needs no signature when mintPhase==2; setMintPhase onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner sets mintPhase to 2 so publicMint replaces the allowlist mint. Otherwise, keep the signer key an EOA (or use only a 7702 delegation, which still works).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
