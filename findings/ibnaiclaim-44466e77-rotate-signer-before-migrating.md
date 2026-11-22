---
id: ibnaiclaim-44466e77-rotate-signer-before-migrating
format: 2
title: 'IBNAIClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  name: IBNAIClaim
  code: verified
  code_url: https://etherscan.io/address/0x44466e7757fa46a630509d04f82ef8c4e1ce8761#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  file: IBNAIClaim.sol
  line: 90
  has: address recovered = _recover(digest, signature);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  file: IBNAIClaim.sol
  line: 91
  has: require(recovered == authorizedSigner, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  file: IBNAIClaim.sol
  line: 56
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x44466e7757fa46a630509d04f82ef8c4e1ce8761'
  fn: authorizedSigner()(address)
  is: '0xe455c6616a2e87100e6dd57410a64828309c965d'
  says: The signer it keeps in storage is 0xe455c6616a2e87100e6dd57410a64828309c965d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe455c6616a2e87100e6dd57410a64828309c965d'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x9ddf7d5a8fa3aa5224b954e6eac21f6e025dac6053d5fb8ef75341103d0414c4'
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

IBNAIClaim accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x44466e7757fa46a630509d04f82ef8c4e1ce8761#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x44466e7757fa46a630509d04f82ef8c4e1ce8761#code) changes the signer.
- The signer at the block is [0xe455…965d](https://etherscan.io/address/0xe455c6616a2e87100e6dd57410a64828309c965d), an account without code.

## Reviewer notes

### Mechanism

claim (IBNAIClaim.sol, line 69) recovers a signer on line 90 and tests it on line 91 against the signer it keeps in storage (authorizedSigner() returns 0xe455c6616a2e87100e6dd57410a64828309c965d). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (IBNAIClaim.sol, line 56) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-29, recovering 0xe455…965d; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
