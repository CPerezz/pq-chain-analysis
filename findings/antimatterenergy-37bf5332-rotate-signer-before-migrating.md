---
id: antimatterenergy-37bf5332-rotate-signer-before-migrating
format: 2
title: 'AntimatterEnergy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  name: AntimatterEnergy
  code: verified
  code_url: https://etherscan.io/address/0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1#code
  copies: 2
  family: d466f490516747cec8f9df6e68be89d8
  upgradeable: 'no'
  admin: '0x636ef44b167cc66a60495cf59740a1ad8222cdee'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setEnergyFactory before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  file: contracts/Antimatter Energy.sol
  line: 87
  has: address energyFactory_ = ECDSA.recover(_hash, proof.v, proof.r, proof.s);
  says: _verifyProof recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  file: contracts/Antimatter Energy.sol
  line: 88
  has: require(energyFactory_ == energyFactory, "Verified collect proof error");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  file: contracts/Antimatter Energy.sol
  line: 78
  has: function setEnergyFactory
  says: setEnergyFactory changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1'
  fn: energyFactory()(address)
  is: '0xa1f74972b8c608d6dcb4fc868baaccd1796a03b9'
  says: The signer it keeps in storage is 0xa1f74972b8c608d6dcb4fc868baaccd1796a03b9 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa1f74972b8c608d6dcb4fc868baaccd1796a03b9'
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

AntimatterEnergy checks an ECDSA signature in _verifyProof and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setEnergyFactory changes the signer.

## Evidence

- [_verifyProof](https://etherscan.io/address/0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setEnergyFactory](https://etherscan.io/address/0x37bf5332e59f2f78c8ef5c8e7264cbe108bed5e1#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa1f7…03b9](https://etherscan.io/address/0xa1f74972b8c608d6dcb4fc868baaccd1796a03b9), an account without code.

## Reviewer notes

### Mechanism

_verifyProof (contracts/Antimatter Energy.sol, line 84) recovers a signer on line 87 and tests it on line 88 against the signer it keeps in storage (energyFactory() returns 0xa1f74972b8c608d6dcb4fc868baaccd1796a03b9). Neither isValidSignature selector is in the code, so that account is never asked. setEnergyFactory (contracts/Antimatter Energy.sol, line 78) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-07-28, recovering 0xa1f7…03b9; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
