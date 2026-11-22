---
id: gamediseaseartdispenser-33ee3f68-rotate-signer-before-migrating
format: 2
title: 'GameDiseaseArtDispenser: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f'
  name: GameDiseaseArtDispenser
  code: verified
  code_url: https://etherscan.io/address/0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f#code
  copies: 1
  upgradeable: 'no'
  admin: '0xeb334a9ed800024889989eb4fbe1e16f4474dcab'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f'
  file: contracts/ERC721/GameDiseaseArtDispenser.sol
  line: 1639
  has: require(signers[getMessageSigner(signature, tokenId)], "not a signer");
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f'
  file: contracts/ERC721/GameDiseaseArtDispenser.sol
  line: 1611
  has: function setSigner
  says: setSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xcaf7e7385d8b82610d8dea0353d891022bee3e96'
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

GameDiseaseArtDispenser accepts a call to mint only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [mint](https://etherscan.io/address/0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x33ee3f6846c28f61809be70d51d5a4a3a7cce39f#code) changes who may sign; only the owner can call it.
- The address recovered in its latest signature check on record is [0xcaf7…3e96](https://etherscan.io/address/0xcaf7e7385d8b82610d8dea0353d891022bee3e96), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/ERC721/GameDiseaseArtDispenser.sol, line 1638) recovers a signer on line 1639 and tests it on line 1639 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/ERC721/GameDiseaseArtDispenser.sol, line 1611) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-28, recovering 0xcaf7…3e96; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
