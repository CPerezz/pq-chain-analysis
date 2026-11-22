---
id: macininovault-5d006d94-rotate-signer-before-migrating
format: 2
title: 'MacininoVault: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  name: MacininoVault
  code: verified
  code_url: https://etherscan.io/address/0x5d006d947fa48d7324eee1030644209f29e239e4#code
  copies: 1
  upgradeable: 'no'
  admin: '0x47df27e2044b2e9e784058bc51575ab74eb5442c'
value:
  usd: 5
  basis: held
activity:
  txs_90d: 28
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  file: src/MacininoVault.sol
  line: 594
  has: address recovered = ECDSA.recover(digest, signature);
  says: execute recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  file: src/MacininoVault.sol
  line: 595
  has: if (!hasRole(SIGNER_ROLE, recovered)) revert InvalidSigner(recovered);
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x5d006d947fa48d7324eee1030644209f29e239e4'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xf3f606ebcdf242505cace0ae274e54d013e2936e'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe3dfde3f5b6f90f6187174b51b86e969087d37d72ddfe1f287b35e33147fa0ee'
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

MacininoVault accepts a call to execute only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [execute](https://etherscan.io/address/0x5d006d947fa48d7324eee1030644209f29e239e4#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x5d006d947fa48d7324eee1030644209f29e239e4#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xe3dfde3f5b6f90f6187174b51b86e969087d37d72ddfe1f287b35e33147fa0ee) on record recovered [0xf3f6…936e](https://etherscan.io/address/0xf3f606ebcdf242505cace0ae274e54d013e2936e), an account without code.

## Reviewer notes

### Mechanism

execute (src/MacininoVault.sol, line 580) recovers a signer on line 594 and tests it on line 595 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-07, recovering 0xf3f6…936e; 28 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
