---
id: opfeerouter-0cd5a167-rotate-signer-before-migrating
format: 2
title: 'OPFeeRouter: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  name: OPFeeRouter
  code: verified
  code_url: https://etherscan.io/address/0x0cd5a167655d7a1961f6a181f4c07a010a0147b5#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd63e6d795b221c7bfc82a885f1481b1c830da1a4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 29
impact: liveness
action: Replace the signer with setFeeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  file: contracts/OPFeeRouter.sol
  line: 179
  has: if (ECDSA.recover(_hashTypedDataV4(_quoteHash(quote)), request.signature) != feeSigner) {
  says: _route recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  file: contracts/OPFeeRouter.sol
  line: 138
  has: function setFeeSigner
  says: setFeeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0cd5a167655d7a1961f6a181f4c07a010a0147b5'
  fn: feeSigner()(address)
  is: '0xb2b1e671b0df2ef41da44969b467f68f270b5640'
  says: The signer it keeps in storage is 0xb2b1e671b0df2ef41da44969b467f68f270b5640 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb2b1e671b0df2ef41da44969b467f68f270b5640'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x3b3419de4496931cfcf550915397d9dcdfe44a32d374f83e598569e406647952'
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

OPFeeRouter checks an ECDSA signature in _route and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setFeeSigner changes the signer.

## Evidence

- [_route](https://etherscan.io/address/0x0cd5a167655d7a1961f6a181f4c07a010a0147b5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setFeeSigner](https://etherscan.io/address/0x0cd5a167655d7a1961f6a181f4c07a010a0147b5#code) changes the signer; only the owner can call it.
- The signer at the block is [0xb2b1…5640](https://etherscan.io/address/0xb2b1e671b0df2ef41da44969b467f68f270b5640), an account without code.

## Reviewer notes

### Mechanism

_route (contracts/OPFeeRouter.sol, line 163) recovers a signer on line 179 and tests it on line 179 against the signer it keeps in storage (feeSigner() returns 0xb2b1e671b0df2ef41da44969b467f68f270b5640). Neither isValidSignature selector is in the code, so that account is never asked. setFeeSigner (contracts/OPFeeRouter.sol, line 138) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-26, recovering 0xb2b1…5640; 29 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
