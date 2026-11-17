---
id: magpie-router-signer
title: "Magpie / Fly.trade MagpieRouterV3_1 (idle since July 2026): a quantum attacker who recovers a relayer key and a migrated user's old ECDSA key can spend the user's approvals through swapWithUserSignature; a forged Magpie quote signature only moves the attacker's own funds"
project: magpie
status: confirmed
severity: LOW
patterns: [PQ-4, PQ-1]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xa6e941eab67569ca4522f70d343714ff51d571c4"
  implementation: null
  name: MagpieRouterV3_1
  upgradeable: config-only
  admin: "Ownable2Step owner 0xc8d7d0bd61c5ca5a493a229f6754da5560f486ae (EOA): updateInternalCaller, pause, updateCoreAddress"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-07-07
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Magpie / Fly.trade owner EOA 0xc8d7d0bd61c5ca5a493a229f6754da5560f486ae: updateInternalCaller(caller, false) for every internal caller and pause(); a replacement router would verify post-quantum relayer signatures and users' ERC-1271 signatures"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/magpie-router-signer/classification.jsonl
  - evidence/magpie-router-signer/onchain.json
  - evidence/magpie-router-signer/activity.json
  - evidence/magpie-router-signer/source-excerpts.md
  - evidence/magpie-router-signer/reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review13 (re-read verified source on Sourcify; owner and pause reads)
  ref: evidence/magpie-router-signer/reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

MagpieRouterV3_1 has two `ecrecover`-only paths. `swapWithMagpieSignature` needs a quote signed by a whitelisted
Magpie "internal caller" key, but always spends the caller's own tokens, so forging that key gains only fee and route
freedom (PQ-4, nothing taken). `swapWithUserSignature` spends the tokens of whoever signed the swap (PQ-1), but only a
whitelisted internal caller may submit it; a quantum attacker who recovers a relayer key and the old key of a user who
migrated to a post-quantum account could drain that user's approvals to the router. The router has had no transaction
since 2026-07-07 and holds about USD 2; users' approvals were not measured. Rated LOW (step 4): one known owner can
switch both paths off by removing the internal callers and pausing.

## Mechanism

- `swapWithMagpieSignature` (`contracts/MagpieRouterV3_1.sol` 178-186, `whenNotPaused`) calls
  `verifySignature(swapData, true)` (lines 71-99), which builds the EIP-712 `Swap(...)` digest over router, sender,
  recipient, assets, deadline, amounts and fees and calls `LibRouter.verifySignature` (`contracts/libraries/LibRouter.sol`
  202-262): with `useCaller` it recovers the signer with `recoverSigner` (raw `ecrecover`, lines 153-174) and requires
  `internalCaller[signer]`; `fromAddress` is `msg.sender` (lines 244-255).
- `swapWithUserSignature` (lines 189-200, `onlyInternalCaller`) calls `verifySignature(swapData,
  false)`: `fromAddress = recoverSigner(digest, r, s, v)` (lines 256-260). No ERC-1271 path.
- `swap` (lines 106-158) then does `fromAssetAddress.transferFrom(fromAddress, router, amountIn)` and forwards to the
  core contract; an optional EIP-2612 `permit` for `fromAddress` is applied first (`LibRouter.permit`).
- Patterns PQ-4 (internal-caller key) and PQ-1 (user signature, `ecrecover` only). Excerpts:
  [`source-excerpts.md`](../evidence/magpie-router-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the paths above.
- CHECKED (on-chain, block 26,431,214): no proxy; holds about USD 2 of USDC/USDT dust
  ([`onchain.json`](../evidence/magpie-router-signer/onchain.json)).
- CHECKED (on-chain, block 26,431,592, [`reads.json`](../evidence/magpie-router-signer/reads.json)): `owner()` =
  `0xc8d7d0bd61c5ca5a493a229f6754da5560f486ae`, code size 0 (an EOA, also the deployer); `paused()` = false.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 146,770
  transactions. Xatu: no transaction 2026-10-16 to 2026-11-16, last 2026-07-07
  ([`activity.json`](../evidence/magpie-router-signer/activity.json)); the newest direct transactions on Blockscout
  are users calling `swapWithMagpieSignature` (2026-05-06).
- Not established: the current internal-caller set (the `UpdateInternalCaller` logs could not be scanned with the
  public RPCs available) and whether the internal callers are EOAs.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa6e941ea…` MagpieRouterV3_1 | config-only | — (USD 2 dust) | 2026-07-07 | 0 |

What can be taken is what migrated users still have approved to this router, and only together with a forged
internal-caller key; allowances were not enumerated, so `value_usd` is `null` (the router's USD 2 is dust, not the
exposure). No other Magpie deployment is in the registry.

## Remediation

- Owner EOA `0xc8d7d0bd…`: `updateInternalCaller(caller, false)` for every internal caller, which disables both
  signature paths, and `pause()`. The router is idle, so this costs nothing.
- A replacement router should verify relayer quotes with a post-quantum signer and accept users' ERC-1271 signatures
  with code checked first.
- Users: revoke approvals to `0xa6e941ea…`. EIP-8151 would protect migrated users without Magpie acting.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM -> LOW, step 4: the operator-key path spends only the caller's own funds, and the user-signature path is reachable only by whitelisted internal callers that one known owner can remove; the router is idle since 2026-07-07. Added PQ-1; `fix.layer` new-deployment -> onchain-config; removed the USD 2 `held` value.
