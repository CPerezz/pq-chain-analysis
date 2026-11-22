---
id: bullionenumerablenft-62bee1bc-rotate-signer-before-migrating
format: 2
title: 'BullionEnumerableNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x62bee1bc8cf74fbbbd1f8444a39ca1db4acc368c'
  name: BullionEnumerableNFT
  code: verified
  code_url: https://etherscan.io/address/0xe9e9431b1135a06850997288bd0323047cc0da51#code
  proxy_of: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  copies: 3
  family: 3e1513020c35faa70065d8627c722138
  upgradeable: 'yes'
  admin: '0x0777d389bcf05bf197f0411d0957663b720e92c1'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setPackSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  file: contracts/BullionNFTEnum.sol
  line: 262
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: packWithSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  file: contracts/BullionNFTEnum.sol
  line: 263
  has: if (signer != packSigner) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe9e9431b1135a06850997288bd0323047cc0da51'
  file: contracts/BullionNFTEnum.sol
  line: 132
  has: function setPackSigner
  says: setPackSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x62bee1bc8cf74fbbbd1f8444a39ca1db4acc368c'
  fn: packSigner()(address)
  is: '0x47d049161d9b5dc2aaa18265bd9f6959da9c980e'
  says: The signer it keeps in storage is 0x47d049161d9b5dc2aaa18265bd9f6959da9c980e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x47d049161d9b5dc2aaa18265bd9f6959da9c980e'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0ece552d7c5a27c4a9a00112b33910f4898c3103b0980cd16ab5954e158211dc'
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

BullionEnumerableNFT accepts a call to packWithSig only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPackSigner changes the signer.

## Evidence

- [packWithSig](https://etherscan.io/address/0xe9e9431b1135a06850997288bd0323047cc0da51#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPackSigner](https://etherscan.io/address/0xe9e9431b1135a06850997288bd0323047cc0da51#code) changes the signer.
- The signer at the block is [0x47d0…980e](https://etherscan.io/address/0x47d049161d9b5dc2aaa18265bd9f6959da9c980e), an account without code.

## Reviewer notes

### Mechanism

packWithSig (contracts/BullionNFTEnum.sol, line 247) recovers a signer on line 262 and tests it on line 263 against the signer it keeps in storage (packSigner() returns 0x47d049161d9b5dc2aaa18265bd9f6959da9c980e). Neither isValidSignature selector is in the code, so that account is never asked. setPackSigner (contracts/BullionNFTEnum.sol, line 132) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-24, recovering 0x47d0…980e; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
