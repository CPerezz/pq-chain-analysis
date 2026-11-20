---
id: 1109e476-fixed-signer
title: "0x1109e476: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1109e476ee25ce6e0838e331df3e23e7ae4af443"
  family: "fd060f9dad81203c9b841ef58ee873a5"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The FLY/Pilot admins: deploy a new minter with a new signer and give it the mint and updateMetrics rights."
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
  note: "The row facts give no code size for the signer address 0xc90a…. It matches owner(), which OZ Ownable sets to the deployer, so it is very likely an EOA, but its current code is not measured. The constant 0x14185d… (no code) is probably fly or pilot, not the signer. Rated MEDIUM because only new mints stop."
---

## Summary

The voucher signer is immutable and cannot be replaced, and there is no ERC-1271 path. If the signer key's account gets real code, claims stop. Nothing is locked, because the rewards are newly minted tokens.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` is set only in the constructor
- _verifyVoucher: require(dg.recover(sig) == signer)
- signer() getter = 0xc90a5663326637d6c852258400ca9643ca4aef5f, the same address as owner()
- _processClaim calls fly.mint(who, flyOut); the contract holds no user deposits

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new FLYMinterVoucher with an EOA signer, or with ERC-1271 support. Then grant it the FLY mint role and the Pilot updateMetrics role.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
