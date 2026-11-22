---
id: rebelsbyrichie-f58580e0-rotate-signer-before-migrating
format: 2
title: 'RebelsByRichie: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  name: RebelsByRichie
  code: verified
  code_url: https://etherscan.io/address/0xf58580e099826ed2042a6c709b03aa1b43059b62#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdfdf3eab2a4abf3bf09bfe3ece18fc43759c9858'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 131
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  file: project/contracts/RebelsByRichie.sol
  line: 68
  has: address recovered = ECDSA.recover(ethSignedHash, signature);
  says: whitelistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  file: project/contracts/RebelsByRichie.sol
  line: 69
  has: if (recovered != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  file: project/contracts/RebelsByRichie.sol
  line: 165
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf58580e099826ed2042a6c709b03aa1b43059b62'
  fn: signer()(address)
  is: '0xaac43a8cbcbb687008247b4decf47bcefe15123f'
  says: The signer it keeps in storage is 0xaac43a8cbcbb687008247b4decf47bcefe15123f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xaac43a8cbcbb687008247b4decf47bcefe15123f'
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

RebelsByRichie accepts a call to whitelistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [whitelistMint](https://etherscan.io/address/0xf58580e099826ed2042a6c709b03aa1b43059b62#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xf58580e099826ed2042a6c709b03aa1b43059b62#code) changes the signer; only the owner can call it.
- The signer at the block is [0xaac4…123f](https://etherscan.io/address/0xaac43a8cbcbb687008247b4decf47bcefe15123f), an account without code.

## Reviewer notes

### Mechanism

whitelistMint (project/contracts/RebelsByRichie.sol, line 54) recovers a signer on line 68 and tests it on line 69 against the signer it keeps in storage (signer() returns 0xaac43a8cbcbb687008247b4decf47bcefe15123f). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (project/contracts/RebelsByRichie.sol, line 165) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-01, recovering 0xaac4…123f; 131 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
