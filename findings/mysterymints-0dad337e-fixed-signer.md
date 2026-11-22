---
id: mysterymints-0dad337e-fixed-signer
format: 2
title: 'MysteryMints: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  name: MysteryMints
  code: verified
  code_url: https://etherscan.io/address/0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1c90081cd1c161a3e9de8e2c9d4c1754a49143c0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  file: contracts/MysteryMints.sol
  line: 175
  has: return recoverSigner(ethSignedMessageHash, signature) == WHITELIST_SIGNER;
  says: isWhitelisted recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  file: contracts/MysteryMints.sol
  line: 45
  has: address public constant WHITELIST_SIGNER = 0x8430e0B7be3315735C303b82E4471D59AC152Aa5;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8'
  fn: WHITELIST_SIGNER()(address)
  is: '0x8430e0b7be3315735c303b82e4471d59ac152aa5'
  says: A signer fixed at deployment is 0x8430e0b7be3315735c303b82e4471d59ac152aa5 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x8430e0b7be3315735c303b82e4471d59ac152aa5'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

MysteryMints checks an ECDSA signature in isWhitelisted and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [isWhitelisted](https://etherscan.io/address/0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x0dad337e30af2a196f04ec1efd21ad2d6553d5b8#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x8430…2aa5](https://etherscan.io/address/0x8430e0b7be3315735c303b82e4471d59ac152aa5), an account without code.

## Reviewer notes

### Mechanism

isWhitelisted (contracts/MysteryMints.sol, line 172) recovers a signer on line 175 and tests it on line 175 against a signer fixed at deployment (WHITELIST_SIGNER() returns 0x8430e0b7be3315735c303b82e4471d59ac152aa5). Neither isValidSignature selector is in the code, so that account is never asked. WHITELIST_SIGNER is written on line 45 of contracts/MysteryMints.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-01-12, recovering 0x8430…2aa5; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
