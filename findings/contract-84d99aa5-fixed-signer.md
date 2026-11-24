---
id: contract-84d99aa5-fixed-signer
format: 2
title: Resolver stops accepting signatures from owners whose accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if an owner moves to real code; others still sign. Owners move tokens directly; its ETH
  is already stuck.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  label: '1inch: Labs Resolver'
  code: bytecode
  code_url: https://etherscan.io/address/0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1#code
  copies: 2
  family: deee56139ab65b5710a3cbf52581c72b
  upgradeable: 'no'
value:
  usd: 2
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Before moving an owner account to real code, sign with another owner, or deploy a new resolver that trusts
  a new key.
evidence_level: bytecode
checks:
- id: isvalid
  selector: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isValidSignature(bytes32,bytes)
  says: the code answers ERC-1271 signature checks
  for:
  - what
- id: flow
  bytecode: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  has: 5b60006102926101748585856110ca565b6102bc57
  says: isValidSignature recovers the signer, runs the owner test on it and returns the magic value only if it passes
  for:
  - evidence-1
  - what
- id: recover
  bytecode: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  has: 600080526020600060808360015afa
  says: the signer is recovered by a STATICCALL to precompile 0x01 with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: owner-test
  bytecode: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  has: 5b60007f00000000000000000000000055dcad916750c19c4ec69d65ff0317767b36ce9073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614806107ea57
  says: the owner test compares the address with 0x55dc... pushed as a constant in the code, then four more constants
  for:
  - action
  - evidence-1
  - justification
  - what
- id: owner-gate
  bytecode: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  has: 6108fb3361074356
  says: owner-only functions run the same owner test on msg.sender
  for:
  - evidence-2
- id: not-owner
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  is: false
  says: an address outside the five is not an owner
  for:
  - notes
- id: no-proxy
  storage: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - action
  - what
- id: no-upgrade
  selector: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - what
- id: rescue-owner
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  data: '0xe53b2017000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  from: '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  is: 0x
  says: rescueFunds(token) called directly by an owner succeeds, sending the token balance to the caller
  for:
  - evidence-2
  - justification
  - whose
- id: rescue-other
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  data: '0xe53b2017000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: '0x5fc483c5'
  says: rescueFunds reverts for anyone who is not an owner
  for:
  - evidence-2
  - whose
- id: owner-1
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  is: true
  says: 0x55dcad916750c19c4ec69d65ff0317767b36ce90 is one of the five owners
  for:
  - action
  - evidence-1
  - justification
  - what
- id: plain-1
  code: '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  is: empty
  says: owner 0x55dcad916750c19c4ec69d65ff0317767b36ce90 has no code
  for:
  - evidence-1
- id: used-1
  nonce: '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  min: 164113
  says: owner 0x55dcad916750c19c4ec69d65ff0317767b36ce90 has sent 164113 transactions
  for:
  - evidence-1
- id: owner-2
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0x315b47a8c3780434b153667588db4ca628526e20'
  is: true
  says: 0x315b47a8c3780434b153667588db4ca628526e20 is one of the five owners
  for:
  - action
  - evidence-1
  - justification
  - what
- id: plain-2
  code: '0x315b47a8c3780434b153667588db4ca628526e20'
  is: empty
  says: owner 0x315b47a8c3780434b153667588db4ca628526e20 has no code
  for:
  - evidence-1
- id: used-2
  nonce: '0x315b47a8c3780434b153667588db4ca628526e20'
  min: 21740
  says: owner 0x315b47a8c3780434b153667588db4ca628526e20 has sent 21740 transactions
  for:
  - evidence-1
- id: owner-3
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0x1739b308d2232f9987975298c4459b5e51fa272e'
  is: true
  says: 0x1739b308d2232f9987975298c4459b5e51fa272e is one of the five owners
  for:
  - action
  - evidence-1
  - justification
  - what
- id: plain-3
  code: '0x1739b308d2232f9987975298c4459b5e51fa272e'
  is: empty
  says: owner 0x1739b308d2232f9987975298c4459b5e51fa272e has no code
  for:
  - evidence-1
- id: used-3
  nonce: '0x1739b308d2232f9987975298c4459b5e51fa272e'
  min: 85290
  says: owner 0x1739b308d2232f9987975298c4459b5e51fa272e has sent 85290 transactions
  for:
  - evidence-1
