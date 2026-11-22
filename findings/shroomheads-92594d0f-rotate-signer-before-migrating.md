---
id: shroomheads-92594d0f-rotate-signer-before-migrating
format: 2
title: 'ShroomHeads: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x92594d0f692fc2b25a8030573f3ff10abf034bdb'
  name: ShroomHeads
  code: verified
  code_url: https://etherscan.io/address/0x92594d0f692fc2b25a8030573f3ff10abf034bdb#code
  copies: 1
  upgradeable: 'no'
  admin: '0x5b1e4a8cbb5509dc45ee7591d58dcf059ce8c828'
value:
  usd: 112
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x92594d0f692fc2b25a8030573f3ff10abf034bdb'
  file: contracts/ShroomHeads.sol
  line: 235
  has: require(signerAddress == ECDSA.recover(digest, _signature), "Not authorized. You need to be whitelisted on
    Dis
  says: privateMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x92594d0f692fc2b25a8030573f3ff10abf034bdb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x92594d0f692fc2b25a8030573f3ff10abf034bdb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x92594d0f692fc2b25a8030573f3ff10abf034bdb'
  file: contracts/ShroomHeads.sol
  line: 128
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x927b0aaf0f6d71ae2f952cfb489199af01e40e6c'
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

ShroomHeads accepts a call to privateMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [privateMint](https://etherscan.io/address/0x92594d0f692fc2b25a8030573f3ff10abf034bdb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x92594d0f692fc2b25a8030573f3ff10abf034bdb#code) changes the signer (through _setSignerAddress); only a role holder can call it.
- The address recovered in its latest signature check on record is [0x927b…0e6c](https://etherscan.io/address/0x927b0aaf0f6d71ae2f952cfb489199af01e40e6c), an account without code.

## Reviewer notes

### Mechanism

privateMint (contracts/ShroomHeads.sol, line 224) recovers a signer on line 235 and tests it on line 235 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. _setSignerAddress (contracts/ShroomHeads.sol, line 121) writes it, called by setSignerAddress. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-30, recovering 0x927b…0e6c; 0 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
