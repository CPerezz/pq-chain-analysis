---
id: rewards-086b9734-rotate-signer-before-migrating
format: 2
title: 'Rewards: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  name: Rewards
  code: verified
  code_url: https://etherscan.io/address/0x086b9734d33783bbe4fbc8249df4c686aae27054#code
  copies: 1
  upgradeable: 'no'
  admin: '0x90b6c61b102ea260131ab48377e143d6eb3a9d4b'
value:
  usd: 43859
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  file: contracts/rewards/Rewards.sol
  line: 97
  has: address signatureSigner = _hash(recipient).recover(v, r, s);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  file: contracts/rewards/Rewards.sol
  line: 98
  has: require(signatureSigner == rewardsSigner, "Invalid Signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  file: contracts/rewards/Rewards.sol
  line: 80
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x086b9734d33783bbe4fbc8249df4c686aae27054'
  fn: rewardsSigner()(address)
  is: '0xba0846ece7f77f969393fbc914d216db30f5586e'
  says: The signer it keeps in storage is 0xba0846ece7f77f969393fbc914d216db30f5586e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xba0846ece7f77f969393fbc914d216db30f5586e'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x815eb99f8529a6839b286757b46143e1673cb3b306c75d6dc7e0695ea431ecd0'
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

Rewards accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0x086b9734d33783bbe4fbc8249df4c686aae27054#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x086b9734d33783bbe4fbc8249df4c686aae27054#code) changes the signer; only the owner can call it.
- The signer at the block is [0xba08…586e](https://etherscan.io/address/0xba0846ece7f77f969393fbc914d216db30f5586e), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/rewards/Rewards.sol, line 91) recovers a signer on line 97 and tests it on line 98 against the signer it keeps in storage (rewardsSigner() returns 0xba0846ece7f77f969393fbc914d216db30f5586e). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/rewards/Rewards.sol, line 80) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0xba08…586e; 3 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
