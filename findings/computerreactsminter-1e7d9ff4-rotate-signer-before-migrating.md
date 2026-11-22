---
id: computerreactsminter-1e7d9ff4-rotate-signer-before-migrating
format: 2
title: 'ComputerReactsMinter: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  name: ComputerReactsMinter
  code: verified
  code_url: https://etherscan.io/address/0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbd63249d019402a8545627d366bca4cf7f4bdb73'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  file: contracts/ComputerReactsMinter.sol
  line: 48
  has: address recoveredSigner = ethSignedMessageHash.recover(signature);
  says: Mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  file: contracts/ComputerReactsMinter.sol
  line: 50
  has: require(recoveredSigner == _signer, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  file: contracts/ComputerReactsMinter.sol
  line: 85
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c'
  fn: signer()(address)
  is: '0x9a306b95b0ff309c776424b723f2602032cf9a1a'
  says: The signer it keeps in storage is 0x9a306b95b0ff309c776424b723f2602032cf9a1a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9a306b95b0ff309c776424b723f2602032cf9a1a'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x79f3ab5625e096f05bba46dcd5b26c22014e731b4d90b313d211261cfeadb7ef'
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

ComputerReactsMinter accepts a call to Mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [Mint](https://etherscan.io/address/0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x1e7d9ff44bf499eb1a3d313e9c25bb50e113903c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x9a30…9a1a](https://etherscan.io/address/0x9a306b95b0ff309c776424b723f2602032cf9a1a), an account without code.

## Reviewer notes

### Mechanism

Mint (contracts/ComputerReactsMinter.sol, line 45) recovers a signer on line 48 and tests it on line 50 against the signer it keeps in storage (signer() returns 0x9a306b95b0ff309c776424b723f2602032cf9a1a). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/ComputerReactsMinter.sol, line 85) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-15, recovering 0x9a30…9a1a; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
