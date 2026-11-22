---
id: attestationoracle-b53977a7-rotate-signer-before-migrating
format: 2
title: 'AttestationOracle: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb53977a70d755a56d3ce26926acb4c33f7861c61'
  name: AttestationOracle
  code: verified
  code_url: https://etherscan.io/address/0x870deb459512099e70e9a640cf3140a0d969fc18#code
  proxy_of: '0x870deb459512099e70e9a640cf3140a0d969fc18'
  copies: 2
  family: 1268274390bb20ff5e70a60c6ceef038
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 209
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x870deb459512099e70e9a640cf3140a0d969fc18'
  file: src/AttestationOracle.sol
  line: 227
  has: address signer = ECDSA.recover(digest, signatures[i]);
  says: attest recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x870deb459512099e70e9a640cf3140a0d969fc18'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x870deb459512099e70e9a640cf3140a0d969fc18'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x870deb459512099e70e9a640cf3140a0d969fc18'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x759c2cd90594fdb114c5d37c5c3ea78a0033ed35'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xf8c30bd35371fc37384f77b24e132e57100f6758b44f24f75ae51e89b8bce0d9'
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

AttestationOracle accepts a call to attest only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [attest](https://etherscan.io/address/0x870deb459512099e70e9a640cf3140a0d969fc18#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x870deb459512099e70e9a640cf3140a0d969fc18#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xf8c30bd35371fc37384f77b24e132e57100f6758b44f24f75ae51e89b8bce0d9) on record recovered [0x759c…ed35](https://etherscan.io/address/0x759c2cd90594fdb114c5d37c5c3ea78a0033ed35), an account without code.

## Reviewer notes

### Mechanism

attest (src/AttestationOracle.sol, line 130) recovers a signer on line 227 and tests it on line 227 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x759c…ed35; 209 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
