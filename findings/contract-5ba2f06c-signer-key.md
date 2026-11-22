---
id: contract-5ba2f06c-signer-key
format: 2
title: RFQ maker trusts one ECDSA quote signer a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A forged quote signer drains the maker vault's approvals; only the maker can fix it with a new contract.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  code: decompiled
  code_url: code/0x28f24a9bf29739f9b9823facb36921bd366e060bf76fdc8aa28867fd993316b0.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xc493f943a1fd910d01dcabea86e61415ce43e787'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Revoke the vault's approvals to this contract and deploy an RFQ contract that verifies quotes with a post-quantum
  signature.
evidence_level: bytecode
checks:
- id: sel-setsigners
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: setSigners(address[])
  says: Owner can set the quote signer list.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-signers
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: signers(uint256)
  says: Contract exposes its signer list.
  for:
  - evidence-2
  - what
- id: sel-usedquote
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: usedQuote(bytes32)
  says: Contract records used quotes.
  for:
  - evidence-2
  - what
- id: sel-eip712
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: eip712Domain()
  says: Contract uses an EIP-712 signing domain.
  for:
  - evidence-1
- id: sel-ecdsa-err
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: ECDSAInvalidSignature()
  says: Code contains OpenZeppelin ECDSA signature checks.
  for:
  - evidence-1
  - justification
  - what
- id: sel-counterparty
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: counterparty(address)
  says: Contract keeps a caller allowlist.
  for:
  - evidence-3
  - what
- id: sel-setcounterparty
  selector: '0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae'
  fn: setCounterparty(address,bool)
  says: Owner edits the caller allowlist.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract settles a market maker's RFQ quotes, accepting a quote when its ECDSA signer is in the owner-set signer list. A quantum attacker who recovers the signer key, acting through an allowlisted caller, can sign quotes that move the maker vault's approved tokens to themselves.

## Evidence

- [Code](https://etherscan.io/address/0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae#code) includes OpenZeppelin's ECDSA invalid-signature error and an EIP-712 domain getter.
- [Code](https://etherscan.io/address/0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae#code) keeps an owner-set signer list (setSigners, signers) and a used-quote record.
- [Code](https://etherscan.io/address/0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae#code) restricts fills to callers the owner allowlists with setCounterparty.

## Reviewer notes

### Mechanism

Unverified bytecode. The selector scan finds setSigners(address[]), signers(uint256), usedQuote(bytes32), eip712Domain(), setCounterparty(address,bool) and counterparty(address). It also finds OpenZeppelin's ECDSAInvalidSignature error. In the decompiled fill function (0xb5b50906), there is a reentrancy guard, then a check that counterparty[msg.sender] is set, then a price check against setDiff. Kev infers the following from this: the function recovers the EIP-712 quote signer with ECDSA.recover, requires that signer to be in signers (one signer, 0xfc79…), marks the quote used, and moves tokens with transferFrom. The taker's tokens go to vault 0x9ba0cf15 and the vault's tokens go to the taker. The vault approves this contract for unlimited USDC, USDT, WETH and POL. setSigners can rotate the signer only to another ECDSA key, and the owner is an ECDSA EOA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No ERC-1271 selector, so no contract-signer path.
- Ruled out: Not upgradeable; signer rotation stays ECDSA.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
