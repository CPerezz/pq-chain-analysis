---
id: mutanty00tsapeclub-7b7e7b9c-rotate-signer-before-migrating
format: 2
title: 'Mutanty00tsApeClub: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  name: Mutanty00tsApeClub
  code: verified
  code_url: https://etherscan.io/address/0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca#code
  copies: 1
  upgradeable: 'no'
  admin: '0x57c0649731f79832c88e3939d248db95d2344dc3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 32
impact: liveness
action: Replace the signer with setSignerHolder before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  file: contracts/MutanBoredY00tsAC/Mutanty00tsApeClub.sol
  line: 165
  has: address _signer = messagehash.toEthSignedMessageHash().recover(_signature);
  says: isMessageValidHolder recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  file: contracts/MutanBoredY00tsAC/Mutanty00tsApeClub.sol
  line: 166
  has: if (signerHolder == _signer) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  file: contracts/MutanBoredY00tsAC/Mutanty00tsApeClub.sol
  line: 98
  has: function setSignerHolder
  says: setSignerHolder changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca'
  fn: signerHolder()(address)
  is: '0x80b6294872cbb6ee5fe17c6456b807c97f2b316e'
  says: The signer it keeps in storage is 0x80b6294872cbb6ee5fe17c6456b807c97f2b316e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x80b6294872cbb6ee5fe17c6456b807c97f2b316e'
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

Mutanty00tsApeClub checks an ECDSA signature in isMessageValidHolder and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerHolder changes the signer.

## Evidence

- [isMessageValidHolder](https://etherscan.io/address/0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerHolder](https://etherscan.io/address/0x7b7e7b9c354ad3cf0711710830f8f0c5802a77ca#code) changes the signer; only the owner can call it.
- The signer at the block is [0x80b6…316e](https://etherscan.io/address/0x80b6294872cbb6ee5fe17c6456b807c97f2b316e), an account without code.

## Reviewer notes

### Mechanism

isMessageValidHolder (contracts/MutanBoredY00tsAC/Mutanty00tsApeClub.sol, line 162) recovers a signer on line 165 and tests it on line 166 against the signer it keeps in storage (signerHolder() returns 0x80b6294872cbb6ee5fe17c6456b807c97f2b316e). Neither isValidSignature selector is in the code, so that account is never asked. setSignerHolder (contracts/MutanBoredY00tsAC/Mutanty00tsApeClub.sol, line 98) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-12-19; 32 transactions called the address in the 90 days before the block. 11 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
