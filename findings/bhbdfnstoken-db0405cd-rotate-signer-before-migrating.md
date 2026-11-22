---
id: bhbdfnstoken-db0405cd-rotate-signer-before-migrating
format: 2
title: 'BHBDfnsToken: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  name: BHBDfnsToken
  code: verified
  code_url: https://etherscan.io/address/0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7#code
  copies: 1
  upgradeable: 'no'
  admin: '0x66d133602dc0063886f46c67600ad1390d40512f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  file: bhb/BHBDfnsToken.sol
  line: 164
  has: address signer = reserveAttestationDigest(a).recover(signature);
  says: attestReserve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  file: bhb/BHBDfnsToken.sol
  line: 165
  has: if (!hasRole(RESERVE_SIGNER_ROLE, signer)) revert InvalidSignature();
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x66d133602dc0063886f46c67600ad1390d40512f'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x27b7ede0beaf500c7c50e66062e87077b027361fe150ad9e5a773a6f66b32f09'
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

BHBDfnsToken accepts a call to attestReserve only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [attestReserve](https://etherscan.io/address/0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xdb0405cd36fe5b42f8374e817a1eedc94b7bbed7#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x27b7ede0beaf500c7c50e66062e87077b027361fe150ad9e5a773a6f66b32f09) on record recovered [0x66d1…512f](https://etherscan.io/address/0x66d133602dc0063886f46c67600ad1390d40512f), an account without code.

## Reviewer notes

### Mechanism

attestReserve (bhb/BHBDfnsToken.sol, line 151) recovers a signer on line 164 and tests it on line 165 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-05, recovering 0x66d1…512f; 3 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
