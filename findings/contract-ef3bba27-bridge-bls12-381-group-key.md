---
id: contract-ef3bba27-bridge-bls12-381-group-key
format: 2
title: Early Gonka WGNK bridge trusts a BLS group key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: One BLS12-381 group key authorises releases; no upgrade path, so only Gonka consensus can replace
  it.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xef3bba27779c4b08b3b3534407113747d6601180'
  project: gonka
  code: decompiled
  code_url: code/0x4dec0b4edc0766b1eb7c8b6c1f3da9394516c303ba97fb2cd5d9c9c4c82bc40d.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xce8cad52e9787b13ba41c92ad7e8dcc5921866b4'
value:
  usd: 3
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Retire this deployment and move any remaining bridged funds to a bridge that verifies post-quantum signatures.
evidence_level: bytecode
checks:
- id: sel-withdraw
  selector: '0xef3bba27779c4b08b3b3534407113747d6601180'
  fn: withdraw((uint64,bytes32,address,address,uint256,bytes))
  says: withdraw selector is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-mint
  selector: '0xef3bba27779c4b08b3b3534407113747d6601180'
  fn: mintWithSignature((uint64,bytes32,address,uint256,bytes))
  says: mintWithSignature selector is in the code
  for:
  - evidence-2
  - justification
  - what
- id: sel-submit
  selector: '0xef3bba27779c4b08b3b3534407113747d6601180'
  fn: submitGroupKey(uint64,bytes,bytes)
  says: submitGroupKey selector is in the code
  for:
  - evidence-3
  - justification
  - what
- id: sel-epochkeys
  selector: '0xef3bba27779c4b08b3b3534407113747d6601180'
  fn: epochGroupKeys(uint64)
  says: epochGroupKeys(uint64) getter is in the code
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

This earlier Gonka bridge deployment is also a WGNK token, and it releases tokens and mints WGNK on commands signed by an epoch group key. A quantum attacker who recovers a registered epoch key can withdraw what it holds, mint WGNK and install their own next key.

## Evidence

- [withdraw](https://etherscan.io/address/0xef3bba27779c4b08b3b3534407113747d6601180#code) is in the code and releases bridged tokens on a signed command.
- [mintWithSignature](https://etherscan.io/address/0xef3bba27779c4b08b3b3534407113747d6601180#code) is in the code and mints WGNK on a signed command.
- [submitGroupKey](https://etherscan.io/address/0xef3bba27779c4b08b3b3534407113747d6601180#code) stores the next epoch's group key from a signed submission.

## Reviewer notes

### Mechanism

Bytecode-only older build of Gonka's BridgeContract. Selectors withdraw, mintWithSignature, submitGroupKey, setGroupKey and epochGroupKeys(uint64) are present. Decompiled code shows the same GONKA_CHAIN_ID, the 30-day TIMEOUT_DURATION, and checkAndHandleTimeout/resetToNormalOperation state logic. Kev's finding reports the bytecode calls EIP-2537 precompiles 0x0f (pairing) and 0x10 (map to G1) and contains the BLS12-381 modulus. withdraw and mintWithSignature verify one BLS signature against epochGroupKeys[epochId], which is stored on-chain. Recovering the secret lets an attacker forge withdrawals and mints and chain new keys through submitGroupKey. The owner is an EOA and can set keys only in admin control.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy: the contract is not upgradeable.
- Ruled out: No calls in the study's 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
