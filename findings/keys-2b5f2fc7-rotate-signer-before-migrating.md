---
id: keys-2b5f2fc7-rotate-signer-before-migrating
format: 2
title: 'Keys: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b'
  name: Keys
  code: verified
  code_url: https://etherscan.io/address/0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x288b037b777749a01f3168ff8c30efcce9ce3e85'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 136
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b'
  file: Keys.sol
  line: 1961
  has: signerAddress == hash.toEthSignedMessageHash().recover(signature),
  says: validateUsingECDASignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b'
  file: Keys.sol
  line: 2025
  has: function setSignerAddress
  says: setSignerAddress changes the signer
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

Keys checks an ECDSA signature in validateUsingECDASignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [validateUsingECDASignature](https://etherscan.io/address/0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x2b5f2fc733acd1521a9efc6c4f354cdd7eec6c1b#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

validateUsingECDASignature (Keys.sol, line 1956) recovers a signer on line 1961 and tests it on line 1961 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (Keys.sol, line 2025) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-19; 136 transactions called the address in the 90 days before the block. 6 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
