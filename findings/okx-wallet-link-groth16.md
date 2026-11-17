---
id: okx-wallet-link-groth16
title: "OKX CEX Wallet link: a Groth16 verifier (0xc3dace2f) plus one OKX ECDSA cosigner key let a clone act on users' OKX smart wallets; a quantum attacker who forges both can add itself as owner and drain them, unless OKX pauses the registry"
project: okx
status: candidate
severity: LOW
patterns: [PQ-7, PQ-4]
primitives: [bn254, ecrecover]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88"
  implementation: null
  name: Groth16 verifier (verifyProof, 37 public inputs) used by OKX "CEX Wallet" ZK validator 0xea93c8d93b053ba360dd720986147559f5550b38
  upgradeable: "no"
  admin: none on the verifier; the ZK validator's key-hash registry 0x3175dd6cf68f98837eaff53ae8e30fd877679baa can be paused by EOA 0xa07ae4bdfa7ba8bc0e8a8525bcc768300a8970bb and is owned by TimelockController 0xca9b5728cb353afcf6e41afd8b71f7ceb0aa703b (12 h delay)
  value_usd: 28786
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 4150
families: []
fix:
  layer: onchain-config
  who_acts: pauser EOA 0xa07ae4bdfa7ba8bc0e8a8525bcc768300a8970bb pauses registry 0x3175dd6cf68f98837eaff53ae8e30fd877679baa (or TimelockController 0xca9b5728cb353afcf6e41afd8b71f7ceb0aa703b revokes key hashes); a post-quantum replacement needs OKX to deploy a new validator and users to install it
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-wallet-link-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [okx-pmm-protocol-maker-sig]
---

## Summary

The Groth16 verifier `0xc3dace2f…` (37 public inputs, unverified) belongs to OKX: its only caller is the "OKX CEX
Wallet" ZK validator `0xea93c8d9…`, used by per-user clones that can execute calls on users' OKX smart wallets (built
from OKX's `SmartWalletFactory`). Each clone execution needs a valid proof plus an ECDSA signature from one shared
OKX key `0x52e6e540…`. A CRQC holder can forge both (setup trapdoor, and the key from its on-chain signatures) and
use a clone to add itself as owner of a linked wallet. The wallets reached hold about USD 28.8k in ETH, WETH, USDT
and USDC. OKX's pauser EOA can pause the validator's registry, which makes every proof fail. Rated LOW, step 4: one
known operator changes a setting (and under USD 50k measured).

## Mechanism

- Clone (EIP-1167 of `0xd8f8b2eb…`, created by `0x6f714629…`) `initialize(bytes32[] keyHashes, address[] validators)`
  with validators ZK `0xea93c8d9…` and ECDSA `0x98ab855d…`; it stores a hash of that set. Its execute entry
  (`0x98c2f162`) staticcalls each validator, consumes a nonce at `0xc7cee046…`, and calls the user's smart wallet
  `execute(Call[])` (in the sample: `addOwner`).
- ZK validator: checks `registry.isKeyHashValid(...)` at `0x3175dd6c…`, then
  `verifier().verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[37])` on `0xc3dace2f…` (37 `ecMul`/`ecAdd`
  calls and one `ecPairing`). `verifier()` is fixed in code.
