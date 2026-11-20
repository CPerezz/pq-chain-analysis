---
id: c1542021-fixed-signer
title: "0xc1542021 (tagged Demonix: DMX Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc1542021c3b20dc90ea54c70dabdb0ded4d4eb04"
  family: "bbaae1578215685cb828320ebd91a5aa"
  label: "Demonix: DMX Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 50
  last_active: 2026-11-14
fix:
  layer: new-deployment
  who_acts: "The owner/project would need to redeploy, or whitelisted users would have to use the paid public mint instead."
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
  note: "The study_note's description as a presale whose deposit and claim need a signature doesn't fit this source. This contract is an NFT mint where only the free whitelist mint needs a signature. The rating is MEDIUM because only a function stops working and nothing is locked."
---

## Summary

The whitelist mint only accepts signatures from a constant signer address that has no code today. If that account gets code under EIP-8151, whitelistMint stops working. No funds are locked: the public mint still works and the owner can still withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _SIGNER_PUBLIC_KEY is a constant set to 0x42945b71...1329; its code_bytes = 0 and it is not delegated
- whitelistMint requires _recoverAddress(msg.sender, signature) == _SIGNER_PUBLIC_KEY, using ECDSA.recover with no ERC-1271 check
- No function can set the signer; the row facts list only transferOwnership as a setter
- mint(uint) is paid and needs no signature; withdrawAll() is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 50 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Redeploy with a signer that can be replaced or with ERC-1271 support, or keep the signer key as a plain EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
