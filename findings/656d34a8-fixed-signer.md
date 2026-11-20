---
id: 656d34a8-fixed-signer
title: "0x656d34a8 (tagged R Planet: RPlanet Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x656d34a8309363302e46de99853f4cef30b85a1d"
  family: "379b91c00c121a8430c7487c312a5f27"
  label: "R Planet: RPlanet Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 268
  last_active: 2026-11-17
fix:
  layer: new-deployment
  who_acts: "Project owner (redeploy or use the crossmint/owner paths); signer key holder must not give its account non-delegation code"
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
  note: "legendaryWallet (171 bytes of code) is the address that receives withdrawals. It is not the signer."
---

## Summary

The signer is a hard-coded constant EOA (0 bytes of code today), and nothing can replace it. If that key's account gets real code, signed public mint() stops working. No funds get locked: the ETH already held can still be withdrawn with withdraw(), and NFTs can still be transferred.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- publicKey constant 0xFCDD24e44A8c669c2798394fc7091b84D360d916, code_bytes 0, not delegated
- verifySignedAddress: ecrecover(prefixedHashMessage,_v,_r,_s) == publicKey, no code check or ERC-1271
- Only setters: transferOwnership, setCrossmintAddress, setBaseURI; none touch publicKey
- withdraw() onlyOwner sends balance to legendaryWallet without signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 268 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Deploy a new contract that has a signer setter or ERC-1271 support. In the meantime, sell through crossmint() or ownerOnlyMint().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
