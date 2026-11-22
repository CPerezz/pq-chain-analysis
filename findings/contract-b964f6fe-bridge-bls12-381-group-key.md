---
id: contract-b964f6fe-bridge-bls12-381-group-key
format: 2
title: Earlier Gonka bridge lets a quantum attacker forge mints and withdrawals
status: candidate
severity: MEDIUM
justification: One BLS12-381 group key authorizes mints and withdrawals; only Gonka consensus can replace it with
  a new deployment.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  project: gonka
  code: decompiled
  code_url: code/0x70930f7854171099a3ee5dd315957356c7b897bb6546d4ce9e6fa32cb5f71d0a.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
value:
  usd: 3
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a bridge with a post-quantum signature check, migrate holdings to it and stop honouring this contract.
evidence_level: bytecode
checks:
- id: sel-mint
  selector: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  fn: mintWithSignature((uint64,bytes32,address,uint256,bytes))
  says: mint-on-signature entry point is in the code
  for:
  - evidence-1
  - justification
  - what
- id: sel-withdraw
  selector: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  fn: withdraw((uint64,bytes32,address,address,uint256,bytes))
  says: withdraw-on-signature entry point is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-groupkeys
  selector: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  fn: epochGroupKeys(uint64)
  says: per-epoch group keys are stored and readable
  for:
  - evidence-2
  - what
- id: sel-submitkey
  selector: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  fn: submitGroupKey(uint64,bytes,bytes)
  says: new epoch keys are accepted on a signature
  for:
  - evidence-3
  - justification
  - what
- id: sel-setkey
  selector: '0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b'
  fn: setGroupKey(uint64,bytes)
  says: owner key-setting function is in the code
  for:
  - action
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This earlier Gonka bridge deployment is also a WGNK token. It mints WGNK and releases held tokens on a signature from a stored epoch group key. A quantum attacker who recovers that key can withdraw the bridge's balance, mint unbacked WGNK and install their own next-epoch key.

## Evidence

- [Bytecode](https://etherscan.io/address/0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b#code) exposes mintWithSignature and withdraw entry points.
- [Bytecode](https://etherscan.io/address/0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b#code) stores per-epoch group keys read through epochGroupKeys(uint64).
- [Bytecode](https://etherscan.io/address/0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b#code) accepts new epoch keys via submitGroupKey and owner setGroupKey.

## Reviewer notes

### Mechanism

Unverified bytecode of an older build of Gonka's BridgeContract. Entry points mintWithSignature and withdraw look up epochGroupKeys[epochId] (selector 0xdce67dfb, stored as a G2 key) and, per kev's bytecode read, verify a BLS12-381 signature over the command using the EIP-2537 precompiles 0x10 (map to G1) and 0x0f (pairing check). submitGroupKey stores the next epoch's key when signed by the current one, so a recovered key lets an attacker chain their own keys. setGroupKey and resetToNormalOperation are owner-only (EOA 0xeec5ca42...) and work only in admin-control state, entered after a 30-day timeout via checkAndHandleTimeout. The contract has no upgrade path, and the owner cannot change the signature scheme.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy; the verification cannot be upgraded in place.
- Ruled out: Owner can only set BLS keys, not change the scheme.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
