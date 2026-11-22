---
id: entelechynfg-9c6cbbd1-rotate-signer-before-migrating
format: 2
title: 'EntelechyNfg: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  name: EntelechyNfg
  code: verified
  code_url: https://etherscan.io/address/0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095#code
  copies: 2
  family: a9fee29d0bfcb5d8c9177a925321f97d
  upgradeable: 'no'
  admin: '0xab0ead1f6c7801e155364eba4b5b64f446647833'
value:
  usd: 674
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setSignerWallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  file: contracts/MintpassValidator.sol
  line: 34
  has: address signer = ECDSA.recover(digest, signature);
  says: validateMintpass recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  file: contracts/MintpassValidator.sol
  line: 37
  has: signer == SIGNER_WALLET,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  file: contracts/EntelechyNfg.sol
  line: 308
  has: function setSignerWallet
  says: setSignerWallet changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095'
  fn: SIGNER_WALLET()(address)
  is: '0x723804db666346463554d43f7e6af1847d313221'
  says: The signer it keeps in storage is 0x723804db666346463554d43f7e6af1847d313221 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x723804db666346463554d43f7e6af1847d313221'
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

EntelechyNfg checks an ECDSA signature in validateMintpass and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerWallet changes the signer.

## Evidence

- [validateMintpass](https://etherscan.io/address/0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerWallet](https://etherscan.io/address/0x9c6cbbd1cc719b6f0117e7508049a2efd7d63095#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7238…3221](https://etherscan.io/address/0x723804db666346463554d43f7e6af1847d313221), an account without code.

## Reviewer notes

### Mechanism

validateMintpass (contracts/MintpassValidator.sol, line 28) recovers a signer on line 34 and tests it on line 37 against the signer it keeps in storage (SIGNER_WALLET() returns 0x723804db666346463554d43f7e6af1847d313221). Neither isValidSignature selector is in the code, so that account is never asked. setSignerWallet (contracts/EntelechyNfg.sol, line 308) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-28, recovering 0x7238…3221; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
