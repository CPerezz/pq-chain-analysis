---
id: contract-ab388373-bridge-bls12-381-group-key
format: 2
title: Earlier Gonka WGNK bridge trusts a BLS group key a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: One BLS12-381 group key authorizes releases; only Gonka consensus can replace it with a post-quantum
  bridge.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xab3883735707d751291833ebfa7932c4f60a5821'
  project: gonka
  code: decompiled
  code_url: code/0x70930f7854171099a3ee5dd315957356c7b897bb6546d4ce9e6fa32cb5f71d0a.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x5e462df25607418dfdf2f2b54ff3b34f1410fc25'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a bridge with a post-quantum signature check and stop honouring this contract.
evidence_level: bytecode
checks:
- id: sel-withdraw
  selector: '0xab3883735707d751291833ebfa7932c4f60a5821'
  fn: withdraw((uint64,bytes32,address,address,uint256,bytes))
  says: The withdraw entry point is present.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-mint
  selector: '0xab3883735707d751291833ebfa7932c4f60a5821'
  fn: mintWithSignature((uint64,bytes32,address,uint256,bytes))
  says: The signature-gated WGNK mint is present.
  for:
  - evidence-2
  - justification
  - what
- id: sel-submit
  selector: '0xab3883735707d751291833ebfa7932c4f60a5821'
  fn: submitGroupKey(uint64,bytes,bytes)
  says: Group-key rotation by signature is present.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: sel-groupkeys
  selector: '0xab3883735707d751291833ebfa7932c4f60a5821'
  fn: epochGroupKeys(uint64)
  says: Per-epoch group keys are stored on-chain.
  for:
  - what
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

This earlier Gonka bridge deployment is also a WGNK token and releases tokens or mints WGNK against a BLS12-381 signature from an epoch group key. A quantum attacker who recovers a registered group key can sign withdrawals, mints and new epoch keys.

## Evidence

- [withdraw](https://etherscan.io/address/0xab3883735707d751291833ebfa7932c4f60a5821#code) is in the code and releases tokens on a group-key signature.
- [mintWithSignature](https://etherscan.io/address/0xab3883735707d751291833ebfa7932c4f60a5821#code) is in the code and mints WGNK on a group-key signature.
- [submitGroupKey](https://etherscan.io/address/0xab3883735707d751291833ebfa7932c4f60a5821#code) is in the code and installs the next epoch key when it is signed by the current key.

## Reviewer notes

### Mechanism

The contract is unverified bytecode, an older build of Gonka's BridgeContract. Its selectors include withdraw, mintWithSignature, submitGroupKey, setGroupKey, epochGroupKeys, checkAndHandleTimeout and resetToNormalOperation. The decompiled code shows GONKA_CHAIN_ID, TIMEOUT_DURATION 2592000 and epoch group keys stored per uint64 epoch. In kev's finding, withdraw and mintWithSignature verify a BLS12-381 signature over the command with the precompiles 0x10 (map to G1) and 0x0f (pairing) against epochGroupKeys[epochId]. submitGroupKey chains the next epoch's key to the current one, so a single recovered key gives persistent control. The owner (an EOA) can set keys only in ADMIN_CONTROL, which is entered after a 30-day timeout. The owner cannot change the signature scheme.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade path to swap the verification.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
