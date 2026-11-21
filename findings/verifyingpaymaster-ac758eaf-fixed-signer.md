---
id: verifyingpaymaster-ac758eaf-fixed-signer
format: 2
title: Paymaster stops sponsoring if its fixed signer's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the signer moves its account to real code; the owner can still withdraw the deposit
  by a direct call.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  name: VerifyingPaymaster
  code: verified
  code_url: https://etherscan.io/address/0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c#code
  copies: 27
  family: c24b5a05c34850eed31fc7c31f4a893f
  upgradeable: 'no'
  admin: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
value:
  usd: 6
  basis: held
activity: {}
impact: liveness
action: Deploy a paymaster with a new signer and move the deposit with withdrawTo before the signer's account takes
  real code.
evidence_level: source
checks:
- id: recover
  source: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  file: VerifyingPaymaster.sol
  line: 93
  has: if (verifyingSigner != ECDSA.recover(hash, signature)) {
  says: the recovered address must equal verifyingSigner
  for:
  - evidence-1
  - justification
  - what
- id: fail
  source: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  file: VerifyingPaymaster.sol
  line: 94
  has: return ("", _packValidationData(true, validUntil, validAfter));
  says: on mismatch the paymaster reports a failed signature, so the EntryPoint refuses the operation
  for:
  - what
- id: immut
  source: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  file: VerifyingPaymaster.sol
  line: 25
  has: address public immutable verifyingSigner;
  says: the signer is an immutable, part of the deployed code
  for:
  - evidence-1
  - justification
  - what
- id: ctor
  source: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  file: VerifyingPaymaster.sol
  lines:
  - 31
  - 34
  has: verifyingSigner = _verifyingSigner;
  says: the signer is set once, in the constructor
  for:
  - evidence-1
  - what
- id: withdraw
  source: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  file: BasePaymaster.sol
  lines:
  - 105
  - 110
  has: uint256 amount ) public onlyOwner { entryPoint.withdrawTo(withdrawAddress, amount);
  says: the owner withdraws the EntryPoint deposit by a direct call, no signature
  for:
  - action
  - evidence-2
  - justification
- id: signer
  call: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  fn: verifyingSigner()(address)
  is: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  says: the signer this address trusts
  for:
  - action
  - evidence-2
- id: owner
  call: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  fn: owner()(address)
  is: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  says: the owner is the same account as the signer
  for:
  - action
  - evidence-2
  - justification
- id: signer-code
  code: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  is: empty
  says: the signer has no code at the block
  for:
  - evidence-2
- id: signer-nonce
  nonce: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  is: 7
  says: 'the signer has sent transactions: a live key'
  for:
  - notes
- id: deposit
  call: '0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c'
  fn: getDeposit()(uint256)
  is: 41082246065050971
  says: this address has 0.041 ETH deposited at the EntryPoint
  for:
  - evidence-3
- id: copy-signer
  call: '0xff313783839be6717ca9bc2e8cbda05f2aaf1386'
  fn: verifyingSigner()(address)
  is: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  says: the copy trusts the same signer
  for:
  - evidence-3
- id: copy-owner
  call: '0xff313783839be6717ca9bc2e8cbda05f2aaf1386'
  fn: owner()(address)
  is: '0xecbc06bd5e6ecebed60196e469b7559ffc584479'
  says: the copy has the same owner
  for:
  - notes
- id: copy-deposit
  call: '0xff313783839be6717ca9bc2e8cbda05f2aaf1386'
  fn: getDeposit()(uint256)
  is: 896607545217316891
  says: the copy has 0.897 ETH deposited at the EntryPoint
  for:
  - evidence-3
- id: alone
  replay: '0xb9e191e704ce2875a30a04c8dcd07629cbce355f74a6801506f62974696bdead'
  run: eip8151
  ok: true
  says: a real operation sponsored by the copy still succeeds under EIP-8151 with nobody migrating
  for:
  - notes
- id: delegated
  replay: '0xb9e191e704ce2875a30a04c8dcd07629cbce355f74a6801506f62974696bdead'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer the operation still succeeds
  for:
  - what
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

This paymaster pays for ERC-4337 operations only when they carry an ECDSA signature from one signer fixed in its code at deployment. If that signer's account takes real code, every operation it signs is refused; an EIP-7702 delegation keeps working.

## Evidence

- The [verified source](https://etherscan.io/address/0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c#code) compares the recovered address with an immutable signer set in the constructor.
- The [signer](https://etherscan.io/address/0xecbc06bd5e6ecebed60196e469b7559ffc584479) is a plain account and is also the owner, who withdraws the deposit by a direct call.
- The [copy at 0xff31…1386](https://etherscan.io/address/0xff313783839be6717ca9bc2e8cbda05f2aaf1386) trusts the same signer with a 0.897 ETH deposit; this address has 0.041 ETH.

## Reviewer notes

### Mechanism

EntryPoint v0.7 calls validatePaymasterUserOp (BasePaymaster, only from the EntryPoint), which runs _validatePaymasterUserOp: it hashes the operation with validUntil/validAfter, recovers the signature in paymasterAndData with OpenZeppelin ECDSA.recover and compares it with verifyingSigner. On mismatch it returns SIG_VALIDATION_FAILED, so the EntryPoint rejects the operation. verifyingSigner is immutable, set in the constructor; the contract is not a proxy, so only a new deployment changes it. There is no ERC-1271 or code-size branch. The owner (the same EOA as the signer at the block) withdraws the EntryPoint deposit with withdrawTo, onlyOwner, a msg.sender check that keeps working after the owner's account takes code. At the block: signer 0xecbc…4479 has no code and nonce 7; deposit 0.041 ETH here; the copy 0xff31…1386 has the same signer and owner and a 0.897 ETH deposit, and is the copy that sponsored the study's replayed transaction.

### Checks

- Header facts: this address alone, at block 26,438,999; 27 addresses run this code.
- Ruled out: ERC-1271 or a second path for a signer with code: _validatePaymasterUserOp compares only with ECDSA.recover (VerifyingPaymaster.sol line 93).
- Ruled out: a setter for the signer: verifyingSigner is immutable (line 25), assigned only in the constructor (line 32); the address is not a proxy.
- Ruled out: key state: the signer is an EOA with no code and nonce 7 at the block, and is the key the code checks (verifyingSigner()).
- Ruled out: breaks by itself: the replay of 0xb9e1…dead (a handleOps through the copy 0xff31…1386) succeeds under EIP-8151 alone; the paymaster's recovery uses OpenZeppelin ECDSA, no fixed gas amount (scanner ec_gas_const empty). No rated finding missing.
- Ruled out: replay as evidence: the replay with code at the signer reverts, but the operation's sender is a separate EIP-7702 account (0xc25f…5872) whose own validation I could not read in full, so the card does not cite that revert; evidence stays at source.
- Ruled out: value: the $6 the address holds itself (0.0028 ETH and 1 USDC) has no withdraw function and is not what the signer gates; whose it is was not established. The EntryPoint deposit belongs to the paymaster and the owner withdraws it.
- Ruled out: copies: only this address and 0xff31…1386 were read; the other 25 copies' signers and deposits were not read.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
