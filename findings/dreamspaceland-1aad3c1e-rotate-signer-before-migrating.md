---
id: dreamspaceland-1aad3c1e-rotate-signer-before-migrating
format: 2
title: 'DreamSpaceLand: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  name: DreamSpaceLand
  code: verified
  code_url: https://etherscan.io/address/0x1aad3c1ec95fe32aada51a2a4acb20676605b862#code
  copies: 1
  upgradeable: 'no'
  admin: '0x48b87263d7b256bdb585eda6792005f222c2197a'
value:
  usd: 361
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with transferAdminship before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  file: contracts/Admin.sol
  line: 98
  has: address recoveredAddress = ethSignedMessageHash.recover(signature);
  says: verifyAdminSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  file: contracts/Admin.sol
  line: 99
  has: return recoveredAddress == admin();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  file: contracts/Admin.sol
  line: 86
  has: function transferAdminship
  says: transferAdminship changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1aad3c1ec95fe32aada51a2a4acb20676605b862'
  fn: admin()(address)
  is: '0xfba327646272c67f3690aae39c3d267bfcd8160d'
  says: The signer it keeps in storage is 0xfba327646272c67f3690aae39c3d267bfcd8160d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfba327646272c67f3690aae39c3d267bfcd8160d'
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

DreamSpaceLand checks an ECDSA signature in verifyAdminSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferAdminship changes the signer.

## Evidence

- [verifyAdminSignature](https://etherscan.io/address/0x1aad3c1ec95fe32aada51a2a4acb20676605b862#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [transferAdminship](https://etherscan.io/address/0x1aad3c1ec95fe32aada51a2a4acb20676605b862#code) changes the signer (through _setAdmin); only the owner can call it.
- The signer at the block is [0xfba3…160d](https://etherscan.io/address/0xfba327646272c67f3690aae39c3d267bfcd8160d), an account without code.

## Reviewer notes

### Mechanism

verifyAdminSignature (contracts/Admin.sol, line 96) recovers a signer on line 98 and tests it on line 99 against the signer it keeps in storage (admin() returns 0xfba327646272c67f3690aae39c3d267bfcd8160d). Neither isValidSignature selector is in the code, so that account is never asked. _setAdmin (contracts/Admin.sol, line 90) writes it, called by transferAdminship. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-17, recovering 0xfba3…160d; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
