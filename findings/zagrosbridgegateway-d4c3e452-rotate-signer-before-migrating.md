---
id: zagrosbridgegateway-d4c3e452-rotate-signer-before-migrating
format: 2
title: 'ZagrosBridgeGateway: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25'
  name: ZagrosBridgeGateway
  code: verified
  code_url: https://etherscan.io/address/0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25#code
  copies: 1
  upgradeable: 'no'
  admin: '0x00000005668becb40d7eaafdae73ed6347932d49'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Before a signer's account moves to real code, use setRelayer so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25'
  file: contracts/ZagrosBridgeGateway.sol
  line: 300
  has: address signer = ECDSA.recover(digest, _signatures[i]);
  says: claimTokens recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25'
  file: contracts/ZagrosBridgeGateway.sol
  line: 169
  has: function setRelayer
  says: setRelayer changes who may sign
  for:
  - action
  - evidence-2
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

ZagrosBridgeGateway accepts a call to claimTokens only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRelayer changes who may sign.

## Evidence

- [claimTokens](https://etherscan.io/address/0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setRelayer](https://etherscan.io/address/0xd4c3e452a13fe2fd2b1fde65adf17d101eb42d25#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

claimTokens (contracts/ZagrosBridgeGateway.sol, line 275) recovers a signer on line 300 and tests it on line 300 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setRelayer (contracts/ZagrosBridgeGateway.sol, line 169) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
