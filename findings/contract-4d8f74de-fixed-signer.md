---
id: contract-4d8f74de-fixed-signer
format: 2
title: Owner signatures stop counting here once an owner's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if an owner moves its account to real code; the five owners are fixed in the code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  code: bytecode
  code_url: https://etherscan.io/address/0x4d8f74decbc4b16b7455c7ab5cc978968191533c#code
  copies: 2
  family: deee56139ab65b5710a3cbf52581c72b
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Keep one owner account free of real code, or deploy a copy with new owners, before moving an owner account
  to real code.
evidence_level: bytecode
checks:
- id: ivs
  bytecode: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  has: 60006102926101748585856110ca565b6102bc577fffffffff000000000000000000000000000000000000000000000000000000006102de565b7f1626ba7e00000000000000000000000000000000000000000000000000000000
  says: isValidSignature (0x1626ba7e) recovers the signer, passes it to the owner test, and returns 0x1626ba7e on
    a match, 0xffffffff otherwise
  for:
  - evidence-1
  - justification
  - what
- id: rec
  bytecode: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  has: 848152600080526020600060808360015afa50
  says: the recovery is a STATICCALL to the precompile 0x01 with all remaining gas (GAS), not a fixed amount
  for:
  - evidence-1
  - what
- id: own1
  bytecode: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  has: 60007f0000000000000000000000003e4798b0e268bb73c04e29afe0bc7fdcf37b67c173ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1614806107ea5750
  says: the owner test compares the address with constants pushed from the code (PUSH32), not with storage
  for:
  - action
  - evidence-1
  - justification
  - what
- id: arb
  bytecode: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  has: 6105eb33610743565b61062157
  says: arbitraryCalls (0x1f3177ba) runs the owner test on msg.sender, so an owner calls out from the contract directly
  for:
  - what
  - whose
- id: sweep
  bytecode: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  has: 610fdf33610743565b61101557
  says: the token sweep (0xe53b2017) runs the owner test on msg.sender and sends the balance to the caller
  for:
  - what
  - whose
- id: notowner
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x0000000000000000000000000000000000000001'
  is: false
  says: an address outside the five is not an owner
  for:
  - what
- id: o1
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  is: true
  says: 0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1 is one of the five owners
  for:
  - action
  - evidence-2
  - what
- id: c1
  code: '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  is: empty
  says: owner 0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1 has no code
  for:
  - evidence-2
- id: o2
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d'
  is: true
  says: 0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d is one of the five owners
  for:
  - action
  - evidence-2
  - what
- id: c2
  code: '0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d'
  is: empty
  says: owner 0x5dd10b2c9333a8aadf3bc58a966ae4524dea011d has no code
  for:
  - evidence-2
- id: o3
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x263f925011bfefbc638948ed15af1c131b26bd46'
  is: true
  says: 0x263f925011bfefbc638948ed15af1c131b26bd46 is one of the five owners
  for:
  - action
  - evidence-2
  - what
- id: c3
  code: '0x263f925011bfefbc638948ed15af1c131b26bd46'
  is: empty
  says: owner 0x263f925011bfefbc638948ed15af1c131b26bd46 has no code
  for:
  - evidence-2
- id: o4
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x1c1a61b05e29953745c5973159ad13ad644e0a7e'
  is: true
  says: 0x1c1a61b05e29953745c5973159ad13ad644e0a7e is one of the five owners
  for:
  - action
  - evidence-2
  - what
- id: c4
  code: '0x1c1a61b05e29953745c5973159ad13ad644e0a7e'
  is: empty
  says: owner 0x1c1a61b05e29953745c5973159ad13ad644e0a7e has no code
  for:
  - evidence-2
- id: o5
  call: '0x4d8f74decbc4b16b7455c7ab5cc978968191533c'
  fn: isOwner(address)(bool)
  args:
  - '0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a'
  is: true
  says: 0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a is one of the five owners
  for:
  - action
  - evidence-2
  - what
- id: c5
  code: '0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a'
  is: empty
  says: owner 0x90d40b463eac5d6eed58f5d5b251f636a19b3c0a has no code
  for:
  - evidence-2
- id: n1
  nonce: '0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1'
  is: 2782
  says: owner 0x3e47…67c1 has sent 2,782 transactions
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-4d8f74de, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL candidate (PQ-17, bytecode): a copy of the order resolver 0x84d99aa5 answering ERC-1271
    only for five owners fixed in its code (no storage, no setter); an owner moving to real code stops counting
    (an EIP-7702 delegation still works) and owners keep direct calls. Refuter agrees (it disassembled the code
    itself); Claude read the sheet.'
related: []
---

## What happens

This contract approves signatures for other contracts through ERC-1271 when the signer is one of five owner keys written into its code. An owner whose account takes real code no longer signs for it; an EIP-7702 delegation keeps working. Owners still call it directly.

## Evidence

- [Its code](https://etherscan.io/address/0x4d8f74decbc4b16b7455c7ab5cc978968191533c#code) returns the ERC-1271 success value only when the recovered signer is one of five owner constants.
- All five owners have no code at the block; [one of them](https://etherscan.io/address/0x3e4798b0e268bb73c04e29afe0bc7fdcf37b67c1) has sent 2,782 transactions.

## Reviewer notes

### Mechanism

Unverified code, judged from the disassembly (decompiled code used as a lead only). isValidSignature (0x1626ba7e, entry 0x00c1) calls the recover routine at 0x10ca (65-byte and 64-byte signatures, low-s check, STATICCALL to 0x01 with all gas), then the owner test at 0x0743, which compares the address with five PUSH32 constants (immutables) 0x3e47..67c1, 0x5dd1..011d, 0x263f..bd46, 0x1c1a..0a7e, 0x90d4..3c0a; match returns 0x1626ba7e, else 0xffffffff. isOwner (0x2f54bf6e) exposes the same test. arbitraryCalls (0x1f3177ba), approve (0x7e5465ba), 0xb089fef4, the WETH unwrap and ETH send (0xc12ea3ca), and the token sweeps (0xd824d791, 0xe53b2017) all require isOwner(msg.sender), so owners keep full control by direct call after migrating. resolveOrders (0x1944799f) is callable only by 0xac322546..5fdb, a constant in the code. The disassembly has no SSTORE or SLOAD and no DELEGATECALL: no function can change the owners.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: erc1271: the contract is itself the ERC-1271 side; it never asks an owner with code through ERC-1271 (no call to the recovered address after recovery).
- Ruled out: unused-implementation: not a proxy or clone; it holds its own owners as constants, and owner 0x3e47..67c1 is an active account (nonce 2,782).
- Ruled out: key-state: all five owners answer isOwner true and have no code at the block.
- Ruled out: breaks-by-itself / gas: the recovery forwards all gas (GAS before STATICCALL), so the higher price breaks nothing with nobody migrating.
- Ruled out: direct-path: owners keep arbitraryCalls, approve and the sweeps by direct call; only signatures given through ERC-1271 are lost, which the card says.
- Ruled out: copies: 0x84d99aa569d93a9ca187d83734c8c4a519c4e9b1 runs the same code with five other owner constants; it is its own row.

### Questions

- Which contract asks this one for ERC-1271 signatures, and is it still used? Only logs or traces show it; the code names 0xac322546fea4b6858ffc5ea51771cdcd7f715fdb as the only caller of resolveOrders.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
