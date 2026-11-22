---
id: gmpayoutdemo-11d69527-rotate-signer-before-migrating
format: 2
title: 'GmPayoutDemo: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x11d69527dc7216dc2138bb8df52a59d3a08ce004'
  name: GmPayoutDemo
  code: verified
  code_url: https://etherscan.io/address/0xd306368f9a5fb878f0869038811a16361a17d32a#code
  proxy_of: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  copies: 2
  family: dd00381f86fa8e87b1678301a3097450
  upgradeable: 'yes'
  admin: '0xb051239939dae11a6f1ff83fe7505b7cd5ba8d37'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with rotateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  file: contracts/newContractSafeDemo.sol
  line: 323
  has: address recovered = ECDSA.recover(ethHash, signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  file: contracts/newContractSafeDemo.sol
  line: 324
  has: 'require(recovered == signer, "GmPayout: invalid signature");'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd306368f9a5fb878f0869038811a16361a17d32a'
  file: contracts/newContractSafeDemo.sol
  line: 155
  has: function rotateSigner
  says: rotateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x11d69527dc7216dc2138bb8df52a59d3a08ce004'
  fn: getSigner()(address)
  is: '0x35eec2e26e91267b1de7c0bc7bdb2134f451888a'
  says: The signer it keeps in storage is 0x35eec2e26e91267b1de7c0bc7bdb2134f451888a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x35eec2e26e91267b1de7c0bc7bdb2134f451888a'
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

GmPayoutDemo checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. rotateSigner changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xd306368f9a5fb878f0869038811a16361a17d32a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [rotateSigner](https://etherscan.io/address/0xd306368f9a5fb878f0869038811a16361a17d32a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x35ee…888a](https://etherscan.io/address/0x35eec2e26e91267b1de7c0bc7bdb2134f451888a), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (contracts/newContractSafeDemo.sol, line 320) recovers a signer on line 323 and tests it on line 324 against the signer it keeps in storage (getSigner() returns 0x35eec2e26e91267b1de7c0bc7bdb2134f451888a). Neither isValidSignature selector is in the code, so that account is never asked. rotateSigner (contracts/newContractSafeDemo.sol, line 155) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-10-26, recovering 0xc98b…758c; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
