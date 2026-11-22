---
id: mutanthounds-354634c4-rotate-signer-before-migrating
format: 2
title: 'MutantHounds: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x354634c4621cdfb7a25e6486cca1e019777d841b'
  name: MutantHounds
  code: verified
  code_url: https://etherscan.io/address/0xb35091819bfb5613d6de4285ee353c03a2ee8fe4#code
  proxy_of: '0xb35091819bfb5613d6de4285ee353c03a2ee8fe4'
  copies: 2
  family: 8bcf5ebfbe24fb67e5c44767b5763b70
  upgradeable: 'yes'
  admin: '0xa1291b8de9d3251164926f76499d3215523acae3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 519
impact: liveness
action: Replace the signer with setSoulContract before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb35091819bfb5613d6de4285ee353c03a2ee8fe4'
  file: MutantHounds.sol
  line: 3802
  has: address signer = returnVoucherSigner(tokenIds[i], receivers[i], signatures[i]);
  says: mintSoulBoundForBurnedHounds recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb35091819bfb5613d6de4285ee353c03a2ee8fe4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb35091819bfb5613d6de4285ee353c03a2ee8fe4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb35091819bfb5613d6de4285ee353c03a2ee8fe4'
  file: MutantHounds.sol
  line: 3602
  has: function setSoulContract
  says: setSoulContract changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x354634c4621cdfb7a25e6486cca1e019777d841b'
  fn: authoritySigner()(address)
  is: '0x68d90d10d2c7532ff902fd272ca4bb57dd37319b'
  says: The signer it keeps in storage is 0x68d90d10d2c7532ff902fd272ca4bb57dd37319b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x68d90d10d2c7532ff902fd272ca4bb57dd37319b'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

MutantHounds accepts a call to mintSoulBoundForBurnedHounds only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSoulContract changes the signer.

## Evidence

- [mintSoulBoundForBurnedHounds](https://etherscan.io/address/0xb35091819bfb5613d6de4285ee353c03a2ee8fe4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSoulContract](https://etherscan.io/address/0xb35091819bfb5613d6de4285ee353c03a2ee8fe4#code) changes the signer; only the owner can call it.
- The signer at the block is [0x68d9…319b](https://etherscan.io/address/0x68d90d10d2c7532ff902fd272ca4bb57dd37319b), an account without code.

## Reviewer notes

### Mechanism

mintSoulBoundForBurnedHounds (MutantHounds.sol, line 3779) recovers a signer on line 3802 and tests it on line 3802 against the signer it keeps in storage (authoritySigner() returns 0x68d90d10d2c7532ff902fd272ca4bb57dd37319b). Neither isValidSignature selector is in the code, so that account is never asked. setSoulContract (MutantHounds.sol, line 3602) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-01-30, recovering 0x68d9…319b; 519 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
