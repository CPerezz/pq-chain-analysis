---
id: multisig-0eaa2b74-rotate-signer-before-migrating
format: 2
title: 'MultiSig: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0eaa2b7472d169c038817133a1e87afed8f01996'
  name: MultiSig
  code: verified
  code_url: https://etherscan.io/address/0x0eaa2b7472d169c038817133a1e87afed8f01996#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 159
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x0eaa2b7472d169c038817133a1e87afed8f01996'
  file: contracts/MultiSig.sol
  line: 81
  has: address recovered = recover(_hash, signatures[i]);
  says: executeTransaction recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0eaa2b7472d169c038817133a1e87afed8f01996'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0eaa2b7472d169c038817133a1e87afed8f01996'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0eaa2b7472d169c038817133a1e87afed8f01996'
  file: contracts/MultiSig.sol
  line: 45
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa53a6fe2d8ad977ad926c485343ba39f32d3a3f6'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
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

MultiSig accepts a call to executeTransaction only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [executeTransaction](https://etherscan.io/address/0x0eaa2b7472d169c038817133a1e87afed8f01996#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0x0eaa2b7472d169c038817133a1e87afed8f01996#code) changes who may sign.
- The address recovered in its latest signature check on record is [0xa53a…a3f6](https://etherscan.io/address/0xa53a6fe2d8ad977ad926c485343ba39f32d3a3f6), an account without code.

## Reviewer notes

### Mechanism

executeTransaction (contracts/MultiSig.sol, line 71) recovers a signer on line 81 and tests it on line 81 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addSigner (contracts/MultiSig.sol, line 45) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-13, recovering 0xa53a…a3f6; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
