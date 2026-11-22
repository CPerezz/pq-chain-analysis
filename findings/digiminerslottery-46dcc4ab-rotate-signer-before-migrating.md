---
id: digiminerslottery-46dcc4ab-rotate-signer-before-migrating
format: 2
title: 'DigiMinersLottery: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b'
  name: DigiMinersLottery
  code: verified
  code_url: https://etherscan.io/address/0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb3f7eabd1298299e5a2512afb5f5251e775021af'
value:
  usd: 11
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeSignerwallet before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b'
  file: DigiMinersLottery.sol
  line: 1485
  has: if(checkSign(signature, quantity, tokenIdHolding, multiplier, _msgSender(), roundId) != signerWallet) revert
    F
  says: buyTickets recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b'
  file: DigiMinersLottery.sol
  line: 1445
  has: function changeSignerwallet
  says: changeSignerwallet changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd2149d74486e2c1b1c8d5a35984835f2b6184f5c'
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

DigiMinersLottery accepts a call to buyTickets only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSignerwallet changes the signer.

## Evidence

- [buyTickets](https://etherscan.io/address/0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSignerwallet](https://etherscan.io/address/0x46dcc4abb1971ae5619695bd0fb067db2a74dd8b#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xd214…4f5c](https://etherscan.io/address/0xd2149d74486e2c1b1c8d5a35984835f2b6184f5c), an account without code.

## Reviewer notes

### Mechanism

buyTickets (DigiMinersLottery.sol, line 1475) recovers a signer on line 1485 and tests it on line 1485 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. changeSignerwallet (DigiMinersLottery.sol, line 1445) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-26, recovering 0xd214…4f5c; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
