---
id: policywalletethgasless-9789a532-rotate-signer-before-migrating
format: 2
title: 'PolicyWalletEthGasless: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9789a532043929f13f9c0f691daae275c78282cd'
  name: PolicyWalletEthGasless
  code: verified
  code_url: https://etherscan.io/address/0x9789a532043929f13f9c0f691daae275c78282cd#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc43c8660984cc6aa31b4660e2ca7013e5b132bb4'
value:
  usd: 9
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setGuardian before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9789a532043929f13f9c0f691daae275c78282cd'
  file: ethereum-guardian.sol
  line: 113
  has: require(_recover(message, signature) == guardian, "bad guardian sig");
  says: approvePayoutMeta recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9789a532043929f13f9c0f691daae275c78282cd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9789a532043929f13f9c0f691daae275c78282cd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x9789a532043929f13f9c0f691daae275c78282cd'
  file: ethereum-guardian.sol
  line: 160
  has: function setGuardian
  says: setGuardian changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9789a532043929f13f9c0f691daae275c78282cd'
  fn: guardian()(address)
  is: '0x7a0f44b598517a6dd1cd054fe5bdf2a1fcba1e38'
  says: The signer it keeps in storage is 0x7a0f44b598517a6dd1cd054fe5bdf2a1fcba1e38 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x7a0f44b598517a6dd1cd054fe5bdf2a1fcba1e38'
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

PolicyWalletEthGasless accepts a call to approvePayoutMeta only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setGuardian changes the signer.

## Evidence

- [approvePayoutMeta](https://etherscan.io/address/0x9789a532043929f13f9c0f691daae275c78282cd#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setGuardian](https://etherscan.io/address/0x9789a532043929f13f9c0f691daae275c78282cd#code) changes the signer.
- The signer at the block is [0x7a0f…1e38](https://etherscan.io/address/0x7a0f44b598517a6dd1cd054fe5bdf2a1fcba1e38), an account without code.

## Reviewer notes

### Mechanism

approvePayoutMeta (ethereum-guardian.sol, line 108) recovers a signer on line 113 and tests it on line 113 against the signer it keeps in storage (guardian() returns 0x7a0f44b598517a6dd1cd054fe5bdf2a1fcba1e38). Neither isValidSignature selector is in the code, so that account is never asked. setGuardian (ethereum-guardian.sol, line 160) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-24, recovering 0x7a0f…1e38; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
