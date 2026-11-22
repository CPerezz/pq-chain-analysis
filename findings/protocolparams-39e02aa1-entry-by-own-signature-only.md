---
id: protocolparams-39e02aa1-entry-by-own-signature-only
title: "ProtocolParams: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x39e02aa1dbf55a7fdd70f2d6f64fe24293e82cf8"
  family: "be86c7a1d5f327917c62433970ddd8b3"
  copies: 2
  name: "ProtocolParams"
  upgradeable: "yes"
  admin: "TimelockController 0xdec656861922d11a3f08e8ba3631ccdea877d9d3 (TBV_PROTOCOL_ADMIN, 5-day delay); proposers not read"
  rating: LOW
  txs_90d: 9
  last_active: 2026-11-12
fix:
  layer: account-migration
  who_acts: "UC admin (chooses a new op-ETH key without code)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Key registration by its own signature only; nothing held. LOW holds."
---

## Summary

ProtocolParams (TBV, UUPS proxy): setOperationEthKey requires a proof-of-possession signature by the new op-ETH key itself. Under EIP-8151 a new key with non-7702 code cannot be registered; no funds are held and the admin can pick another key.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: BTCProofOfPossession: secp256k1 recovery in contract code (Secp256k1.recover), not the precompile / EthProofOfPossession verify: the new operator key named must sign its own registration /…. Read (function text).
- ProtocolParams.sol:228-242 setOperationEthKey: _requireCurrentUcAdmin(msg.sender), then EthProofOfPossession.verify (ECDSA.recover == newOpEthKey, EthProofOfPossession.sol:41); BTC PoP uses BIP340 via the ecrecover trick, recovered value is a hash-derived address, not an account
- EIP-1967 impl 0x7ff7f17b… set; _authorizeUpgrade onlyAdmin (TBV_PROTOCOL_ADMIN 0x1ed62f…); hasRole(admin, 0xdec65686…) = true at 26438999; 0xdec65686… has code and getMinDelay() = 432000 (TimelockController, 5 days); initial admin 0x29d6008b… no longer holds the role
- balance 0 at 26438999; no payable/withdraw path

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Register an op-ETH key that is an EOA or 7702-delegated account; protocol could upgrade via the timelock if needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
