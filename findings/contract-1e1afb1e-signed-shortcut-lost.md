---
id: contract-1e1afb1e-signed-shortcut-lost
format: 2
title: Pauly token holders whose accounts take real code lose permit
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a holder moves its account to real code, and approve stays open to that holder.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  code: decompiled
  code_url: code/0xe127e17bf48ba75b2d3f47fe3ee55fe1cd370dfb96d96937f24961ab1454d7e5.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Tell holders to use approve once their accounts take real code; permit then rejects their signatures.
evidence_level: bytecode
checks:
- id: name
  call: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  fn: name()(string)
  is: You Get Nothing
  says: the token name at the block
  for:
  - what
- id: sel-permit
  selector: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the code has permit
  for:
  - what
- id: sel-approve
  selector: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  fn: approve(address,uint256)
  says: the code has approve
  for:
  - evidence-2
- id: permit-ok
  call: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  data: '0xd505accf0000000000000000000000001c1bb1b50cbdd0ac1550039047ff3929d806ff17000000000000000000000000000000000000000000000000000000000000dead00000000000000000000000000000000000000000000000000000000000003e8ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000001b83d97f121af2f1cbbac72a5a8a452f5de2029d710be44e349db81e72ebbac0f524cb16b887e3be178da0c085f18786661d54a646956772575d60252e850de4ae'
  is: 0x
  says: a permit signed by the owner key (fresh EOA) is accepted at the block
  for:
  - what
- id: permit-bad
  call: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  data: '0xd505accf0000000000000000000000001c1bb1b50cbdd0ac1550039047ff3929d806ff17000000000000000000000000000000000000000000000000000000000000dead00000000000000000000000000000000000000000000000000000000000003e9ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000001b83d97f121af2f1cbbac72a5a8a452f5de2029d710be44e349db81e72ebbac0f524cb16b887e3be178da0c085f18786661d54a646956772575d60252e850de4ae'
  reverts_with: '0x8baa579f'
  says: 'the same signature over a different value is rejected: the recovered address must equal the owner'
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  call: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  fn: approve(address,uint256)(bool)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  - '1000'
  from: '0x1c1BB1b50CbdD0AC1550039047Ff3929d806FF17'
  is: true
  says: approve from the holder succeeds with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ecrec
  bytecode: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  has: 602060006080600060015afa156000519081151790841415176103f157
  says: staticcall to precompile 0x01 with gas(); the result must be non-zero and equal to the owner, else no jump
    to the success path
  for:
  - evidence-1
  - what
- id: no1271
  bytecode: '0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e'
  has: 1626ba7e
  absent: true
  says: no ERC-1271 isValidSignature call
  for:
  - evidence-1
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

The Pauly token ("You Get Nothing") lets a holder approve a spender directly, or by a permit whose ECDSA signature must recover to the holder. A holder whose account takes real code loses permit and keeps approve.

## Evidence

- [permit](https://etherscan.io/address/0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e#code) passes the signature to the recovery precompile with all remaining gas, compares the result with the owner and has no ERC-1271 path.
- [approve](https://etherscan.io/address/0x1e1afb1eca49d0790e0e99f869bd9fb942ea557e#code) is a direct call from the holder that takes no signature.

## Reviewer notes

### Mechanism

Unverified runtime (1,494 bytes), a Solady-style ERC-20, not a proxy, no owner. permit (0xd505accf) requires block.timestamp <= deadline, builds the EIP-712 digest from the permit typehash and a domain separator hardcoded for this address on chain 1 (0xe48f2c07...), calls the ecrecover precompile with staticcall(gas(), 1, 0, 0x80, 0, 0x20), and requires the returned address to be non-zero and equal to the owner argument, else reverts with 0x8baa579f. On success it increments nonces(owner) and writes the allowance (owner, spender) = value (decompiled reading). approve (0x095ea7b3) writes the caller allowance with no signature. A simulated permit signed by a fresh EOA key succeeds at the block; the same signature with a changed value reverts 0x8baa579f. Under EIP-8151 the precompile returns nothing for an owner with real code, so permit reverts for that owner; an EIP-7702 delegated owner still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: fixed gas to the precompile: the call forwards gas() (bytes 600060015afa), so the higher recovery price does not break it by itself.
- Ruled out: an ERC-1271 path: the ERC-1271 selector 0x1626ba7e is absent from the code.
- Ruled out: a re-checked signature: permit consumes the signature at once (nonce increments); nobody relies on it later.
- Ruled out: proxy or implementation-only code: no DELEGATECALL, EIP-1967 slots empty (tool facts); the token answers name, symbol and totalSupply 1e27 at the block itself.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
