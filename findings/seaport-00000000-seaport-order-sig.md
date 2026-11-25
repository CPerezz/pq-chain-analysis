---
id: seaport-00000000-seaport-order-sig
format: 2
title: OpenSea Seaport 1.5 accepts ECDSA orders a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Immutable with no owner; users must revoke approvals or move, and OpenSea can only close its conduit
  channel.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00000000000000adc04c56bf30ac9d3c0aaf14dc'
  name: Seaport
  project: opensea
  code: verified
  code_url: https://etherscan.io/address/0x00000000000000adc04c56bf30ac9d3c0aaf14dc#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 1000
  basis: held
activity:
  txs_90d: 141
impact: funds-loss
action: Deploy a Seaport that checks account code first, then close the Seaport 1.5 channel on the OpenSea conduit.
evidence_level: source
checks:
- id: code
  code: '0x00000000000000adc04c56bf30ac9d3c0aaf14dc'
  is: contract
  bytes: 24367
  says: The address holds contract code.
  for:
  - what
- id: sel-fulfill
  selector: '0x00000000000000adc04c56bf30ac9d3c0aaf14dc'
  fn: fulfillBasicOrder((address,uint256,uint256,address,address,address,uint256,uint256,uint8,uint256,uint256,bytes32,uint256,bytes32,bytes32,uint256,(uint256,address)[],bytes))
  says: The contract exposes fulfillBasicOrder, which fills signed orders.
  for:
  - evidence-1
  - justification
  - what
- id: upd-channel
  source: '0x00000000000000adc04c56bf30ac9d3c0aaf14dc'
  file: src/interfaces/ConduitControllerInterface.sol
  has: function updateChannel(
  line: 150
  says: A conduit owner can open or close a channel such as Seaport.
  for:
  - action
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; on-chain reads of the OpenSea conduit)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family judged from bytecode and names, a real transaction replayed four ways; not reviewed
    by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-2
reviews: []
related: []
---

## What happens

Seaport 1.5 fills signed orders that transfer the offerer's approved NFTs and tokens. It trusts an ECDSA signature recovering to the offerer before the account's code, so a quantum attacker with an old key sells approved assets after a post-quantum move.

## Evidence

- [fulfillBasicOrder](https://etherscan.io/address/0x00000000000000adc04c56bf30ac9d3c0aaf14dc#code) fills a signed order and moves the offerer's items to the fulfiller.
- The conduit controller's [updateChannel](https://etherscan.io/address/0x00000000000000adc04c56bf30ac9d3c0aaf14dc#code) lets a conduit owner open or close a channel such as Seaport.

## Reviewer notes

### Mechanism

Verifiers._verifySignature derives the EIP-712 order digest and calls SignatureVerification._assertValidSignature for orders that were not pre-validated. It is reached from _validateBasicOrder, _validateOrder and _validate. For 64- or 65-byte signatures, _assertValidSignature calls the ecrecover precompile and sets success := and(eq(signer, recoveredSigner), gt(signer, 0)). Only if that fails does it call isValidSignature (ERC-1271) on the offerer. An account that migrated to post-quantum code at the same address is therefore still accepted by a forged ECDSA signature. The fulfiller then receives the offer items, pulled directly through approvals given to Seaport or through a conduit with an open Seaport 1.5 channel. ConduitController.updateChannel (owner: ConduitCaptain, held by the OpenSea Safe) can close that channel. The contract itself has no owner and cannot be changed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or admin: the contract cannot be upgraded.
- Ruled out: Unmigrated EOAs gain no new exposure; their old key already controls their assets.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
