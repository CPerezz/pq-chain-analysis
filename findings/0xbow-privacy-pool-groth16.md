---
id: "0xbow-privacy-pool-groth16"
title: "0xbow Privacy Pools: a forged Groth16 proof drains all 14 pools (about USD 8.4M) through immutable BN254 withdrawal and ragequit verifiers"
project: "0xbow"
status: confirmed
severity: CRITICAL
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d"
  implementation: null
  name: WithdrawalVerifier
  upgradeable: "no"
  admin: none; no proxy or owner; every PrivacyPool stores it as immutable WITHDRAWAL_VERIFIER (read at block 26431492)
  value_usd: 8416502
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 925
- address: "0xa45aca8604a73d80c551faad6355a5c3a5565ec6"
  implementation: null
  name: CommitmentVerifier
  upgradeable: "no"
  admin: none; no proxy or owner; every PrivacyPool stores it as immutable RAGEQUIT_VERIFIER (read at block 26431492)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-09
  txs_30d: 26
families: []
fix:
  layer: new-deployment
  who_acts: "0xbow Entrypoint 0x6818809eefce719e480a7526d76bd3e561526b46 (UUPS proxy; OWNER_ROLE held by Safe 0xad7f9a19e2598b6efe0a25c84fb1c87f81eb7159, 2 of 4) registers new pools with post-quantum verifiers and winds down the old ones; every depositor must then withdraw or ragequit from the old pools"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/0xbow-privacy-pool-groth16/classification.jsonl
  - evidence/0xbow-privacy-pool-groth16/onchain.json
  - evidence/0xbow-privacy-pool-groth16/activity.json
  - evidence/0xbow-privacy-pool-groth16/source-excerpts.md
  - evidence/0xbow-privacy-pool-groth16/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review01)
  ref: evidence/0xbow-privacy-pool-groth16/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: CRITICAL
related: []
---

## Summary

Every 0xbow Privacy Pool on mainnet (14 pools, one per asset) releases funds on a Groth16 proof checked by one of
two immutable BN254 verifiers. A quantum attacker who recovers the setup trapdoor from the verifying keys can prove a
withdrawal or ragequit of any amount and empty every pool: about USD 8.4M at block 26,431,492 (2026-11-17), mostly
the USDT pool (USD 6.6M) and the ETH pool (707 ETH). The pools fix their verifiers at construction and nobody can
change them or move the pooled funds; 0xbow can only open new pools, and the old ones are safe only once every
depositor has left. Rated CRITICAL (step 4: pooled loss through a forged proof, verification immutable, users cannot
all be counted on to move).

## Mechanism

- `PrivacyPool.withdraw(Withdrawal, WithdrawProof)` (pool source, `src/contracts/PrivacyPool.sol` lines 110–128):
  the `validWithdrawal` modifier checks the caller is `processooor`, the context hash, a known state root and
  `ASPRoot == ENTRYPOINT.latestRoot()` (all public values), then `WITHDRAWAL_VERIFIER.verifyProof(pA, pB, pC,
  pubSignals)`, spends the nullifier and `_push`es `withdrawnValue` to the processooor. The withdrawn amount, the
  nullifier and the new commitment are public signals bound only by the proof.
- `PrivacyPool.ragequit(RagequitProof)` (lines 132–150): checks `depositors[label] == msg.sender`, then
  `RAGEQUIT_VERIFIER.verifyProof`, that the commitment is in the state tree, and pays `_proof.value()` to the caller.
  Any address that has made one deposit can prove a false value for its own commitment.
