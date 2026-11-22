---
id: atemcarclubcards-020cdc47-rotate-signer-before-migrating
format: 2
title: 'ATEMCarClubCards: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x020cdc4775366ae436f13a7d333143432e884934'
  name: ATEMCarClubCards
  code: verified
  code_url: https://etherscan.io/address/0x020cdc4775366ae436f13a7d333143432e884934#code
  copies: 1
  upgradeable: 'no'
  admin: '0x48a3ddc0f75d91a63c4e081537d82730d8682d78'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 84
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x020cdc4775366ae436f13a7d333143432e884934'
  file: contracts/ATEM.sol
  line: 138
  has: return (_recover(hash, token) == signer);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x020cdc4775366ae436f13a7d333143432e884934'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x020cdc4775366ae436f13a7d333143432e884934'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x020cdc4775366ae436f13a7d333143432e884934'
  file: contracts/ATEM.sol
  line: 105
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xeced2e374649d777377ed15984288b0c635cac1b'
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

ATEMCarClubCards checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x020cdc4775366ae436f13a7d333143432e884934#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x020cdc4775366ae436f13a7d333143432e884934#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xeced…ac1b](https://etherscan.io/address/0xeced2e374649d777377ed15984288b0c635cac1b), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/ATEM.sol, line 133) recovers a signer on line 138 and tests it on line 138 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/ATEM.sol, line 105) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-12, recovering 0xeced…ac1b; 84 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
