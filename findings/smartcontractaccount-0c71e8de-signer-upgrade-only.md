---
id: smartcontractaccount-0c71e8de-signer-upgrade-only
title: "SmartContractAccount: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0c71e8def7a359b347f30dac0739eaee19055008"
  family: "90226a6be4662d6588750d439704aaa6"
  copies: 3
  name: "SmartContractAccount"
  upgradeable: "yes"
  admin: "0xbc803da87442fc26207930e9a0716744851b92ac (7702-delegated EOA)"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted: the key is settable by a live admin, and the same act stays open by a direct call."
---

## Summary

SmartContractAccount proxy: the signer is `admin`, which the admin can replace (changeAdmin), and the admin can also move tokens directly (transferERC20). The admin 0xbc803da8… is a 7702-delegated EOA (nonce 13), and the proxy has an admin-gated upgradeTo.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x18faf8552ab6a0bd155069f5f7eff383ebaaef23: no admin, no upgrade function in the implementation.
- implementation 0x18faf855… source: changeAdmin(address) onlyAdmin; transferERC20 onlyAdmin; permitTransferERC20 requires recover == admin (SmartContractAccount.sol:73-144)
- proxy slot 0 = admin 0xbc803da87442fc26207930e9a0716744851b92ac, slot 1 = 0x18faf855… at 26438999
- 0xbc803da8…: code 0xef0100… (7702 delegation), nonce 13

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin calls changeAdmin, or uses transferERC20 directly

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
