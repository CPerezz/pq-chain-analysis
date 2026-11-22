---
id: fantazya-af95e486-rotate-signer-before-migrating
format: 2
title: 'Fantazya: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  name: Fantazya
  code: verified
  code_url: https://etherscan.io/address/0xaf95e486d156476f9816df9a7356dc96257a5282#code
  copies: 1
  upgradeable: 'no'
  admin: '0x88b01c2bb126de410b4b102f78214153b22e3cd0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 17
impact: liveness
action: Replace the signer with setPubkey before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  file: contracts/Fantazya.sol
  line: 115
  has: return abi.encode(_user,MAX_SUPPLY).toEthSignedMessageHash().recover(_signature) == PUB_KEY;
  says: isWhitelisted recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  file: contracts/Fantazya.sol
  line: 148
  has: function setPubkey
  says: setPubkey changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xaf95e486d156476f9816df9a7356dc96257a5282'
  fn: PUB_KEY()(address)
  is: '0x17ae8246568ce2d2005faf85e055d158a7e65f80'
  says: The signer it keeps in storage is 0x17ae8246568ce2d2005faf85e055d158a7e65f80 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x17ae8246568ce2d2005faf85e055d158a7e65f80'
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

Fantazya checks an ECDSA signature in isWhitelisted and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPubkey changes the signer.

## Evidence

- [isWhitelisted](https://etherscan.io/address/0xaf95e486d156476f9816df9a7356dc96257a5282#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPubkey](https://etherscan.io/address/0xaf95e486d156476f9816df9a7356dc96257a5282#code) changes the signer.
- The signer at the block is [0x17ae…5f80](https://etherscan.io/address/0x17ae8246568ce2d2005faf85e055d158a7e65f80), an account without code.

## Reviewer notes

### Mechanism

isWhitelisted (contracts/Fantazya.sol, line 114) recovers a signer on line 115 and tests it on line 115 against the signer it keeps in storage (PUB_KEY() returns 0x17ae8246568ce2d2005faf85e055d158a7e65f80). Neither isValidSignature selector is in the code, so that account is never asked. setPubkey (contracts/Fantazya.sol, line 148) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-04, recovering 0x17ae…5f80; 17 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
