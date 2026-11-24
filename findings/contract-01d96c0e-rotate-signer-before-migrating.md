---
id: contract-01d96c0e-rotate-signer-before-migrating
format: 2
title: Smart accounts lose owner signatures once the key's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Signing works until a key's account moves to real code; the account can register a new key, and direct
  calls still pass.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  code: decompiled
  code_url: code/0x378e8c0547e6e8ef44d766f0a1dc197ab59562b64b0ed6e117a4b1b00357f1f1.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 6
  last: 2026-11-15
impact: liveness
action: Tell account owners to register a new key with enable from their smart account before moving the key's account
  to real code.
evidence_level: executed
checks:
- id: enablesel
  selector: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  fn: enable(bytes)
  says: the code has the selector of enable(bytes)
  for:
  - action
  - what
- id: enablewrite
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: '3384528360205283208054'
  says: enable computes the mapping slot of the caller and loads it before writing the new key there
  for:
  - action
  - justification
  - what
  - whose
- id: ownerexec
  call: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  fn: execute(address,uint256,bytes,uint8)()
  args:
  - '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  - 0
  - '0x0c959556000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000141111111111111111111111111111111111111111000000000000000000000000'
  - 0
  from: '0xdc768186cac0d2563e4986d0bed86a2d9221b87d'
  is: ''
  says: called by its stored key's address, the account's execute runs enable on the validator without reverting
  for:
  - action
  - justification
- id: strangerexec
  call: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  fn: execute(address,uint256,bytes,uint8)()
  args:
  - '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  - 0
  - '0x0c959556000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000141111111111111111111111111111111111111111000000000000000000000000'
  - 0
  from: '0x2222222222222222222222222222222222222222'
  reverts: true
  says: the same call from another address reverts
  for:
  - notes
- id: stored
  call: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  fn: ecdsaValidatorStorage(address)(address)
  args:
  - '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  is: '0xdc768186cac0d2563e4986d0bed86a2d9221b87d'
  says: the validator stores a key for the smart account 0x8cd1beb4...
  for:
  - what
  - whose
- id: recover
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 10915114165afa
  says: 'the recovery: a STATICCALL with all gas to address 1 when the signature has 65 bytes and a low s'
  for:
  - evidence-1
  - what
- id: emptyrevert
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 638baa579f90526004601cfd
  says: when the recovery returns nothing the code reverts with error 0x8baa579f
  for:
  - evidence-1
  - what
- id: sigread
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 3384528360205273ffffffffffffffffffffffffffffffffffffffff9182604086205416
  says: validateSignature loads the key stored for the caller, to compare with the recovered address
  for:
  - what
- id: no1271
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 1626ba7e
  absent: true
  says: the ERC-1271 selector is not in the code
  for:
  - evidence-1
  - what
- id: tx
  tx: '0xd13cc9cc03bb659c01d030e1656ffa78056245221eae5b4b81c617b82e77e188'
  to: '0xca11bde05977b3631167028862be2a173976ca11'
  ok: true
  says: a real transaction that succeeded, in which an operation of 0x8cd1beb4... was validated here
  for:
  - evidence-2
- id: replaycode
  replay: '0xd13cc9cc03bb659c01d030e1656ffa78056245221eae5b4b81c617b82e77e188'
  run: eip8151_signer_code
  ok: false
  says: replayed with code at the signer, the transaction reverts
  for:
  - evidence-2
  - justification
  - what
- id: replaydeleg
  replay: '0xd13cc9cc03bb659c01d030e1656ffa78056245221eae5b4b81c617b82e77e188'
  run: eip8151_signer_delegated
  ok: true
  says: replayed with a 7702 delegation at the signer, it passes
  for:
  - evidence-2
  - justification
- id: replayprice
  replay: '0xd13cc9cc03bb659c01d030e1656ffa78056245221eae5b4b81c617b82e77e188'
  run: eip8151
  ok: true
  says: replayed under the new price alone, it passes
  for:
  - notes
- id: keycode
  code: '0xdc768186cac0d2563e4986d0bed86a2d9221b87d'
  is: delegation
  target: '0x88cf071b4bf5facab6712070a671f71282188d46'
  says: the stored key's account carries a 7702 delegation, not real code
  for:
  - notes
- id: acctimpl
  storage: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x000000000000000000000000e05e1af3f9e107c6127a6105fcb45379dafb829f'
  says: the smart account is a proxy to 0xe05e1af3...
  for:
  - notes
- id: acctexec
  selector: '0xe05e1af3f9e107c6127a6105fcb45379dafb829f'
  fn: execute(address,uint256,bytes,uint8)
  says: the account's code has an execute function selector
  for:
  - notes
- id: emptytest
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 3d156105b257
  says: after the recovery the code tests the size of the returned data and jumps to the revert when it is zero
  for:
  - evidence-1
  - what
