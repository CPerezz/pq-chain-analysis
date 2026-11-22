---
id: artai-d55e9a09-rotate-signer-before-migrating
format: 2
title: 'ArtAI: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  name: ArtAI
  code: verified
  code_url: https://etherscan.io/address/0xd55e9a096400036d5965cd4bc6fb580555957647#code
  copies: 1
  upgradeable: 'no'
  admin: '0x147b6b69903023f1ba1eaa48f45c6a75f2e6e0d8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 39
impact: liveness
action: Replace the signer with setMessageSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  file: ArtAI.sol
  line: 1463
  has: address signer = ECDSA.recover(_message, _signedMessage);
  says: _verifyRewardProof recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  file: ArtAI.sol
  line: 1465
  has: if (signer != _messageSigner) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd55e9a096400036d5965cd4bc6fb580555957647'
  file: ArtAI.sol
  line: 1388
  has: function setMessageSigner
  says: setMessageSigner changes the signer
  for:
  - action
  - evidence-2
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

ArtAI checks an ECDSA signature in _verifyRewardProof and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMessageSigner changes the signer.

## Evidence

- [_verifyRewardProof](https://etherscan.io/address/0xd55e9a096400036d5965cd4bc6fb580555957647#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMessageSigner](https://etherscan.io/address/0xd55e9a096400036d5965cd4bc6fb580555957647#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

_verifyRewardProof (ArtAI.sol, line 1451) recovers a signer on line 1463 and tests it on line 1465 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setMessageSigner (ArtAI.sol, line 1388) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-19; 39 transactions called the address in the 90 days before the block. 12 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
