---
id: contract-3f403b1d-fixed-signer
format: 2
title: Trading contract approves signatures only from a fixed key
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks unless the key's holder moves its account to real code; the holder keeps direct control.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  code: decompiled
  code_url: code/0x48b8fb1a966ce0c2ce8908f9199b6b4c363452ca919ea5564602254817055909.sol
  copies: 1
value:
  usd: 0
  whose: operator
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Deploy a replacement with a new key and move what relies on these signature approvals to it before moving
  the key's account to real code.
evidence_level: bytecode
checks:
- id: sel1271
  selector: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  fn: isValidSignature(bytes32,bytes)
  says: the contract answers ERC-1271 signature checks
  for:
  - what
- id: ec
  bytecode: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  has: 60015afa50739b288bb8e08a3b943023557387fbed83c2f8cc4b815114
  says: the ecrecover precompile gets all remaining gas; its result is compared with the constant key 0x9b28…cc4b
  for:
  - action
  - evidence-1
  - justification
  - what
- id: magic
  bytecode: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  has: 630b135d3f60e11b
  says: on a match the code builds the ERC-1271 answer 0x1626ba7e (0x0b135d3f shifted left by one)
  for:
  - evidence-1
  - what
- id: foreign
  call: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  fn: isValidSignature(bytes32,bytes)(bytes4)
  args:
  - '0x1111111111111111111111111111111111111111111111111111111111111111'
  - '0xe7c93726a865578504442b1a6827f676e0ed74bdff2be3960d1e253bbcfc44626aa772b878bc912bdbb33a0014ec507c4b3896ea85aa914b74dee9b7ac3e56da1c'
  is: '0x00000000'
  says: a valid signature by another key (private key 1) is refused
  for:
  - evidence-1
  - what
- id: noproxy
  storage: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: 'the EIP-1967 implementation slot is empty: the address is not an upgradeable proxy'
  for:
  - action
  - evidence-2
  - what
- id: keyeoa
  code: '0x9b288bb8e08a3b943023557387fbed83c2f8cc4b'
  is: empty
  says: the key's account has no code at the block
  for:
  - evidence-2
  - justification
- id: keynonce
  nonce: '0x9b288bb8e08a3b943023557387fbed83c2f8cc4b'
  min: 231
  says: the key's account has sent at least 231 transactions
  for:
  - evidence-2
- id: direct
  bytecode: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  has: 33739b288bb8e08a3b943023557387fbed83c2f8cc4b14
  says: a path compares the caller with the key's address
  for:
  - evidence-3
  - justification
  - what
  - whose
- id: dcall
  bytecode: '0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa'
  has: 60401c6001600160a01b03165af4
  says: delegate() delegatecalls to an address read from calldata with all remaining gas
  for:
  - evidence-3
  - what
  - whose
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

This contract answers ERC-1271 signature checks with yes only when the signature recovers to one key fixed in its code. No function can replace that key, so if its account takes real code, the contract approves no signature. The holder keeps a direct call that runs any code as the contract.

## Evidence

- The [bytecode](https://etherscan.io/address/0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa#code) recovers the signer with ECDSA and compares it with the constant 0x9b28…cc4b; another key gets 0x00000000.
- The [key 0x9b28…cc4b](https://etherscan.io/address/0x9b288bb8e08a3b943023557387fbed83c2f8cc4b) is a plain account with no code at the block; the contract is not a proxy.
- Its [function delegate()](https://etherscan.io/address/0x3f403b1dbb93bec0a1d530369aaa350c51c0ebaa#code) runs code from an address in the calldata; only the key's address may call it.

## Reviewer notes

### Mechanism

Unverified code (2,947 bytes), read by disassembly; the decompiler's output agrees. Selector 0x1626ba7e (isValidSignature) requires a 65-byte signature and s in the lower half, calls the ecrecover precompile (address 1) with all remaining gas (GAS, not a constant), then compares the returned word with PUSH20 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b; equal returns 0x1626ba7e, otherwise 0. The key exists only as that code constant: the code has no SSTORE opcode, and the EIP-1967 implementation slot is empty, so neither storage nor a proxy upgrade can change it. Under EIP-8151, once the key's account has real code the precompile returns nothing and the comparison fails, so every signature is refused. Selector 0xc89e4361 (delegate()) checks CALLER == the same constant and DELEGATECALLs to an address taken from calldata with all gas; this is a direct call, unaffected by EIP-8151, through which the holder can move whatever the contract holds. The other selectors (0x1944799f, 0xfa461e33, 0x0965d04b) are trading/callback paths gated by msg.sender/tx.origin against eight fixed addresses and send tokens to the constant 0xa88800cd213da5ae406ce248380802bd53b47647; they recover nothing.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: fixed gas for the recovery: the STATICCALL to address 1 is given GAS, all remaining gas (bytes 60015afa).
- Ruled out: an ERC-1271 or code-size branch for a key with code: there is one STATICCALL in the code and one comparison with the constant.
- Ruled out: a setter or upgrade: the key is a PUSH20 constant, no SSTORE opcode in the disassembly, EIP-1967 implementation slot zero; a delegatecall cannot rewrite code.
- Ruled out: key already a contract or unset: the key 0x9b28…cc4b has no code and nonce 231 at the block.
- Ruled out: copies or proxies: the dossier lists none.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
