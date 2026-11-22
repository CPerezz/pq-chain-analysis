---
id: contract-2da512ea-signer-key
format: 2
title: Market-maker Safe's signature handler accepts quantum-forgeable ECDSA keys
status: candidate
severity: MEDIUM
justification: An ECDSA signer key approves Safe orders; the Safe owners must deploy a post-quantum handler, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2da512ea8cff88c046d1b402251ff37398752458'
  code: decompiled
  code_url: code/0xec5b97cf6af5d05d9ea0f9a5778479c94685b4e015e091420e2300d22c1e7efb.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 43476
impact: funds-loss
action: Deploy a post-quantum ERC-1271 handler and point the maker Safe at it with setFallbackHandler.
evidence_level: bytecode
checks:
- id: sel-isvalid
  selector: '0x2da512ea8cff88c046d1b402251ff37398752458'
  fn: isValidSignature(bytes32,bytes)
  says: The contract implements the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-signers
  selector: '0x2da512ea8cff88c046d1b402251ff37398752458'
  fn: authorizedSigners(address)
  says: The contract keeps a mapping of authorised signer addresses.
  for:
  - evidence-2
  - justification
  - what
- id: sel-setsigner
  selector: '0x2da512ea8cff88c046d1b402251ff37398752458'
  fn: setSigner(address,bool)
  says: The contract lets its owner add or remove signer addresses.
  for:
  - evidence-3
- id: sel-owner
  selector: '0x2da512ea8cff88c046d1b402251ff37398752458'
  fn: OWNER()
  says: The contract exposes a fixed owner address.
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This contract answers ERC-1271 isValidSignature checks for a market maker's Safe. It approves a hash signed by an ECDSA key listed in authorizedSigners. A quantum attacker who recovers that key can sign token transfers and orders that pull the Safe's approved tokens.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x2da512ea8cff88c046d1b402251ff37398752458#code) is exposed and approves hashes signed by an authorised key.
- [authorizedSigners](https://etherscan.io/address/0x2da512ea8cff88c046d1b402251ff37398752458#code) holds the set of accepted ECDSA signer addresses.
- [setSigner](https://etherscan.io/address/0x2da512ea8cff88c046d1b402251ff37398752458#code) changes that set, so it can only swap one ECDSA key for another.

## Reviewer notes

### Mechanism

The maker Safe (1.4.1) stores this contract as its fallback handler. As a result, isValidSignature(bytes32,bytes) calls to the Safe are forwarded here. The decompiled selector 0x1626ba7e handler runs ecrecover over the hash and the (r,s,v) bytes. If the recovered address is true in the authorizedSigners mapping (slot 0), it returns the magic value 0x1626ba7e. Kev's traces show three consumers that pull tokens from the Safe after this check passes: 1inch v6 fillContractOrder, CoW settlement and Permit2 permitTransferFrom. setSigner, gated to the OWNER Safe, only toggles ECDSA addresses. The contract has no post-quantum path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy: no EIP-1967 slot.
- Ruled out: Rotating setSigner keys does not remove the exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
