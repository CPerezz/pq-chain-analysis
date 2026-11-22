---
id: 635c7e2d-fixed-signer
title: "0x635c7e2d: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x635c7e2de558a04a33525a9489045a7245281db7"
  family: "42cce71fab3deffda1c9446981d7a261"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1237
  last_active: 2026-11-17
  recoveries_14d: 220
fix:
  layer: new-deployment
  who_acts: "the custodian's key holders move the dependent wallets' funds out while at least two keys are EOAs"
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
  rating: HIGH
  note: "A 2-of-3 signer set fixed at construction, with no setter and no upgrade, gates every exit from the dependent wallets (one holds 80.85 ETH). A second key remains while one migrates, but the set can never be replaced, so once two keys have code the funds lock. Same rating as the other fixed-signer wallets (custody wallets, Fintoch): moving out before the keys migrate is a migration step, not a way out: HIGH."
---

## Summary

A custodian vault: completeUnlock needs two signatures from a signer set fixed at construction (no setter). It is the custodian() of registry 0xd934…b023, which gates every transfer out of the clone wallets (for example 0xb859…698c, 80.85 ETH). The set holds three EOAs and only two signatures are needed, so one key taking code leaves the other two.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: time-locked vaults (3; 220 recoveries in the window): the signer set looks fixed at creation; the constant admin can extend time locks and sweep ETH. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Constructor args (creation tx 0xa36cf664…, block 16385822): primary 0x4c2f150f…5346, signers 0x7f669bfc…9969, 0xcf81afeb…f713, 0x2bdb56ed…6c57; signerSet() = true for all three, and none has code today
- Last 40 completeUnlock txs (blocks 26.39M–26.44M) recovered 0x7f66… and 0xcf81… each time; completeUnlock calls clone 0xb859…, which sends ETH out
- Registry 0xd934…b023: custodian() = this vault, and its only change path is requestCustodianChange/confirmCustodianChange. Clone impl 0xaa1c…6fa6: every transfer function requires msg.sender == registry.custodian()

## Impact and exposure

- Value held at block 26,438,999: $3,609 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,237 transactions called it in the 90 days before that block; last on 2026-11-17.
- 220 signature recoveries in the study's two-week trace window.

## Remediation

Keep at least two of the three signer keys without code, or move custody to a new custodian (confirmCustodianChange through this vault) before migrating keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
