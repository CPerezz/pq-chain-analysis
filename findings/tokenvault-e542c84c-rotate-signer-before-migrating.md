---
id: tokenvault-e542c84c-rotate-signer-before-migrating
format: 2
title: 'TokenVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  name: TokenVault
  code: verified
  code_url: https://etherscan.io/address/0xe542c84cb42d1571e48f08e1189add5b98f414b7#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc2877fe66cf6ef0ae6e779f857ac31d54a87cb88'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  file: contracts/TokenVault.sol
  line: 88
  has: address signer = ECDSA.recover(message, signature);
  says: _validateWithdrawalSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  file: contracts/TokenVault.sol
  line: 89
  has: return (signer == _signerAddress);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe542c84cb42d1571e48f08e1189add5b98f414b7'
  file: contracts/TokenVault.sol
  line: 58
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd6fd66b501dcb0497845f6989e2f3a5c00f6595e'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x763043a4ef0b5e77ae4cbe265a0401e93d221c067f913fdc6eb383d00913c9a3'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

TokenVault checks an ECDSA signature in _validateWithdrawalSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [_validateWithdrawalSignature](https://etherscan.io/address/0xe542c84cb42d1571e48f08e1189add5b98f414b7#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0xe542c84cb42d1571e48f08e1189add5b98f414b7#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x763043a4ef0b5e77ae4cbe265a0401e93d221c067f913fdc6eb383d00913c9a3) on record recovered [0xd6fd…595e](https://etherscan.io/address/0xd6fd66b501dcb0497845f6989e2f3a5c00f6595e), an account without code.

## Reviewer notes

### Mechanism

_validateWithdrawalSignature (contracts/TokenVault.sol, line 75) recovers a signer on line 88 and tests it on line 89 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/TokenVault.sol, line 58) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-23, recovering 0xd6fd…595e; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
