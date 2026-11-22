---
id: bridgeupgradeable-a7e2ce55-rotate-signer-before-migrating
format: 2
title: 'BridgeUpgradeable: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa7e2ce557980618253d9dafdedb27ecce2f82167'
  name: BridgeUpgradeable
  code: verified
  code_url: https://etherscan.io/address/0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf#code
  proxy_of: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
  copies: 2
  family: f640d362c42806e36fe7bd30b432f3a1
  upgradeable: 'yes'
  admin: '0xf70b2473e7808edaea4a5cea95996a9b1843d96c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 121
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
  file: contracts/BridgeUpgradeable.sol
  line: 623
  has: address sender = ECDSAUpgradeable.recover(hash, signature);
  says: checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
  file: contracts/BridgeUpgradeable.sol
  line: 624
  has: return hasRole(RELAYER_ROLE, sender);
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf'
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

BridgeUpgradeable checks an ECDSA signature in checkSignature and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [checkSignature](https://etherscan.io/address/0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xbd6bcac46246a7cc2308e0ae87f7794f96e33aaf#code) changes who may sign.

## Reviewer notes

### Mechanism

checkSignature (contracts/BridgeUpgradeable.sol, line 606) recovers a signer on line 623 and tests it on line 624 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-14; 121 transactions called the address in the 90 days before the block. 6 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