- `WithdrawalVerifier.verifyProof` and `CommitmentVerifier.verifyProof` are snarkJS Groth16 verifiers with hard-coded
  verifying keys; `checkPairing` calls the BN254 pairing precompile (`staticcall(..., 8, ...)`, excerpt line 184).
  With the trapdoor (the setup's toxic waste, recoverable from the verifying key by a CRQC) a proof for any public
  signals verifies (PQ-7).
- `State.sol` lines 46–48, 92–93: `WITHDRAWAL_VERIFIER` and `RAGEQUIT_VERIFIER` are `immutable`, set in the
  constructor. `windDown()` (only the Entrypoint) sets `dead`, which stops deposits only.

Source excerpts: [`source-excerpts.md`](../evidence/0xbow-privacy-pool-groth16/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, both verifiers): snarkJS Groth16 `verifyProof` with the pairing precompile.
- CHECKED (verified source, Sourcify, ETH pool `0xf241d57c…`, `PrivacyPoolSimple`): `withdraw`, `ragequit`,
  `windDown` and the immutable verifier fields as quoted above.
- CHECKED (Blockscout logs, `PoolRegistered` on the Entrypoint): 14 pools registered between blocks 22,153,715 and
  24,435,268.
- CHECKED (`eth_call` at block 26,431,492): every one of the 14 pools returns `WITHDRAWAL_VERIFIER() = 0x022891f9…`
  and `RAGEQUIT_VERIFIER() = 0xa45aca86…`; none is `dead`; balances of each pool's asset as listed in
  [`escrow.json`](../evidence/0xbow-privacy-pool-groth16/escrow.json).
- CHECKED (block 26,431,492): Entrypoint `0x6818809e…` is an ERC-1967 proxy, implementation `0x15e35502…`; `OWNER_ROLE`
  is held by `0xad7f9a19…` (`hasRole` true), a Safe with threshold 2 of 4; the earlier holder `0x1f4fe25c…` was
  revoked at block 22,169,228.
- CHECKED (block 26,431,214, [`onchain.json`](../evidence/0xbow-privacy-pool-groth16/onchain.json)): both
  verifiers have no proxy, owner or holdings.
- CHECKED (Xatu, [`activity.json`](../evidence/0xbow-privacy-pool-groth16/activity.json)): 925 and 26 transactions
  reached the verifiers in 2026-10-16 to 2026-11-16; yearly pre-quantum calls (`curated_contracts.csv`, `txs_y1`):
  3,974 and 286.
- INFERRED (from source): an Entrypoint upgrade that makes `latestRoot()` revert would freeze `withdraw` for everyone,
  but `ragequit` does not consult the Entrypoint, so no admin action protects funds already in the pools.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x022891f9…` WithdrawalVerifier | no | USD 8.4M (escrow: 14 pools) | 2026-11-15 | 925 |
| `0xa45aca86…` CommitmentVerifier | no | same pools (not counted twice) | 2026-11-09 | 26 |

Escrow (block 26,431,492; ETH at USD 1,811.62, tokens at Blockscout prices):

| Pool | Asset | Balance | USD |
|---|---|---|---|
| `0xe859c0bd25f260baee534fb52e307d3b64d24572` | USDT | 6,601,627 | 6,596,966 |
| `0xf241d57c6debae225c0f2e6ea1529373c9a9c9fb` | ETH | 707.43 | 1,281,595 |
| `0xb419c2867ab3cbc78921660cb95150d95a94ce86` | USDC | 404,386 | 404,234 |
| `0x1a604e9dfa0efdc7ffda378af16cb81243b61633` | wstETH | 26.14 | 59,206 |
| `0xb4b5fd38fd4788071d7287e3cb52948e0d10b23e` | BOLD | 49,826 | 49,716 |
| 9 other pools (frxUSD, wOETH, WBTC, USDS, sUSDS, USD1, DAI, fxUSD, USDe) | | | 24,785 |
| **Total** | | | **8,416,502** |

Both verifiers are shared by all 14 pools, so the whole amount is exposed through either one. No other consumer of
these verifiers was looked for.

## Remediation

- Replacement: new withdrawal and ragequit circuits proved with a hash-based system (STARK/FRI or WHIR) and a matching
  on-chain verifier, deployed in new pools; the ASP root logic carries over.
- Who acts: 0xbow, through the Entrypoint `0x6818809eefce719e480a7526d76bd3e561526b46` whose `OWNER_ROLE` Safe
  `0xad7f9a19e2598b6efe0a25c84fb1c87f81eb7159` (2 of 4) can `registerPool`/`removePool` and `windDownPool`. That stops
  new deposits into the old pools but cannot change their verifiers or move their funds.
- Users: each depositor must withdraw (or ragequit) from the old pools and redeposit in the new ones before a CRQC
  exists; funds left behind stay drainable. No protocol change is needed or would help.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review01): CRITICAL kept, step 4: pool source read (verifiers immutable, no admin path moves pooled funds, ragequit bypasses the Entrypoint); escrow measured across the 14 registered pools (USD 8.4M at block 26,431,492); Entrypoint owner recorded.
