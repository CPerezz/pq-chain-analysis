---
id: vftokenburntomint-52f516a9-rotate-signer-before-migrating
format: 2
title: 'VFTokenBurnToMint: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  name: VFTokenBurnToMint
  code: verified
  code_url: https://etherscan.io/address/0x52f516a94d0eb5fd8fa628484e864c80bed497e4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 51
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  file: contracts/examples/VFTokenBurnToMintV1.sol
  line: 213
  has: address signer = txHash.toEthSignedMessageHash().recover(signature);
  says: _isValidMintSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  file: contracts/examples/VFTokenBurnToMintV1.sol
  line: 214
  has: return signer == _mintSigner;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x52f516a94d0eb5fd8fa628484e864c80bed497e4'
  file: contracts/examples/VFTokenBurnToMintV1.sol
  line: 70
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x91e29c8cfdc161217d75286188507f07a576629b'
  is: delegation
  target: '0xd6cedde84be40893d153be9d467cd6ad37875b28'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
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

VFTokenBurnToMint checks an ECDSA signature in _isValidMintSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [_isValidMintSignature](https://etherscan.io/address/0x52f516a94d0eb5fd8fa628484e864c80bed497e4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0x52f516a94d0eb5fd8fa628484e864c80bed497e4#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x91e2…629b](https://etherscan.io/address/0x91e29c8cfdc161217d75286188507f07a576629b), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_isValidMintSignature (contracts/examples/VFTokenBurnToMintV1.sol, line 209) recovers a signer on line 213 and tests it on line 214 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (contracts/examples/VFTokenBurnToMintV1.sol, line 70) writes it. The signer's account holds an EIP-7702 delegation to 0xd6cedde84be40893d153be9d467cd6ad37875b28. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-05-17, recovering 0x91e2…629b; 51 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
