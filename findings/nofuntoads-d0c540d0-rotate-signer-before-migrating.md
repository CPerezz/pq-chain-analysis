---
id: nofuntoads-d0c540d0-rotate-signer-before-migrating
format: 2
title: 'NoFunToads: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  name: NoFunToads
  code: verified
  code_url: https://etherscan.io/address/0xd0c540d08bf79a7b265ebb08b00c7fed45af1171#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7c2661b16dc816538ecd5bcbc30d518e5aa1f68f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setPublicSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  file: NoFunToads.sol
  line: 1146
  has: verifyHash(v, r, s, nonce) == publicSigner,
  says: preMintToad recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  file: NoFunToads.sol
  line: 1121
  has: function setPublicSigner
  says: setPublicSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd0c540d08bf79a7b265ebb08b00c7fed45af1171'
  fn: publicSigner()(address)
  is: '0xcacc5a38c1358270f41ae64be39448ee5727638b'
  says: The signer it keeps in storage is 0xcacc5a38c1358270f41ae64be39448ee5727638b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcacc5a38c1358270f41ae64be39448ee5727638b'
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

NoFunToads accepts a call to preMintToad only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPublicSigner changes the signer.

## Evidence

- [preMintToad](https://etherscan.io/address/0xd0c540d08bf79a7b265ebb08b00c7fed45af1171#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPublicSigner](https://etherscan.io/address/0xd0c540d08bf79a7b265ebb08b00c7fed45af1171#code) changes the signer; only the owner can call it.
- The signer at the block is [0xcacc…638b](https://etherscan.io/address/0xcacc5a38c1358270f41ae64be39448ee5727638b), an account without code.

## Reviewer notes

### Mechanism

preMintToad (NoFunToads.sol, line 1129) recovers a signer on line 1146 and tests it on line 1146 against the signer it keeps in storage (publicSigner() returns 0xcacc5a38c1358270f41ae64be39448ee5727638b). Neither isValidSignature selector is in the code, so that account is never asked. setPublicSigner (NoFunToads.sol, line 1121) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-30, recovering 0xcacc…638b; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
