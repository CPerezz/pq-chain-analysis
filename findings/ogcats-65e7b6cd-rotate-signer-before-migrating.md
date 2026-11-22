---
id: ogcats-65e7b6cd-rotate-signer-before-migrating
format: 2
title: 'OGCats: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  name: OGCats
  code: verified
  code_url: https://etherscan.io/address/0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67#code
  copies: 1
  upgradeable: 'no'
  admin: '0xceaec97df672fa60d5b38c3120af88716ec5d552'
value:
  usd: 866
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setCouponSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  file: OGCats.sol
  line: 2549
  has: address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
  says: buyCatWhitelist recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  file: OGCats.sol
  line: 2550
  has: 'require(signer != address(0), "ECDSA: invalid signature");'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67'
  file: OGCats.sol
  line: 2422
  has: function setCouponSignerAddress
  says: setCouponSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xda3fc1d657fbb1705ebb7ffe6e4fef4e8c4929bd'
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

OGCats accepts a call to buyCatWhitelist only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setCouponSignerAddress changes the signer.

## Evidence

- [buyCatWhitelist](https://etherscan.io/address/0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setCouponSignerAddress](https://etherscan.io/address/0x65e7b6cd46de7b0a83bbf8af745ba9eef9e66d67#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xda3f…29bd](https://etherscan.io/address/0xda3fc1d657fbb1705ebb7ffe6e4fef4e8c4929bd), an account without code.

## Reviewer notes

### Mechanism

buyCatWhitelist (OGCats.sol, line 2539) recovers a signer on line 2549 and tests it on line 2550 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setCouponSignerAddress (OGCats.sol, line 2422) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-31, recovering 0xda3f…29bd; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
