---
id: pulsechain-bridge-validators
title: "PulseChain bridge: a quantum attacker who recovers 5 of the 8 validator ECDSA keys can relay forged messages through the Ethereum ForeignAMB and drain the PulseChain Omnibridge (USD 40.1M)"
project: pulsechain
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-18]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xd0764fae29e0a6a96ff685f71cfc685456d5636c"
  implementation: "0xe98699957d3504acd57fff861e4b77b57eb02467"
  name: ForeignAMB (EternalStorageProxy; Ethereum side of the Ethereum-PulseChain bridge, destinationChainId 369)
  upgradeable: "yes"
  admin: "upgradeabilityOwner EOA 0xdf5d165a7eb95d26355c56d53799b7da1240e585; owner EOA 0x0fb17adb94627eea37bb7ef12f85ab4590e3805f; validator set 0x2fa878ab3f87cc1c9737fc071108f904c0b0c95d owned by EOA 0x3ea02ef8a3956f69d23b5b30327e0f5e352e513f (read at block 26431561)"
  value_usd: 40094354
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 6574
families: []
fix:
  layer: contract-upgrade
  who_acts: "PulseChain bridge operators: upgradeabilityOwner EOA 0xdf5d165a7eb95d26355c56d53799b7da1240e585 upgrades the ForeignAMB implementation to a post-quantum verification (and the Omnibridge 0x1715a3e4a142d8b698131108995174f37aeba10d upgradeabilityOwner EOA 0x13a9594a2696d3c35f9d6e4be6b332f699c57801 if needed)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431561
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pulsechain-bridge-validators
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1e8644eb"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [eternalstorageproxy-4c36d291-validator-signatures, eternalstorageproxy-4aa42145-validator-signatures]
---

## Summary

The Ethereum side of the PulseChain bridge (a fork of the Gnosis/POA AMB and Omnibridge) executes any message from
PulseChain that carries ECDSA signatures from 5 of its 8 validators (PQ-5). A quantum attacker who recovers five
validator keys from their on-chain signatures can relay a forged `handleBridgedTokens` call to the PulseChain
ForeignOmnibridge `0x1715a3e4…`, which held at least USD 40.1M at block 26,431,561. The AMB is upgradeable by a
single EOA. Rated MEDIUM: step 4 (fix by a contract upgrade by one known owner).

## Mechanism

- `executeSignatures(_data, _signatures)` and the `safeExecuteSignatures*` wrappers (verified `ForeignAMB.sol`, lines
  1514-1568) call `_allowMessageExecution` (line 1577) → `Message.hasEnoughValidSignatures(_data, _signatures,
  validatorContract(), true)` (lines 106-140): for `requiredSignatures()` entries it runs `ecrecover(hash, v, r, s)`
  and requires `validatorContract.isValidator(recovered)` with no duplicates.
- `_executeMessage` (line 1597) then checks only message version, destination chain and replay, and calls the
  executor (`processMessage`). No Hashi or other second check exists in this implementation.
- Executors seen in recent `RelayedMessage` events: ForeignOmnibridge `0x1715a3e4…` (most messages),
  ForeignOmnibridge `0xe20e337d…`, and `0x81374cd4…` (Blockscout: HexMirrorRegistrar).
- Pattern PQ-5. The draft's source excerpt for this address was empty (the proxy source has no check); the lines above
  are from the implementation `0xe9869995…` on Sourcify.

## Evidence

- CHECKED (verified source on Sourcify, implementation `0xe9869995…`, read 2026-11-17): the lines above.
- CHECKED (`cast call` at block 26,431,561): `implementation()` `0xe9869995…`, `sourceChainId()` 1,
  `destinationChainId()` 369 (PulseChain), `upgradeabilityOwner()` `0xdf5d165a…`, `owner()` `0x0fb17adb…` (both EOAs
  with nonce 0), `validatorContract()` `0x2fa878ab…` with `requiredSignatures()` 5 and 8 validators, owned by EOA
  `0x3ea02ef8…`; `hashiManager()` reverts ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pulsechain-bridge-validators/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): the AMB and both Omnibridges were created by `0x30e22ab6…`; both Omnibridges
  return `bridgeContract()` = this AMB; owner `0x610094ab…` and upgradeabilityOwner `0x13a9594a…` are EOAs.
- CHECKED (precompile trace): 98,579 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function): 6,574 transactions in 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/pulsechain-bridge-validators/activity.json)).
- INFERRED: the owner EOAs have never sent an Ethereum transaction, so their public keys are not exposed on Ethereum;
  PulseChain copied Ethereum's state, so they may be exposed there. Omnibridge per-token daily execution limits, which
  would slow a drain, were not read.

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd0764fae…` ForeignAMB (Ethereum-PulseChain) | yes | $40.09M | 2026-11-16 | 6,574 |

Escrow: ForeignOmnibridge `0x1715a3e4…` held $40.09M on the first page of its ERC-20 holdings (USDC $11.41M, DAI
$10.44M, WETH 4,022.9 = $7.30M, HEX $5.46M, USDT $3.81M, WBTC $0.98M, LINK $0.12M, …) and no ETH; the second
Omnibridge `0xe20e337d…` holds nothing. The AMB itself holds nothing.

Moved here from `gnosis-bridge-validators` on 2026-11-17: the address was attributed to Gnosis Chain, but it bridges
to chain 369 and is run by PulseChain's deployer.

## Remediation

- Post-quantum replacement: validator attestations with a post-quantum signature scheme (or a STARK proof of the
  PulseChain validator set's consensus), checked by a new ForeignAMB implementation.
- Who acts: the upgradeabilityOwner EOA `0xdf5d165a…`; rotating validators through `0x2fa878ab…` (owner `0x3ea02ef8…`)
  does not help, since any new ECDSA key is exposed once it signs. No protocol change needed.
- Users: bridged-token holders can withdraw to Ethereum before the escrow is at risk; nothing else protects them.
- The admin keys are single ECDSA EOAs themselves (PQ-12-like owner risk), outside this finding's mechanism.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`), as part of
  `gnosis-bridge-validators`.
- 2026-11-17 review (Review20): split out of `gnosis-bridge-validators` (attribution: destinationChainId 369,
  PulseChain deployer `0x30e22ab6…`). Rated MEDIUM, step 4: upgradeable proxy, one EOA upgrades; escrow measured at
  $40.09M in ForeignOmnibridge `0x1715a3e4…` at block 26,431,561.
- 2026-11-19 (study `eip-8151-impact`, PQ-18): under EIP-8151 a real transaction fails as sent and passes with more gas: whoever sends it must add gas on activation day. Executed: a real transaction reverts when its signer has code.
