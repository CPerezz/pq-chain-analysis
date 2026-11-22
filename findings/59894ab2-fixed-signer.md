---
id: 59894ab2-fixed-signer
title: "0x59894ab2 (tagged deployed by Hyped'n'Bananed: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x59894ab2fad941f86b59b94a68a9de5028a4c559"
  family: "88f4f0813a031030ca3943c9e224f852"
  label: "deployed by Hyped'n'Bananed: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 397
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-10-23
fix:
  layer: offchain
  who_acts: "Owner (can mintTo users directly in place of free mints)"
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
  note: "The second constant 0x4ea65764736f6c634300080d0033 is part of the compiler metadata at the end of the bytecode, not a real address. The study note calls this a presale with signed deposit and claim, but the code is an NFT contract where only free minting needs a signature."
---

## Summary

The signer is AUTH_ADDRESS, a constant in the code. Nothing can replace it, and the contract has no code check or ERC-1271 path. That address has 0 code bytes today, so it is a plain account. The signature only gates freemintTo, which mints new NFTs for free. Nothing already held is locked: the owner can still withdraw the ETH, paid claims need no signature, and the owner can mint directly with mintTo. This is MEDIUM: only the signed free mint stops working.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- AUTH_ADDRESS is constant 0x0D654EDb68684e7F66093d6366c309315aAC882F; row facts show code_bytes 0, not delegated
- freemintTo: require(who == AUTH_ADDRESS, "Wrong Auth") using ecrecover via ECDSA.recover
- No setter for AUTH_ADDRESS; the only setter, transferOwnership, changes the owner
- withdraw/withdrawAll onlyOwner move ETH; claim() needs no signature; mintTo onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $397 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

No contract change is needed. The owner can give free mints by calling mintTo(_to,_quantity) directly. The AUTH_ADDRESS key should not get non-delegation code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
