---
id: satosproof-8af71829-rotate-signer-before-migrating
format: 2
title: 'SATOsProof: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8af718295088b868bfcde741b1ffba415ff76594'
  name: SATOsProof
  code: verified
  code_url: https://etherscan.io/address/0x8af718295088b868bfcde741b1ffba415ff76594#code
  copies: 1
  upgradeable: 'no'
  admin: '0x39f6e3a7a270519b1489e2420d6c1a6d530ffed6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Replace the signer with setValidator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8af718295088b868bfcde741b1ffba415ff76594'
  file: SATOsProof.sol
  line: 2402
  has: address signerOwner = signatureWallet(_to, amount, _timestamp,_signature);
  says: mintByWhitelist recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8af718295088b868bfcde741b1ffba415ff76594'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8af718295088b868bfcde741b1ffba415ff76594'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8af718295088b868bfcde741b1ffba415ff76594'
  file: SATOsProof.sol
  line: 2404
  has: require(signerOwner == _validator, "Not authorized to mint");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8af718295088b868bfcde741b1ffba415ff76594'
  file: SATOsProof.sol
  line: 2358
  has: function setValidator
  says: setValidator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x8af718295088b868bfcde741b1ffba415ff76594'
  fn: _validator()(address)
  is: '0xdf9b4a20ad19e58622cc6a2fe1425ababaec41ae'
  says: The signer it keeps in storage is 0xdf9b4a20ad19e58622cc6a2fe1425ababaec41ae at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xdf9b4a20ad19e58622cc6a2fe1425ababaec41ae'
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

SATOsProof accepts a call to mintByWhitelist only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidator changes the signer.

## Evidence

- [mintByWhitelist](https://etherscan.io/address/0x8af718295088b868bfcde741b1ffba415ff76594#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidator](https://etherscan.io/address/0x8af718295088b868bfcde741b1ffba415ff76594#code) changes the signer; only the owner can call it.
- The signer at the block is [0xdf9b…41ae](https://etherscan.io/address/0xdf9b4a20ad19e58622cc6a2fe1425ababaec41ae), an account without code.

## Reviewer notes

### Mechanism

mintByWhitelist (SATOsProof.sol, line 2394) recovers a signer on line 2402 and tests it on line 2404 against the signer it keeps in storage (_validator() returns 0xdf9b4a20ad19e58622cc6a2fe1425ababaec41ae). Neither isValidSignature selector is in the code, so that account is never asked. setValidator (SATOsProof.sol, line 2358) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-03-24, recovering 0xdf9b…41ae; 8 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
