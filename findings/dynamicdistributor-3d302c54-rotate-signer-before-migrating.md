---
id: dynamicdistributor-3d302c54-rotate-signer-before-migrating
format: 2
title: 'DynamicDistributor: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  name: DynamicDistributor
  code: verified
  code_url: https://etherscan.io/address/0x3d302c54c8bec9163518f4a4dc479443d8d9db98#code
  copies: 5
  family: bb0527363d2d528d99ee5ed608d67867
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeMaster before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  file: src/distributors/DynamicDistributor.sol
  line: 51
  has: address signer = messageHash.recover(_signature);
  says: reveal recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  file: src/distributors/DynamicDistributor.sol
  line: 52
  has: require(signer == master, "Not signed by master!");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  file: src/distributors/DynamicDistributor.sol
  line: 31
  has: function changeMaster
  says: changeMaster changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3d302c54c8bec9163518f4a4dc479443d8d9db98'
  fn: master()(address)
  is: '0x826addd2fe68ff352319a0827c6b3c4a72473175'
  says: The signer it keeps in storage is 0x826addd2fe68ff352319a0827c6b3c4a72473175 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x826addd2fe68ff352319a0827c6b3c4a72473175'
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

DynamicDistributor accepts a call to reveal only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeMaster changes the signer.

## Evidence

- [reveal](https://etherscan.io/address/0x3d302c54c8bec9163518f4a4dc479443d8d9db98#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeMaster](https://etherscan.io/address/0x3d302c54c8bec9163518f4a4dc479443d8d9db98#code) changes the signer.
- The signer at the block is [0x826a…3175](https://etherscan.io/address/0x826addd2fe68ff352319a0827c6b3c4a72473175), an account without code.

## Reviewer notes

### Mechanism

reveal (src/distributors/DynamicDistributor.sol, line 41) recovers a signer on line 51 and tests it on line 52 against the signer it keeps in storage (master() returns 0x826addd2fe68ff352319a0827c6b3c4a72473175). Neither isValidSignature selector is in the code, so that account is never asked. changeMaster (src/distributors/DynamicDistributor.sol, line 31) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-18, recovering 0x826a…3175; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
