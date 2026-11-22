---
id: herera-cf7d63a7-rotate-signer-before-migrating
format: 2
title: 'HerEra: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  name: HerEra
  code: verified
  code_url: https://etherscan.io/address/0xcf7d63a79d64531719c41d9cf3c18146ecdc4938#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8c853ca0163df0772a6c7c31eb37a85c9ba18de6'
value:
  usd: 12
  basis: held
activity:
  txs_90d: 346
impact: liveness
action: Replace the signer with setVoucherSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  file: src/HerEra.sol
  line: 286
  has: if (ECDSA.recover(voucherDigest(v), signature) != voucherSigner) revert VoucherInvalidSignature();
  says: _consumeVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  file: src/HerEra.sol
  line: 590
  has: function setVoucherSigner
  says: setVoucherSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xcf7d63a79d64531719c41d9cf3c18146ecdc4938'
  fn: voucherSigner()(address)
  is: '0x8a70fe8f0027160393e07f2b46fa9076a79431e7'
  says: The signer it keeps in storage is 0x8a70fe8f0027160393e07f2b46fa9076a79431e7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8a70fe8f0027160393e07f2b46fa9076a79431e7'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb73c912ee0eb582f3799d62240bf504ff1ea226dab8dc1199e4096c81ba0752e'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

HerEra checks an ECDSA signature in _consumeVoucher and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVoucherSigner changes the signer.

## Evidence

- [_consumeVoucher](https://etherscan.io/address/0xcf7d63a79d64531719c41d9cf3c18146ecdc4938#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVoucherSigner](https://etherscan.io/address/0xcf7d63a79d64531719c41d9cf3c18146ecdc4938#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8a70…31e7](https://etherscan.io/address/0x8a70fe8f0027160393e07f2b46fa9076a79431e7), an account without code.

## Reviewer notes

### Mechanism

_consumeVoucher (src/HerEra.sol, line 276) recovers a signer on line 286 and tests it on line 286 against the signer it keeps in storage (voucherSigner() returns 0x8a70fe8f0027160393e07f2b46fa9076a79431e7). Neither isValidSignature selector is in the code, so that account is never asked. setVoucherSigner (src/HerEra.sol, line 590) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-13, recovering 0x8a70…31e7; 346 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
