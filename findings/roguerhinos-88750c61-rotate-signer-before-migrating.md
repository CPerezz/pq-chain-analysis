---
id: roguerhinos-88750c61-rotate-signer-before-migrating
format: 2
title: 'RogueRhinos: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x88750c615802cc4700c031ccbce821f664ef6060'
  name: RogueRhinos
  code: verified
  code_url: https://etherscan.io/address/0x88750c615802cc4700c031ccbce821f664ef6060#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6cbaf1f2b868c37d521b7e95ff8de29049eb0986'
value:
  usd: 72
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setMsgSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x88750c615802cc4700c031ccbce821f664ef6060'
  file: contracts/RogueRhinos.sol
  line: 319
  has: address recoveredSigner = ECDSA.recover(ethHash, _sig);
  says: legitSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x88750c615802cc4700c031ccbce821f664ef6060'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x88750c615802cc4700c031ccbce821f664ef6060'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x88750c615802cc4700c031ccbce821f664ef6060'
  file: contracts/RogueRhinos.sol
  line: 320
  has: return (recoveredSigner == msgSigner);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x88750c615802cc4700c031ccbce821f664ef6060'
  file: contracts/RogueRhinos.sol
  line: 239
  has: function setMsgSigner
  says: setMsgSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x45107553d3963e3982aa6b3ee16ffafd87fcd277'
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

RogueRhinos checks an ECDSA signature in legitSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMsgSigner changes the signer.

## Evidence

- [legitSigner](https://etherscan.io/address/0x88750c615802cc4700c031ccbce821f664ef6060#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMsgSigner](https://etherscan.io/address/0x88750c615802cc4700c031ccbce821f664ef6060#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0x4510…d277](https://etherscan.io/address/0x45107553d3963e3982aa6b3ee16ffafd87fcd277), an account without code.

## Reviewer notes

### Mechanism

legitSigner (contracts/RogueRhinos.sol, line 304) recovers a signer on line 319 and tests it on line 320 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setMsgSigner (contracts/RogueRhinos.sol, line 239) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-04, recovering 0x4510…d277; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
