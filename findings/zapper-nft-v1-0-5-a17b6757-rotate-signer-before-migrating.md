---
id: zapper-nft-v1-0-5-a17b6757-rotate-signer-before-migrating
format: 2
title: 'Zapper_NFT_V1_0_5: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  name: Zapper_NFT_V1_0_5
  code: verified
  code_url: https://etherscan.io/address/0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf#code
  copies: 7
  family: 41ab5f89b308046619c667f224bb4870
  upgradeable: 'no'
  admin: '0xa0863436913b1b439ccaa6fbf89408116c1dde29'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  file: contracts/NFT/SignatureVerifier/SignatureVerifier.sol
  line: 42
  has: return recoverSigner(ethSignedMessageHash, signature) == _signer;
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  file: contracts/NFT/Zapper_NFT_V1.sol
  line: 180
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf'
  fn: _signer()(address)
  is: '0x31d65d5d908b0c3ec294bc4a0df6260129eb609c'
  says: The signer it keeps in storage is 0x31d65d5d908b0c3ec294bc4a0df6260129eb609c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x31d65d5d908b0c3ec294bc4a0df6260129eb609c'
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

Zapper_NFT_V1_0_5 checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0xa17b6757fb153c1a05a226e3ca8c65e4af83f5cf#code) changes the signer; only the owner can call it.
- The signer at the block is [0x31d6…609c](https://etherscan.io/address/0x31d65d5d908b0c3ec294bc4a0df6260129eb609c), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/NFT/SignatureVerifier/SignatureVerifier.sol, line 34) recovers a signer on line 42 and tests it on line 42 against the signer it keeps in storage (_signer() returns 0x31d65d5d908b0c3ec294bc4a0df6260129eb609c). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/NFT/Zapper_NFT_V1.sol, line 180) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 7 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
