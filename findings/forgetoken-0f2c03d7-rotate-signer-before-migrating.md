---
id: forgetoken-0f2c03d7-rotate-signer-before-migrating
format: 2
title: 'ForgeToken: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  name: ForgeToken
  code: verified
  code_url: https://etherscan.io/address/0x0f2c03d7240346c17ace551715c95210e7418d9e#code
  copies: 1
  upgradeable: 'no'
  admin: '0x86fed702bcaf26f0b41476a58d4e88242654146e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 208
impact: liveness
action: Replace the signer with setMinterAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  file: ForgeToken.sol
  line: 787
  has: _recoverSigner(message, _sig) == minterAddress,
  says: safeMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  file: ForgeToken.sol
  line: 702
  has: function setMinterAddress
  says: setMinterAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0f2c03d7240346c17ace551715c95210e7418d9e'
  fn: minterAddress()(address)
  is: '0x86fed702bcaf26f0b41476a58d4e88242654146e'
  says: The signer it keeps in storage is 0x86fed702bcaf26f0b41476a58d4e88242654146e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x86fed702bcaf26f0b41476a58d4e88242654146e'
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

ForgeToken accepts a call to safeMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMinterAddress changes the signer.

## Evidence

- [safeMint](https://etherscan.io/address/0x0f2c03d7240346c17ace551715c95210e7418d9e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMinterAddress](https://etherscan.io/address/0x0f2c03d7240346c17ace551715c95210e7418d9e#code) changes the signer; only the owner can call it.
- The signer at the block is [0x86fe…146e](https://etherscan.io/address/0x86fed702bcaf26f0b41476a58d4e88242654146e), an account without code.

## Reviewer notes

### Mechanism

safeMint (ForgeToken.sol, line 774) recovers a signer on line 787 and tests it on line 787 against the signer it keeps in storage (minterAddress() returns 0x86fed702bcaf26f0b41476a58d4e88242654146e). Neither isValidSignature selector is in the code, so that account is never asked. setMinterAddress (ForgeToken.sol, line 702) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-10-23, recovering 0x86fe…146e; 208 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
