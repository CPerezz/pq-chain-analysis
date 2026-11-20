---
id: 12f6a542-fixed-signer
title: "0x12f6a542: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x12f6a5427411cc12e288ffa87cf2cc4a777392aa"
  family: "21bcde4f704dd0cea10ae6f73854ec8c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner or deployer"
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
  note: "The verdict assumes the signer 0xc90a... is an EOA today. That is not proven: the row facts give no code size for this address. The only address constant measured is 0x1618..., which has 0 bytes of code. If 0xc90a... turns out to have non-7702 code, the verdict becomes refuted. The study_note's 'presale' description does not match this code."
---

## Summary

The signer is immutable and nothing can replace it. If the signer key's account gets real code, new pilot NFT mints and airdrops stop. Nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer`, assigned only in the constructor
- mintPilotNFT: `require(dg.recover(sig) == signer)`, a plain ECDSA check with no ERC-1271 path
- signer() getter returns 0xc90a5663326637d6c852258400ca9643ca4aef5f, the same address as owner()
- _beforeTokenTransfer: `require(f == address(0)
- t == address(0), "soul-bound")`, so there is no value flow beyond minting

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be rotated or that accepts ERC-1271 signatures, and point METAR minter rights at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