- id: vcsel
  selector: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  fn: validCaller(address,bytes)
  says: the code has the selector of validCaller(address,bytes)
  for:
  - what
- id: vccode
  bytecode: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  has: 33815280855273ffffffffffffffffffffffffffffffffffffffff91829120541691519216148152f3
  says: 'validCaller returns whether the address passed in equals the key stored for the caller: no recovery, no
    code read'
  for:
  - evidence-3
  - justification
  - what
- id: vckey
  call: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  fn: validCaller(address,bytes)(bool)
  args:
  - '0xdc768186cac0d2563e4986d0bed86a2d9221b87d'
  - 0x
  from: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  is: 'true'
  says: asked by the smart account, the validator approves a direct caller that is the stored key's address
  for:
  - evidence-3
  - justification
  - what
- id: vcstranger
  call: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  fn: validCaller(address,bytes)(bool)
  args:
  - '0x2222222222222222222222222222222222222222'
  - 0x
  from: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  is: 'false'
  says: and refuses another caller
  for:
  - evidence-3
  - what
- id: acctdefault
  call: '0x8cd1beb4cce4dd7ab6874a1358d1fb04213be97a'
  fn: getDefaultValidator()(address)
  args: []
  is: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  says: this validator is the default validator of the smart account 0x8cd1beb4...
  for:
  - evidence-3
  - whose
- id: slot1967
  storage: '0x01d96c0e273878ca176ff4699ad92e6f6a41b29d'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the EIP-1967 implementation slot of the validator is empty
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-01d96c0e, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code'', title shortened to fit); a fresh refuter agrees on every part and re-ran
    all four replay runs; Claude read the changed sentences. Kept as before.'
related: []
---

## What happens

Smart accounts register one owner key each here. It accepts a signature when ECDSA recovers that key, and a direct call from the key's address. If the key's account moves to real code, its signatures fail; its direct calls still pass.

## Evidence

- The [bytecode](https://etherscan.io/address/0x01d96c0e273878ca176ff4699ad92e6f6a41b29d#code) recovers each signature with ECDSA, reverts when nothing is recovered, and has no contract-signature check.
- A real [operation](https://etherscan.io/tx/0xd13cc9cc03bb659c01d030e1656ffa78056245221eae5b4b81c617b82e77e188) reverts when replayed with real code at its signer and passes with a delegation there.
- Asked by the account 0x8cd1beb4…, [validCaller](https://etherscan.io/address/0x01d96c0e273878ca176ff4699ad92e6f6a41b29d#code) returns true for the stored key's address and false for another, comparing addresses with no signature.

## Reviewer notes

### Mechanism

Unverified code; selectors from the disassembly: enable(bytes), disable(bytes), validateUserOp, validateSignature(bytes32,bytes), validCaller(address,bytes), ecdsaValidatorStorage(address). enable stores the first 20 bytes of its argument in a mapping slot keyed by the caller; disable zeroes it. validateUserOp (0x0497) and validateSignature (0x05c0) load that slot, recover through one routine (0x054a: the only STATICCALL, all gas, to address 1 for a 65-byte low-s signature) and compare with the stored key; empty return data reverts with 0x8baa579f. validCaller returns whether the address passed in equals the caller's stored key. One account is identified: 0x8cd1beb4... has this validator as default and stores 0xdc768186... (a 7702 delegation). Its own code (proxy to 0xe05e1af3...) was not reviewed. Real code at the key cannot be simulated through the gateway.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: one STATICCALL, no CALL, EXTCODESIZE or EXTCODEHASH in the disassembly; 1626ba7e absent.
- Ruled out: unused code: 0x8cd1beb4... has it as default validator with a key stored; two operations recovered keys in the window.
- Ruled out: key unset or a contract: the stored key carries a 7702 delegation, which still recovers (replay passes).
- Ruled out: setter closed: enable has no guard and writes the caller's own slot; no owner, pause or deadline in the six functions.
- Ruled out: fixed gas, or a break with nobody migrating: the call forwards all gas; the replay under the new price alone passes.
- Ruled out: rechecked later: the account can already void any signature with enable or disable, so migrating gives no new power.
- Ruled out: no direct path: disproved, the card now says it. validCaller approves the key's address; the account's execute runs enable for it (ownerexec) and reverts for another (strangerexec). The earlier 'only' and 'must' were wrong.
- Ruled out: proxy or deployer: no DELEGATECALL or CREATE; EIP-1967 slot empty.
- Ruled out: signed-shortcut-lost instead of this issue: the validator's trusted key is a stored value that enable replaces, which is this root issue; the direct-call path belongs to the account's execute, and the card states it. Both are INFORMATIONAL.

### Questions

- The second key recovered in the window, 0xe10ff271..., belongs to an account I did not identify. How many accounts have a key here is not known: counting needs a log scan the gateway refuses.
- Whether a key's account can still make the direct call after it takes real code depends on that code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
