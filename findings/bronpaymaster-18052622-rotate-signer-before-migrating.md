---
id: bronpaymaster-18052622-rotate-signer-before-migrating
format: 2
title: 'BronPaymaster: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  name: BronPaymaster
  code: verified
  code_url: https://etherscan.io/address/0x1805262288a1e931ea3fca239d206f2f3ce93c16#code
  copies: 2
  family: c6072a357d6a289d8af4b87c86a7afa3
  upgradeable: 'no'
  admin: '0xa5b7329fd4bb374672c4dda903ec4758c4be4ad7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 56
impact: liveness
action: Replace the signer with setVerifyingSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  file: project/contracts/BronPaymaster.sol
  line: 158
  has: bool sigOk = signature.length == 65 && verifyingSigner == ECDSA.recover(hash, signature);
  says: _validatePaymasterUserOp recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  file: project/contracts/BronPaymaster.sol
  line: 69
  has: function setVerifyingSigner
  says: setVerifyingSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1805262288a1e931ea3fca239d206f2f3ce93c16'
  fn: verifyingSigner()(address)
  is: '0xfa0b384d00e7d62df4c5d79cfccb51381fe72ffd'
  says: The signer it keeps in storage is 0xfa0b384d00e7d62df4c5d79cfccb51381fe72ffd at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfa0b384d00e7d62df4c5d79cfccb51381fe72ffd'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xc91df2b9ca4998a53780f6d3d1be4c663d157f6a2dcc9ef649eb7bd8fdfe6617'
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

BronPaymaster checks an ECDSA signature in _validatePaymasterUserOp and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifyingSigner changes the signer.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x1805262288a1e931ea3fca239d206f2f3ce93c16#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifyingSigner](https://etherscan.io/address/0x1805262288a1e931ea3fca239d206f2f3ce93c16#code) changes the signer (through _setVerifyingSigner); only the owner can call it.
- The signer at the block is [0xfa0b…2ffd](https://etherscan.io/address/0xfa0b384d00e7d62df4c5d79cfccb51381fe72ffd), an account without code.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (project/contracts/BronPaymaster.sol, line 142) recovers a signer on line 158 and tests it on line 158 against the signer it keeps in storage (verifyingSigner() returns 0xfa0b384d00e7d62df4c5d79cfccb51381fe72ffd). Neither isValidSignature selector is in the code, so that account is never asked. _setVerifyingSigner (project/contracts/BronPaymaster.sol, line 246) writes it, called by setVerifyingSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-21, recovering 0xfa0b…2ffd; 56 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
