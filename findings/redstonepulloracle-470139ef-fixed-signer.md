---
id: redstonepulloracle-470139ef-fixed-signer
title: "RedStonePullOracle: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x470139efeee7c481d08eb0898af87ee9a8b0a0ea"
  family: "703ac7e99a527772afedb0a03557ba82"
  copies: 2
  name: "RedStonePullOracle"
  label: "deployed by Tokemak: Deployer 1"
  upgradeable: "no"
  rating: NONE
  txs_90d: 107
  last_active: 2026-11-17
  recoveries_14d: 60
fix:
  layer: none
  who_acts: "ORACLE_MANAGER role"
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
  verdict: refuted
  rating: NONE
  note: "Not a fixed signer: ORACLE_MANAGER replaces the RedStone signers with registerAuthorizedSigners and the quorum with setUniqueSignersThreshold. Its other rows (gas limits, signed shortcut) are filed on their own."
---

## Summary

The authorised RedStone signers are not fixed. registerAuthorizedSigners(address[]) lets ORACLE_MANAGER replace them, and setUniqueSignersThreshold changes the quorum.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed / Tokemak AutopoolToken permit:…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source RedStonePullOracle.sol lines 173-184: registerAuthorizedSigners is guarded by hasRole(ORACLE_MANAGER) and overwrites _authorizedSigners
- Deployed bytecode contains selectors 0x1cb1f9c5 (registerAuthorizedSigners) and 0x7f1a4460

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 107 transactions called it in the 90 days before that block; last on 2026-11-17.
- 60 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
