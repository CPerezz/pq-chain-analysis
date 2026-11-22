---
id: marketplacev2-cfd3e772-rotate-signer-before-migrating
format: 2
title: 'MarketplaceV2: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcfd3e772338ee65193e74eb0e70ecb228afb5df7'
  name: MarketplaceV2
  code: verified
  code_url: https://etherscan.io/address/0x6d2907c8fa418045e57c02913df73ed05a536f19#code
  proxy_of: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  copies: 2
  family: 2327f2f04503b957b8d50e7a21ee1d30
  upgradeable: 'yes'
  admin: '0xe305ab43425f550288010a3ea9785366b4f2f1fd'
value:
  usd: 9360
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  file: project:/contracts/MarketplaceV2.sol
  line: 444
  has: address signer = recoverSigner(prefixed(hashWithoutPrefix), _signature);
  says: _createNftItem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  file: project:/contracts/MarketplaceV2.sol
  line: 447
  has: hasRole(AUCTION_FINISHER_ROLE, signer),
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x6d2907c8fa418045e57c02913df73ed05a536f19'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xfa6a7e9157fe8df1d9cfa2a2c6e67e65aa3e9d9f'
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

MarketplaceV2 checks an ECDSA signature in _createNftItem and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_createNftItem](https://etherscan.io/address/0x6d2907c8fa418045e57c02913df73ed05a536f19#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x6d2907c8fa418045e57c02913df73ed05a536f19#code) changes who may sign.
- The address recovered in its latest signature check on record is [0xfa6a…9d9f](https://etherscan.io/address/0xfa6a7e9157fe8df1d9cfa2a2c6e67e65aa3e9d9f), an account without code.

## Reviewer notes

### Mechanism

_createNftItem (project:/contracts/MarketplaceV2.sol, line 429) recovers a signer on line 444 and tests it on line 447 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-03-23, recovering 0xfa6a…9d9f; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
