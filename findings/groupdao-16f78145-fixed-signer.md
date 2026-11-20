---
id: groupdao-16f78145-fixed-signer
title: "GroupDAO: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x16f78145ad0b9af58747e9a97ebd99175378bd3d"
  family: "ab9599b80dea8a629e559552131c3d03"
  copies: 2
  name: "GroupDAO"
  label: "GroupDAO: GDO Token"
  upgradeable: "no"
  rating: NONE
  value_usd: 7814
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-11-10
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "The signed function has been unreachable since 2022; EIP-8151 changes nothing."
---

## Summary

GroupDAO GDO token: claim() mints airdrop tokens on a signature from the immutable cSigner, but it has required block.timestamp < END_AIRDROP (1643644800, 2022-02-01), so it has been dead since 2022 regardless of EIP-8151.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: GroupDAO claim: signed by cSigner, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- GroupDao.sol: claim requires block.timestamp < END_AIRDROP = 1643644800, then ecrecover(...) == cSigner (immutable, no setter)
- Block 26438999 timestamp 1794969479 > END_AIRDROP, so claim always reverts before the recovery
- Token transfers have no signature; the constants (ADDR_DAO/STAKING/LP/ILP) are EOAs with no code

## Impact and exposure

- Value held at block 26,438,999: $7,814 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
