---
id: example-confirmed
title: "ExampleRouter: a quantum attacker who recovers the quote signer's key can sign quotes at any price"
project: example-project
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x1111111111111111111111111111111111111111"
  implementation: null
  name: ExampleRouter
  upgradeable: "no"
  admin: "owner 0x5555555555555555555555555555555555555555 can call setSigner; nothing can change the check"
  value_usd: 1200000
  value_basis: held
  value_as_of: 2026-11-10
  last_active: 2026-11-09
  txs_30d: 4200
families: []
fix:
  layer: new-deployment
  who_acts: "the ExampleRouter team: deploy a router that verifies a post-quantum signature and move market makers to it"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
sources:
- by: other
  study: example-study
  who: example-author
  ref: https://github.com/example/example-study-code/blob/0123456789abcdef0123456789abcdef01234567/notes/router.md
  date: 2026-11-10
  verdict: reported
  rating: MEDIUM
related: []
---

## Summary

`ExampleRouter` fills a swap when the quote carries a signature from one stored key. Whoever recovers that key from its
public key can sign quotes at any price and drain what the router holds, about USD 1.2M on 2026-11-10. The owner can
replace the key but not the kind of signature, so the fix is a new router.

## Mechanism

`fill(Quote q, bytes sig)` computes the EIP-712 digest of `q` and requires `ecrecover(digest, v, r, s) == signer`
(pattern PQ-4). `signer` is one address set by `setSigner`, which only the owner can call. There is no other way to
authorise a quote.

## Evidence

- CHECKED (verified source, Sourcify, `ExampleRouter.sol` lines 88 to 96): the check quoted below is the only one on
  the path to the transfer.
- CHECKED (state read at block 26,431,214): `signer()` returns `0x6666…6666`; `owner()` returns `0x5555…5555`; the
  EIP-1967 implementation slot is empty, so the code cannot change.
- INFERRED: the signer key has signed on-chain quotes, so its public key is known.

```solidity
88    function fill(Quote calldata q, bytes calldata sig) external {
89        bytes32 digest = _hashTypedDataV4(_hash(q));
90        (uint8 v, bytes32 r, bytes32 s) = _split(sig);
91        require(ecrecover(digest, v, r, s) == signer, "bad quote");
92        _settle(q);
93    }
```

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x11111111…` ExampleRouter | no | USD 1.2M (held) | 2026-11-09 | 4,200 |

## Remediation

A new router that verifies a post-quantum signature, or a signer contract checked through ERC-1271. Rotating the key
does not help: the new key is recoverable the same way. No protocol change is needed.

## History

- 2026-11-10: reported by example-author from example-study. Rated MEDIUM: fixable without a protocol change, by a
  new deployment.
