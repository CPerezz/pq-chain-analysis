---
id: divergence-c7f3dba1-rotate-signer-before-migrating
format: 2
title: 'Divergence: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407'
  name: Divergence
  code: verified
  code_url: https://etherscan.io/address/0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb15c7bd982641be78c96ef1fede5f483a930ce99'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407'
  file: contracts/Ticketed.sol
  line: 99
  has: return signedHash.recover(signature) == _signer;
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407'
  file: contracts/Divergence.sol
  line: 186
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x816ae721f90d9cd5190d0385e7224c6798dad52b'
  is: delegation
  target: '0x699f638e1544a25d7401d1ee512693af41ccb388'
  says: 'the address recovered in the latest signature check on record holds an EIP-7702 delegation: an ECDSA key
    still controls it'
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

Divergence checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc7f3dba1970bfe60feecb6e5e4a44103b57b1407#code) changes the signer (through _setClaimSigner); only the owner can call it.
- The address recovered in its latest signature check on record is [0x816a…d52b](https://etherscan.io/address/0x816ae721f90d9cd5190d0385e7224c6798dad52b), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_verify (contracts/Ticketed.sol, line 92) recovers a signer on line 99 and tests it on line 99 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. _setClaimSigner (contracts/Ticketed.sol, line 102) writes it, called by setSigner. The signer's account holds an EIP-7702 delegation to 0x699f638e1544a25d7401d1ee512693af41ccb388. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-12, recovering 0x816a…d52b; 6 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
