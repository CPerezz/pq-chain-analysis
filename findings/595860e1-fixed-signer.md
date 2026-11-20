---
id: 595860e1-fixed-signer
title: "0x595860e1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x595860e123ac869b5d7b32a59509d46bff6fbd76"
  family: "1ed86ce89d344d6349cba4b6174379e7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-10-13
fix:
  layer: new-deployment
  who_acts: "owner (could move the presale window and mint the rest itself with ownerMintForSell; changing the signer would need a new deployment)"
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
  note: "The study note says 'deposit and claim', but the code only has a signed presale mint. The signer address is taken from the immutable in the runtime bytecode."
---

## Summary

Only presaleMint needs the immutable whitelistChecker signature. That address is an EOA today. If it gets code, whitelist mints stop working, but no funds get locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable whitelistChecker` is assigned in the constructor and has no setter
- presaleMint: recover(signature) == whitelistChecker
- Bytecode immutable 0x692a2dad63273759dcfc578aef36238581a58ea2 is an EOA with no code
- ownerWithdrawETH() is onlyOwner and sends the whole balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

Deploy a new contract with a signer that can be replaced or that supports ERC-1271, or have the owner sell the remaining supply through ownerMintForSell.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
