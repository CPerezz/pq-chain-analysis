---
id: contract-4f8916cc-rotate-signer-before-migrating
format: 2
title: Signature check stops if its one signer key's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if the signer key's account moves to real code, and the admin can set a new key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  code: bytecode
  code_url: https://etherscan.io/address/0x4f8916cc1d9307364f0343e0a1e9c658b79daa46#code
  copies: 2
  family: c82dcacd03d3f18f5a643a1d213d8082
  admin: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Set a new key with setSigner, on both copies, before the current signer key's account moves to real code.
evidence_level: bytecode
checks:
- id: compare
  bytecode: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  has: 73ffffffffffffffffffffffffffffffffffffffff8060075416911603611a6c57005b7fbbfe1a31
  says: the recovered address is compared with the address in slot 7, reverting 0xbbfe1a31 on mismatch
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa
  bytecode: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  has: 60015afa156116b2575f5173ffffffffffffffffffffffffffffffffffffffff811615
  says: a STATICCALL to the ecrecover precompile with all gas, and a zero-address test on its result
  for:
  - evidence-1
- id: wrongsig
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  data: '0x2cf886719f9fe4a5956733c0d3ffc9631a8c98be2b7bfff73139f2886928c07c9b3c0d6300000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000041e8af43d0cd7d863acb13c147c47a2ca430e63e3875077cb068d4499658b3550771e5d238be74591ed409ffee5ee704024b2b5b9c0bd44e6cfef11aee1d50a35f1c00000000000000000000000000000000000000000000000000000000000000'
  from: '0x7d4b9a1ac0fa0a82d24f9c85662b5f830f47c0fd'
  reverts_with: bbfe1a31
  says: from the signer-operator, a valid signature by another key reverts with the wrong-signer error
  for:
  - evidence-1
  - what
- id: opgate
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xd7191c62734237531546faee4f63764434d18167cf7e8b14ca4b1f01ea131925'
  - '0x7d4b9a1ac0fa0a82d24f9c85662b5f830f47c0fd'
  is: true
  says: the operator contract holds the signer-operator role
  for:
  - what
- id: opowner
  call: '0x7d4b9a1ac0fa0a82d24f9c85662b5f830f47c0fd'
  fn: owner()(address)
  is: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
  says: the signer-operator contract is owned by the same Safe
  for:
  - what
- id: notpaused
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  fn: paused()(bool)
  is: false
  says: the contract is not paused
  for:
  - what
- id: signer
  storage: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  slot: 7
  is: '0x64e5fc1ee00e5de8af8c19a6cd8f0742d1858c91'
  says: slot 7 holds the signer key
  for:
  - evidence-1
  - what
- id: signereoa
  code: '0x64e5fc1ee00e5de8af8c19a6cd8f0742d1858c91'
  is: empty
  says: the signer account has no code
  for:
  - evidence-1
- id: setsel
  selector: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  fn: setSigner(address)
  says: setSigner is in the code
  for:
  - evidence-2
- id: setter
  bytecode: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  has: 600754827fffffffffffffffffffffffff0000000000000000000000000000000000000000821617600755
  says: setSigner writes the new address into slot 7
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setok
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  data: '0x6c19e7830000000000000000000000000000000000000000000000000000000000000001'
  from: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
  is: ''
  says: the admin Safe can call setSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setdeny
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  data: '0x6c19e7830000000000000000000000000000000000000000000000000000000000000001'
  from: '0x0000000000000000000000000000000000000001'
  reverts_with: e2517d3f
  says: 'another account cannot: AccessControlUnauthorizedAccount'
  for:
  - evidence-2
- id: admin
  call: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  fn: defaultAdmin()(address)
  is: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
  says: the default admin is the Safe
  for:
  - action
  - evidence-2
  - justification
- id: safethr
  call: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
  fn: getThreshold()(uint256)
  is: 1
  says: the Safe needs one signature
  for:
  - evidence-2
- id: safeowners
  call: '0x6c539e15f08d3804b5112d4ad34101274749cea8'
  fn: getOwners()(address[])
  is:
  - '0xc3d5f0b5fc70717794e07b89a2323582c1fc7fb0'
  - '0x4f10405ee1c04fee3a51a118ac895192b02d5f7a'
  says: the Safe has two owners
  for:
  - evidence-2
- id: copysigner
  storage: '0x88762797331a435833b3f9df96002488de0a92c9'
  slot: 7
  is: '0x64e5fc1ee00e5de8af8c19a6cd8f0742d1858c91'
  says: the copy stores the same signer
  for:
  - action
  - evidence-3
