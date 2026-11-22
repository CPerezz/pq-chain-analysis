---
id: b3lapestaking-6fe7f538-rotate-signer-before-migrating
format: 2
title: 'B3LApeStaking: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  name: B3LApeStaking
  code: verified
  code_url: https://etherscan.io/address/0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa#code
  copies: 2
  family: e132b1412591647c80b14d42c4ddbebb
  upgradeable: 'no'
  admin: '0x2d34c1ef0c1abbd0205b68f79644566a1a318b73'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  file: src/B3LApeStaking.sol
  line: 50
  has: address signerAddress = hash.toEthSignedMessageHash().recover(signature);
  says: stakeApeCoin recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  file: src/B3LApeStaking.sol
  line: 51
  has: require(signerAddress == signer, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa'
  file: src/B3LApeStaking.sol
  line: 139
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x4a482e752cbfc41c74915bdbaded4f0032e0a78d'
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

B3LApeStaking accepts a call to stakeApeCoin only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [stakeApeCoin](https://etherscan.io/address/0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x6fe7f5383ad48b33640ceef921e60a75e4fbd6fa#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x4a48…a78d](https://etherscan.io/address/0x4a482e752cbfc41c74915bdbaded4f0032e0a78d), an account without code.

## Reviewer notes

### Mechanism

stakeApeCoin (src/B3LApeStaking.sol, line 38) recovers a signer on line 50 and tests it on line 51 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/B3LApeStaking.sol, line 139) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-03-15, recovering 0x4a48…a78d; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