- ECDSA validator: `ecrecover` against a configured key; both samples recover the same EOA `0x52e6e540…`.
- Patterns PQ-7 (BN254 Groth16) and PQ-4 (one service ECDSA key). Details:
  [`consumers.md`](#consumers-and-controls-okx-wallet-link-groth16).

## Evidence

- CHECKED (traces of txs at blocks 26,423,555 and 26,423,955, `debug_traceTransaction`): the call chain above;
  `verifyProof` and the ECDSA validator both return 1, then the wallet runs `addOwner`.
- CHECKED (on-chain reads, 2026-11-17): ZK validator `project()` = "OKX CEX Wallet", `verifier()` = `0xc3dace2f…`,
  `registry()` = `0x3175dd6c…`; registry `owner()` = TimelockController `0xca9b5728…` (`getMinDelay` 43,200 s;
  proposer EOA `0x5f9fd2c8…`, admin EOA `0xa07ae4bd…`), `pauser()` = EOA `0xa07ae4bd…`, not paused.
- CHECKED (simulation with a state override setting the registry's paused bit): `isKeyHashValid` and the ZK
  validator's check return false for the sampled proof that passes unpaused.
- CHECKED (Blockscout and GitHub): `SmartWalletFactory` `0x5c328f3b…` source is identical to
  `okxlabs/okx-smart-wallet-evm` `src/SmartWalletFactory.sol`; all contracts in the chain were created by
  `DeployFactory` `0xfac89754…`, which also created the verifier.
- CHECKED (clone `0xdc60bcdf…`): its stored config hash `0xb8fdeadf()` equals `0xb0c4e825(keyHashes, validators)` for
  the two validators passed to `initialize`.
- CHECKED (holdings at latest, ~block 26,431,973; [`okx-accounts.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-wallet-link-groth16/okx-accounts.json)):
  25,995 factory accounts hold USD 1.4k and the 1,561 census members running the wallet logic hold USD 27.4k (ETH,
  WETH, USDT, USDC only), USD 28.8k together.
- CHECKED (Xatu call frames): 4,150 transactions reached the verifier 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-wallet-link-groth16/activity.json)).
- INFERRED: the clone requires every validator in its stored set to pass (both are called in every sample and the
  stored hash covers both); clone and validator bytecode were not fully decompiled, so status stays `candidate`.
- INFERRED: the account list may be incomplete (log paging stopped early) and other tokens were not measured.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xc3dace2f…` Groth16 verifier | no | $28.8k (escrow: OKX smart wallets, 4 assets) | 2026-11-16 | 4,150 |

The verifier holds nothing. The escrow is the OKX smart wallets a CEX-link clone can act on; the figure counts all
wallets of that logic, an upper bound for those actually linked. The ECDSA validator `0x98ab855d…` (PQ-4) is not in
this registry yet.

## Remediation

- Now: pauser EOA `0xa07ae4bd…` can pause registry `0x3175dd6c…` (or the timelock `0xca9b5728…` can revoke key
  hashes), which disables the ZK validator and with it the clone path.
- Post-quantum: OKX deploys a validator with a hash-based (STARK/FRI) proof and a post-quantum cosigner, and users
  install new clones/owners; old clones stay usable unless the registry stays paused.
- No protocol change needed. Users can remove the clone owner from their wallet.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> LOW, step 4: identified as OKX (project set to okx, id kept); the verifier gates an OKX CEX-wallet link path whose ZK validator can be disabled at once by one known pauser (simulated); exposure measured at USD 28.8k (step 5 would also lower). ECDSA cosigner added as PQ-4. Linked `unidentified-cd815022-pmm-vault-signer`.
- 2026-11-17 integration: id renamed from `unidentified-c3dace2f-snark-verifier` (project identified). `related` changed from `unidentified-cd815022-pmm-vault-signer` (its OKX attribution was not established) to `okx-pmm-protocol-maker-sig`, the other OKX finding.

# Source excerpts: okx-wallet-link-groth16

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88`

No verified source on Sourcify or Blockscout.

# Consumers and controls: okx-wallet-link-groth16

Read 2026-11-17 (latest block about 26,431,600; `ethereum-rpc.publicnode.com`, traces from `eth.drpc.org`
`debug_traceTransaction` with callTracer).

## Verifier

`0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88`: 4,755 bytes, not verified (Sourcify, Blockscout). Selector `0x76852571`
= `verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[37])`. In traces it calls `ecMul` (0x07) and `ecAdd` (0x06)
37 times each, then `ecPairing` (0x08) once: a Groth16 verifier with 37 public inputs. No storage, no owner, not a proxy.
Created by `DeployFactory` `0xfac897544659fb136c064d5428947f5bc9cc1fa2` (Sourcify verified), which also created every
contract below.

## Call chain (txs `0xc4d6534c…6eda` block 26,423,955 and `0x7ce72105…4622` block 26,423,555)

1. Relayer EOA `0x883a95fdf8df78e7128fced0e9d931a687ff542f` calls Multicall `0x4ebc36dc…` or directly `0x6f714629…`.
2. `SmartWalletFactory` `0x5c328f3b5f117ffc693378a2c5b16c4f80f86295` (Blockscout verified; source identical to
   `okxlabs/okx-smart-wallet-evm` `src/SmartWalletFactory.sol`; `IMPLEMENTATION()` = `0x36d3cbd8…`) creates the user's
   smart wallet (ERC-1967 proxy, e.g. `0xf8d9ce44…`) when needed.
3. Clone factory `0x6f714629052538051c41d5965369bec0eea594e3` creates an EIP-1167 clone of `0xd8f8b2eb…` and calls
   `initialize(bytes32[] keyHashes, address[] validators)` with validators `[0xea93c8d9…, 0x98ab855d…]`.
4. The clone's `0x98c2f162` execute entry staticcalls each validator with `0x8d75716e`:
   - ZK validator `0xea93c8d93b053ba360dd720986147559f5550b38`: `project()` = "OKX CEX Wallet", `verifier()` =
     `0xc3dace2f…` (pure: fixed in code), `registry()` = `0x3175dd6c…`; it asks the registry
     `isKeyHashValid(bytes32,bytes32)` and then calls `verifyProof`.
   - ECDSA validator `0x98ab855dac8dcc24e47f1f5dbf68561ce412dc40`: `ecrecover` returns `0x52e6e54053a89af28a7c4017a147d423b46860b6`
     (no code, nonce 0) in both sampled transactions, for two different users: a shared service key.
5. The clone consumes a nonce at `0xc7cee046…` and calls the user's smart wallet `execute(Call[])`, which here runs
   `addOwner(bytes32,address,uint256)` on that wallet.

## Registry controls

| Read | Value |
|---|---|
| `0x3175dd6c….owner()` | TimelockController `0xca9b5728cb353afcf6e41afd8b71f7ceb0aa703b`, `getMinDelay()` 43,200 s; proposer/canceller EOA `0x5f9fd2c8…`, executor `0xe0c77584…`, admin EOA `0xa07ae4bd…` (roles from creation tx `0x328bf99f…`; admin and proposer re-checked with `hasRole`) |
| `0x3175dd6c….pauser()` | EOA `0xa07ae4bdfa7ba8bc0e8a8525bcc768300a8970bb` |
| `paused()` | false |
| Simulation (`cast call --override-state-diff`, slot 0 paused bit set) | `isKeyHashValid` for the sampled key returns false, and the ZK validator's `0x8d75716e` returns 0 for the sampled proof that returns 1 unpaused |

## Wallets reached

Census families for logic `0x36d3cbd8…`: 1,378 ERC-1967 proxies and 183 EIP-7702 EOAs. `AccountCreated` events from
`SmartWalletFactory` since block 23,732,085: see `okx-accounts.json`.
