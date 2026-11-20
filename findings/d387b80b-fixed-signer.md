---
id: d387b80b-fixed-signer
title: "0xd387b80b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd387b80bf5bbc672a99af9bac46652493bec94c8"
  family: "67e5d64c8aa87fedbd7de6dde36a7a4b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project owner/operator"
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
  note: "Only new mints are affected. Already minted NFTs stay transferable and the ETH can be withdrawn by the owner."
---

## Summary

The signer is a hardcoded constant with no setter and no ERC-1271 path. It is 7702-delegated today. If that key's account gets real code, new signed mints stop. Nothing held is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- safeMint: address signer = ecrecover(hash,v,r,s); require(signer == 0x005199627E4aea0Ba8c85c2D182fE8852bcFEdEF)
- No function writes a signer variable; the only setter is transferOwnership, which changes the owner
- Bytecode fact: 0x005199...EdEF is 7702-delegated (0xef0100afab751f...)
- withdraw() onlyOwner sends the contract's whole balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key an EOA or 7702-delegated account, or deploy a new contract with a settable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
