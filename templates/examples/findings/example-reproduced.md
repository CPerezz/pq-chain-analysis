---
id: example-reproduced
title: "ExampleToken: a permit that succeeds today reverts when ecrecover returns nothing for the holder"
project: example-project
status: reproduced
severity: LOW
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: liveness
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x2222222222222222222222222222222222222222"
  implementation: null
  name: ExampleToken
  upgradeable: "no"
  admin: "none: no proxy and no owner"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-09
  txs_30d: 910
families: []
fix:
  layer: account-migration
  who_acts: "holders: approve on-chain instead of signing a permit"
  protocol_change: not-needed
evidence:
  level: executed
  block: 26435437
repro:
  code: https://github.com/example/eip-replay/tree/0123456789abcdef0123456789abcdef01234567
  command: "python -m eip_replay replay 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa --change changes/ecrecover-returns-nothing.json"
  inputs:
    block: 26435438
    tx: "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  expect:
    before: {status: "0x1", gas_used: 76460}
    after: {status: "0x0"}
sources:
- by: other
  study: example-study
  who: example-author
  ref: https://github.com/example/example-study-code/blob/0123456789abcdef0123456789abcdef01234567/notes/token.md
  date: 2026-11-10
  verdict: reported
  rating: LOW
related: []
---

## Summary

`ExampleToken.permit` accepts only an `ecrecover` signature. Replaying a real permit with `ecrecover` made to return
nothing turns a successful transaction into a revert. Nothing is lost: the holder can still call `approve`.

## Mechanism

`permit` requires `ecrecover(digest, v, r, s) == owner` (pattern PQ-1) and has no ERC-1271 branch. When the precompile
returns empty output, Solidity reads the recovered address as zero and the `require` fails.

## Evidence

- CHECKED (verified source, `ExampleToken.sol` lines 140 to 152): the check quoted below.
- CHECKED (executed, state before the transaction in block 26,435,438): the command in the header prints status `0x1`
  with 76,460 gas before, equal to the real receipt, and status `0x0` after.

```solidity
148        address recovered = ecrecover(digest, v, r, s);
149        require(recovered != address(0) && recovered == owner, "invalid signature");
```

## Impact and exposure

No value is exposed. The permit path stops working for the holder; `approve` and `transfer` do not.

## Remediation

None needed in the contract. Holders approve on-chain.

## History

- 2026-11-10: reproduced by example-author from example-study with the command in the header. Rated LOW: an
  alternative path exists and nothing can be taken.
