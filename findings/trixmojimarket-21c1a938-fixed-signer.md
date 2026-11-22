---
id: trixmojimarket-21c1a938-fixed-signer
format: 2
title: 'TrixmojiMarket: its signer cannot be replaced and must not take real code'
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
  address: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  name: TrixmojiMarket
  code: verified
  code_url: https://etherscan.io/address/0x21c1a938d06f87a039abfc48d1ccb459f55b1685#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  file: trixmoji/contracts/TrixmojiMarket.sol
  line: 87
  has: require(digest.recover(signature) == verifier, "invalid verifier");
  says: _approve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  file: trixmoji/contracts/TrixmojiMarket.sol
  line: 46
  has: verifier = verifier_; creator = creator_;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x21c1a938d06f87a039abfc48d1ccb459f55b1685'
  fn: verifier()(address)
  is: '0x5f5d219c6b3f732ebdce4bfd9c4655957ff472c4'
  says: A signer fixed at deployment is 0x5f5d219c6b3f732ebdce4bfd9c4655957ff472c4 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x5f5d219c6b3f732ebdce4bfd9c4655957ff472c4'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xad892c26b94ebc5d806b109cf7dddc4df5e8a77620f5564fd30c52da61effd24'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

TrixmojiMarket checks an ECDSA signature in _approve and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_approve](https://etherscan.io/address/0x21c1a938d06f87a039abfc48d1ccb459f55b1685#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x21c1a938d06f87a039abfc48d1ccb459f55b1685#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x5f5d…72c4](https://etherscan.io/address/0x5f5d219c6b3f732ebdce4bfd9c4655957ff472c4), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_approve (trixmoji/contracts/TrixmojiMarket.sol, line 82) recovers a signer on line 87 and tests it on line 87 against a signer fixed at deployment (verifier() returns 0x5f5d219c6b3f732ebdce4bfd9c4655957ff472c4). Neither isValidSignature selector is in the code, so that account is never asked. verifier is written on line 46 of trixmoji/contracts/TrixmojiMarket.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x5f5d…72c4; 18 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
