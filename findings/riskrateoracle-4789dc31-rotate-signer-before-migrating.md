---
id: riskrateoracle-4789dc31-rotate-signer-before-migrating
format: 2
title: 'RiskRateOracle: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4789dc31aa8d22298275292f95b57dd8526c7955'
  name: RiskRateOracle
  code: verified
  code_url: https://etherscan.io/address/0x4789dc31aa8d22298275292f95b57dd8526c7955#code
  copies: 5
  family: 3d372378bc5a8f8a0c77170c697f3cf0
  upgradeable: 'no'
  admin: '0x3ad86338cd0c36b3064f6250eaf21d91fcbdc45c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2479
impact: liveness
action: Before a signer's account moves to real code, use activateSignerChange so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x4789dc31aa8d22298275292f95b57dd8526c7955'
  file: contracts/oracles/BaseTimelockedOracle.sol
  line: 369
  has: address recovered = ECDSA.recover(digest, signatures[i]);
  says: _verifySignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4789dc31aa8d22298275292f95b57dd8526c7955'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4789dc31aa8d22298275292f95b57dd8526c7955'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x4789dc31aa8d22298275292f95b57dd8526c7955'
  file: contracts/oracles/BaseTimelockedOracle.sol
  line: 685
  has: function activateSignerChange
  says: activateSignerChange changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x75e6754903125d606a544ee30b010b60f5a0da35'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x153099ef37584e2efc4c610389b86a0e9addbb8309a14e2e241e98475c7559f9'
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

RiskRateOracle checks an ECDSA signature in _verifySignatures and accepts only an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. activateSignerChange changes who may sign.

## Evidence

- [_verifySignatures](https://etherscan.io/address/0x4789dc31aa8d22298275292f95b57dd8526c7955#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [activateSignerChange](https://etherscan.io/address/0x4789dc31aa8d22298275292f95b57dd8526c7955#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x153099ef37584e2efc4c610389b86a0e9addbb8309a14e2e241e98475c7559f9) on record recovered [0x75e6…da35](https://etherscan.io/address/0x75e6754903125d606a544ee30b010b60f5a0da35), an account without code.

## Reviewer notes

### Mechanism

_verifySignatures (contracts/oracles/BaseTimelockedOracle.sol, line 358) recovers a signer on line 369 and tests it on line 369 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. activateSignerChange (contracts/oracles/BaseTimelockedOracle.sol, line 685) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x75e6…da35; 2,479 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
