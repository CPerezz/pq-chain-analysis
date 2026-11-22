---
id: ayninftclaim-22c6b2e3-rotate-signer-before-migrating
format: 2
title: 'AyniNFTClaim: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x22c6b2e3084ccbf980b472a18aa892c200b63dbc'
  name: AyniNFTClaim
  code: verified
  code_url: https://etherscan.io/address/0xd9e0bae8f9c25abf399e52508a602138bcf8ad49#code
  proxy_of: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  copies: 3
  family: 047168cbd2205bf64eaf97f4054db5e6
  upgradeable: 'yes'
  admin: '0x26ad6124c0e8cad7a1425d01d9e4f56790cb042a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 32
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  file: project/contracts/AyniNFTClaim.sol
  line: 150
  has: address recoveredSigner = ECDSA.recover(authorizationHash, signature);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  file: project/contracts/AyniNFTClaim.sol
  line: 151
  has: if (!isSigner[recoveredSigner]) revert UnauthorizedSigner(recoveredSigner);
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd9e0bae8f9c25abf399e52508a602138bcf8ad49'
  file: project/contracts/AyniNFTClaim.sol
  line: 226
  has: function setSigner
  says: setSigner changes who may sign
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
  tx: '0xc16a0db2de75fa32b12e7f941e4cb07ed0f034d432ea1454f267033591064064'
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

AyniNFTClaim accepts a call to claim only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [claim](https://etherscan.io/address/0xd9e0bae8f9c25abf399e52508a602138bcf8ad49#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xd9e0bae8f9c25abf399e52508a602138bcf8ad49#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xc16a0db2de75fa32b12e7f941e4cb07ed0f034d432ea1454f267033591064064) on record recovered [0xa3c4…9a33](https://etherscan.io/address/0xa3c48b6557c636c675b3e0b96cdc114bd9919a33), an account without code.

## Reviewer notes

### Mechanism

claim (project/contracts/AyniNFTClaim.sol, line 141) recovers a signer on line 150 and tests it on line 151 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (project/contracts/AyniNFTClaim.sol, line 226) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xa3c4…9a33; 32 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
