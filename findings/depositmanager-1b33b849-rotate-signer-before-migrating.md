---
id: depositmanager-1b33b849-rotate-signer-before-migrating
format: 2
title: 'DepositManager: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1b33b8499eb6d681cdcf19c79df8a3dec9c652c3'
  name: DepositManager
  code: verified
  code_url: https://etherscan.io/address/0x8ad73868f367c8b8973cbb614516ac8ac33cacd8#code
  proxy_of: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  copies: 2
  family: 918d851b53453faf80922b1a0b6a9f3d
  upgradeable: 'yes'
  admin: '0x40eec91b339159c461112fd35a8f502da2f83c7d'
value:
  usd: 393
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use setScreenerPermission so that another key can sign in
  its place.
evidence_level: source
checks:
- id: recover
  source: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  file: contracts/DepositManager.sol
  line: 448
  has: address recoveredSigner = _recoverDepositRequestSigner(req, signature);
  says: _completeDeposit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  file: contracts/DepositManager.sol
  line: 449
  has: require(_screeners[recoveredSigner], "request signer !screener");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x8ad73868f367c8b8973cbb614516ac8ac33cacd8'
  file: contracts/DepositManager.sol
  line: 193
  has: function setScreenerPermission
  says: setScreenerPermission changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x36cbeb4242950aca49317fd835439b8f31263753'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

DepositManager checks an ECDSA signature in _completeDeposit and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setScreenerPermission changes who may sign.

## Evidence

- [_completeDeposit](https://etherscan.io/address/0x8ad73868f367c8b8973cbb614516ac8ac33cacd8#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setScreenerPermission](https://etherscan.io/address/0x8ad73868f367c8b8973cbb614516ac8ac33cacd8#code) changes who may sign; only the owner can call it.
- The address recovered in its latest signature check on record is [0x36cb…3753](https://etherscan.io/address/0x36cbeb4242950aca49317fd835439b8f31263753), an account without code.

## Reviewer notes

### Mechanism

_completeDeposit (contracts/DepositManager.sol, line 441) recovers a signer on line 448 and tests it on line 449 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setScreenerPermission (contracts/DepositManager.sol, line 193) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-05-21, recovering 0x36cb…3753; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
