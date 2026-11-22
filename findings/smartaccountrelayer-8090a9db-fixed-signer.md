---
id: smartaccountrelayer-8090a9db-fixed-signer
format: 2
title: 'SmartAccountRelayer: its signer cannot be replaced and must not take real code'
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
  address: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  name: SmartAccountRelayer
  code: verified
  code_url: https://etherscan.io/address/0x8090a9db6aca56ffa186c75ca0787b18af1058a0#code
  copies: 3
  family: c39929235d707649d6fc0e41ae925ee4
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13731
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  file: src/SmartAccountRelayer.sol
  line: 73
  has: if (recoverSigner(ethSignedMessageHash, signature) != authorizedCaller) {
  says: relayOperation recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  file: src/SmartAccountRelayer.sol
  line: 44
  has: authorizedCaller = _authorizedCaller;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x8090a9db6aca56ffa186c75ca0787b18af1058a0'
  fn: authorizedCaller()(address)
  is: '0xe78288221aae3a0d3ddf8fa08d3602c3014eed7a'
  says: A signer fixed at deployment is 0xe78288221aae3a0d3ddf8fa08d3602c3014eed7a at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe78288221aae3a0d3ddf8fa08d3602c3014eed7a'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x64801c6c4ebe1caf96f2e1ef5b2762774bffaebea0639602a6f44d7c0dd94abd'
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

SmartAccountRelayer accepts a call to relayOperation only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [relayOperation](https://etherscan.io/address/0x8090a9db6aca56ffa186c75ca0787b18af1058a0#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x8090a9db6aca56ffa186c75ca0787b18af1058a0#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xe782…ed7a](https://etherscan.io/address/0xe78288221aae3a0d3ddf8fa08d3602c3014eed7a), an account without code.

## Reviewer notes

### Mechanism

relayOperation (src/SmartAccountRelayer.sol, line 59) recovers a signer on line 73 and tests it on line 73 against a signer fixed at deployment (authorizedCaller() returns 0xe78288221aae3a0d3ddf8fa08d3602c3014eed7a). Neither isValidSignature selector is in the code, so that account is never asked. authorizedCaller is written on line 44 of src/SmartAccountRelayer.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0xe782…ed7a; 13,731 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
