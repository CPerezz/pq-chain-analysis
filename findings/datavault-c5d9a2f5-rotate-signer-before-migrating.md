---
id: datavault-c5d9a2f5-rotate-signer-before-migrating
format: 2
title: 'DataVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  name: DataVault
  code: verified
  code_url: https://etherscan.io/address/0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 2099
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  file: contracts/presale/DataVault.sol
  line: 345
  has: address recovered = hash.recover(v, r, s);
  says: claimSelectedRewards recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  file: contracts/presale/DataVault.sol
  line: 347
  has: if (recovered != signer) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0'
  file: contracts/presale/DataVault.sol
  line: 251
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x05a50724339e46f35f3897f28feaa768f6c7e20b'
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

DataVault accepts a call to claimSelectedRewards only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [claimSelectedRewards](https://etherscan.io/address/0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc5d9a2f5ca7fd61f45d1fb57202cbc1d308babd0#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x05a5…e20b](https://etherscan.io/address/0x05a50724339e46f35f3897f28feaa768f6c7e20b), an account without code.

## Reviewer notes

### Mechanism

claimSelectedRewards (contracts/presale/DataVault.sol, line 322) recovers a signer on line 345 and tests it on line 347 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/presale/DataVault.sol, line 251) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-01-23, recovering 0x05a5…e20b; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
