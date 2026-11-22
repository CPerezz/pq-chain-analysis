---
id: contract-304eddbe-rotate-signer-before-migrating
format: 2
title: Safety signer must be replaced before its account moves to real code
status: candidate
severity: INFORMATIONAL
justification: Paused now; once unpaused, signed calls work until the safety signer moves to real code, then the
  owner resets it.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  code: decompiled
  code_url: code/0x35fba45a1c643467e9a634f022f41538045267a096c01b537c353bb341b30c6b.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x1fb80c820a1e988b56f1bfbc05441e6937458c75'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10
  last: 2026-08-20
impact: liveness
action: Set a new safety signer with the owner's configuration call before moving the current signer's account to
  real code.
evidence_level: bytecode
checks:
- id: pause-single
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b600154600160a01b900460ff161561121c576040516313d0ff5960e31b815260040160405180910390fd5b60018054600160a81b900460ff16146112485760405163769dd35360e11b815260040160405180910390fd5b6001805460ff60a81b1916600160a91b17905560405161128f9084906112729087906020016135ab565b6040516020818303038152906040528051906020012084846121ca56
  says: the single signed call reverts with 0x9e87fac8 while byte 20 of slot 1 is set, before it jumps to the signature
    routine at 0x21ca
  for:
  - justification
  - what
- id: pause-batch
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b600154600160a01b900460ff1615611bda576040516313d0ff5960e31b815260040160405180910390fd5b60018054600160a81b900460ff1614611c065760405163769dd35360e11b815260040160405180910390fd5b6001805460ff60a81b1916600160a91b1790555f611c2486866124e1565b9050611c5a848787604051602001611c3d9291906135bd565b6040516020818303038152906040528051906020012085856121ca56
  says: the batch signed call reverts with 0x9e87fac8 while byte 20 of slot 1 is set, before it jumps to the signature
    routine at 0x21ca
  for:
  - justification
  - what
- id: setpaused-entry
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 6316c38b3c146103a057
  says: setPaused(bool), selector 0x16c38b3c, is dispatched to offset 0x03a0
  for:
  - justification
- id: setpaused-jump
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b3480156103ab575f5ffd5b506102d76103ba36600461314f565b610eb256
  says: the code at 0x03a0 decodes the argument and jumps to 0x0eb2
  for:
  - justification
- id: setpaused-body
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b5f546001600160a01b03163314610edc576040516330cd747160e01b815260040160405180910390fd5b60018054821515600160a01b0260ff60a01b19909116179055
  says: the code at 0x0eb2 requires the caller to be the owner and writes the argument to byte 20 of slot 1, so
    the owner can unpause
  for:
  - justification
- id: recover
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 019060a0016020604051602081039080840390855afa
  says: the code calls the signature-recovery precompile at address 1 with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: compare
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b6007546001600160a01b03166121f36121ec86612147565b848461292d565b6001600160a01b03161461221a57604051638baa579f60e01b
  says: the recovered address must equal the address in slot 7, or the call reverts with error 0x8baa579f
  for:
  - evidence-1
  - justification
  - what
- id: signer
  call: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  fn: safetySigner()(address)
  is: '0x00c4199d1b25060e6907e4190d6046e89b53014a'
  says: slot 7, read by safetySigner(), holds this key
  for:
  - evidence-1
  - what
- id: signer-eoa
  code: '0x00c4199d1b25060e6907e4190d6046e89b53014a'
  is: empty
  says: the safety signer's account has no code
  for:
  - evidence-1
- id: no-1271
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer contract through ERC-1271
  for:
  - what
- id: flag
  storage: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  slot: 8
  is: '0x0000000000000000000000011fb80c820a1e988b56f1bfbc05441e6937458c75'
  says: byte 20 of slot 8, the switch that blocks unsigned calls, is 1
  for:
  - evidence-3
  - what
- id: flag-check
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b600854600160a01b900460ff16156111a857604051630283916360e21b
  says: the routine the unsigned execute functions call reverts while that byte of slot 8 is set
  for:
  - evidence-3
  - what
- id: setter-entry
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 6359dc842d1461049e57
  says: selector 0x59dc842d is dispatched to offset 0x049e
  for:
  - action
  - evidence-2
- id: setter-jump
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b3480156104a9575f5ffd5b506102d76104b83660046132df565b6112bf565b
  says: the code at 0x049e decodes the arguments and jumps to 0x12bf
  for:
  - action
  - evidence-2
