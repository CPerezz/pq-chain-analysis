---
id: portal-2593c582-rotate-signer-before-migrating
format: 2
title: 'Portal: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2593c582b7a24d94ba0056b493fd4048bd99fc3f'
  name: Portal
  code: verified
  code_url: https://etherscan.io/address/0x5d89db6cc9295c8e802d96c521c8209353ce3215#code
  proxy_of: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  copies: 2
  family: 2d092e821cb07350e9cfca56b8bc44fb
  upgradeable: 'yes'
  admin: '0x5856cca44fafa86aa40fc32d59cdd7a1d83da22a'
value:
  usd: 764
  basis: held
activity:
  txs_90d: 11
impact: liveness
action: Before a signer's account moves to real code, use updateSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  file: contracts/Portal.sol
  line: 239
  has: address signer = ECDSA.recover(messageHash, v, r, s);
  says: receiveMessage recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  file: contracts/Portal.sol
  line: 240
  has: require(isSigner[signer], "!signer");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x5d89db6cc9295c8e802d96c521c8209353ce3215'
  file: contracts/Portal.sol
  line: 303
  has: function updateSigner
  says: updateSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x12a67bdc9a74dc0bde185d6ca03480a16bfb0e96'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe8b2ffb01198d23b411d57a50bbbc62cd1feea53e0c5d69c30d4490ec72fabbc'
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

Portal accepts a call to receiveMessage only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes who may sign.

## Evidence

- [receiveMessage](https://etherscan.io/address/0x5d89db6cc9295c8e802d96c521c8209353ce3215#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x5d89db6cc9295c8e802d96c521c8209353ce3215#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xe8b2ffb01198d23b411d57a50bbbc62cd1feea53e0c5d69c30d4490ec72fabbc) on record recovered [0x12a6…0e96](https://etherscan.io/address/0x12a67bdc9a74dc0bde185d6ca03480a16bfb0e96), an account without code.

## Reviewer notes

### Mechanism

receiveMessage (contracts/Portal.sol, line 197) recovers a signer on line 239 and tests it on line 240 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/Portal.sol, line 303) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-10, recovering 0x12a6…0e96; 11 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
