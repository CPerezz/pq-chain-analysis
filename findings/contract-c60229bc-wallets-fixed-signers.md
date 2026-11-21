---
id: contract-c60229bc-wallets-fixed-signers
format: 2
title: 'Two-of-three wallet: listed owners lose quorum if two move to real code'
status: candidate
severity: INFORMATIONAL
justification: Breaks only if listed owners move to real code; no function replaces an owner, so funds must leave
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  code: bytecode
  code_url: https://etherscan.io/address/0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Move everything out of this wallet before a second listed owner moves its account to real code; its owners
  cannot be replaced.
evidence_level: bytecode
checks:
- id: dispatcher
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 8063a0e67e2b1161004e578063a0e67e2b14610174578063b7d5e5641461019f578063c6a2a9f1146101c8578063d74f8edd146101f3576100c9565b806301173672146100ce5780631398a5f6146100f7578063159648621461012257806385b2566a1461014b576100c956
  says: the dispatcher lists exactly eight selectors and sends anything else to a revert
  for:
  - action
  - evidence-1
  - justification
  - what
- id: fn-spend
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: spend(address,uint256,uint8[],bytes32[],bytes32[])
  says: spend (ETH) is in the code
  for:
  - what
- id: fn-erc20
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: spendERC20(address,address,uint256,uint8[],bytes32[],bytes32[])
  says: spendERC20 (tokens) is in the code
  for:
  - what
- id: fn-any
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: spendAny(address,uint256,uint8[],bytes32[],bytes32[],bytes)
  says: spendAny (any call) is in the code
  for:
  - what
- id: recover
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 600183601b8c8c85
  says: the recovery targets precompile 0x01 with v + 27 (two sites)
  for:
  - evidence-1
  - justification
  - what
- id: staticcall
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 855afa15
  says: the recovery STATICCALL forwards all remaining gas
  for:
  - what
- id: threshold
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: '600254878790501015'
  says: the number of signatures must be at least required (slot 2)
  for:
  - evidence-1
  - justification
  - what
- id: is-owner
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 60200190815260200160002060009054906101000a900460ff16
  says: each recovered address is looked up in the isOwner mapping at slot 0
  for:
  - evidence-1
  - what
- id: zero-not-owner
  storage: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  slot: '0xad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5'
  is: 0
  says: isOwner[address(0)] is false, so a recovery that returns nothing does not count
  for:
  - what
- id: owners
  call: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: getOwners()(address[])
  is:
  - '0xDB69295463CBd76Ba6cDf98bC61d2BE0EAB5c8CF'
  - '0xedec8f84185C4652081D7E00dADae118D0D89793'
  - '0x365B9a2c0a9A9Bf86CAA08514E6EFCe2c2A991e6'
  says: the wallet has three owners
  for:
  - action
  - evidence-2
  - what
- id: required
  call: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: getRequired()(uint256)
  is: 2
  says: two owner signatures are required
  for:
  - action
  - evidence-1
  - what
- id: nonce
  call: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: getSpendNonce()(uint256)
  is: 0
  says: the wallet has never spent
  for:
  - evidence-2
  - what
- id: no-add
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: addOwner(address)
  absent: true
  says: no addOwner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-remove
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: removeOwner(address)
  absent: true
  says: no removeOwner
  for:
  - action
  - justification
  - what
- id: no-replace
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: replaceOwner(address,address)
  absent: true
  says: no replaceOwner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-change
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: changeRequirement(uint256)
  absent: true
  says: no changeRequirement
  for:
  - action
  - justification
  - what
- id: no-1271
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: no ERC-1271 call to a signer with code
  for:
  - what
- id: no-1271-old
  selector: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: no legacy ERC-1271 call either
  for:
  - what
- id: code-1
  code: '0xdb69295463cbd76ba6cdf98bc61d2be0eab5c8cf'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
- id: code-2
  code: '0xedec8f84185c4652081d7e00dadae118d0d89793'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
- id: code-3
  code: '0x365b9a2c0a9a9bf86caa08514e6efce2c2a991e6'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
- id: nonce-1
  nonce: '0xdb69295463cbd76ba6cdf98bc61d2be0eab5c8cf'
  is: 0
  says: owner 1 never sent a transaction
  for:
  - evidence-2
- id: nonce-2
  nonce: '0xedec8f84185c4652081d7e00dadae118d0d89793'
  is: 0
  says: owner 2 never sent a transaction
  for:
  - evidence-2
- id: nonce-3
  nonce: '0x365b9a2c0a9a9bf86caa08514e6efce2c2a991e6'
  is: 0
  says: owner 3 never sent a transaction
  for:
  - evidence-2
