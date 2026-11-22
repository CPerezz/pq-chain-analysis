---
id: tokenrewardv2-d4517dbe-rotate-signer-before-migrating
format: 2
title: 'TokenRewardV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd4517dbeef443cf3d1d760abdd4268f12940c6f8'
  name: TokenRewardV2
  code: verified
  code_url: https://etherscan.io/address/0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e#code
  proxy_of: '0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e'
  copies: 3
  family: 51b86c9903e4a7e86f2707c2533abe12
  upgradeable: 'yes'
  admin: '0x5529c777be16e545e03d5b11b77b799f102efaf4'
value:
  usd: 3088
  basis: held
activity:
  txs_90d: 4569
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e'
  file: src/TokenReward/TokenRewardV2.sol
  line: 648
  has: return ECDSA.recover(hash, signature) == signer;
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e'
  file: src/TokenReward/TokenRewardV2.sol
  line: 157
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd4517dbeef443cf3d1d760abdd4268f12940c6f8'
  fn: signer()(address)
  is: '0x5529c777be16e545e03d5b11b77b799f102efaf4'
  says: The signer it keeps in storage is 0x5529c777be16e545e03d5b11b77b799f102efaf4 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5529c777be16e545e03d5b11b77b799f102efaf4'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xcad47ed45ce9c4f76a4aae18bb103a4df479899c754f82fb62f2e8c1e9912037'
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

TokenRewardV2 checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xe6cb4bca79b07bd1ea1e176e2774e35b4b222c7e#code) changes the signer; only the owner can call it.
- The signer at the block is [0x5529…faf4](https://etherscan.io/address/0x5529c777be16e545e03d5b11b77b799f102efaf4), an account without code.

## Reviewer notes

### Mechanism

_verify (src/TokenReward/TokenRewardV2.sol, line 644) recovers a signer on line 648 and tests it on line 648 against the signer it keeps in storage (signer() returns 0x5529c777be16e545e03d5b11b77b799f102efaf4). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/TokenReward/TokenRewardV2.sol, line 157) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-28, recovering 0x40e9…9f8b; 4,569 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