- id: copyadmin
  call: '0x88762797331a435833b3f9df96002488de0a92c9'
  fn: defaultAdmin()(address)
  is: '0x703f954b1d1e2fe928e9808cf6b57609a7c5dd32'
  says: the copy's default admin
  for:
  - action
  - evidence-3
- id: copyadmincode
  bytecode: '0x703f954b1d1e2fe928e9808cf6b57609a7c5dd32'
  has: 7fa619486e
  says: the copy's admin is a Safe proxy
  for:
  - evidence-3
- id: no1271
  bytecode: '0x4f8916cc1d9307364f0343e0a1e9c658b79daa46'
  has: 1626ba7e
  absent: true
  says: no ERC-1271 call in the code
  for:
  - notes
- id: deleg
  replay: '0xead8fc046e2807de799b2e74f10d7679947aa48c97008c878f44360437a77281'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer, a real call still succeeds
  for:
  - what
- id: eip8151
  replay: '0xead8fc046e2807de799b2e74f10d7679947aa48c97008c878f44360437a77281'
  run: eip8151
  ok: true
  says: under EIP-8151 alone the real call succeeds
  for:
  - notes
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

Unpaused, it serves a signer-operator contract owned by its admin: each signed id that contract submits is recovered and refused unless it matches one stored key. If that key's account takes real code, every check fails until the admin sets a new key; an EIP-7702 delegation keeps working.

## Evidence

- [The code](https://etherscan.io/address/0x4f8916cc1d9307364f0343e0a1e9c658b79daa46#code) reverts unless the recovered address equals the stored signer key, an account with no code.
- [setSigner](https://etherscan.io/address/0x4f8916cc1d9307364f0343e0a1e9c658b79daa46#code) replaces that key; only the default admin, a Safe that needs one of its two owners, can call it.
- [A second copy](https://etherscan.io/address/0x88762797331a435833b3f9df96002488de0a92c9#code) trusts the same key; another Safe is its admin.

## Reviewer notes

### Mechanism

Unverified code, read from the disassembly. Selector 0x2cf88671(bytes32 id, bytes sig) requires the caller to hold SIGNER_OPERATOR_ROLE (0xd7191c62...), requires not paused, hashes id with chainid and address(this) into an eth_sign digest, refuses a digest already used (slot 8 mapping) and marks it used, recovers with OpenZeppelin ECDSA (STATICCALL to precompile 1 with all gas, low-s check, reverts on zero address), then compares the result with the address in slot 7 and reverts 0xbbfe1a31 on mismatch; otherwise it stops. setSigner(address) (0x6c19e783) is gated by onlyRole(DEFAULT_ADMIN_ROLE) and writes slot 7; 0x7ac3c02f returns it. AccessControlDefaultAdminRules: defaultAdmin is 0x6c539e15f08d3804b5112d4ad34101274749cea8, a Safe proxy, threshold 1, two owners; no pending admin change. The signer-operator 0x7d4b9a1ac0fa0a82d24f9c85662b5f830f47c0fd is owned by the same Safe. Copy 0x88762797331a435833b3f9df96002488de0a92c9 stores the same signer; its defaultAdmin is 0x703f954b1d1e2fe928e9808cf6b57609a7c5dd32, a Safe proxy with threshold 1. Under EIP-8151 a signer with real code makes ecrecover return nothing, OZ recover reverts, and every call reverts until setSigner installs a new key.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: ERC-1271 or code-size branch: none; after the recovery the code compares with slot 7 and stops or reverts, and the ERC-1271 selector 0x1626ba7e is absent from the code (check no1271).
- Ruled out: Fixed gas: the recovery forwards all gas (PUSH1 1, GAS, STATICCALL); the replay of 0xead8fc04... under EIP-8151 alone succeeds (check eip8151), so nothing breaks with nobody migrating.
- Ruled out: Key state: slot 7 holds 0x64e5...8c91, the address the scan recovered 56 times in the two-week window, with no code and nonce 0 (a signing key that never sent a transaction, presumed live).
- Ruled out: Setter: an eth_call of setSigner from the admin Safe succeeds and from another account reverts with AccessControlUnauthorizedAccount(caller, 0).
- Ruled out: Path closed: paused() is false at the block; the copy is not paused either.
- Ruled out: Unused implementation: not a proxy implementation; it is configured and recovered signers in real transactions.
- Ruled out: Replay not cited for the failure: the replayed transaction goes through another contract (root selector 0x571e7696) on the copy, and without a trace I cannot show that this contract's own check is the step that fails with code at the signer. Only its delegated run (success) is cited.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
