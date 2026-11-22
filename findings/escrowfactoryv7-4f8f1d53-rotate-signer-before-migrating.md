---
id: escrowfactoryv7-4f8f1d53-rotate-signer-before-migrating
format: 2
title: 'EscrowFactoryV7: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4f8f1d53c532b51338b98fc961d46a29d1268697'
  name: EscrowFactoryV7
  code: verified
  code_url: https://etherscan.io/address/0x4f8f1d53c532b51338b98fc961d46a29d1268697#code
  copies: 1
  upgradeable: 'no'
  admin: '0x781551402fba10bb3df20a3391da5aa43d5e65d7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 385
impact: liveness
action: Before a signer's account moves to real code, use removeApprover so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x4f8f1d53c532b51338b98fc961d46a29d1268697'
  file: contracts/ApproverRegistry.sol
  line: 133
  has: address signer = _recover(digest, approvals[i]);
  says: _checkApprovals recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4f8f1d53c532b51338b98fc961d46a29d1268697'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4f8f1d53c532b51338b98fc961d46a29d1268697'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x4f8f1d53c532b51338b98fc961d46a29d1268697'
  file: contracts/FactoryGovernance.sol
  line: 130
  has: function removeApprover
  says: removeApprover changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x23a752fdb2a6d96490bd0d378b1633be29122df8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0836a79b220f663c3ebc44f473dee1a78cec2c82087ab94c7befd3fd811dee73'
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

EscrowFactoryV7 checks an ECDSA signature in _checkApprovals and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. removeApprover changes who may sign.

## Evidence

- [_checkApprovals](https://etherscan.io/address/0x4f8f1d53c532b51338b98fc961d46a29d1268697#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [removeApprover](https://etherscan.io/address/0x4f8f1d53c532b51338b98fc961d46a29d1268697#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x0836a79b220f663c3ebc44f473dee1a78cec2c82087ab94c7befd3fd811dee73) on record recovered [0x23a7…2df8](https://etherscan.io/address/0x23a752fdb2a6d96490bd0d378b1633be29122df8), an account without code.

## Reviewer notes

### Mechanism

_checkApprovals (contracts/ApproverRegistry.sol, line 114) recovers a signer on line 133 and tests it on line 133 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. removeApprover (contracts/FactoryGovernance.sol, line 130) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-21, recovering 0x23a7…2df8; 385 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
