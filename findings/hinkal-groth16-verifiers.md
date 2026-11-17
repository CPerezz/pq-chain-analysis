---
id: hinkal-groth16-verifiers
title: "Hinkal shielded pools: a recovered BN254 Groth16 setup trapdoor lets a quantum attacker forge transact proofs and drain the pools ($92k); the owner can register post-quantum verifiers"
project: hinkal
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4"
  implementation: null
  name: Hinkal (shielded pool; VerifierFacade registry)
  upgradeable: config-only
  admin: "owner() HinkalTimelockController 0xf04310839973454155d9886a4023451f8d3db7d0 (6 h delay), proposer/executor Safe 0x4d28b33517ab72e7e2f728ff6527f8256cced7fb (2 of 3); registerVerifiers/removeVerifier; read at block 26431610"
  value_usd: 63939
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: null
- address: "0x25e5e82f5702a27c3466fe68f14abdbbadfca826"
  implementation: null
  name: Hinkal (shielded pool; VerifierFacade registry)
  upgradeable: config-only
  admin: "owner() EOA 0xbdc77a0c69f13207acb70a6981cad60b4c1d1942; registerVerifiers/removeVerifier; read at block 26431610"
  value_usd: 12978
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-21
  txs_30d: null
- address: "0x2ea81946ff675d5eb88192144ffc1418fa442e28"
  implementation: null
  name: Hinkal (shielded pool; VerifierFacade registry)
  upgradeable: config-only
  admin: "owner() EOA 0xbdc77a0c69f13207acb70a6981cad60b4c1d1942; registerVerifiers/removeVerifier; read at block 26431610"
  value_usd: 14921
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-24
  txs_30d: null
