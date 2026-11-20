---
id: f7767231-fixed-signer
title: "0xf7767231: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf7767231aec17c4ce5f630edc45f8159433a44a3"
  family: "99b2806ab022225375e21094ec08b49c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 11
  last_active: 2026-11-14
fix:
  layer: new-deployment
  who_acts: "deployer 0x786327ca99c6462ad509b786a24d57c20070aea0"
evidence:
  level: bytecode
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
  note: "MEDIUM: signed mint dies, nothing locked (anyone can sweep ETH to 0xdc66)."
---

## Summary

ERC721A staking/mint NFT (not DogZone): signed mint 0x6ed96433 (EIP-712) requires the recovered address to equal immutable 0x786327ca99c6462ad509b786a24d57c20070aea0 ("error signer"); if that key gets code, the signed mint dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: PUSH32 immutable 0x786327ca99c6462ad509b786a24d57c20070aea0 compared to recovered signer before revert "error signer" (f776 at 0x29c8–0x2a23); the study's constants 0xdc66…/0xde7d… are payout/minter addresses, not the signer
- signer 0x786327ca99c6462ad509b786a24d57c20070aea0: cast code = 0x (EOA) at block 26438999; equals owner() but immutable, no setter
- other mint: mintTo only by contract 0xde7dc7…2173; ETH out via public sendtoReceive() to 0xdc66…421f
- balance at block 26438999: 9,999,900,000 wei; txs_90d=11, last_active=2026-11-14

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 11 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Keep the deployer key an EOA or redeploy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
