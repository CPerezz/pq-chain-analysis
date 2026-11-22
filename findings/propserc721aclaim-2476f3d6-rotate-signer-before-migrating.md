---
id: propserc721aclaim-2476f3d6-rotate-signer-before-migrating
format: 2
title: 'PropsERC721AClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2476f3d6732e045ddf0d8f77b8d78142da71dceb'
  name: PropsERC721AClaim
  code: verified
  code_url: https://etherscan.io/address/0x7e2439dd181f708fb3cab1ab8cbeb4369322a988#code
  proxy_of: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  copies: 13
  family: 80151d35f0cb2ea9b728e33900d0d427
  admin: '0xab60a6c17060392d4e85f291383cdfbea9b1f341'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignatureVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  file: contracts/adhoc/PropsERC721AClaim/PropsERC721AClaim.sol
  line: 516
  has: address recoveredAddress = ECDSAUpgradeable.recover(
  says: revertOnInvalidAddressSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  file: contracts/adhoc/PropsERC721AClaim/PropsERC721AClaim.sol
  line: 525
  has: if (recoveredAddress != signatureVerifier) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7e2439dd181f708fb3cab1ab8cbeb4369322a988'
  file: contracts/adhoc/PropsERC721AClaim/PropsERC721AClaim.sol
  line: 550
  has: function setSignatureVerifier
  says: setSignatureVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2476f3d6732e045ddf0d8f77b8d78142da71dceb'
  fn: signatureVerifier()(address)
  is: '0x2732499d11e66d3858bda27852e057a13a4c8179'
  says: The signer it keeps in storage is 0x2732499d11e66d3858bda27852e057a13a4c8179 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x2732499d11e66d3858bda27852e057a13a4c8179'
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

PropsERC721AClaim checks an ECDSA signature in revertOnInvalidAddressSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignatureVerifier changes the signer.

## Evidence

- [revertOnInvalidAddressSignature](https://etherscan.io/address/0x7e2439dd181f708fb3cab1ab8cbeb4369322a988#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignatureVerifier](https://etherscan.io/address/0x7e2439dd181f708fb3cab1ab8cbeb4369322a988#code) changes the signer.
- The signer at the block is [0x2732…8179](https://etherscan.io/address/0x2732499d11e66d3858bda27852e057a13a4c8179), an account without code.

## Reviewer notes

### Mechanism

revertOnInvalidAddressSignature (contracts/adhoc/PropsERC721AClaim/PropsERC721AClaim.sol, line 512) recovers a signer on line 516 and tests it on line 525 against the signer it keeps in storage (signatureVerifier() returns 0x2732499d11e66d3858bda27852e057a13a4c8179). Neither isValidSignature selector is in the code, so that account is never asked. setSignatureVerifier (contracts/adhoc/PropsERC721AClaim/PropsERC721AClaim.sol, line 550) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 13 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-11-17, recovering 0x2732…8179; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
