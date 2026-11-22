---
id: tokenplay-56d967f8-rotate-signer-before-migrating
format: 2
title: 'TokenPlay: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x56d967f8003648f31b9f2c1cab1109fcc8098ec5'
  name: TokenPlay
  code: verified
  code_url: https://etherscan.io/address/0xcb50855b215d6395d4813c122a8c325e20006610#code
  proxy_of: '0xcb50855b215d6395d4813c122a8c325e20006610'
  copies: 2
  family: f16a4e33e1fad717b608f37212367eba
  upgradeable: 'yes'
  admin: '0x7552ef661fc986ddf139bb0afcf07e8b196ff699'
value:
  usd: 7
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setPaymentVoucherSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcb50855b215d6395d4813c122a8c325e20006610'
  file: contracts/TokenPlay.sol
  line: 778
  has: address signer = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(structHash), sig);
  says: _consumeVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcb50855b215d6395d4813c122a8c325e20006610'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcb50855b215d6395d4813c122a8c325e20006610'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xcb50855b215d6395d4813c122a8c325e20006610'
  file: contracts/TokenPlay.sol
  line: 779
  has: if (!(signer == paymentVoucherSigner)) revert InvalidVoucherSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xcb50855b215d6395d4813c122a8c325e20006610'
  file: contracts/TokenPlay.sol
  line: 712
  has: function setPaymentVoucherSigner
  says: setPaymentVoucherSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x56d967f8003648f31b9f2c1cab1109fcc8098ec5'
  fn: paymentVoucherSigner()(address)
  is: '0x965ff6bd192c0e9c144fe9d447e767e1997de070'
  says: The signer it keeps in storage is 0x965ff6bd192c0e9c144fe9d447e767e1997de070 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x965ff6bd192c0e9c144fe9d447e767e1997de070'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
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

TokenPlay checks an ECDSA signature in _consumeVoucher and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPaymentVoucherSigner changes the signer.

## Evidence

- [_consumeVoucher](https://etherscan.io/address/0xcb50855b215d6395d4813c122a8c325e20006610#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPaymentVoucherSigner](https://etherscan.io/address/0xcb50855b215d6395d4813c122a8c325e20006610#code) changes the signer; only the owner can call it.
- The signer at the block is [0x965f…e070](https://etherscan.io/address/0x965ff6bd192c0e9c144fe9d447e767e1997de070), an account without code.

## Reviewer notes

### Mechanism

_consumeVoucher (contracts/TokenPlay.sol, line 757) recovers a signer on line 778 and tests it on line 779 against the signer it keeps in storage (paymentVoucherSigner() returns 0x965ff6bd192c0e9c144fe9d447e767e1997de070). Neither isValidSignature selector is in the code, so that account is never asked. setPaymentVoucherSigner (contracts/TokenPlay.sol, line 712) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
