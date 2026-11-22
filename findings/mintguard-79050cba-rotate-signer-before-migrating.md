---
id: mintguard-79050cba-rotate-signer-before-migrating
format: 2
title: 'MintGuard: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x79050cba7f04962dc8b28a163716a62769d3c0d7'
  name: MintGuard
  code: verified
  code_url: https://etherscan.io/address/0xfc87de14205024b1a5b90f83cd275edd7a97745b#code
  proxy_of: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  copies: 2
  family: 06fbd9a63e0e96e0d4c7cd7eba176287
  upgradeable: 'yes'
  admin: '0xa11e1b6dea5f888b978eae87bd0b731f8ca32551'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setVoucherSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  file: src/MintGuard.sol
  line: 145
  has: address recovered = ECDSA.recover(digest, voucher.v, voucher.r, voucher.s);
  says: verifyVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  file: src/MintGuard.sol
  line: 146
  has: require(recovered == signer, InvalidSignature());
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xfc87de14205024b1a5b90f83cd275edd7a97745b'
  file: src/MintGuard.sol
  line: 155
  has: function setVoucherSigner
  says: setVoucherSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x79050cba7f04962dc8b28a163716a62769d3c0d7'
  fn: voucherSigner()(address)
  is: '0x80d9ca5c1554ecb1cb9cc07f8942b6a0417cc8a7'
  says: The signer it keeps in storage is 0x80d9ca5c1554ecb1cb9cc07f8942b6a0417cc8a7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x80d9ca5c1554ecb1cb9cc07f8942b6a0417cc8a7'
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

MintGuard checks an ECDSA signature in verifyVoucher and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVoucherSigner changes the signer.

## Evidence

- [verifyVoucher](https://etherscan.io/address/0xfc87de14205024b1a5b90f83cd275edd7a97745b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVoucherSigner](https://etherscan.io/address/0xfc87de14205024b1a5b90f83cd275edd7a97745b#code) changes the signer; only the owner can call it.
- The signer at the block is [0x80d9…c8a7](https://etherscan.io/address/0x80d9ca5c1554ecb1cb9cc07f8942b6a0417cc8a7), an account without code.

## Reviewer notes

### Mechanism

verifyVoucher (src/MintGuard.sol, line 136) recovers a signer on line 145 and tests it on line 146 against the signer it keeps in storage (voucherSigner() returns 0x80d9ca5c1554ecb1cb9cc07f8942b6a0417cc8a7). Neither isValidSignature selector is in the code, so that account is never asked. setVoucherSigner (src/MintGuard.sol, line 155) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-01, recovering 0x80d9…c8a7; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
