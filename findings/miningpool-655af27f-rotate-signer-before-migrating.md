---
id: miningpool-655af27f-rotate-signer-before-migrating
format: 2
title: 'MiningPool: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x655af27fd486ac6acb67ccf760e180421930276f'
  name: MiningPool
  code: verified
  code_url: https://etherscan.io/address/0x655af27fd486ac6acb67ccf760e180421930276f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x655af27fd486ac6acb67ccf760e180421930276f'
  file: MiningPool.sol
  line: 457
  has: require(recoverSigner(message, sig) == owner_);
  says: claimMasternodeReward recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x655af27fd486ac6acb67ccf760e180421930276f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x655af27fd486ac6acb67ccf760e180421930276f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x655af27fd486ac6acb67ccf760e180421930276f'
  file: MiningPool.sol
  line: 101
  has: function transferOwnership
  says: transferOwnership changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x655af27fd486ac6acb67ccf760e180421930276f'
  fn: owner_()(address)
  is: '0x20a3726ac2a5c1604c50e65b09bb5d280b0d176b'
  says: The signer it keeps in storage is 0x20a3726ac2a5c1604c50e65b09bb5d280b0d176b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x20a3726ac2a5c1604c50e65b09bb5d280b0d176b'
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

MiningPool accepts a call to claimMasternodeReward only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [claimMasternodeReward](https://etherscan.io/address/0x655af27fd486ac6acb67ccf760e180421930276f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x655af27fd486ac6acb67ccf760e180421930276f#code) changes the signer; only the owner can call it.
- The signer at the block is [0x20a3…176b](https://etherscan.io/address/0x20a3726ac2a5c1604c50e65b09bb5d280b0d176b), an account without code.

## Reviewer notes

### Mechanism

claimMasternodeReward (MiningPool.sol, line 449) recovers a signer on line 457 and tests it on line 457 against the signer it keeps in storage (owner_() returns 0x20a3726ac2a5c1604c50e65b09bb5d280b0d176b). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership (MiningPool.sol, line 101) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-04-19, recovering 0x20a3…176b; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