- address: "0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3"
  implementation: null
  name: Groth16 Verifier (4 public inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-09
  txs_30d: 0
- address: "0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b"
  implementation: null
  name: Groth16 verifier (18 inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-09
  txs_30d: 0
- address: "0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a"
  implementation: null
  name: Groth16 verifier (20 inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-10
  txs_30d: 0
- address: "0x5b3fb770f00fadb4ae49df6882152bd1d27895ee"
  implementation: null
  name: Groth16 verifier (26 inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-09
  txs_30d: 0
- address: "0x96a0ea201f11ff3aad8cf463d438292acd6fb34a"
  implementation: null
  name: Groth16 Verifier (34 public inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-09
  txs_30d: 0
- address: "0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546"
  implementation: null
  name: Groth16 verifier (29 inputs; retired)
  upgradeable: "no"
  admin: "none (immutable verifier); retired: no Hinkal verifierMap entry reaches it since 2026-06-10"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-09
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Hinkal: owner EOA 0xbdc77a0c69f13207acb70a6981cad60b4c1d1942 (pools 0x25e5e82f…, 0x2ea81946…) and Safe 0x4d28b33517ab72e7e2f728ff6527f8256cced7fb via timelock 0xf04310839973454155d9886a4023451f8d3db7d0 (pool 0x7cb60446…) call registerVerifiers with post-quantum verifiers, after Hinkal builds the new circuits"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hinkal-groth16-verifiers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review23 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hinkal-groth16-verifiers/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Hinkal's shielded pools release deposits on a Groth16 proof over BN254 (PQ-7). A quantum attacker who recovers a
circuit's setup trapdoor can prove a false spend and withdraw what a pool holds: $91.8k across three Hinkal pools on
2026-11-17 (mostly `0x7cb60446…`, $63.9k). The six verifiers in the census are retired: Hinkal re-registered every
circuit on 2026-06-10 and no pool reaches them now, but the replacements are BN254 Groth16 verifiers too. Each pool
picks its verifiers through `registerVerifiers`, so its owner can switch to post-quantum verifiers once they exist.
Rated MEDIUM (step 4): the fix is new verifiers the owner registers, which needs new circuits; over $50k is exposed.

## Mechanism

- `Hinkal.transact(a, b, c, dimensions, circomData)` calls `VerifierFacade.verifyProof`, which looks up
  `verifierMap[buildVerifierId(dimensions, externalActionId)]` and calls `verifyProof(a, b, c, input, verifierId)` on
  it; the transaction moves pool tokens only if that returns true.
- Each registered entry is a small wrapper (deployer `0xc2212d20…`) that forwards to a snarkjs-style Groth16 verifier
  `verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[n])` checking the pairing equation with the BN254
  precompiles.
- `registerVerifiers(ids, addresses)` and `removeVerifier(id)` are `onlyOwner` (Ownable2Step): this is the switch a
  post-quantum fix uses.
- The six census verifiers (4–34 public inputs) were the targets of six wrappers that Hinkal pool `0x25e5e82f…` used
  until 2026-06-10; their last calls are 2026-06-09/10.
- Pattern PQ-7. The pools' source is verified; the verifiers are not (bytecode: selectors, BN254 constants).

## Evidence

- CHECKED (verified source, Sourcify, `0x25e5e82f…`): `Hinkal.transact`, `VerifierFacade` registry and owner
  functions ([`notes.md`](#review-notes-review23-2026-11-17)).
- CHECKED (traces, `trace_block`/`trace_transaction` on eth.drpc.org): each of the six verifiers was last called by a
  wrapper inside `Hinkal.transact` on `0x25e5e82f…`; verifier ids taken from those calls.
- CHECKED (on-chain read, block ~26,431,576): `verifierMap(id)` for those six ids and all 64 ids ever registered on
  `0x25e5e82f…` (117 `VerifierRegistered` events, Routescan logs API): none points to the old wrappers; no current
  wrapper's code embeds any of the six verifier addresses. Same check for the 117 distinct wrappers registered on
  pools `0x7cb60446…` and `0x2ea81946…`: none.
- CHECKED (traces): current verifiers `0x2617f5b3…` (pool `0x25e5e82f…`, 2026-09-21), `0x2cd65ac8…` (pool
  `0x7cb60446…`, 2026-11), `0x27ff63ee…` (pool `0x2ea81946…`, 2026-05-29) all contain the BN254 base-field modulus.
- CHECKED (on-chain read, block 26,431,610): no EIP-1967 slots on the pools; `owner()` of `0x25e5e82f…` and
  `0x2ea81946…` = EOA `0xbdc77a0c…`; `owner()` of `0x7cb60446…` = HinkalTimelockController `0xf0431083…`
  (`getMinDelay` 21,600 s) whose proposer/executor/canceller is Safe `0x4d28b335…` (2 of 3).
- CHECKED (block 26,431,610): pool holdings (ETH balance + Blockscout-priced ERC-20s)
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hinkal-groth16-verifiers/escrow.json)).
- CHECKED (block 26,431,214): the six verifiers hold nothing and are not proxies
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hinkal-groth16-verifiers/onchain.json)); last calls in
  [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/hinkal-groth16-verifiers/activity.json).

## Impact and exposure

| Contract | Role | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0x7cb60446…` Hinkal | pool + registry | config-only (timelock, Safe 2/3) | $63.9k (USDC 53.7k, ETH 8.9k) | 2026-11-17 | — |
| `0x25e5e82f…` Hinkal | pool + registry | config-only (owner EOA) | $13.0k | 2026-09-21 | — |
| `0x2ea81946…` Hinkal | pool + registry | config-only (owner EOA) | $14.9k | 2026-07-24 | — |
| `0x45926fe3…` Groth16 verifier (4) | retired | no | — | 2026-06-09 | 0 |
| `0x73567fbb…` Groth16 verifier (18) | retired | no | — | 2026-06-09 | 0 |
| `0x5099c001…` Groth16 verifier (20) | retired | no | — | 2026-06-10 | 0 |
| `0x5b3fb770…` Groth16 verifier (26) | retired | no | — | 2026-06-09 | 0 |
| `0x96a0ea20…` Groth16 verifier (34) | retired | no | — | 2026-06-09 | 0 |
| `0x96b3597f…` Groth16 verifier (29) | retired | no | — | 2026-06-09 | 0 |

The pools hold the shielded deposits themselves, so their holdings (`value_basis: held`) are the exposure; total
$91.8k. The three pools were added in this review: they are the contracts users call and that release funds; the
census listed only the verifiers. 30-day transaction counts for the pools were not measured. Pool `0x2ea81946…`'s
token list has unpriced tokens beyond the first page, so its value is a lower bound.

## Remediation

- Hinkal builds its circuits for a hash-based proof system (STARK/FRI or similar), deploys the verifiers, and each
  pool owner calls `registerVerifiers` for every circuit id (and `removeVerifier` for the BN254 ones): EOA
  `0xbdc77a0c…` for `0x25e5e82f…` and `0x2ea81946…`; Safe `0x4d28b335…` through timelock `0xf0431083…` for
  `0x7cb60446…`. No contract upgrade is needed.
- Users can withdraw from the pools; nothing else is in their hands.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review23): MEDIUM kept, step 4: verifiers are configurable by each pool's owner, but post-quantum verifiers need new circuits; $91.8k measured in the three Hinkal pools (added as contracts, value held), so step 5 does not lower it. The six census verifiers are retired (no registry entry reaches them since 2026-06-10); live verifiers are still BN254 Groth16. Status candidate -> confirmed (pool source verified, verifiers by bytecode and trace, state read).

# Source excerpts: hinkal-groth16-verifiers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x45926fe3fe2edf47a1614c5f61b4c10484a24ed3`

No verified source on Sourcify or Blockscout.


## Contract `0x73567fbbe4aab2efd52474b7f6df41bfc1cfba7b`

No verified source on Sourcify or Blockscout.


## Contract `0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a`

No verified source on Sourcify or Blockscout.


## Contract `0x5b3fb770f00fadb4ae49df6882152bd1d27895ee`

No verified source on Sourcify or Blockscout.


## Contract `0x96a0ea201f11ff3aad8cf463d438292acd6fb34a`

No verified source on Sourcify or Blockscout.


## Contract `0x96b3597f6e8af2db8ed1c2125eb4da43dfd6c546`

No verified source on Sourcify or Blockscout.

# Review notes (Review23, 2026-11-17)

## How Hinkal checks proofs (verified source, Sourcify, Hinkal `0x25e5e82f5702a27c3466fe68f14abdbbadfca826`)

- `Hinkal.transact(a, b, c, dimensions, circomData)` → `VerifierFacade.verifyProof(a, b, c, input, buildVerifierId(dimensions, externalActionId))`
  → `verifierMap[verifierId].verifyProof(a, b, c, input, verifierId)` (selector `0x6743734c`).
- `registerVerifiers(uint256[] ids, address[] verifiers)` and `removeVerifier(id)` are `onlyOwner` (Ownable2Step).
- Each registered address is a small wrapper (≈1,325 bytes, deployer `0xc2212d20…`) that forwards to one fixed
  snarkjs-style Groth16 verifier `verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[n])` (address embedded in
  the wrapper's code).

## The six census verifiers are retired (traces via eth.drpc.org `trace_block`; reads at block ~26,431,576)

| Verifier | Wrapper that called it | verifierId used | verifierMap(id) now |
|---|---|---|---|
| 0x45926fe3… (4 inputs) | 0x56651dc0… | 0x58848304… | 0x6f8865d8… |
| 0x73567fbb… (18) | 0x109569e8… | 0xfa58fbc6… | 0x163fe0b0… |
| 0x5099c001… (20) | 0xbfabaf16… | 0x30382e94… | 0x163fe0b0… |
| 0x5b3fb770… (26) | 0x376725ab… | 0x8fb63dca… | 0x4d890d7f… |
| 0x96a0ea20… (34) | 0xc54d0326… | 0xb2ea2c02… | 0x50ca9296… |
| 0x96b3597f… (29) | 0xdbc1309d… | 0xc26d639b… | 0x4d890d7f… |

- Owner EOA `0xbdc77a0c…` re-registered all ids on 2026-06-10 (6 `registerVerifiers` txs, blocks 25,285,697–25,285,711);
  the six verifiers' last calls are 2026-06-09/10.
- All 117 `VerifierRegistered` events of `0x25e5e82f…` (Routescan logs API): 64 distinct ids; `verifierMap(id)` read
  now for every id: none points to any of the six old wrappers; none of the 32 currently registered wrappers' code
  contains any of the six verifier addresses.
- Other Hinkal pools: `0x7cb60446…` (149 registrations) and `0x2ea81946…` (321): none registers the six verifiers or
  their wrappers; none of their 117 distinct registered wrappers' code contains the six addresses.

## Live Hinkal verification is still BN254 Groth16

- `0x25e5e82f…` tx `0x095ac30c…` (2026-09-21): wrapper `0x163fe0b0…` → verifier `0x2617f5b358dd51fe8e2357b0ef80254e8d515d74`
  (`verifyProof(...,uint256[14])`, code contains the BN254 base-field modulus).
- `0x7cb60446…` tx `0xd2b98b24…` (2026-11): wrapper `0x8c16d510…` → verifier `0x2cd65ac8e4bf2ac3d21fdb0b9330cf6233b1ca4d`
  (`verifyProof(...,uint256[15])`, BN254 modulus present).
- `0x2ea81946…` tx `0x2367b289…` (2026-05-29): wrapper `0xe0f73f57…` → verifier `0x27ff63ee7a1501fe4457d753cd55cb90c79719ea`
  (BN254 modulus present).

## Who can change it (reads at block 26,431,610)

- `0x25e5e82f…` and `0x2ea81946…`: no EIP-1967 slots; `owner()` = `0xbdc77a0c69f13207acb70a6981cad60b4c1d1942` (EOA).
- `0x7cb60446…`: no EIP-1967 slots; `owner()` = HinkalTimelockController `0xf04310839973454155d9886a4023451f8d3db7d0`
  (`getMinDelay()` = 21,600 s); proposer, executor and canceller roles granted to Safe
  `0x4d28b33517ab72e7e2f728ff6527f8256cced7fb` (2 of 3: `0xbdc77a0c…`, `0x6c7fc304…`, `0x091418cb…`).

## Escrow

Pool holdings in [`escrow.json`](escrow.json): `0x25e5e82f…` $12,978; `0x7cb60446…` $63,939; `0x2ea81946…`
$14,921 (ETH at $1,811.62 + Blockscout-priced ERC-20s). Last `transact`: 2026-09-21, 2026-11-17, 2026-05-29.
