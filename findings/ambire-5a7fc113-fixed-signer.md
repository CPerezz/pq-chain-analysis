---
id: ambire-5a7fc113-fixed-signer
title: "AmbireAccount7702: signer fixed in code"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5a7fc11397e9a8ad41bf10bf13f22b0a63f96f6d"
  family: "f5967d8dcd9e2017576d3f8379176e12"
  name: "AmbireAccount7702"
  label: "Ambire: EIP-7702 Delegator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1
  last_active: 2026-09-26
fix:
  layer: onchain-config
  who_acts: "the account owner (self-call setAddrPrivilege, or a direct executeBySender tx)"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The same act is open by a direct call, and keys are settable → LOW, consistent with the other Ambire rows (0x9701ae64…, 0xd7974ab5…, 0x66b71dc6…)."
---

## Summary

The Ambire EIP-7702 delegator. Its built-in privileged key is address(this), the delegating EOA itself, whose code is a 7702 delegation indicator that EIP-8151 exempts. Other privileged keys are settable by the account, and the same act stays open by a direct call (executeBySender).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode…. Read from source. Executed: a real transaction is unaffected by code at the signer. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source AmbireAccount7702.sol: privileges(key) returns 2 for address(this) and ENTRY_POINT_MARKER for EntryPoint 0x…71727De2…; others from storage
- AmbireAccount.sol:97-99 setAddrPrivilege requires msg.sender == address(this) (settable key); :187-192 executeBySender lets any privileged msg.sender (including the EOA itself) execute without a signature
- execute() :156-165 recovers via SignatureValidator (also ERC-1271/external modes) and checks privileges(signerKey); row: a real tx is unaffected by code at the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-26.

## Remediation

None needed. A key that takes real code is replaced by setAddrPrivilege, or the owner calls executeBySender directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
