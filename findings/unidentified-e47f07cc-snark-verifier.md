---
id: unidentified-e47f07cc-snark-verifier
title: "Unidentified Balancer dynamic-fee oracle (FeeManagerV3, deployer 0xf5e64718): a forged Halo2-KZG proof plus the Lit signer key sets the AAVE/ETH pools' swap fee; nothing can be taken"
project: unidentified-e47f07cc
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: auxiliary
contracts:
- address: "0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca"
  implementation: null
  name: AAVEETHDynamicFeeVerifier6h_2
  upgradeable: "no"
  admin: none; current verifier of FeeManagerV3 0x6e09d8ef and FeeManagerV3_v2 0x522eb7a9, whose owner Safe 0xb7aadd330a64088a85e500874dcdcfb7f253feb4 (2 of 3) can replace it with updateVerifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-10
  txs_30d: 0
- address: "0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68"
  implementation: null
  name: Halo2Verifier
  upgradeable: "no"
  admin: none; retired (no FeeManager points at it, block 26,431,598)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-11-27
  txs_30d: 0
- address: "0xe47f07cc96b269c68e4a2a5b9b3bd0e02c6ae698"
  implementation: null
  name: AAVEETHDynamicFeeVerifier6h
  upgradeable: "no"
  admin: none; retired (no FeeManager points at it, block 26,431,598)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-11-28
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: owner Safe 0xb7aadd330a64088a85e500874dcdcfb7f253feb4 (2 of 3) of both FeeManagers, via updateVerifier to a post-quantum verifier
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/unidentified-e47f07cc-snark-verifier/classification.jsonl
  - evidence/unidentified-e47f07cc-snark-verifier/onchain.json
  - evidence/unidentified-e47f07cc-snark-verifier/activity.json
  - evidence/unidentified-e47f07cc-snark-verifier/source-excerpts.md
  - evidence/unidentified-e47f07cc-snark-verifier/consumers.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review04)
  ref: evidence/unidentified-e47f07cc-snark-verifier/consumers.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

These three EZKL-generated Halo2 verifiers (KZG on BN254, PQ-7) check proofs of a 6-hour AAVE/ETH volatility fee for
two `FeeManagerV3` contracts, which then set the swap fee of a Balancer V2 pool (20wstETH-80AAVE, USD 2.1M) and a
Balancer V3 Gyro pool (empty). A quantum attacker with the setup trapdoor, and also the Lit Protocol ECDSA key that
signs the inputs, can set any swap fee the pool allows; no pool funds move through this path. Rated LOW, step 4: the
check guards an auxiliary fee setting through which nothing can be taken, and one known owner (Safe `0xb7aadd33…`)
can repoint the verifier.

## Mechanism

- `AAVEETHDynamicFeeVerifier6h_2.verifyProof(bytes proof, uint256[] instances)` (source lines 69ff, `ec_pairing` at
  line 193) is a Halo2 verifier with KZG commitments on BN254: `ecAdd`/`ecMul`, `modexp` for field inversion, and one
  `ecPairing` at the end. `0xe47f07cc…` and `0x196649f7…` are earlier builds of the same circuit.
- `FeeManagerV3_v2.updateFee(proof, inputData, timestamp, dynamicFeeUnscaled, signature)` (Sourcify source lines
  105–151) first requires `ECDSA.recover(keccak256(abi.encode(inputData, timestamp)), signature) == litPublicKey`
  (a Lit Protocol PKP key, secp256k1), then `verifier.verifyProof(proof, instances)`, then stores `dynamicFee`.
  `publishFee` (anyone) pushes it to the pools: `setSwapFeePercentage` through Balancer V2 helper `0x8a8b9f35…`, or
  `setStaticSwapFeePercentage` on the Balancer V3 vault for `FeeManagerV3`.
- `updateVerifier(address)` and `updateLitPublicKey(address)` are `onlyOwner`.
- Source excerpts: [`source-excerpts.md`](../evidence/unidentified-e47f07cc-snark-verifier/source-excerpts.md).

## Evidence

- CHECKED (Sourcify-verified source of the three verifiers and of both FeeManagers): the functions above.
- CHECKED (precompile trace plus `eth_getTransactionByHash` on every verifier transaction): all are `updateFee`
  (`0x3534d694`) calls from EOA `0xf5e64718…` to `0x6e09d8ef…` or `0x522eb7a9…`; `0x196649f7…` until block
  23,889,868, `0xe47f07cc…` until 23,897,070, `0xbda7b855…` from 23,891,716 to 24,423,205.
- CHECKED (`cast call` at block 26,431,598): both FeeManagers have `owner()` = Safe `0xb7aadd33…` (2 of 3 owners),
  `verifier()` = `0xbda7b855…`, `description()` = "AAVEETH6h"; `litPublicKey` `0x1a601e2a…` / `0x30fe0fd6…`.
- CHECKED (Blockscout, `publishFee` calldata 2026-02-10): pools `0x12216142…` (GyroECLPPool, AAVE/WETH, holds dust)
  and poolId `0x3de27efa…0588` (20wstETH-80AAVE, 187.87 wstETH + 15,573 AAVE, USD 2.11M at Blockscout rates);
  current fees 0.288% and 0.292% ([`consumers.json`](../evidence/unidentified-e47f07cc-snark-verifier/consumers.json)).
- CHECKED (on-chain read at block 26,431,214): verifiers hold nothing ([`onchain.json`](../evidence/unidentified-e47f07cc-snark-verifier/onchain.json));
  last FeeManager activity 2026-02-10.
- CHECKED (Blockscout): deployer `0xf5e64718…` is an EOA with no name, tag or ENS name; the operator stays
  unidentified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xbda7b855…` AAVEETHDynamicFeeVerifier6h_2 (in use) | no | — | 2026-02-10 | 0 |
| `0x196649f7…` Halo2Verifier (retired) | no | — | 2025-11-27 | 0 |
| `0xe47f07cc…` AAVEETHDynamicFeeVerifier6h (retired) | no | — | 2025-11-28 | 0 |

A forged update changes only the swap-fee percentage, within the bounds Balancer enforces; LPs lose fee income or
traders pay a higher fee inside their own slippage limits, but no pool balance can be withdrawn. The 20wstETH-80AAVE
pool's USD 2.11M is therefore not recorded as exposure. The oracle has not updated since 2026-02-10.

## Remediation

- Post-quantum replacement: a hash-based (STARK/FRI) proof of the fee computation and a post-quantum signature for
  the input data instead of the Lit ECDSA key.
- Who acts: the owner Safe `0xb7aadd330a64088a85e500874dcdcfb7f253feb4` (2 of 3), by `updateVerifier` and
  `updateLitPublicKey` on both FeeManagers, or by removing them as the pools' fee managers. No protocol change is
  needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review04): MEDIUM -> LOW, step 4: the verified FeeManagerV3 source shows the proof (plus a Lit ECDSA signature) only sets a Balancer swap fee, so nothing can be taken (impact funds-loss -> none, role core -> auxiliary), and owner Safe 0xb7aadd33 can repoint the verifier. Evidence level bytecode -> source-read; status candidate -> confirmed.
