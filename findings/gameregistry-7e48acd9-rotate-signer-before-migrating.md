---
id: gameregistry-7e48acd9-rotate-signer-before-migrating
format: 2
title: 'GameRegistry: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  name: GameRegistry
  code: verified
  code_url: https://etherscan.io/address/0x7e48acd999c58c773f932dca8d02427f030e7f0c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0a5b0e232d47541eb503bc862a9db2672b8fba24'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 20
impact: liveness
action: Replace the signer with setQuoteSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  file: src/GameRegistry.sol
  line: 200
  has: if (q.payer != msg.sender || ECDSA.recover(quoteDigest(q), signature) != quoteSigner) {
  says: createGame recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  file: src/GameRegistry.sol
  line: 168
  has: function setQuoteSigner
  says: setQuoteSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7e48acd999c58c773f932dca8d02427f030e7f0c'
  fn: quoteSigner()(address)
  is: '0xafb23c04e30f9b9f797ef6e3f8bb6a6d6318cc0b'
  says: The signer it keeps in storage is 0xafb23c04e30f9b9f797ef6e3f8bb6a6d6318cc0b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xafb23c04e30f9b9f797ef6e3f8bb6a6d6318cc0b'
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

GameRegistry accepts a call to createGame only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setQuoteSigner changes the signer.

## Evidence

- [createGame](https://etherscan.io/address/0x7e48acd999c58c773f932dca8d02427f030e7f0c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setQuoteSigner](https://etherscan.io/address/0x7e48acd999c58c773f932dca8d02427f030e7f0c#code) changes the signer; only the owner can call it.
- The signer at the block is [0xafb2…cc0b](https://etherscan.io/address/0xafb23c04e30f9b9f797ef6e3f8bb6a6d6318cc0b), an account without code.

## Reviewer notes

### Mechanism

createGame (src/GameRegistry.sol, line 198) recovers a signer on line 200 and tests it on line 200 against the signer it keeps in storage (quoteSigner() returns 0xafb23c04e30f9b9f797ef6e3f8bb6a6d6318cc0b). Neither isValidSignature selector is in the code, so that account is never asked. setQuoteSigner (src/GameRegistry.sol, line 168) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 20 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
