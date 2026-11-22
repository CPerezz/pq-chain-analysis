---
id: accountablepushoracle-43348357-rotate-signer-before-migrating
format: 2
title: 'AccountablePushOracle: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  name: AccountablePushOracle
  code: verified
  code_url: https://etherscan.io/address/0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb2a3cf69c97afd4de7882e5fee120e4efc77b706'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setObserver before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  file: contracts/tranches/oracles/valuation/AccountablePushOracle.sol
  line: 68
  has: if (ECDSA.recover(digest, signature) != observer) {
  says: pushProofOfReserve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  file: contracts/tranches/oracles/valuation/AccountablePushOracle.sol
  line: 31
  has: function setObserver
  says: setObserver changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc'
  fn: observer()(address)
  is: '0x6970791f36128c69574046c4135dc7e3cb38c52c'
  says: The signer it keeps in storage is 0x6970791f36128c69574046c4135dc7e3cb38c52c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6970791f36128c69574046c4135dc7e3cb38c52c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7191567d9efe6066767041c36123739f1cb5447edddc2c8b3bdee98f3d7be382'
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

AccountablePushOracle accepts a call to pushProofOfReserve only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setObserver changes the signer.

## Evidence

- [pushProofOfReserve](https://etherscan.io/address/0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setObserver](https://etherscan.io/address/0x433483570b69691a9e1e4ef9791a4ca92dd8c1fc#code) changes the signer (through _setObserver); only the owner can call it.
- The signer at the block is [0x6970…c52c](https://etherscan.io/address/0x6970791f36128c69574046c4135dc7e3cb38c52c), an account without code.

## Reviewer notes

### Mechanism

pushProofOfReserve (contracts/tranches/oracles/valuation/AccountablePushOracle.sol, line 42) recovers a signer on line 68 and tests it on line 68 against the signer it keeps in storage (observer() returns 0x6970791f36128c69574046c4135dc7e3cb38c52c). Neither isValidSignature selector is in the code, so that account is never asked. _setObserver (contracts/tranches/oracles/valuation/AccountablePushOracle.sol, line 82) writes it, called by setObserver. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-20, recovering 0x6970…c52c; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