- id: owner-4
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0x49bcbc58848ac642b48f3d824d8b728a1045d08b'
  is: true
  says: 0x49bcbc58848ac642b48f3d824d8b728a1045d08b is one of the five owners
  for:
  - action
  - evidence-1
  - justification
  - what
- id: plain-4
  code: '0x49bcbc58848ac642b48f3d824d8b728a1045d08b'
  is: empty
  says: owner 0x49bcbc58848ac642b48f3d824d8b728a1045d08b has no code
  for:
  - evidence-1
- id: used-4
  nonce: '0x49bcbc58848ac642b48f3d824d8b728a1045d08b'
  min: 41479
  says: owner 0x49bcbc58848ac642b48f3d824d8b728a1045d08b has sent 41479 transactions
  for:
  - evidence-1
- id: owner-5
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: isOwner(address)(bool)
  args:
  - '0xb398ffef80144095b8712c70a0c09886c8151feb'
  is: true
  says: 0xb398ffef80144095b8712c70a0c09886c8151feb is one of the five owners
  for:
  - action
  - evidence-1
  - justification
  - what
- id: plain-5
  code: '0xb398ffef80144095b8712c70a0c09886c8151feb'
  is: empty
  says: owner 0xb398ffef80144095b8712c70a0c09886c8151feb has no code
  for:
  - evidence-1
- id: used-5
  nonce: '0xb398ffef80144095b8712c70a0c09886c8151feb'
  min: 27
  says: owner 0xb398ffef80144095b8712c70a0c09886c8151feb has sent 27 transactions
  for:
  - evidence-1
- id: resolve
  selector: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  fn: resolveOrders(address,bytes,bytes)
  says: the code has the 1inch resolver entry point resolveOrders
  for:
  - what
- id: copy-owner-1
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  is: true
  says: 0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1 is one of the copy's five owners
  for:
  - notes
- id: copy-plain-1
  code: '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  is: empty
  says: copy owner 0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1 has no code
  for:
  - notes
- id: copy-used-1
  nonce: '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  min: 2782
  says: copy owner 0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1 has sent 2782 transactions
  for:
  - notes
- id: copy-owner-2
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d'
  is: true
  says: 0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d is one of the copy's five owners
  for:
  - notes
- id: copy-plain-2
  code: '0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d'
  is: empty
  says: copy owner 0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d has no code
  for:
  - notes
- id: copy-used-2
  nonce: '0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d'
  min: 116
  says: copy owner 0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d has sent 116 transactions
  for:
  - notes
- id: copy-owner-3
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x263f925011bfefbc638948ed15af1c131b26bd46'
  is: true
  says: 0x263f925011bfefbc638948ed15af1c131b26bd46 is one of the copy's five owners
  for:
  - notes
- id: copy-plain-3
  code: '0x263f925011bfefbc638948ed15af1c131b26bd46'
  is: empty
  says: copy owner 0x263f925011bfefbc638948ed15af1c131b26bd46 has no code
  for:
  - notes
- id: copy-used-3
  nonce: '0x263f925011bfefbc638948ed15af1c131b26bd46'
  min: 98
  says: copy owner 0x263f925011bfefbc638948ed15af1c131b26bd46 has sent 98 transactions
  for:
  - notes
- id: copy-owner-4
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x1c1a61b05e29953745c5973159ad13ad644e0a7e'
  is: true
  says: 0x1c1a61b05e29953745c5973159ad13ad644e0a7e is one of the copy's five owners
  for:
  - notes
- id: copy-plain-4
  code: '0x1c1a61b05e29953745c5973159ad13ad644e0a7e'
  is: empty
  says: copy owner 0x1c1a61b05e29953745c5973159ad13ad644e0a7e has no code
  for:
  - notes
- id: copy-used-4
  nonce: '0x1c1a61b05e29953745c5973159ad13ad644e0a7e'
  is: 0
  says: copy owner 0x1c1a61b05e29953745c5973159ad13ad644e0a7e has never sent a transaction
  for:
  - notes
- id: copy-owner-5
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a'
  is: true
  says: 0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a is one of the copy's five owners
  for:
  - notes
- id: copy-plain-5
  code: '0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a'
  is: empty
  says: copy owner 0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a has no code
  for:
  - notes
- id: copy-used-5
  nonce: '0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a'
  is: 0
  says: copy owner 0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a has never sent a transaction
  for:
  - notes
