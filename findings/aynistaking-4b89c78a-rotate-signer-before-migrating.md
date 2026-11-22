---
id: aynistaking-4b89c78a-rotate-signer-before-migrating
format: 2
title: 'AyniStaking: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4b89c78aa42822e1bd24865a4fe44a138cac590f'
  name: AyniStaking
  code: verified
  code_url: https://etherscan.io/address/0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2#code
  proxy_of: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  copies: 2
  family: e095da616e9431b383068fd96d6b9205
  upgradeable: 'yes'
  admin: '0x3fd172fdf91924d8cd4ea5d438e3aeb1700fa239'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  file: contracts/AyniStaking.sol
  line: 233
  has: address signer = ECDSA.recover(digest, _signature);
  says: stakeExternal recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  file: contracts/AyniStaking.sol
  line: 234
  has: if (!isSigner[signer]) revert InvalidSigner();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2'
  file: contracts/AyniStaking.sol
  line: 555
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa3c48b6557c636c675b3e0b96cdc114bd9919a33'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x010cce35247b0b91c2436b4ff4018c1cb436db01485f41374960c69d641b579c'
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

AyniStaking accepts a call to stakeExternal only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [stakeExternal](https://etherscan.io/address/0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0x4d5c9af231cfe37afce6b1dafa60d2e4f14153e2#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x010cce35247b0b91c2436b4ff4018c1cb436db01485f41374960c69d641b579c) on record recovered [0xa3c4…9a33](https://etherscan.io/address/0xa3c48b6557c636c675b3e0b96cdc114bd9919a33), an account without code.

## Reviewer notes

### Mechanism

stakeExternal (contracts/AyniStaking.sol, line 173) recovers a signer on line 233 and tests it on line 234 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addSigner (contracts/AyniStaking.sol, line 555) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-11, recovering 0xa3c4…9a33; 10 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
