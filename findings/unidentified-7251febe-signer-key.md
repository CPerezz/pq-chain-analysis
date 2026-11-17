---
id: unidentified-7251febe-signer-key
title: "Unidentified DEX aggregator router 0x7251febe: one operator ECDSA key co-signs every route; a recovered key lets anyone run unapproved routes with their own funds, reaching only the router's $13"
project: unidentified-7251febe
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x7251febeabb01ec9de53ece7a96f1c951f886dd2"
  implementation: "0x85461e163c64f99a8709dff3bab0db808c358bd6"
  name: TransparentUpgradeableProxy → unverified aggregator router
  upgradeable: "yes"
  admin: ProxyAdmin 0xbfd7909f709abdb12999fd541beba56e299c817d, owner EOA 0x66a2d663f73d151e7ef552196de163d8023bc39e (also the router's owner, who sets the operator); operator EOA 0xfe651ec9eeb964d814c8a628a6312462e9456712 (block 26431713)
  value_usd: 13
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 920
families: []
fix:
  layer: contract-upgrade
  who_acts: owner EOA 0x66a2d663f73d151e7ef552196de163d8023bc39e (ProxyAdmin 0xbfd7909f709abdb12999fd541beba56e299c817d)
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7251febe-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (bytecode and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7251febe-signer-key/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

An unverified swap router behind proxy `0x7251febe…` (same address on Base, OP, BNB Chain, Polygon, Arbitrum and Avalanche) requires each route to carry a signature, with a deadline, from its `operator` key, checked with ECDSA (PQ-4). A quantum attacker who recovers the operator key from its signatures in calldata can sign routes the operator never approved. The router pulls tokens only from the caller (`claimTokens(token, msg.sender, …)` at every call site), so other users' approvals cannot be reached; what a forged route can take is the router's own balance, $13 on 2026-11-17. Rated LOW: step 4 gives MEDIUM (an EOA can upgrade the proxy), lowered by step 5 (under USD 50k).

## Mechanism

- User entry `0xec5b999d` (unresolved name; 40 of 50 sampled transactions): calldata carries the input tokens and amounts, adapter calls, a deadline and a 65-byte signature (sample `0x595c5203…`: deadline `0x69ba7b35`).
- In the implementation, at offsets `0x123f`-`0x126f`: `keccak256` of the encoded route, then an OpenZeppelin-style ECDSA recover (the bytecode carries the `s <= n/2` constant), then a comparison with storage slot `0x9a`, the slot `operator()` returns. `setOperator(address)` changes the key.
- Tokens are pulled through `approveProxy` (`0x70cbb871…`) with `claimTokens(token, from, to, amount)`; all three call sites (`0x14ad`, `0x15bf`, `0x19dc`) pass `CALLER` as `from`.
- Pattern PQ-4: one operator key; rotating it does not help.

## Evidence

- CHECKED (bytecode of implementation `0x85461e16…`, 10,177 bytes, unverified on Ethereum and on the other chains checked): selectors `execute(...)`, `operator()`, `setOperator`, `registeredAdapters`, `approveProxy`, `setApproveProxy`, `feeRate`, `changeFeeRate`, `withdrawDust`, `owner`; the signature check and `claimTokens` call sites above ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7251febe-signer-key/review.json)).
- CHECKED (on-chain, block 26,431,713): EIP-1967 implementation `0x85461e16…`, admin ProxyAdmin `0xbfd7909f…`, whose `owner()` is EOA `0x66a2d663…`; router `owner()` the same EOA; `operator()` EOA `0xfe651ec9…`; `approveProxy()` `0x70cbb871…`; `feeRate()` 0.
- CHECKED (holdings, block 26,431,214): 0.00075 ETH and $11.5 of tokens ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7251febe-signer-key/onchain.json)).
- CHECKED (precompile trace, last year): 29,864 transactions with ecrecover (`txs_y1`); Xatu: 920 transactions 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-7251febe-signer-key/activity.json)).
- NOT ESTABLISHED: the project behind the router (creator `0xec60bb16…`, owner and operator EOAs carry no labels; implementations are unverified on every chain checked).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7251febe…` router proxy | yes (EOA ProxyAdmin owner) | $13 | 2026-11-16 | 920 |

- Exposed: the router's own balance, $13. Users' approvals to `approveProxy` are not reachable through a forged route, since tokens are taken only from the caller. A forged signature lets the attacker route its own funds through adapters without the operator's consent.
- Removed the draft family entry (`0x1995bb51…`, 63 proxies): it groups contracts that share the generic TransparentUpgradeableProxy bytecode with unrelated implementations (its representative is a Symbiosis BridgeV2 proxy).

## Remediation

- The owner EOA `0x66a2d663…` upgrades the implementation to verify operator approvals with a post-quantum scheme (ERC-7913 verifier for an ML-DSA or hash-based key), or drops the operator signature if it only gates route selection.
- The owner and ProxyAdmin control rest on one ECDSA EOA (PQ-12), a larger quantum exposure than the operator key: whoever recovers it can upgrade the router, and an upgraded router could ask `approveProxy` for tokens users approved to it (INFERRED; `approveProxy` is unverified and its caller checks were not read).
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM -> LOW, step 5: bytecode shows tokens are pulled only from the caller, so the exposure is the router's $13. Signature compared with `operator()` read in bytecode, so status candidate -> confirmed (evidence stays bytecode). Removed an unrelated proxy-bytecode family. Project not identified.

# Source excerpts: unidentified-7251febe-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7251febeabb01ec9de53ece7a96f1c951f886dd2` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x85461e163c64f99a8709dff3bab0db808c358bd6`

No verified source on Sourcify or Blockscout.
