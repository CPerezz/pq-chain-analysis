---
id: adamethsettlement-37c5c6a2-rotate-signer-before-migrating
format: 2
title: 'AdamEthSettlement: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  name: AdamEthSettlement
  code: verified
  code_url: https://etherscan.io/address/0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157#code
  copies: 3
  family: e5b8cc60cb3a43b3603f55f4d1aefa76
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with changeOperator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  file: Users/usr0102794/origin-adam/contracts/contracts/AdamEthSettlement.sol
  line: 47
  has: require(ecrecover(data, v, r, s) == operator, "invalid signature");
  says: settle recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  file: Users/usr0102794/origin-adam/contracts/contracts/AdamEthSettlement.sol
  line: 90
  has: function changeOperator
  says: changeOperator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157'
  fn: operator()(address)
  is: '0x2d2c9f9512727c08bd50bf4018c189bfb9123602'
  says: The signer it keeps in storage is 0x2d2c9f9512727c08bd50bf4018c189bfb9123602 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x2d2c9f9512727c08bd50bf4018c189bfb9123602'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xc2ecdb88eb573fe019c681e9d94a7c890cc585f96c265cc9cba81088f0073c51'
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

AdamEthSettlement accepts a call to settle only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeOperator changes the signer.

## Evidence

- [settle](https://etherscan.io/address/0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeOperator](https://etherscan.io/address/0x37c5c6a227ae6d0140f2411c81e0ba9f60fb7157#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x2d2c…3602](https://etherscan.io/address/0x2d2c9f9512727c08bd50bf4018c189bfb9123602), an account without code.

## Reviewer notes

### Mechanism

settle (Users/usr0102794/origin-adam/contracts/contracts/AdamEthSettlement.sol, line 32) recovers a signer on line 47 and tests it on line 47 against the signer it keeps in storage (operator() returns 0x2d2c9f9512727c08bd50bf4018c189bfb9123602). Neither isValidSignature selector is in the code, so that account is never asked. changeOperator (Users/usr0102794/origin-adam/contracts/contracts/AdamEthSettlement.sol, line 90) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-21, recovering 0x2d2c…3602; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
