---
id: trippymints-7859b3be-rotate-signer-before-migrating
format: 2
title: 'TrippyMints: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7859b3bea9ed3420891578ef806d76dda4b752aa'
  name: TrippyMints
  code: verified
  code_url: https://etherscan.io/address/0x7859b3bea9ed3420891578ef806d76dda4b752aa#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6b90fc53c79b62b586b178a33357eec16f7f574c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setServerPublicKey before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7859b3bea9ed3420891578ef806d76dda4b752aa'
  file: contracts/trippy.sol
  line: 76
  has: return _serverPublicKey == hash.recover(signature);
  says: matchAddressSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7859b3bea9ed3420891578ef806d76dda4b752aa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7859b3bea9ed3420891578ef806d76dda4b752aa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7859b3bea9ed3420891578ef806d76dda4b752aa'
  file: contracts/trippy.sol
  line: 148
  has: function setServerPublicKey
  says: setServerPublicKey changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x1d78dcd7888b6ddb9acf465f46ebc477db42e151'
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

TrippyMints checks an ECDSA signature in matchAddressSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setServerPublicKey changes the signer.

## Evidence

- [matchAddressSigner](https://etherscan.io/address/0x7859b3bea9ed3420891578ef806d76dda4b752aa#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setServerPublicKey](https://etherscan.io/address/0x7859b3bea9ed3420891578ef806d76dda4b752aa#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x1d78…e151](https://etherscan.io/address/0x1d78dcd7888b6ddb9acf465f46ebc477db42e151), an account without code.

## Reviewer notes

### Mechanism

matchAddressSigner (contracts/trippy.sol, line 75) recovers a signer on line 76 and tests it on line 76 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setServerPublicKey (contracts/trippy.sol, line 148) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-12-04, recovering 0x1d78…e151; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
