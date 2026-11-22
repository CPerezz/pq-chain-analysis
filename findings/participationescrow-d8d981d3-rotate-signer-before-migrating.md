---
id: participationescrow-d8d981d3-rotate-signer-before-migrating
format: 2
title: 'ParticipationEscrow: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  name: ParticipationEscrow
  code: verified
  code_url: https://etherscan.io/address/0xd8d981d32b12ea85b739bb667946975d25b0ab53#code
  copies: 3
  family: 4908f19891cc9fa1370a644fbf3e14d6
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setAuthorizationSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  file: src/ParticipationEscrow.sol
  line: 152
  has: _recoverSigner(
  says: depositWithAuthorization recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  file: src/ParticipationEscrow.sol
  line: 154
  has: ) != authorizationSigner
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  file: src/ParticipationEscrow.sol
  line: 107
  has: function setAuthorizationSigner
  says: setAuthorizationSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd8d981d32b12ea85b739bb667946975d25b0ab53'
  fn: authorizationSigner()(address)
  is: '0xc6123de03a4d656c5248aeb0cfc253c46e39a2fe'
  says: The signer it keeps in storage is 0xc6123de03a4d656c5248aeb0cfc253c46e39a2fe at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc6123de03a4d656c5248aeb0cfc253c46e39a2fe'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x1c53dbb572dbd06a5944177cd10ca3bdd30dd8b399e7c416d30ab87c839324be'
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

ParticipationEscrow accepts a call to depositWithAuthorization only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizationSigner changes the signer.

## Evidence

- [depositWithAuthorization](https://etherscan.io/address/0xd8d981d32b12ea85b739bb667946975d25b0ab53#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizationSigner](https://etherscan.io/address/0xd8d981d32b12ea85b739bb667946975d25b0ab53#code) changes the signer.
- The signer at the block is [0xc612…a2fe](https://etherscan.io/address/0xc6123de03a4d656c5248aeb0cfc253c46e39a2fe), an account without code.

## Reviewer notes

### Mechanism

depositWithAuthorization (src/ParticipationEscrow.sol, line 135) recovers a signer on line 152 and tests it on line 154 against the signer it keeps in storage (authorizationSigner() returns 0xc6123de03a4d656c5248aeb0cfc253c46e39a2fe). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizationSigner (src/ParticipationEscrow.sol, line 107) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-04, recovering 0xc612…a2fe; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
