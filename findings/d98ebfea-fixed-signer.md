---
id: d98ebfea-fixed-signer
title: "0xd98ebfea: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd98ebfeac3cc0017fc7225ae2c8ac9a260d446b7"
  family: "aafbb2553d975fda3c3e66cc7e2f1dfb"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "contract owner 0x136caa995d37007682958c70770c71747794184e"
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
  note: "MEDIUM: no update path, mint function dies, sale proceeds leave via owner withdraw()."
---

## Summary

ERC721A signed-mint collection: the only mint path requires a signature from fixed signer 0x20b1897f…A152; if that key gets code, minting dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled.sol: mint (mint(uint256,bytes) via verifier 0x648b4d5b) requires recovered == 0x20b1897ffeb6883533851fa4a8c6b1712239a152 ("Invalid signature"); setters = transferOwnership only
- signer() returns 0x20b1…a152 at block 26438999; cast code = 0x (EOA)
- no other mint; ETH out via onlyOwner withdraw()
- balance 0 at block 26438999; txs_90d=0, last_active=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep signer key an EOA or redeploy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
