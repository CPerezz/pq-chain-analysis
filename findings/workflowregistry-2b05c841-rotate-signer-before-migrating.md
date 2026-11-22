---
id: workflowregistry-2b05c841-rotate-signer-before-migrating
format: 2
title: 'WorkflowRegistry: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  name: WorkflowRegistry
  code: verified
  code_url: https://etherscan.io/address/0x2b05c841811bcd8204ea44da33649bf79c4fd163#code
  copies: 3
  family: ebc88f775955ba5b08ad52c424820197
  upgradeable: 'no'
  admin: '0x1d653a91f0663eb79e11f3832b8750f8c9959b1a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use updateAllowedSigners so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  file: src/v0.8/workflow/v2/WorkflowRegistry.sol
  line: 646
  has: address signer = _recoverSigner(uint8(LinkingRequestType.LINK_OWNER), owner, validityTimestamp, proof, signatu
  says: canLinkOwner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  file: src/v0.8/workflow/v2/WorkflowRegistry.sol
  line: 647
  has: if (!s_allowedSigners.contains(signer)) {
  says: the recovered address must be an address in the signer set it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2b05c841811bcd8204ea44da33649bf79c4fd163'
  file: src/v0.8/workflow/v2/WorkflowRegistry.sol
  line: 574
  has: function updateAllowedSigners
  says: updateAllowedSigners changes who may sign
  for:
  - action
  - evidence-2
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

WorkflowRegistry checks an ECDSA signature in canLinkOwner and accepts only an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateAllowedSigners changes who may sign.

## Evidence

- [canLinkOwner](https://etherscan.io/address/0x2b05c841811bcd8204ea44da33649bf79c4fd163#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [updateAllowedSigners](https://etherscan.io/address/0x2b05c841811bcd8204ea44da33649bf79c4fd163#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

canLinkOwner (src/v0.8/workflow/v2/WorkflowRegistry.sol, line 631) recovers a signer on line 646 and tests it on line 647 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. updateAllowedSigners (src/v0.8/workflow/v2/WorkflowRegistry.sol, line 574) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
