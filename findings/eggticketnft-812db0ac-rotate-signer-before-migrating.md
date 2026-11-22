---
id: eggticketnft-812db0ac-rotate-signer-before-migrating
format: 2
title: 'EggTicketNft: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  name: EggTicketNft
  code: verified
  code_url: https://etherscan.io/address/0x812db0ac0282f9dbc54d878328c69693755d58a6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7b9634c706100c456cff4306aa61dec399af2b1d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 315
impact: liveness
action: Replace the signer with setTrustedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  file: contracts/EggTicketNft.sol
  line: 141
  has: require(ECDSA.recover(digest, signature) == trustedSigner, "bad signature");
  says: buyWithQuote recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  file: contracts/EggTicketNft.sol
  line: 203
  has: function setTrustedSigner
  says: setTrustedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x812db0ac0282f9dbc54d878328c69693755d58a6'
  fn: trustedSigner()(address)
  is: '0x8a1802d87e380fc07279f111867da89a5b5b3d84'
  says: The signer it keeps in storage is 0x8a1802d87e380fc07279f111867da89a5b5b3d84 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8a1802d87e380fc07279f111867da89a5b5b3d84'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2b459a893aa79d1e3149d6d5518874d893902cc5a040a63f05326198186bbf2f'
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

EggTicketNft accepts a call to buyWithQuote only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setTrustedSigner changes the signer.

## Evidence

- [buyWithQuote](https://etherscan.io/address/0x812db0ac0282f9dbc54d878328c69693755d58a6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setTrustedSigner](https://etherscan.io/address/0x812db0ac0282f9dbc54d878328c69693755d58a6#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8a18…3d84](https://etherscan.io/address/0x8a1802d87e380fc07279f111867da89a5b5b3d84), an account without code.

## Reviewer notes

### Mechanism

buyWithQuote (contracts/EggTicketNft.sol, line 113) recovers a signer on line 141 and tests it on line 141 against the signer it keeps in storage (trustedSigner() returns 0x8a1802d87e380fc07279f111867da89a5b5b3d84). Neither isValidSignature selector is in the code, so that account is never asked. setTrustedSigner (contracts/EggTicketNft.sol, line 203) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-22, recovering 0x8a18…3d84; 315 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