- id: r-rescue-owner
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  data: '0xe53b2017000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  from: '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  is: 0x
  says: an owner calling rescueFunds(WETH) directly succeeds
  for:
  - justification
- id: r-eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  is: 1294496422127671
  says: the address holds 0.001294 ETH natively (about $2.33 of the $2.42)
  for:
  - justification
- id: r-rescue-eth
  call: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  data: '0xe53b20170000000000000000000000000000000000000000000000000000000000000000'
  from: '0x55dcad916750c19c4ec69d65ff0317767b36ce90'
  reverts: true
  says: 'rescueFunds(address(0)) reverts: rescueFunds does not move ETH'
  for:
  - justification
- id: r-unwrap-send
  bytecode: '0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1'
  has: 61138890604051600060405180830381858888f1
  says: the only value-carrying CALL sends, with 5,000 gas, the amount just withdrawn from WETH
  for:
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-84d99aa5, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'moved: Moved to fixed-signer, INFORMATIONAL (PQ-17): the order resolver answers ERC-1271 only for five
    owners fixed in its code, with no setter or upgrade; an owner moving to real code stops counting (an EIP-7702
    delegation still works). Claude fixed the first refuter''s point (its 0.001294 ETH is already stuck: the only
    ETH-sending call pays what it unwraps from 3 wei of WETH). Fresh refuter agrees; Claude read the sheet. Copy
    0x4d8f74de… is its own row.'
related: []
---

## What happens

This order resolver answers signature checks for itself (ERC-1271) only when an ECDSA signature recovers to one of five owner addresses built into its code. An owner whose account takes real code stops counting; an EIP-7702 delegation still works. No function can change the owners.

## Evidence

- The [code](https://etherscan.io/address/0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1#code) compares the recovered signer with five fixed addresses; all five are plain accounts that sent transactions.
- Owner-only [functions](https://etherscan.io/address/0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1#code) such as rescueFunds check the caller directly, so owners still move funds without a signature.

## Reviewer notes

### Mechanism

Unverified code, read from the disassembly (the decompiler output wrongly showed a single key and was not used). isValidSignature (0x1626ba7e) jumps to 0x0282, which calls the recover routine at 0x10ca (65- or 64-byte signatures, low-s check, STATICCALL to 0x01 with GAS) and passes the result to the owner test at 0x0743. That test returns true if the address equals any of five immutables pushed as PUSH32 constants: 0x55dcad91..., 0x315b47a8..., 0x1739b308..., 0x49bcbc58..., 0xb398ffef.... On true it returns 0x1626ba7e, else 0xffffffff. isOwner(address) (0x2f54bf6e) exposes the same test. Six call sites, among them rescueFunds (0xe53b2017) and unwrapTo (0xc12ea3ca), run the same test on CALLER and revert 0x5fc483c5 otherwise. The code has no SSTORE-backed owner, no DELEGATECALL and no upgrade function, so the owner set can only change by deploying a new contract. Under EIP-8151 a recovered owner whose account holds real code yields no address, so that owner's ERC-1271 signatures fail; the other four still sign, and the owner-only direct calls compare msg.sender and are unaffected.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size branch for owners with code: the recover routine has only the precompile call (bytecode at 0x10ca-0x1197).
- Ruled out: a fixed gas amount on the precompile: it is called with GAS, so the price change alone breaks nothing.
- Ruled out: key-state: all five owners answer isOwner true and are plain accounts with 27 to 164,113 transactions at the block.
- Ruled out: upgrade or setter: no EIP-1967 implementation, no upgradeTo, owners are code constants (not storage).
- Ruled out: the old row's single fixed key and 'upgrade-only' issue: the code trusts five fixed keys and has no upgrade path, so the root issue is fixed-signer.
- Ruled out: copy 0x4d8f74decbc4b16b7455c7ab5cc978968191533c: same code shape with its own five owners fixed in it (0x3e4798b0..., 0x5dd10b2c..., 0x263f9250..., 0x1c1a61b0..., 0x90d40b46...); none has code, but 0x1c1a61b0... and 0x90d40b46... have never sent a transaction (nonce 0). It holds nothing; the same notice applies to it with its own keys, as its own row.
- Ruled out: order filling itself: resolveOrders does not use the recovery; the recover routine is reached from one call site only, isValidSignature (bytecode offset 0x0282).

### Questions

- Which contracts ask this resolver isValidSignature, and for what (orders or permits signed in its name)? Only transactions or logs can show it; the card does not name the service that stops.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
