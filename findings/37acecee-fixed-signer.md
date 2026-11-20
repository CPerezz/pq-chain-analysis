---
id: 37acecee-fixed-signer
title: "0x37acecee: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x37aceceebdc30398cf5b6ae6b7458e9e39d694d3"
  family: "f5865362751ec5ea2b61683caa7e9832"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Signer key holder (same as owner 0xdc55…88a) should avoid putting non-7702 code on that account; otherwise the owner mints using reserve() or deploys a new contract"
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
  note: "Owner and signer are the same address (0xdc55…88a). Address 0x1418…d959 is another constant (EOA) that the shown source does not use as the signer."
---

## Summary

The onboard mint accepts signatures only from a hardcoded constant _signer. That address is an EOA today (0 bytes of code) and nothing can replace it. If the account gets code, signed minting stops. No funds are held, and the owner can still mint through reserve(). So only one function stops and nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public constant _signer = 0xdC55Ee0780a776B01ecbE0110daefa30705fE88a`
- _verify: `_recover(hash, token) == _signer` uses ECDSA.recover with no ERC-1271 check
- onboard requires _verify(_hash(salt,msg.sender),signature) before _safeMint
- constants: 0xdc55…88a code_bytes 0, delegated false; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key without code (only EOA or 7702 delegation). Otherwise the owner mints through reserve() or redeploys with a settable signer that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
