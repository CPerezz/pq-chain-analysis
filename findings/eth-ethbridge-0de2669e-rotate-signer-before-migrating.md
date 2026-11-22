---
id: eth-ethbridge-0de2669e-rotate-signer-before-migrating
format: 2
title: 'ETH_EthBridge: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0de2669e8a7a6f6cc0cbd3cf2d1eead89e243208'
  name: ETH_EthBridge
  code: verified
  code_url: https://etherscan.io/address/0xceaa330f7085f2aac57260101d0d26c977b463ba#code
  proxy_of: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  copies: 2
  family: 9f48f12eb1a425c0492beb37f810acda
  upgradeable: 'yes'
  admin: '0xb6db3c082d25c0dc26602334b5f3d270091dc422'
value:
  usd: 41
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  file: contracts/common/CommonBridge.sol
  line: 375
  has: (signer, ) = ECDSA.tryRecover(messageHash, signature);
  says: feeCheck recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  file: contracts/common/CommonBridge.sol
  line: 376
  has: if (hasRole(FEE_PROVIDER_ROLE, signer))
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xceaa330f7085f2aac57260101d0d26c977b463ba'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
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

ETH_EthBridge checks an ECDSA signature in feeCheck and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [feeCheck](https://etherscan.io/address/0xceaa330f7085f2aac57260101d0d26c977b463ba#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xceaa330f7085f2aac57260101d0d26c977b463ba#code) changes who may sign.

## Reviewer notes

### Mechanism

feeCheck (contracts/common/CommonBridge.sol, line 365) recovers a signer on line 375 and tests it on line 376 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-19; 0 transactions called the address in the 90 days before the block. 183 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
