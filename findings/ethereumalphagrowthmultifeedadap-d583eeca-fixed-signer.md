---
id: ethereumalphagrowthmultifeedadap-d583eeca-fixed-signer
title: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd583eecaa7bbde0d8ad3c84b8dac4d9612f823b4"
  family: "707c1d26f2ffcbf567f6926d176a368b"
  name: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV1"
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
  note: "No update path, no funds by design -> MEDIUM."
---

## Summary

RedStone multi-feed adapter (Gearbox-style, threshold 3 of a fixed signer list), no setter, direct deployment (no EIP-1967 slot). The MAIN/FALLBACK/MANUAL/OEV updater addresses in this contract are a separate msg.sender allow-list (not ecrecover-based) and are unaffected by EIP-8151; only the RedStone signer-recovery path is in scope. Holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MultiFeedAdapterWithoutRoundsPrimaryProd via RedstoneAdapterBase: getAuthorisedSignerIndex over fixed list, threshold 3 (dossier source)
- EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV1.sol:17-36: _validateBlockTimestamp checks msg.sender against MAIN/FALLBACK/MANUAL/OEV_EXECUTOR_ADDRESS -- a direct-caller allow-list, not ecrecover
- cast storage slot 0 == 0 at block 26438999; no EIP-1967 impl slot

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new adapter with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
