---
id: luckyseven-3ef0979d-rotate-signer-before-migrating
format: 2
title: 'LuckySeven: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  name: LuckySeven
  code: verified
  code_url: https://etherscan.io/address/0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe17a7354748be135c5fd0d36e71986c4337e7217'
value:
  usd: 99
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  file: LuckySeven.sol
  line: 339
  has: require(ECRecovery.recover(hash, betSignature[msg.sender]) == signer);
  says: completeBet recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  file: LuckySeven.sol
  line: 238
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e'
  fn: signer()(address)
  is: '0xbb03f21b16dbda9fd50534ff2db0f9af1c2417c3'
  says: The signer it keeps in storage is 0xbb03f21b16dbda9fd50534ff2db0f9af1c2417c3 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xbb03f21b16dbda9fd50534ff2db0f9af1c2417c3'
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

LuckySeven accepts a call to completeBet only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [completeBet](https://etherscan.io/address/0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x3ef0979d63b66fc3c1b1fdf664deb7059b4fb59e#code) changes the signer; only the owner can call it.
- The signer at the block is [0xbb03…17c3](https://etherscan.io/address/0xbb03f21b16dbda9fd50534ff2db0f9af1c2417c3), an account without code.

## Reviewer notes

### Mechanism

completeBet (LuckySeven.sol, line 334) recovers a signer on line 339 and tests it on line 339 against the signer it keeps in storage (signer() returns 0xbb03f21b16dbda9fd50534ff2db0f9af1c2417c3). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (LuckySeven.sol, line 238) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2019-03-18, recovering 0xbb03…17c3; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
