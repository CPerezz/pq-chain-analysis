---
id: bridge-cbb53f02-rotate-signer-before-migrating
format: 2
title: 'Bridge: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  name: Bridge
  code: verified
  code_url: https://etherscan.io/address/0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4#code
  copies: 1
  upgradeable: 'no'
  admin: '0x32d021f3cb2b86df799f462eec15147774e31d48'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setVerifyAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  file: Bridge.sol
  line: 652
  has: return (recoverSigner(message, signature) == verifyAddress);
  says: transferAnyERC20Token recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  file: Bridge.sol
  line: 600
  has: function setVerifyAddress
  says: setVerifyAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4'
  fn: verifyAddress()(address)
  is: '0x072bc8750a0852c0eac038be3e7f2e7c7dab1e94'
  says: The signer it keeps in storage is 0x072bc8750a0852c0eac038be3e7f2e7c7dab1e94 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x072bc8750a0852c0eac038be3e7f2e7c7dab1e94'
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

Bridge accepts a call to transferAnyERC20Token only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifyAddress changes the signer.

## Evidence

- [transferAnyERC20Token](https://etherscan.io/address/0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifyAddress](https://etherscan.io/address/0xcbb53f02d29ec2ae25e378a94dc701442b1f2aa4#code) changes the signer; only the owner can call it.
- The signer at the block is [0x072b…1e94](https://etherscan.io/address/0x072bc8750a0852c0eac038be3e7f2e7c7dab1e94), an account without code.

## Reviewer notes

### Mechanism

transferAnyERC20Token (Bridge.sol, line 637) recovers a signer on line 652 and tests it on line 652 against the signer it keeps in storage (verifyAddress() returns 0x072bc8750a0852c0eac038be3e7f2e7c7dab1e94). Neither isValidSignature selector is in the code, so that account is never asked. setVerifyAddress (Bridge.sol, line 600) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-25, recovering 0x072b…1e94; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
