---
id: isworkingregistrar-fb4d352a-rotate-signer-before-migrating
format: 2
title: Discount vouchers stop working if the relayer's account moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the relayer moves its account to real code, and the admin can replace the key
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfb4d352a881877c500d714499728cb76d3939acb'
  name: IsWorkingRegistrar
  project: isworking-eth
  code: verified
  code_url: https://etherscan.io/address/0xfb4d352a881877c500d714499728cb76d3939acb#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdffbfc54c6863e6e5ba271e2f0e15fb5d1efe499'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 21
  last: 2026-11-05
impact: liveness
action: Replace the relayer with setRoles before moving the relayer's account to real code.
evidence_level: source
checks:
- id: title
  source: '0xfb4d352a881877c500d714499728cb76d3939acb'
  file: src/IsWorkingRegistrar.sol
  line: 37
  has: Sells permanent, revocable subnames of isworking.eth.
  says: the contract sells subnames of isworking.eth
  for:
  - what
- id: recover
  source: '0xfb4d352a881877c500d714499728cb76d3939acb'
  file: src/IsWorkingRegistrar.sol
  line: 309
  has: if (ECDSA.recover(hashVoucher(v), sig) != relayer) revert BadVoucher();
  says: a voucher is refused unless ECDSA recovers the stored relayer from its signature
  for:
  - evidence-1
  - justification
  - what
- id: novoucher
  source: '0xfb4d352a881877c500d714499728cb76d3939acb'
  file: src/IsWorkingRegistrar.sol
  line: 306
  has: if (v.codeHash == bytes32(0) && v.ticket == bytes32(0)) return (0, false);
  says: an empty voucher gives no discount and no signature is checked
  for:
  - what
- id: setroles
  source: '0xfb4d352a881877c500d714499728cb76d3939acb'
  file: src/IsWorkingRegistrar.sol
  lines:
  - 464
  - 468
  has: relayer = _relayer;
  says: setRoles writes a new relayer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: onlyadmin
  source: '0xfb4d352a881877c500d714499728cb76d3939acb'
  file: src/IsWorkingRegistrar.sol
  line: 464
  has: function setRoles(address _admin, address _treasury, address _relayer) external onlyAdmin {
  says: only the admin can call setRoles
  for:
  - action
  - evidence-2
  - justification
  - what
- id: admin
  call: '0xfb4d352a881877c500d714499728cb76d3939acb'
  fn: admin()(address)
  is: '0xdffbfc54c6863e6e5ba271e2f0e15fb5d1efe499'
  says: the admin that can call setRoles
  for:
  - action
  - evidence-2
  - justification
- id: admin-code
  code: '0xdffbfc54c6863e6e5ba271e2f0e15fb5d1efe499'
  is: delegation
  target: '0x612373d7003d694220f7800eeaf8e3924c0951d3'
  says: the admin is a key account with an EIP-7702 delegation, so it can still send transactions
  for:
  - action
  - justification
- id: relayer
  call: '0xfb4d352a881877c500d714499728cb76d3939acb'
  fn: relayer()(address)
  is: '0x6347dc03f42afdf284fd3c24a7d7467038aa4cf3'
  says: the stored relayer key
  for:
  - evidence-3
  - what
- id: relayer-code
  code: '0x6347dc03f42afdf284fd3c24a7d7467038aa4cf3'
  is: empty
  says: the relayer account has no code
  for:
  - evidence-3
  - justification
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

This registrar sells isworking.eth subnames and gives a discount only on a voucher signed by its relayer key. If the relayer's account moves to real code, vouchers are refused until the admin sets a new relayer. Full-price purchases need no signature.

## Evidence

- The [verified source](https://etherscan.io/address/0xfb4d352a881877c500d714499728cb76d3939acb#code) recovers each voucher's signer with ECDSA and rejects it unless it is the stored relayer.
- `setRoles` lets the [admin](https://etherscan.io/address/0xdffbfc54c6863e6e5ba271e2f0e15fb5d1efe499) replace the relayer.
- The [relayer](https://etherscan.io/address/0x6347dc03f42afdf284fd3c24a7d7467038aa4cf3) is an account without code.

## Reviewer notes

### Mechanism

registerWithETH, registerWithToken and registerSponsored all call _useVoucher (lines 302-317). With an all-zero voucher it returns no discount before any signature is read (line 306), so full-price purchases never recover. Otherwise ECDSA.recover of the EIP-712 voucher hash must equal the stored relayer (line 309), or the call reverts BadVoucher. The voucher is checked once, when it is used. registerSponsored also requires msg.sender to be the relayer (line 296). relayer is set in the constructor and written only by setRoles (lines 464-470, onlyAdmin). At the block the relayer 0x6347...4cf3 has empty code and the admin 0xdffb...e499 is an account with an EIP-7702 delegation, which can still send the setRoles call. The contract holds nothing: payments are forwarded to the treasury in the same call (line 275).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for a relayer with code: line 309 is a bare ECDSA.recover compared with relayer; the source has no isValidSignature call.
- Ruled out: a proxy or unused implementation: the dossier reads no proxy slots and no delegatecall; relayer() and admin() are set at this address.
- Ruled out: an unset or contract key: relayer() is 0x6347...4cf3 with empty code at the block.
- Ruled out: a dead setter: setRoles writes relayer (line 468) under onlyAdmin (line 168); admin() is an account with a 7702 delegation, not a contract with real code, so it can still send transactions.
- Ruled out: a path closed for good: the Devcon window is over (devconEndsAt 1793989799, block timestamp 1794969479), but coupons have no global end and the admin can call setCoupon or setDevcon again (lines 413-444).
- Ruled out: a signature rechecked after others relied on it: the voucher is recovered once, in the transaction that uses it; its holder has given nothing before that.
- Ruled out: a fixed gas amount: the recovery goes through OpenZeppelin ECDSA.recover, and the scan found no constant gas on the precompile call (ec_gas_const null).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
