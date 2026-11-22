---
id: evolutionserum-adae0dda-fixed-signer
format: 2
title: 'EvolutionSerum: its signer cannot be replaced and must not take real code'
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
  address: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  name: EvolutionSerum
  code: verified
  code_url: https://etherscan.io/address/0xadae0ddaf90170a44adebcfb8eede12041d13220#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7077e6eb69711cb89d53a51a1db1436e9522db02'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 33
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  file: EvolutionSerum.sol
  line: 124
  has: return recoverSigner(ethSignedMessageHash, signature) == evolutionSigner;
  says: validMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  file: EvolutionSerum.sol
  line: 29
  has: address constant public evolutionSigner = 0x00000001DEA29D000f2e99100C503bf1544Da95d;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xadae0ddaf90170a44adebcfb8eede12041d13220'
  fn: evolutionSigner()(address)
  is: '0x00000001dea29d000f2e99100c503bf1544da95d'
  says: A signer fixed at deployment is 0x00000001dea29d000f2e99100c503bf1544da95d at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x00000001dea29d000f2e99100c503bf1544da95d'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

EvolutionSerum accepts a call to validMint only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [validMint](https://etherscan.io/address/0xadae0ddaf90170a44adebcfb8eede12041d13220#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xadae0ddaf90170a44adebcfb8eede12041d13220#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x0000…a95d](https://etherscan.io/address/0x00000001dea29d000f2e99100c503bf1544da95d), an account without code.

## Reviewer notes

### Mechanism

validMint (EvolutionSerum.sol, line 118) recovers a signer on line 124 and tests it on line 124 against a signer fixed at deployment (evolutionSigner() returns 0x00000001dea29d000f2e99100c503bf1544da95d). Neither isValidSignature selector is in the code, so that account is never asked. evolutionSigner is written on line 29 of EvolutionSerum.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 33 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
