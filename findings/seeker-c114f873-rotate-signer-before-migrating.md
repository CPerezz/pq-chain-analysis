---
id: seeker-c114f873-rotate-signer-before-migrating
format: 2
title: 'Seeker: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  name: Seeker
  code: verified
  code_url: https://etherscan.io/address/0xc114f87326c0e07f40e73b6c9fcea54888c2c67f#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4a59ea67764a5e6f79f3508cd9990c77b9ff2674'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 219
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  file: src/Seeker.sol
  line: 203
  has: if (signedHash.recover(signature) != mintSigner)
  says: privateMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  file: src/Seeker.sol
  line: 345
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc114f87326c0e07f40e73b6c9fcea54888c2c67f'
  fn: mintSigner()(address)
  is: '0x0b07421b023c66ae59e6e76baf72676fe43ef7b0'
  says: The signer it keeps in storage is 0x0b07421b023c66ae59e6e76baf72676fe43ef7b0 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0b07421b023c66ae59e6e76baf72676fe43ef7b0'
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

Seeker accepts a call to privateMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [privateMint](https://etherscan.io/address/0xc114f87326c0e07f40e73b6c9fcea54888c2c67f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0xc114f87326c0e07f40e73b6c9fcea54888c2c67f#code) changes the signer; only the owner can call it.
- The signer at the block is [0x0b07…f7b0](https://etherscan.io/address/0x0b07421b023c66ae59e6e76baf72676fe43ef7b0), an account without code.

## Reviewer notes

### Mechanism

privateMint (src/Seeker.sol, line 189) recovers a signer on line 203 and tests it on line 203 against the signer it keeps in storage (mintSigner() returns 0x0b07421b023c66ae59e6e76baf72676fe43ef7b0). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (src/Seeker.sol, line 345) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-11-23, recovering 0x0b07…f7b0; 219 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