- id: setter-body
  bytecode: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  has: 5b5f546001600160a01b031633146112e9576040516330cd747160e01b815260040160405180910390fd5b6001600160a01b038716158061130857506001600160a01b0387163b15155b80611318575061271061ffff8516115b80611328575061271061ffff8416115b8061133a57506001600160401b038216155b8061134f5750610e106001600160401b038316115b8061136157506001600160401b038116155b8061137657506101006001600160401b038216115b1561139457604051630adede3160e01b815260040160405180910390fd5b600780546001600160a01b0319166001600160a01b038916908117909155
  says: the code at 0x12bf requires the caller to be the owner in slot 0, checks the arguments and writes the new
    signer to slot 7
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner
  call: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  fn: owner()(address)
  is: '0x1fb80c820a1e988b56f1bfbc05441e6937458c75'
  says: the owner is this address
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner-eoa
  code: '0x1fb80c820a1e988b56f1bfbc05441e6937458c75'
  is: empty
  says: the owner is an account without code, so it can send the call
  for:
  - action
  - evidence-2
  - justification
- id: owner-nonce
  nonce: '0x1fb80c820a1e988b56f1bfbc05441e6937458c75'
  is: 41
  says: the owner has sent 41 transactions
  for:
  - evidence-2
- id: paused
  call: '0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9'
  fn: paused()(bool)
  is: true
  says: the contract is paused at the block
  for:
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

The contract runs a signed call only when the signature recovers to one stored key, the safety signer. It is paused at the block, and the unsigned route is switched off. If that key's account moves to real code, signed calls fail until the owner sets a new signer.

## Evidence

- The [code](https://etherscan.io/address/0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9#code) recovers the signer with ECDSA and reverts unless it equals the stored [safety signer](https://etherscan.io/address/0x00c4199d1b25060e6907e4190d6046e89b53014a), an account without code.
- An owner-only function in the [code](https://etherscan.io/address/0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9#code) writes the safety signer; the [owner](https://etherscan.io/address/0x1fb80c820a1e988b56f1bfbc05441e6937458c75) is an account without code that has sent 41 transactions.
- The contract is paused, and the switch in the [code](https://etherscan.io/address/0x304eddbe69db7539d0f8d3538a1fae5fd3ab52c9#code) that makes unsigned operator calls revert is on.

## Reviewer notes

### Mechanism

Unverified; names are selector matches. safetySigner() is slot 7. Selectors 0x53adb556 (one call, body 0x11aa) and 0xd5ca44f9 (batch, body 0x1b68) first test the pause bit (byte 20 of slot 1, revert 0x9e87fac8), then jump to 0x21ca: it recovers a 65-byte signature through the precompile with all gas and reverts 0x8baa579f unless the result equals slot 7. These are the only two jumps to 0x21ca. execute (0x5c1c6dcd) and its batch (0xb44e11af) call 0x24b6, which reverts while byte 20 of slot 8 is set; it is 1. Selector 0x59dc842d jumps via 0x049e to 0x12bf: owner check (0x30cd7471), argument checks (a signer that is zero or has code reverts 0x0adede31), then SSTORE to slot 7; no pause test. acceptOwnership (0x79ba5097) also sets slot 7 to the new owner. setPaused (0x16c38b3c, via 0x03a0 to 0x0eb2) is owner-only and writes the pause bit. paused() is true at the block. The owner has no code and nonce 41. withdrawNative is owner-only and needs no signature.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for a signer with code: the selector 0x1626ba7e is not in the code, and the only compare is with slot 7.
- Ruled out: a fixed gas amount: the precompile call forwards all gas (GAS before STATICCALL).
- Ruled out: a dead setter: eth_call of 0x59dc842d(signer, true, 0, 2000, 2000, 300, 3) from the owner succeeds at the block, from another address reverts 0x30cd7471.
- Ruled out: path closed for good: paused() is true and both signed functions revert on the pause bit before the signature check, but eth_call of setPaused(false) from the owner succeeds (from another address: 0x30cd7471), so the path can reopen.
- Ruled out: something that fails with nobody migrating: the signer has no code and the recovery forwards all gas, so the change alone breaks nothing here.
- Ruled out: a proxy, clones or children: no DELEGATECALL, CREATE or CREATE2 opcode in the code; the address holds its own state.
- Ruled out: the old note's setOperators as the key setter: it writes the operator map (slot 4), which gates the caller, not the recovered signer.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
