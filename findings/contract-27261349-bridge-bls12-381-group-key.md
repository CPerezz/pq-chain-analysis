---
id: contract-27261349-bridge-bls12-381-group-key
format: 2
title: Earlier Gonka WGNK bridge trusts a BLS group key a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: One BLS12-381 group key authorises withdrawals and mints; only a new post-quantum bridge from Gonka
  consensus fixes it.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x27261349a8a623b9c798f2ff9388eba22e5b0525'
  project: gonka
  code: decompiled
  code_url: code/0x82a16eab7daa79fcc8840ffbe81110ffaa77dece990b807e896418a0c64b07b5.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xce8cad52e9787b13ba41c92ad7e8dcc5921866b4'
value:
  usd: 3
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Retire this bridge and move any remaining tokens to a bridge that verifies post-quantum signatures from
  Gonka consensus.
evidence_level: bytecode
checks:
- id: sel-withdraw
  selector: '0x27261349a8a623b9c798f2ff9388eba22e5b0525'
  fn: withdraw((uint64,bytes32,address,address,uint256,bytes))
  says: withdraw selector is in the bytecode
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-mint
  selector: '0x27261349a8a623b9c798f2ff9388eba22e5b0525'
  fn: mintWithSignature((uint64,bytes32,address,uint256,bytes))
  says: mintWithSignature selector is in the bytecode
  for:
  - evidence-2
  - justification
  - what
- id: sel-submit
  selector: '0x27261349a8a623b9c798f2ff9388eba22e5b0525'
  fn: submitGroupKey(uint64,bytes,bytes)
  says: submitGroupKey selector is in the bytecode
  for:
  - action
  - evidence-3
  - justification
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

This earlier Gonka bridge and WGNK token releases locked tokens and mints WGNK on a BLS12-381 signature from an epoch group key. A quantum attacker who recovers that group key could sign withdrawals, mint unbacked WGNK and install their own next-epoch key.

## Evidence

- [withdraw](https://etherscan.io/address/0x27261349a8a623b9c798f2ff9388eba22e5b0525#code) is a function in the bytecode and releases tokens on a group-key signature.
- [mintWithSignature](https://etherscan.io/address/0x27261349a8a623b9c798f2ff9388eba22e5b0525#code) is a function in the bytecode and mints WGNK on a group-key signature.
- [submitGroupKey](https://etherscan.io/address/0x27261349a8a623b9c798f2ff9388eba22e5b0525#code) is a function in the bytecode and stores the next epoch key when signed by the current one.

## Reviewer notes

### Mechanism

Bytecode-only earlier build of Gonka's BridgeContract (same GONKA_CHAIN_ID constant in the decompiled code). withdraw(...) and mintWithSignature(...) look up epochGroupKeys[epochId] and verify a BLS12-381 signature with the EIP-2537 precompiles (pairing check 0x0f, map-to-G1 0x10, per kev's bytecode read), then transfer tokens or mint WGNK. submitGroupKey lets anyone store epoch n+1's key when signed by epoch n's key, so a forged key chains forward. setGroupKey/resetToNormalOperation by the owner (an EOA, also ECDSA) apply only in ADMIN_CONTROL after checkAndHandleTimeout's 30-day timeout. No upgrade path; the contract holds only a few dollars and has no transactions in the study window, and its WGNK has a single holder.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade function; the owner cannot change the signature scheme.
- Ruled out: Exposure here is small: a few dollars held and no WGNK market.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
