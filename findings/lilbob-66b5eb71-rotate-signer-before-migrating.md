---
id: lilbob-66b5eb71-rotate-signer-before-migrating
format: 2
title: 'LilBOB: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  name: LilBOB
  code: verified
  code_url: https://etherscan.io/address/0x66b5eb7152861168d7176b5235ee41c9c9aa4a05#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe622b9fcde561bb35f5796ce1c06de80f8e28d29'
value:
  usd: 6316
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAdminSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  file: NFT.sol
  line: 1715
  has: address recoveredSigner = ecrecover(addressDigest, coupon.v, coupon.r, coupon.s);
  says: _checkCoupon recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  file: NFT.sol
  line: 1717
  has: recoveredSigner != address(0), 'Invalid ECDSA signature'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x66b5eb7152861168d7176b5235ee41c9c9aa4a05'
  file: NFT.sol
  line: 1511
  has: function setAdminSigner
  says: setAdminSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x07dc7520db1869b250267c73ad7412f2613d34a8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

LilBOB checks an ECDSA signature in _checkCoupon and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAdminSigner changes the signer.

## Evidence

- [_checkCoupon](https://etherscan.io/address/0x66b5eb7152861168d7176b5235ee41c9c9aa4a05#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAdminSigner](https://etherscan.io/address/0x66b5eb7152861168d7176b5235ee41c9c9aa4a05#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x07dc…34a8](https://etherscan.io/address/0x07dc7520db1869b250267c73ad7412f2613d34a8), an account without code.

## Reviewer notes

### Mechanism

_checkCoupon (NFT.sol, line 1714) recovers a signer on line 1715 and tests it on line 1717 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setAdminSigner (NFT.sol, line 1511) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-04-07, recovering 0x07dc…34a8; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
