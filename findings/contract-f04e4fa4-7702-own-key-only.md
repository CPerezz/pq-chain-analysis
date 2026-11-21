---
id: contract-f04e4fa4-7702-own-key-only
format: 2
title: Accounts using this 7702 logic lose signed calls if they take real code
status: confirmed
severity: INFORMATIONAL
justification: Keeps working under the change; it breaks only if an account moves to real code, so it is a notice.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853'
  code: bytecode
  code_url: https://etherscan.io/address/0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853#code
  copies: 606
  family: ed84a1cc47194cc107f7b5257c401d2a
value:
  usd: 10980
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Keep the EIP-7702 delegation, or move the funds out, before giving an account this logic as real code.
evidence_level: executed
checks:
- id: deleg
  code: '0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853'
  is: delegation
  bytes: 23
  target: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  says: the account is an externally owned account delegating to this logic
  for:
  - evidence-3
  - whose
- id: entry
  bytecode: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  has: 63143ca9b0
  says: the logic dispatches selector 0x143ca9b0, the signed batch
  for:
  - what
- id: recover
  bytecode: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  has: 60019060a0016020604051602081039080840390855afa
  says: the signature is recovered with a STATICCALL to the ecrecover precompile (address 1) with all remaining
    gas
  for:
  - evidence-1
  - what
- id: self-sig
  bytecode: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  has: 6001600160a01b03811630146102465760405162461bcd60e51b8152602060048201526011602482015270496e76616c6964207369676e6174757265
  says: the recovered address must equal the account's own address, else it reverts with Invalid signature
  for:
  - action
  - evidence-1
  - what
- id: self-only
  bytecode: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  has: '3330146103'
  says: the unsigned functions require the caller to be the account itself
  for:
  - action
  - what
- id: no1271
  bytecode: '0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a'
  has: 631626ba7e
  absent: true
  says: the logic never calls isValidSignature
  for:
  - what
- id: signed-nonce
  call: '0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853'
  fn: nonces(address)(uint256)
  args:
  - '0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853'
  is: 1
  says: this account has run one signed batch
  for:
  - evidence-3
- id: acct-nonce
  nonce: '0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853'
  is: 3
  says: the account's key has sent transactions
  for:
  - evidence-3
- id: replay-today
  replay: '0xbeab8ab39459fd9ea3c02141f20e0891b554e7c99d08fd90b4c00435cb0d028e'
  run: today
  ok: true
  says: the relayed signed batch to an account delegating to this logic succeeds as recorded
  for:
  - evidence-2
  - justification
- id: replay-8151
  replay: '0xbeab8ab39459fd9ea3c02141f20e0891b554e7c99d08fd90b4c00435cb0d028e'
  run: eip8151
  ok: true
  says: under EIP-8151 with the delegation in place it still succeeds
  for:
  - evidence-2
  - justification
  - what
- id: replay-real
  replay: '0xbeab8ab39459fd9ea3c02141f20e0891b554e7c99d08fd90b4c00435cb0d028e'
  run: eip8151_self_real_code
  ok: false
  says: with this logic as real code at the account it reverts
  for:
  - action
  - evidence-2
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

This EIP-7702 account logic runs a batch of calls when a signature recovers to the account itself. An EIP-7702 delegation keeps working under the change. An account that takes this logic as real code can no longer sign for itself, so what it holds is locked.

## Evidence

- [The logic](https://etherscan.io/address/0xfb1b8fb55d1aabeb96bc1c36a9754b28e46a8b6a#code) compares the recovered address with the account's own address and reverts with "Invalid signature" otherwise.
- [A relayed batch](https://etherscan.io/tx/0xbeab8ab39459fd9ea3c02141f20e0891b554e7c99d08fd90b4c00435cb0d028e) still succeeds when replayed under the change, and reverts once the account holds this logic as real code.
- [This account](https://etherscan.io/address/0xf04e4fa4a7d6cf552f69d40186979aaec8c6d853) delegates to this logic and has run one batch.

## Reviewer notes

### Mechanism

The address is an externally owned account whose code is an EIP-7702 delegation to 0xfb1b8fb5 (unverified, 3,189 bytes, read from the disassembly). Selector 0x143ca9b0 takes a list of calls, a deadline and a 65-byte signature, checks the deadline, recovers the signer with one STATICCALL to the ecrecover precompile that passes all remaining gas, and requires the recovered address to equal ADDRESS (the account itself), else reverts with "Invalid signature". It then increments nonces(address(this)) and runs the calls. The two other state-changing functions (0xb61d27f6, 0xb6e0b5ae) require CALLER == ADDRESS: a direct call from the account itself. The only SSTOREs write the nonce mapping keyed by ADDRESS; there is no stored key and no isValidSignature call. With real code at the account, ecrecover returns nothing for its key, and EIP-3607 stops the account from sending transactions, so neither path runs and funds sent to it stay put. As a delegation, EIP-8151 still recovers the account, which the replay confirms.

### Checks

- Header facts: this address alone, at block 26,438,999; 606 addresses run this code.
- Ruled out: an ERC-1271 or second-key path: the code pushes no isValidSignature selector, has one STATICCALL (the precompile) and stores only the nonce.
- Ruled out: a direct path that survives: 0xb61d27f6 and 0xb6e0b5ae accept only the account itself as caller, and an account with real code cannot send transactions.
- Ruled out: a gas finding: the recovery passes all remaining gas, and the replay under EIP-8151 alone succeeds (65,477 gas of a 200,000 limit), so no rated issue sits beside this notice.
- Ruled out: a bundled replay: the replayed transaction carries one call, a USDT transfer, which checks no signature; only this logic's own check fails when the account holds real code.
- Ruled out: an unused or dead account: this address has sent 3 transactions and run one signed batch (nonces = 1); the logic is delegated to by 606 accounts.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
