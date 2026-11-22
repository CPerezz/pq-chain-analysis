---
id: tribulcollection-03d2bc27-rotate-signer-before-migrating
format: 2
title: 'TribulCollection: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x03d2bc2709b0136f61a2889bf2c4fe6582311ea4'
  name: TribulCollection
  code: verified
  code_url: https://etherscan.io/address/0x2cab92ba0551e7beae58c3c1903be144c0c1dce3#code
  proxy_of: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  copies: 11
  family: ee3cad000a21f7f21df3cc0779b1d49d
  upgradeable: 'no'
  admin: '0xf11b6cde1c1ed1ec12db380e4f58b0dc3c1afc68'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  file: contracts/TribulCollection.sol
  line: 96
  has: address signer = ECDSA.recover(hash, _sig.v, _sig.r, _sig.s);
  says: creatorMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  file: contracts/TribulCollection.sol
  line: 98
  has: if (signer != signerAccount) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2cab92ba0551e7beae58c3c1903be144c0c1dce3'
  file: contracts/TribulCollection.sol
  line: 147
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x03d2bc2709b0136f61a2889bf2c4fe6582311ea4'
  fn: signerAccount()(address)
  is: '0x5013a9a2e6b0fc3f6a934c0274063b34712f9e7c'
  says: The signer it keeps in storage is 0x5013a9a2e6b0fc3f6a934c0274063b34712f9e7c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5013a9a2e6b0fc3f6a934c0274063b34712f9e7c'
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

TribulCollection accepts a call to creatorMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [creatorMint](https://etherscan.io/address/0x2cab92ba0551e7beae58c3c1903be144c0c1dce3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x2cab92ba0551e7beae58c3c1903be144c0c1dce3#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x5013…9e7c](https://etherscan.io/address/0x5013a9a2e6b0fc3f6a934c0274063b34712f9e7c), an account without code.

## Reviewer notes

### Mechanism

creatorMint (contracts/TribulCollection.sol, line 86) recovers a signer on line 96 and tests it on line 98 against the signer it keeps in storage (signerAccount() returns 0x5013a9a2e6b0fc3f6a934c0274063b34712f9e7c). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/TribulCollection.sol, line 147) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 11 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-11-10, recovering 0x5013…9e7c; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
