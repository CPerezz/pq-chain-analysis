---
id: testgame-f290792b-rotate-signer-before-migrating
format: 2
title: 'TestGame: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  name: TestGame
  code: verified
  code_url: https://etherscan.io/address/0xf290792b9a2c69c5b4a1668a73c23516382be43a#code
  copies: 2
  family: a5d3e16e92969773f2fadd1f09c3466c
  upgradeable: 'no'
  admin: '0x7b4a49341c0da31cb17b70035fb8c4264fe6591a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setOracle before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  file: src/TestGame.sol
  line: 127
  has: address signer = ECDSA.recover(MessageHashUtils.toEthSignedMessageHash(hash), signature);
  says: activateNode recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  file: src/TestGame.sol
  line: 128
  has: if (signer != oracle) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  file: src/TestGame.sol
  line: 104
  has: function setOracle
  says: setOracle changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf290792b9a2c69c5b4a1668a73c23516382be43a'
  fn: oracle()(address)
  is: '0x7b4a49341c0da31cb17b70035fb8c4264fe6591a'
  says: The signer it keeps in storage is 0x7b4a49341c0da31cb17b70035fb8c4264fe6591a at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x7b4a49341c0da31cb17b70035fb8c4264fe6591a'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x93ba09b67cf5e6b19931c7336717c157ac723f53f9e696ed31c6fa4487593a78'
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

TestGame accepts a call to activateNode only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracle changes the signer.

## Evidence

- [activateNode](https://etherscan.io/address/0xf290792b9a2c69c5b4a1668a73c23516382be43a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracle](https://etherscan.io/address/0xf290792b9a2c69c5b4a1668a73c23516382be43a#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7b4a…591a](https://etherscan.io/address/0x7b4a49341c0da31cb17b70035fb8c4264fe6591a), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

activateNode (src/TestGame.sol, line 119) recovers a signer on line 127 and tests it on line 128 against the signer it keeps in storage (oracle() returns 0x7b4a49341c0da31cb17b70035fb8c4264fe6591a). Neither isValidSignature selector is in the code, so that account is never asked. setOracle (src/TestGame.sol, line 104) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-09, recovering 0x7b4a…591a; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
