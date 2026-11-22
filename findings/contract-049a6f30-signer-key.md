---
id: contract-049a6f30-signer-key
format: 2
title: Maker wallet trusts an ECDSA key that quantum attackers can recover
status: candidate
severity: MEDIUM
justification: The owner ECDSA key signs quotes and the code is fixed, so the maker must move funds to a new PQ-verified
  wallet.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  code: decompiled
  code_url: code/0xd2ad20750df5523588f0349342f21f460ea9a2f2e0aa4cc03239d90a204a77e9.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x595744b06ee5df7c88b65ef5894fae36f2fc4a59'
value:
  usd: 55874
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Withdraw all funds to a new wallet whose isValidSignature verifies a post-quantum signer, and move Permit2
  approvals there.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  has: 60015afa
  says: the runtime code calls the ecrecover precompile
  for:
  - evidence-1
  - evidence-3
  - justification
  - what
- id: sel-sig
  selector: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  fn: isValidSignature(bytes32,bytes)
  says: the ERC-1271 isValidSignature selector is in the code
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-owner
  selector: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  fn: owner()
  says: the owner() getter selector is in the code
  for:
  - justification
  - what
- id: sel-withdraw
  selector: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  fn: withdrawTokens(address[])
  says: the withdrawTokens selector is in the code
  for:
  - action
  - evidence-2
  - what
- id: sel-setowner
  selector: '0x049a6f30a91cdad18473739a69f957175acb83d3'
  fn: setOwner(address,address)
  says: the setOwner selector is in the code
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
  who: review (Review16)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This wallet holds a market maker's inventory and answers isValidSignature by checking an ECDSA signature against its stored owner key. A quantum attacker who recovers that key can sign Permit2 transfers out of the wallet or call withdrawTokens as the owner.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x049a6f30a91cdad18473739a69f957175acb83d3#code) is in the code, and the code calls the ecrecover precompile.
- [withdrawTokens](https://etherscan.io/address/0x049a6f30a91cdad18473739a69f957175acb83d3#code) is in the code and lets the owner key move the wallet's tokens.
- [setOwner](https://etherscan.io/address/0x049a6f30a91cdad18473739a69f957175acb83d3#code) replaces the owner address, which is again checked against an ecrecover result.

## Reviewer notes

### Mechanism

Unverified bytecode, no proxy. isValidSignature(bytes32,bytes) (0x1626ba7e) runs an ECDSA tryRecover via the ecrecover precompile (STATICCALL to 0x01 at offset 3646) and returns the magic value when the recovered address equals owner(). Permit2 permitWitnessTransferFrom calls this during 0x Settler / Relay RFQ fills, so the owner's signatures and public key appear in calldata. withdrawTokens(address[]) and withdrawETH() pay msg.sender when it is the owner or manager. setOwner(address,address) only installs another address compared against ecrecover, so rotation keeps ECDSA; the fix is a new wallet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No DELEGATECALL or proxy upgrade path.
- Ruled out: No forwarding of ERC-1271 to a contract owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
