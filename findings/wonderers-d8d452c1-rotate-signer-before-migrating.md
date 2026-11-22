---
id: wonderers-d8d452c1-rotate-signer-before-migrating
format: 2
title: 'Wonderers: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd8d452c15dea0301734f892d486c4928104e8cfe'
  name: Wonderers
  code: verified
  code_url: https://etherscan.io/address/0xd8d452c15dea0301734f892d486c4928104e8cfe#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7fb102049379e557975203344d0f6f9119b7d84d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 41
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd8d452c15dea0301734f892d486c4928104e8cfe'
  file: contracts/Wonderers.sol
  line: 218
  has: return ECDSA.recover(digest, sig) == signer;
  says: isAuthorized recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd8d452c15dea0301734f892d486c4928104e8cfe'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd8d452c15dea0301734f892d486c4928104e8cfe'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd8d452c15dea0301734f892d486c4928104e8cfe'
  file: contracts/Wonderers.sol
  line: 209
  has: function setSigner
  says: setSigner changes the signer
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

Wonderers checks an ECDSA signature in isAuthorized and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [isAuthorized](https://etherscan.io/address/0xd8d452c15dea0301734f892d486c4928104e8cfe#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xd8d452c15dea0301734f892d486c4928104e8cfe#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

isAuthorized (contracts/Wonderers.sol, line 213) recovers a signer on line 218 and tests it on line 218 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/Wonderers.sol, line 209) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 41 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