- id: distinct
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 1603610fb657600092505050610fe3
  says: two equal recovered addresses make the owner check return false, so duplicates do not count
  for:
  - evidence-1
  - what
- id: zero-buf
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 60405160008152602001604052604051610b7a
  says: the recovery output word is zeroed before the STATICCALL, so an empty return reads as address(0)
  for:
  - what
- id: nonce-sstore
  bytecode: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  has: 600160035461049391906119b2565b6003819055
  says: a runtime SSTORE writes spendNonce+1 to slot 3; disassembly shows all four SSTOREs are of this form
  for:
  - what
- id: isowner-1
  storage: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  slot: '0xe215beb9c885e0fd36949958cff686069c750d815c85e30a88fa967eaad2b129'
  is: 1
  says: isOwner[0xdb69…c8cf] is true
  for:
  - evidence-2
- id: isowner-2
  storage: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  slot: '0x58e51a0cefd4cc3cdd384ff092bc6741411135133b150e284bc9e2e76bcc2c5b'
  is: 1
  says: isOwner[0xedec…9793] is true
  for:
  - evidence-2
- id: isowner-3
  storage: '0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732'
  slot: '0x7f831772b0f5c9913c536a56ab5df47b1fa4a5a3aa7402d604cb31b394454b1c'
  is: 1
  says: isOwner[0x365b…91e6] is true
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This wallet moves ETH or tokens, or makes a call, only when two distinct owners sign with ECDSA; it lists three owners. No function changes the owners or the threshold. If two listed owners move their accounts to real code, the listed owners cannot reach two signatures. It has never spent.

## Evidence

- The [wallet's code](https://etherscan.io/address/0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732#code) recovers each signature with ECDSA, counts distinct stored owners, needs two and has no owner setter.
- Its three listed [owners](https://etherscan.io/address/0xc60229bcf43d5ec5e6abf31a7d202f9ea355b732#readContract) are set as owners, hold no code, never sent a transaction; the spend nonce is 0.

## Reviewer notes

### Mechanism

Ownbit-style multisig, unverified; read from runtime bytecode. The dispatcher has eight selectors: getOwners, getRequired, getSpendNonce, MAX_OWNER_COUNT, spend, spendERC20, spendAny and 0x15964862 (unnamed; its body holds transferFrom and redemption(address,uint256) = 0x616bcd21 calls). Each of the four value-moving bodies (0x021e, 0x03f1, 0x05be, 0x085f) calls a signature check (0x0a38 or 0x0c2c) before any CALL. Each check requires equal v/r/s lengths, count <= owners.length (slot 1), count >= required (slot 2, = 2), recovers each signature with ecrecover (PUSH1 0x01, v + 27, all gas forwarded) into an array, and then 0x0ea0 requires isOwner[signer] (mapping at slot 0) for every signer and no duplicate. A recovery that returns nothing reads as address 0, and isOwner[0] is false, so the signature fails. The runtime has four SSTOREs, all to slot 3 (spend nonce + 1); owners, isOwner and required are written only by the constructor. spendAny refuses a call to the wallet itself. The check reads isOwner, not the owners array; isOwner of the three listed owners is true, but whether the constructor set other keys in it is not shown.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: neither 0x1626ba7e nor 0x20c13b0b is in the code; the only two STATICCALLs go to the precompile at 0x01.
- Ruled out: direct-path: CALLER appears only in the receive path's deposit event; no function checks msg.sender, so an owner cannot spend without signatures.
- Ruled out: setter: no addOwner, removeOwner, replaceOwner or changeRequirement selector; all four SSTOREs in the runtime write slot 3, the spend nonce.
- Ruled out: unused-implementation / wrong-code: not a proxy, no copies; this address's own bytecode was read, and its state is set.
- Ruled out: key-state: the three listed owners are EOAs at the block (no code, nonce 0), isOwner true for each. Unlisted isOwner keys could not be checked (see questions).
- Ruled out: breaks-by-itself / gas: recovery forwards all gas (GAS before STATICCALL); no replays for this family; nothing fails with nobody migrating.
- Ruled out: path-closed: no pause or kill switch; usable, never spent (nonce 0), holds no ETH or priced tokens.
- Ruled out: children: no CREATE or CREATE2 in the runtime (the EOFCREATE byte the disassembler shows sits in the metadata trailer).

### Questions

- Does isOwner hold keys beyond the three listed owners? The signature check reads the isOwner mapping (written only by the constructor), not the owners list, and a mapping cannot be listed from reads at the block; the creation transaction's input would settle it. An unlisted owner key without real code would keep the wallet spendable after two listed owners migrate.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
