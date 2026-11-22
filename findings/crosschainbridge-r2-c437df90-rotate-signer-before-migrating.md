---
id: crosschainbridge-r2-c437df90-rotate-signer-before-migrating
format: 2
title: 'CrossChainBridge_R2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc437df90b37c1db6657339e31bfe54627f0e7181'
  name: CrossChainBridge_R2
  code: verified
  code_url: https://etherscan.io/address/0x85ea08796eb66820379039cab034722e69e4e16c#code
  proxy_of: '0x85ea08796eb66820379039cab034722e69e4e16c'
  copies: 2
  family: b9479c0d47205e66ff83887e10d8907b
  upgradeable: 'yes'
  admin: '0x6a4ae724394147117832879f5f5c88608f448ad9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20
impact: liveness
action: Replace the signer with changeConsensus before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x85ea08796eb66820379039cab034722e69e4e16c'
  file: project:/contracts/upgrades/CrossChainBridge_R2.sol
  line: 357
  has: require(ECDSAUpgradeable.recover(hash, proofSignature) == _consensusAddress, "bad signature");
  says: withdraw recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x85ea08796eb66820379039cab034722e69e4e16c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x85ea08796eb66820379039cab034722e69e4e16c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x85ea08796eb66820379039cab034722e69e4e16c'
  file: project:/contracts/upgrades/CrossChainBridge_R2.sol
  line: 528
  has: function changeConsensus
  says: changeConsensus changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x4069d8a3de3a72eca86ca5e0a4b94619085e7362'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7310af5d53e08259915bc3547daf343d188b9c36db8dd6b3ff3b5e70565e88df'
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

CrossChainBridge_R2 accepts a call to withdraw only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeConsensus changes the signer.

## Evidence

- [withdraw](https://etherscan.io/address/0x85ea08796eb66820379039cab034722e69e4e16c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeConsensus](https://etherscan.io/address/0x85ea08796eb66820379039cab034722e69e4e16c#code) changes the signer; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x7310af5d53e08259915bc3547daf343d188b9c36db8dd6b3ff3b5e70565e88df) on record recovered [0x4069…7362](https://etherscan.io/address/0x4069d8a3de3a72eca86ca5e0a4b94619085e7362), an account without code.

## Reviewer notes

### Mechanism

withdraw (project:/contracts/upgrades/CrossChainBridge_R2.sol, line 333) recovers a signer on line 357 and tests it on line 357 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. changeConsensus (project:/contracts/upgrades/CrossChainBridge_R2.sol, line 528) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x4069…7362; 20 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
