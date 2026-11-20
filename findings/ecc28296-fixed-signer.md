---
id: ecc28296-fixed-signer
title: "0xecc28296: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xecc28296f247039e4db1b9020b5cfd88d894d038"
  family: "6050877e52f30aecdfe980ec2884a184"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator"
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
  note: "The row facts do not give the code size of the signer address, because constants[] is empty: the address is an immutable set in the constructor. The confirmed verdict assumes it is an EOA today, which was not measured. If it already has non-delegation code, the verdict becomes refuted."
---

## Summary

The mint signer is an immutable address set in the constructor, and nothing can replace it. If that key's account gets code, signed public mints stop working. Nothing is locked: the owner can still withdraw ETH and mint with selfMint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constructor: cSigner = 0x32715879DD1fFBFa99F0A54F802E163FBA4fDE29 (immutable)
- mint: require(ecrecover(digest,v,r,s) == cSigner)
- No function writes cSigner. No code check or ERC-1271 path.
- withdraw() onlyOwner transfers the balance. selfMint onlyOwner mints without a signature.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract (or a new mint contract) whose signer can be replaced or that accepts ERC-1271 signatures. Keep the signer key's account an EOA or 7702-delegated.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
