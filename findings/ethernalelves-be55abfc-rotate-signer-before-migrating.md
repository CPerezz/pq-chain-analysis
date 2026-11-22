---
id: ethernalelves-be55abfc-rotate-signer-before-migrating
format: 2
title: 'EthernalElves: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbe55abfcd0bc8863a7472a735e7001509ff0b7b8'
  name: EthernalElves
  code: verified
  code_url: https://etherscan.io/address/0x6df94b08eada7ca46f263a8acce93b795eedfc6a#code
  proxy_of: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  copies: 1
  upgradeable: 'yes'
  admin: '0x7779f54e74fd020f25679d9af568e5ca9eed7901'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setAddresses before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  file: contracts/EthernalElves.sol
  line: 125
  has: address signer = ecrecover(_hash, v, r, s);
  says: _isSignedByValidator recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  file: contracts/EthernalElves.sol
  line: 126
  has: return signer == validator;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x6df94b08eada7ca46f263a8acce93b795eedfc6a'
  file: contracts/EthernalElves.sol
  line: 69
  has: function setAddresses
  says: setAddresses changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xbe55abfcd0bc8863a7472a735e7001509ff0b7b8'
  fn: validator()(address)
  is: '0x80861814a8775de20f9506cf41932e95f80f7035'
  says: The signer it keeps in storage is 0x80861814a8775de20f9506cf41932e95f80f7035 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x80861814a8775de20f9506cf41932e95f80f7035'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
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

EthernalElves checks an ECDSA signature in _isSignedByValidator and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAddresses changes the signer.

## Evidence

- [_isSignedByValidator](https://etherscan.io/address/0x6df94b08eada7ca46f263a8acce93b795eedfc6a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAddresses](https://etherscan.io/address/0x6df94b08eada7ca46f263a8acce93b795eedfc6a#code) changes the signer.
- The signer at the block is [0x8086…7035](https://etherscan.io/address/0x80861814a8775de20f9506cf41932e95f80f7035), an account without code.

## Reviewer notes

### Mechanism

_isSignedByValidator (contracts/EthernalElves.sol, line 114) recovers a signer on line 125 and tests it on line 126 against the signer it keeps in storage (validator() returns 0x80861814a8775de20f9506cf41932e95f80f7035). Neither isValidSignature selector is in the code, so that account is never asked. setAddresses (contracts/EthernalElves.sol, line 69) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
