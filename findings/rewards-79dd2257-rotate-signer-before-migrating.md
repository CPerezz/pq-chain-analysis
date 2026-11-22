---
id: rewards-79dd2257-rotate-signer-before-migrating
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
  address: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  name: Rewards
  code: verified
  code_url: https://etherscan.io/address/0x79dd22579112d8a5f7347c5ed7e609e60da713c5#code
  copies: 1
  upgradeable: 'no'
  admin: '0x804986f81826034f7753484b936a634c706f1adf'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 29
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  file: contracts/rewards/Rewards.sol
  line: 121
  has: address signatureSigner = _hash(recipient).recover(v, r, s);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  file: contracts/rewards/Rewards.sol
  line: 122
  has: require(signatureSigner == rewardsSigner, "Invalid Signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  file: contracts/rewards/Rewards.sol
  line: 104
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x79dd22579112d8a5f7347c5ed7e609e60da713c5'
  fn: rewardsSigner()(address)
  is: '0x568d08b557427c57f454ea2d8c29e3745fa75c65'
  says: The signer it keeps in storage is 0x568d08b557427c57f454ea2d8c29e3745fa75c65 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x568d08b557427c57f454ea2d8c29e3745fa75c65'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xd4ce77efa014b4a08e28be89d34a32cc6c7fae998cc30196cdafd3462d70bc9a'
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

- [claim](https://etherscan.io/address/0x79dd22579112d8a5f7347c5ed7e609e60da713c5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x79dd22579112d8a5f7347c5ed7e609e60da713c5#code) changes the signer; only the owner can call it.
- The signer at the block is [0x568d…5c65](https://etherscan.io/address/0x568d08b557427c57f454ea2d8c29e3745fa75c65), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/rewards/Rewards.sol, line 115) recovers a signer on line 121 and tests it on line 122 against the signer it keeps in storage (rewardsSigner() returns 0x568d08b557427c57f454ea2d8c29e3745fa75c65). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/rewards/Rewards.sol, line 104) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-15, recovering 0x568d…5c65; 29 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
