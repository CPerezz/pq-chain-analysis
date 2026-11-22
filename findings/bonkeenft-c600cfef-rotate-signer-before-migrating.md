---
id: bonkeenft-c600cfef-rotate-signer-before-migrating
format: 2
title: 'BonkeeNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  name: BonkeeNFT
  code: verified
  code_url: https://etherscan.io/address/0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777#code
  copies: 1
  upgradeable: 'no'
  admin: '0x31d08a68629bd2b8d00fedab78b0081783bf17a8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  file: contracts/BonkeeMintAuthorization.sol
  line: 62
  has: require(ecrecover(digest, v, r, s) == mintSigner, "Unauthorized reward");
  says: _consumeBoundPermit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  file: contracts/BonkeeNFT.sol
  line: 82
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777'
  fn: mintSigner()(address)
  is: '0x22c1964fef5414786419083f6f756ba52fe3980c'
  says: The signer it keeps in storage is 0x22c1964fef5414786419083f6f756ba52fe3980c at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x22c1964fef5414786419083f6f756ba52fe3980c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x058cb206744d756a2400df40ae4b00db105df6f102c264202efaa3834cc7f969'
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

BonkeeNFT checks an ECDSA signature in _consumeBoundPermit and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [_consumeBoundPermit](https://etherscan.io/address/0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777#code) changes the signer (through _setMintSigner); only the owner can call it.
- The signer at the block is [0x22c1…980c](https://etherscan.io/address/0x22c1964fef5414786419083f6f756ba52fe3980c), an account without code.

## Reviewer notes

### Mechanism

_consumeBoundPermit (contracts/BonkeeMintAuthorization.sol, line 52) recovers a signer on line 62 and tests it on line 62 against the signer it keeps in storage (mintSigner() returns 0x22c1964fef5414786419083f6f756ba52fe3980c). Neither isValidSignature selector is in the code, so that account is never asked. _setMintSigner (contracts/BonkeeMintAuthorization.sol, line 22) writes it, called by setMintSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-05, recovering 0x22c1…980c; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
