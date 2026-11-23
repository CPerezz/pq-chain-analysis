---
id: seaport-000000000000-seaport-order-sig
format: 2
title: OpenSea Seaport 1.6 lets a quantum attacker forge orders selling users' NFTs
status: confirmed
severity: HIGH
justification: 'Immutable and ownerless: users must revoke or move, and OpenSea can only close this channel on its
  conduit.'
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0000000000000068f116a894984e2db1123eb395'
  name: Seaport
  project: opensea
  code: verified
  code_url: https://etherscan.io/address/0x0000000000000068f116a894984e2db1123eb395#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 682973
impact: funds-loss
action: Deploy a Seaport that checks account code before ecrecover, then close this version's channel on the OpenSea
  conduit.
evidence_level: source
checks:
- id: code
  code: '0x0000000000000068f116a894984e2db1123eb395'
  is: contract
  bytes: 23981
  says: the Seaport address holds contract code
  for:
  - justification
- id: sel-basic
  selector: '0x0000000000000068f116a894984e2db1123eb395'
  fn: fulfillBasicOrder((address,uint256,uint256,address,address,address,uint256,uint256,uint8,uint256,uint256,bytes32,uint256,bytes32,bytes32,uint256,(uint256,address)[],bytes))
  says: Seaport exposes fulfillBasicOrder, which takes a signed order
  for:
  - evidence-1
  - what
- id: c4
  source: '0x0000000000000068f116a894984e2db1123eb395'
  file: lib/seaport-types/src/interfaces/ConduitControllerInterface.sol
  has: function updateChannel(
  line: 150
  says: the conduit controller can open or close a channel
  for:
  - action
  - evidence-3
  - justification
- id: c5
  source: '0x0000000000000068f116a894984e2db1123eb395'
  file: lib/seaport-types/src/interfaces/ConduitControllerInterface.sol
  has: tokens where the token holder has granted the conduit approval.
  line: 143
  says: channels move tokens that holders approved to the conduit
  for:
  - evidence-2
  - what
- id: c6
  source: '0x0000000000000068f116a894984e2db1123eb395'
  file: lib/seaport-types/src/interfaces/ConduitControllerInterface.sol
  has: or vulnerable channels can transfer any ERC20, ERC721 and ERC1155
  line: 142
  says: a channel can transfer users' ERC20/721/1155 tokens
  for:
  - evidence-2
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
reviews: []
related: []
---

## What happens

Seaport fills signed orders, moving offered NFTs and tokens through the user's approvals to Seaport or a conduit. A quantum attacker who recovers a user's old ECDSA key signs orders selling their approved assets, even after a post-quantum account move.

## Evidence

- [fulfillBasicOrder](https://etherscan.io/address/0x0000000000000068f116a894984e2db1123eb395#code) takes an offerer's order together with its signature bytes.
- [Conduit channels](https://etherscan.io/address/0x0000000000000068f116a894984e2db1123eb395#code) can transfer any ERC20, ERC721 and ERC1155 token whose holder approved the conduit.
- [updateChannel](https://etherscan.io/address/0x0000000000000068f116a894984e2db1123eb395#code) lets the conduit owner open or close the Seaport channel.

## Reviewer notes

### Mechanism

Verifiers._verifySignature (Verifiers.sol 90-137) is reached from OrderValidator._validateBasicOrder (117), _validateOrder (271) and _validate (857) for orders not pre-validated. It calls SignatureVerification._assertValidSignature, which runs ecrecover for 64/65-byte signatures (146-155) and sets success = signer == recovered && signer != 0 (177). It calls ERC-1271 isValidSignature only when that fails (181-233). The account's code is not consulted first, so a recovered old key still authorises orders for a migrated account. Offer items are pulled from the offerer directly or via the conduit named by conduitKey. The OpenSea conduit owner (ConduitCaptain, 5-of-7 Safe) can close the channel via updateChannel.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Seaport holds no meaningful funds of its own
- Ruled out: No proxy, admin or owner; code cannot be changed

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.

