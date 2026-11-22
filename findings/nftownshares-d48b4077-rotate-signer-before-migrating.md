---
id: nftownshares-d48b4077-rotate-signer-before-migrating
format: 2
title: 'NFTownShares: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  name: NFTownShares
  code: verified
  code_url: https://etherscan.io/address/0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd3ca10b047011b17254ac7926b6ef4388dad5571'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSigningAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  file: NFTownShares.sol
  line: 1766
  has: require(ECDSA.recover(dataHash, permit.signature.v, permit.signature.r, permit.signature.s) == signingAddress,
  says: publicMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  file: NFTownShares.sol
  line: 1699
  has: function setSigningAddress
  says: setSigningAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920'
  fn: signingAddress()(address)
  is: '0xf07ec6998f33f5f0fefd5ebd9f30322ee0fdb8ef'
  says: The signer it keeps in storage is 0xf07ec6998f33f5f0fefd5ebd9f30322ee0fdb8ef at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf07ec6998f33f5f0fefd5ebd9f30322ee0fdb8ef'
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

NFTownShares accepts a call to publicMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigningAddress changes the signer.

## Evidence

- [publicMint](https://etherscan.io/address/0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigningAddress](https://etherscan.io/address/0xd48b4077d83e5d78bc1b31764e58ab50cc8f1920#code) changes the signer; only the owner can call it.
- The signer at the block is [0xf07e…b8ef](https://etherscan.io/address/0xf07ec6998f33f5f0fefd5ebd9f30322ee0fdb8ef), an account without code.

## Reviewer notes

### Mechanism

publicMint (NFTownShares.sol, line 1718) recovers a signer on line 1766 and tests it on line 1766 against the signer it keeps in storage (signingAddress() returns 0xf07ec6998f33f5f0fefd5ebd9f30322ee0fdb8ef). Neither isValidSignature selector is in the code, so that account is never asked. setSigningAddress (NFTownShares.sol, line 1699) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-08-10, recovering 0xf07e…b8ef; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
