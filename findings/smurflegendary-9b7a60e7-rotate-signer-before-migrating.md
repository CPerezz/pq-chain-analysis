---
id: smurflegendary-9b7a60e7-rotate-signer-before-migrating
format: 2
title: 'SmurfLegendary: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9b7a60e76f59037d152adbbafa8c6db591b274ac'
  name: SmurfLegendary
  code: verified
  code_url: https://etherscan.io/address/0xa8764d8c8c032b032b5724c521b278a8c234154e#code
  proxy_of: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  copies: 2
  family: d75908bfe5312da0d93bd2963c2dac8c
  upgradeable: 'yes'
  admin: '0x6b856dfecc97ee605295d4fc7107b3265675d113'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 69
impact: liveness
action: Replace the signer with setApproverAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  file: contracts/SmurfLegendary.sol
  line: 141
  has: address recoveredAddress = ECDSAUpgradeable.recover(hash, _signature);
  says: checkApprovals recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  file: contracts/SmurfLegendary.sol
  line: 143
  has: 'require(recoveredAddress == __approverAddress, "Smurf: The signature address does not match the provided
    addre'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa8764d8c8c032b032b5724c521b278a8c234154e'
  file: contracts/SmurfLegendary.sol
  line: 184
  has: function setApproverAddress
  says: setApproverAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9b7a60e76f59037d152adbbafa8c6db591b274ac'
  fn: __approverAddress()(address)
  is: '0x9316cfe97bbeebb12c3de349737d77d585621bf4'
  says: The signer it keeps in storage is 0x9316cfe97bbeebb12c3de349737d77d585621bf4 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9316cfe97bbeebb12c3de349737d77d585621bf4'
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

SmurfLegendary checks an ECDSA signature in checkApprovals and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setApproverAddress changes the signer.

## Evidence

- [checkApprovals](https://etherscan.io/address/0xa8764d8c8c032b032b5724c521b278a8c234154e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setApproverAddress](https://etherscan.io/address/0xa8764d8c8c032b032b5724c521b278a8c234154e#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x9316…1bf4](https://etherscan.io/address/0x9316cfe97bbeebb12c3de349737d77d585621bf4), an account without code.

## Reviewer notes

### Mechanism

checkApprovals (contracts/SmurfLegendary.sol, line 131) recovers a signer on line 141 and tests it on line 143 against the signer it keeps in storage (__approverAddress() returns 0x9316cfe97bbeebb12c3de349737d77d585621bf4). Neither isValidSignature selector is in the code, so that account is never asked. setApproverAddress (contracts/SmurfLegendary.sol, line 184) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-06, recovering 0x9316…1bf4; 69 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
