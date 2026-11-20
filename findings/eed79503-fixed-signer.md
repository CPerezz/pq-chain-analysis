---
id: eed79503-fixed-signer
title: "0xeed79503: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xeed7950301f46ec758bbd2d1a7ad6cbf3ef96177"
  family: "a8fd01426c86b76730a3612fac58f1f7"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "n/a"
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
  verdict: refuted
  rating: NONE
  note: "The only fixed-signer ecrecover in this family lives inside an unused/unreferenced public view getter; every function that actually moves tokens or changes ownership uses plain address checks. The claim as stated (deposit/claim needing SIGNER) does not describe this template."
---

## Summary

Shares a common generator template (NFT/streak or NFT-staking contract — 'crate'/'unbind cheetah' strings in the staking variant). Every member has the same dead selector 0x0537a5b1, a public view stub whose real body (hidden by heimdall) contains the only ecrecover/fixed-signer code in the whole family. Every other, fully-decompiled selector (stake, unbind, transferOwnership, renounce, the NFT-streak claim) is gated by plain msg.sender or ownerOf checks, never by a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Heimdall fully decompiles every selector except 0x0537a5b1 in both a representative of this cluster (0x0a3afb20...) and a second, structurally distinct member with extra functions (stake/unbind on 0x539b6d1c...); in both, 0x0537a5b1 is left as a trivial stub while all other logic (including the money-adjacent stake()/unbind()) is shown in full with no recover() call.
- On 0x539b6d1c..., stake(uint256,uint256) is gated by `require(0xe21ebcd2...==msg.sender, "stake can only be called from the Saudis")` (a hardcoded caller check, not ecrecover); unbind (0x0fc9abbc) checks ownerOf(tokenId)==msg.sender via a staticcall, also not ecrecover.
- No PUSH2+JUMP call site anywhere in the bytecode reaches the block containing the STATICCALL-to-1/secp256k1-constant sequence other than a local JUMPI inside the same isolated view function — it is not shared/called by anything else.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
