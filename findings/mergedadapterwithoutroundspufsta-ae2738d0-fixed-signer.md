---
id: mergedadapterwithoutroundspufsta-ae2738d0-fixed-signer
title: "MergedAdapterWithoutRoundsPufStakingV1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xae2738d003af1dbdc31fb83c07b02ca3d2a0abc2"
  family: "98da8b6b8c64cbed423d14ea55b6e752"
  copies: 5
  name: "MergedAdapterWithoutRoundsPufStakingV1"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "RedStone (no owner action; feed just stalls)"
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
  note: "No update path, adapter holds no funds by design -> MEDIUM."
---

## Summary

RedStone pufETH-staking price-feed adapter: fixed 5-signer list (dossier's own copy; threshold 2 in prod config), no setter. This instance is a direct deployment, not a proxy (EIP-1967 slot empty at block 26438999). The adapter itself holds no funds (eth_at_pinned_block=0); any dependent vault was not in this dossier so its own escape path is not claimed here.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MergedAdapterWithoutRoundsPufStakingV1.sol via RedstoneConsumerBase: getAuthorisedSignerIndex over fixed list (dossier source)
- cast storage slot eip1967_implementation == 0 at block 26438999 for this exact address (facts/state.json)
- facts.json: eth_at_pinned_block=0, addresses_with_eth=0; who_depends_on_it: 0 callers seen in corpus

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new adapter with fresh signers; any dependent protocol repoints its feed reference.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
