---
id: puggy-64b88f10-rotate-signer-before-migrating
format: 2
title: 'Puggy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64b88f10faf1603b70fb7370a00c43369f329515'
  name: Puggy
  code: verified
  code_url: https://etherscan.io/address/0x64b88f10faf1603b70fb7370a00c43369f329515#code
  copies: 2
  family: 9ff52306bdf535fbd31119e83fa4b4b0
  upgradeable: 'no'
  admin: '0x4cd108308a859fc5094303c49392898ae0098487'
value:
  usd: 217
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddr before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x64b88f10faf1603b70fb7370a00c43369f329515'
  file: Puggy.sol
  line: 1569
  has: return (_recover(hash, token) == _signer);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x64b88f10faf1603b70fb7370a00c43369f329515'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x64b88f10faf1603b70fb7370a00c43369f329515'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x64b88f10faf1603b70fb7370a00c43369f329515'
  file: Puggy.sol
  line: 1657
  has: function setSignerAddr
  says: setSignerAddr changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa8ee9a4cbe22cea18155efe51d4b5345686773de'
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

Puggy checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddr changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x64b88f10faf1603b70fb7370a00c43369f329515#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddr](https://etherscan.io/address/0x64b88f10faf1603b70fb7370a00c43369f329515#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xa8ee…73de](https://etherscan.io/address/0xa8ee9a4cbe22cea18155efe51d4b5345686773de), an account without code.

## Reviewer notes

### Mechanism

_verify (Puggy.sol, line 1564) recovers a signer on line 1569 and tests it on line 1569 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddr (Puggy.sol, line 1657) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-29, recovering 0xa8ee…73de; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
