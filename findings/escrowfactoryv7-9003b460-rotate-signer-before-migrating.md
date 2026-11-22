---
id: escrowfactoryv7-9003b460-rotate-signer-before-migrating
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
  address: '0x9003b460c25b26c6b54cec0cc741c2a6a206e98a'
  name: EscrowFactoryV7
  code: verified
  code_url: https://etherscan.io/address/0x9003b460c25b26c6b54cec0cc741c2a6a206e98a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xed46defe2f54e43dec0174adeae7181b35b3b422'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Before a signer's account moves to real code, use removeApprover so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x9003b460c25b26c6b54cec0cc741c2a6a206e98a'
  file: contracts/ApproverRegistry.sol
  line: 134
  has: address signer = _recover(digest, approvals[i]);
  says: _checkApprovals recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9003b460c25b26c6b54cec0cc741c2a6a206e98a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9003b460c25b26c6b54cec0cc741c2a6a206e98a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x9003b460c25b26c6b54cec0cc741c2a6a206e98a'
  file: contracts/FactoryGovernance.sol
  line: 226
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
  tx: '0x2d1ed16802cbed195d7185020cb863c0e2ff234e33df42d8e392ff681602af24'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

EscrowFactoryV7 checks an ECDSA signature in _checkApprovals and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. removeApprover changes who may sign.

## Evidence

- [_checkApprovals](https://etherscan.io/address/0x9003b460c25b26c6b54cec0cc741c2a6a206e98a#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [removeApprover](https://etherscan.io/address/0x9003b460c25b26c6b54cec0cc741c2a6a206e98a#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x2d1ed16802cbed195d7185020cb863c0e2ff234e33df42d8e392ff681602af24) on record recovered [0x23a7…2df8](https://etherscan.io/address/0x23a752fdb2a6d96490bd0d378b1633be29122df8), an account without code.

## Reviewer notes

### Mechanism

_checkApprovals (contracts/ApproverRegistry.sol, line 115) recovers a signer on line 134 and tests it on line 134 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. removeApprover (contracts/FactoryGovernance.sol, line 226) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-04, recovering 0x23a7…2df8; 4 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
