---
id: nightbornstaking-cb73af35-rotate-signer-before-migrating
format: 2
title: 'NightbornStaking: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  name: NightbornStaking
  code: verified
  code_url: https://etherscan.io/address/0xcb73af3543f687708d427bf36b94741f80d72b20#code
  copies: 1
  upgradeable: 'no'
  admin: '0x21d14007bf3284b86de09cd0827f38c1b9c86a48'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  file: contracts/NightbornStaking.sol
  line: 121
  has: address recovered = hash.recover(signatures[i]);
  says: stake recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  file: contracts/NightbornStaking.sol
  line: 168
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xcb73af3543f687708d427bf36b94741f80d72b20'
  fn: signer()(address)
  is: '0xfc0970f737c73d880fa902ee0c2e2e12f0da02c7'
  says: The signer it keeps in storage is 0xfc0970f737c73d880fa902ee0c2e2e12f0da02c7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfc0970f737c73d880fa902ee0c2e2e12f0da02c7'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x4c872fc1e1225e8b97b67681b5eba836fa54ca830f0e7e231dea7e9509b7fe22'
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

NightbornStaking accepts a call to stake only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [stake](https://etherscan.io/address/0xcb73af3543f687708d427bf36b94741f80d72b20#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xcb73af3543f687708d427bf36b94741f80d72b20#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfc09…02c7](https://etherscan.io/address/0xfc0970f737c73d880fa902ee0c2e2e12f0da02c7), an account without code.

## Reviewer notes

### Mechanism

stake (contracts/NightbornStaking.sol, line 87) recovers a signer on line 121 and tests it on line 121 against the signer it keeps in storage (signer() returns 0xfc0970f737c73d880fa902ee0c2e2e12f0da02c7). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/NightbornStaking.sol, line 168) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-30, recovering 0xfc09…02c7; 7 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
