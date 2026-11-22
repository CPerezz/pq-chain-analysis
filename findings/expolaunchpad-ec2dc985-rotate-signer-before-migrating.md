---
id: expolaunchpad-ec2dc985-rotate-signer-before-migrating
format: 2
title: 'ExpoLaunchpad: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  name: ExpoLaunchpad
  code: verified
  code_url: https://etherscan.io/address/0xec2dc9852a0799ecafc74c51868e464188a69f7d#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcaf9e72a7d536dfa1bd268ff9afcce476cdf56ab'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setQuoteSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  file: src/v3/ExpoLaunchpad.sol
  line: 124
  has: if (ECDSA.recover(quoteDigest(q), signature) != quoteSigner) revert BadSignature();
  says: launch recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  file: src/v3/ExpoLaunchpad.sol
  line: 88
  has: function setQuoteSigner
  says: setQuoteSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xec2dc9852a0799ecafc74c51868e464188a69f7d'
  fn: quoteSigner()(address)
  is: '0xe3d5732b7692eadcbb03e4a712cd26a0dc36a689'
  says: The signer it keeps in storage is 0xe3d5732b7692eadcbb03e4a712cd26a0dc36a689 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe3d5732b7692eadcbb03e4a712cd26a0dc36a689'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x634d749eee416beb67d4496c4468beec4f83abca02c096ad51090ba43869082f'
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

ExpoLaunchpad accepts a call to launch only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setQuoteSigner changes the signer.

## Evidence

- [launch](https://etherscan.io/address/0xec2dc9852a0799ecafc74c51868e464188a69f7d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setQuoteSigner](https://etherscan.io/address/0xec2dc9852a0799ecafc74c51868e464188a69f7d#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe3d5…a689](https://etherscan.io/address/0xe3d5732b7692eadcbb03e4a712cd26a0dc36a689), an account without code.

## Reviewer notes

### Mechanism

launch (src/v3/ExpoLaunchpad.sol, line 116) recovers a signer on line 124 and tests it on line 124 against the signer it keeps in storage (quoteSigner() returns 0xe3d5732b7692eadcbb03e4a712cd26a0dc36a689). Neither isValidSignature selector is in the code, so that account is never asked. setQuoteSigner (src/v3/ExpoLaunchpad.sol, line 88) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-03, recovering 0xe3d5…a689; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
