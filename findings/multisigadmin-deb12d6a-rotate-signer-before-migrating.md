---
id: multisigadmin-deb12d6a-rotate-signer-before-migrating
format: 2
title: 'MultisigAdmin: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  name: MultisigAdmin
  code: verified
  code_url: https://etherscan.io/address/0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  file: project/contracts/multisigs/baseUpgradeable/MultisigWithValidator.sol
  line: 42
  has: address validator = ECDSA.recover(dataHash, signature);
  says: _checkValidator recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  file: project/contracts/multisigs/baseUpgradeable/MultisigWithValidator.sol
  line: 43
  has: if (hasRole(VALIDATOR_ROLE, validator) == false) revert NotValidator(validator);
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x98006963465697b84d4a9de500841a3c09a28d22'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x516224af1dd0369fdcf22ec05abbe2e8cdaab87497867597cce872be52772004'
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

MultisigAdmin checks an ECDSA signature in _checkValidator and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_checkValidator](https://etherscan.io/address/0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xdeb12d6ac51575cb15dce5a6e00cecedd2e43a58#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x516224af1dd0369fdcf22ec05abbe2e8cdaab87497867597cce872be52772004) on record recovered [0x9800…8d22](https://etherscan.io/address/0x98006963465697b84d4a9de500841a3c09a28d22), an account without code.

## Reviewer notes

### Mechanism

_checkValidator (project/contracts/multisigs/baseUpgradeable/MultisigWithValidator.sol, line 41) recovers a signer on line 42 and tests it on line 43 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-06, recovering 0x9800…8d22; 2 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
