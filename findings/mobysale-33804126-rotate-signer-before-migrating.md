---
id: mobysale-33804126-rotate-signer-before-migrating
format: 2
title: 'MobySale: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x33804126c8c03d53b49264f6e84732591cb92489'
  name: MobySale
  code: verified
  code_url: https://etherscan.io/address/0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0#code
  proxy_of: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  copies: 2
  family: 60c0f27b5ca8aad5c18339be58eeddf6
  upgradeable: 'yes'
  admin: '0xe981f1def268952930e52d598238e53203d0baf4'
value:
  usd: 18
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  file: contracts/MobySale.sol
  line: 666
  has: address signer = _getSignerForPurchaseRequest(
  says: verifyPurchaseRequest recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  file: contracts/MobySale.sol
  line: 670
  has: return signer == verifier;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0'
  file: contracts/MobySale.sol
  line: 221
  has: function setVerifier
  says: setVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x33804126c8c03d53b49264f6e84732591cb92489'
  fn: verifier()(address)
  is: '0x60e31441549992d9f43541fcdcd2691fd9950dd6'
  says: The signer it keeps in storage is 0x60e31441549992d9f43541fcdcd2691fd9950dd6 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x60e31441549992d9f43541fcdcd2691fd9950dd6'
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

MobySale checks an ECDSA signature in verifyPurchaseRequest and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes the signer.

## Evidence

- [verifyPurchaseRequest](https://etherscan.io/address/0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0x513ab8bfb5f32094a88f9fcc6cf4956bd3bd63c0#code) changes the signer; only the owner can call it.
- The signer at the block is [0x60e3…0dd6](https://etherscan.io/address/0x60e31441549992d9f43541fcdcd2691fd9950dd6), an account without code.

## Reviewer notes

### Mechanism

verifyPurchaseRequest (contracts/MobySale.sol, line 657) recovers a signer on line 666 and tests it on line 670 against the signer it keeps in storage (verifier() returns 0x60e31441549992d9f43541fcdcd2691fd9950dd6). Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (contracts/MobySale.sol, line 221) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-02-06, recovering 0x60e3…0dd6; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
