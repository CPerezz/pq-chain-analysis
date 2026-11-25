---
id: contract-ba418fa6-signer-key
format: 2
title: Smart-account module lets a quantum attacker take over user accounts
status: candidate
severity: MEDIUM
justification: Account owners hold funds and the module is not upgradeable; they must switch modules, so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xba418fa699622de824b258c61eb150ed7a13967b'
  code: decompiled
  code_url: code/0xade4e6901daea70b5100613e06087588be935157dc5c208ad653d15c61e60790.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 82
impact: funds-loss
action: Deploy a post-quantum ownership module and co-signer, and have each account enable it and disable this one.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xba418fa699622de824b258c61eb150ed7a13967b'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0xba418fa699622de824b258c61eb150ed7a13967b'
  is: contract
  bytes: 4128
  says: The address holds contract code.
  for:
  - justification
- id: sel-getowner
  selector: '0xba418fa699622de824b258c61eb150ed7a13967b'
  fn: getOwner(address)
  says: getOwner selector present.
  for:
  - what
- id: sel-init
  selector: '0xba418fa699622de824b258c61eb150ed7a13967b'
  fn: initForSmartAccount(address)
  says: initForSmartAccount selector present.
  for:
  - action
  - what
- id: sel-validate
  selector: '0xba418fa699622de824b258c61eb150ed7a13967b'
  fn: validateUserOp((address,uint256,bytes,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes32)
  says: validateUserOp selector present.
  for:
  - evidence-2
  - what
- id: sel-transfer
  selector: '0xba418fa699622de824b258c61eb150ed7a13967b'
  fn: transferOwnership(address)
  says: transferOwnership selector present.
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (paymaster bytecode, EntryPoint deposit reads, deployer siblings)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review18 (LiquidityBank bytecode strings and selectors, proxy and paymaster reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review15 (co-signer bytecode, module immutable, traced user operation)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review22 (module bytecode, NAME/VERSION, trace, account enumeration and balances; moved from biconomy-ecdsa-validator)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This module records an EOA owner per smart account and validates user operations and signatures by recovering ECDSA signers. A quantum attacker who recovers an account owner's key and the fixed co-signer key can sign operations that take over that account.

## Evidence

- [The module's code](https://etherscan.io/address/0xba418fa699622de824b258c61eb150ed7a13967b#code) calls the ecrecover precompile to check signatures.
- [validateUserOp](https://etherscan.io/address/0xba418fa699622de824b258c61eb150ed7a13967b#code) is the EntryPoint v0.6 entry point that checks each user operation's signature.
- [transferOwnership](https://etherscan.io/address/0xba418fa699622de824b258c61eb150ed7a13967b#code) lets an account set a new owner address.

## Reviewer notes

### Mechanism

Bytecode only, no verified source. The module has a Biconomy Smart Account v2 module interface: initForSmartAccount stores an owner per msg.sender, getOwner reads it, and transferOwnership rejects contract addresses (NotEOA). validateUserOp (EntryPoint v0.6) and isValidSignature recover signers with ecrecover (precompile call at byte offset 4014). Per kev's traced call, validateUserOp first calls the immutable co-signer 0x82eace5d isValidSignature, which ecrecovers against its fixed verifying signer, then ecrecovers the account owner. Forging both secp256k1 signatures lets an attacker authorise arbitrary user operations for that account. The module has no proxy, and owners must be EOAs, so the only post-quantum fix is a different module.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy, so the module itself cannot be patched.
- Ruled out: The co-signer key alone is not enough; the owner's signature is also required.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
