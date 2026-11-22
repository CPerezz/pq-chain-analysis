---
id: smolmonsters-593da32c-rotate-signer-before-migrating
format: 2
title: 'SmolMonsters: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  name: SmolMonsters
  code: verified
  code_url: https://etherscan.io/address/0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a#code
  copies: 1
  admin: '0xa92ac9121c41c572d542eb77b70f2402815e18e3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Replace the signer with setValidatorAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  file: Users/flobby/Code/smolmonsters/monster-factory/contracts/contracts/SmolMintable.sol
  line: 119
  has: address signer = ECDSA.recover(validationHash, validator);
  says: whitelistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  file: Users/flobby/Code/smolmonsters/monster-factory/contracts/contracts/SmolMintable.sol
  line: 120
  has: 'require(signer == validatorWallet, "SM: Signature");'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  file: Users/flobby/Code/smolmonsters/monster-factory/contracts/contracts/SmolMintable.sol
  line: 66
  has: function setValidatorAddress
  says: setValidatorAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a'
  fn: validatorWallet()(address)
  is: '0x01eeb078354fe7a34832a9e4124aeae6464cdeeb'
  says: The signer it keeps in storage is 0x01eeb078354fe7a34832a9e4124aeae6464cdeeb at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x01eeb078354fe7a34832a9e4124aeae6464cdeeb'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
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

SmolMonsters accepts a call to whitelistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidatorAddress changes the signer.

## Evidence

- [whitelistMint](https://etherscan.io/address/0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidatorAddress](https://etherscan.io/address/0x593da32cdd2fd6cb7ec1ca04db2f590b9870fe1a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x01ee…deeb](https://etherscan.io/address/0x01eeb078354fe7a34832a9e4124aeae6464cdeeb), an account without code.

## Reviewer notes

### Mechanism

whitelistMint (Users/flobby/Code/smolmonsters/monster-factory/contracts/contracts/SmolMintable.sol, line 108) recovers a signer on line 119 and tests it on line 120 against the signer it keeps in storage (validatorWallet() returns 0x01eeb078354fe7a34832a9e4124aeae6464cdeeb). Neither isValidSignature selector is in the code, so that account is never asked. setValidatorAddress (Users/flobby/Code/smolmonsters/monster-factory/contracts/contracts/SmolMintable.sol, line 66) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-10, recovering 0x01ee…deeb; 7 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
