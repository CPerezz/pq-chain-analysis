---
id: f04336d8-fixed-signer
title: "0xf04336d8: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf04336d85ac722fe5c8e619651ba014fc67f0602"
  family: "f50b9a122b68cf0567e0d4d043eb67d2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Whoever holds the SIGNER key: they must not give that account non-delegation code. Otherwise only a new deployment would help."
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
  note: "Only the operator's own stock is at stake: the contract holds items or tokens the operator put there for claimants, and no user deposited anything. Claims die for good with no rescue or update path: MEDIUM (D-024: operator's own money)."
---

## Summary

claimAirdrop accepts only signatures from a constant SIGNER, which is an EOA today (code_bytes 0). There is no setter, no ERC-1271 path and no upgrade path. Ownership is renounced and no function rescues the contract's balance. If SIGNER gets code, unclaimed airdrop tokens stay locked in the contract for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private constant SIGNER = 0xe1cF...A51E`, checked in claimAirdrop with `.recover(signature) == SIGNER`
- constants[0] 0xe1cf...a51e: code_bytes 0, delegated false (EOA)
- upgradeable: no; getters owner() = 0 (renounced)
- No function transfers the contract's own token balance except claimAirdrop and addLiquidity, and addLiquidity is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the SIGNER key as an EOA (or 7702-delegated) until claims finish. Otherwise the only route is to redeploy the token or airdrop with a replaceable signer or ERC-1271 support. On-chain, the existing contract cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
