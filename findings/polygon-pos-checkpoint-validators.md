---
id: polygon-pos-checkpoint-validators
title: "Polygon PoS: forging 2/3 of validator ECDSA keys lets anyone submit a false checkpoint to RootChain and exit ~USD 2.1B from the PoS and Plasma bridges"
project: polygon
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x5e3ef299fddf15eaa0432e6e66473ace8c13d908"
  implementation: "0x1d9ee26f794676acf56bac9a479f766403d0f5cc"
  name: StakeManagerProxy → StakeManager
  upgradeable: "yes"
  admin: Timelock 0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef (proxy owner; min delay 0; proposer/executor Safe 0xfa7d2a996ac6350f4b56c043112da0366a59b74c, 5 of 9)
  value_usd: 2149110101
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 8717
families: []
fix:
  layer: contract-upgrade
  who_acts: "Polygon: Safe 0xfa7d2a996ac6350f4b56c043112da0366a59b74c (5 of 9) through Timelock 0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef upgrades StakeManager 0x5e3ef299fddf15eaa0432e6e66473ace8c13d908 and RootChain 0x86e4dc95c7fbdbf52e33d563bbdb00823894c287 to a post-quantum checkpoint check; the 100 validators register post-quantum keys in the matching Heimdall release"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-pos-checkpoint-validators
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
  who: Review14 (StakeManager, RootChain and RootChainManager source; on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-pos-checkpoint-validators/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [polygon-fflonk-verifier]
---

## Summary

Polygon PoS checkpoints (the Bor block roots that every bridge exit is proven against) are accepted on Ethereum when
validators holding more than 2/3 of the stake sign them with secp256k1 keys. A quantum attacker who recovers the signer
keys of that stake (their public keys are on-chain) can submit a checkpoint with a fabricated root and exit whatever
the PoS bridge predicates and the Plasma DepositManager hold: about USD 2.15B on 2026-11-17. Signers can only rotate
to other ECDSA keys; the fix is an upgrade of StakeManager and RootChain by Polygon's Timelock plus a validator
release: rated MEDIUM (step 4: contract upgrade).

## Mechanism

- `RootChain.submitCheckpoint(bytes data, uint[3][] sigs)` (RootChainProxy `0x86e4…c287`, implementation `0x536c…bd03`)
  is callable by anyone. It decodes `(proposer, start, end, rootHash, accountHash, borChainID)`, stores the header
  block and calls `stakeManager.checkSignatures(end - start + 1, keccak256(0x01 || data), accountHash, proposer, sigs)`;
  `require(_reward != 0, "Invalid checkpoint")`.
- `StakeManager.checkSignatures` (`onlyRootChain`) recovers each signer with `ECVerify.ecrecovery(voteHash, sigs[i])`
  (sorted, duplicates skipped), sums the stake and delegated stake of active validators and, in
  `_increaseRewardAndAssertConsensus`, requires `signedStakePower >= currentTotalStake * 2 / 3 + 1`.
- Bridge exits: `RootChainManager.exit(inputData)` (`0xa0c6…7c77`, implementation `0xf023…2dfa`) checks the burn
  receipt against a checkpoint via `_checkBlockMembershipInCheckpoint` → `_checkpointManager.headerBlocks(...)`, then
  the predicate for the token type releases the funds. Plasma exits through WithdrawManager use the same header blocks.
- Validators change their signer with `updateSigner(validatorId, signerPubkey)` (another secp256k1 key, at most once
  per `signerUpdateLimit` = 100 epochs). Pattern PQ-5.

## Evidence

- CHECKED (Sourcify verified source of StakeManager `0x1d9e…f5cc`; Blockscout verified source of RootChain
  `0x536c…bd03` and RootChainManager `0xf023…2dfa`, read 2026-11-17): the functions above.
- CHECKED (cast at block 26,431,492): proxy implementation and owner slots (`matic.network.proxy.*`) of StakeManager
  and RootChainManager = Timelock `0xcaf0…8cef`; Timelock `getMinDelay()` = 0, PROPOSER and EXECUTOR roles held by Safe
  `0xfa7d…b74c` (threshold 5, 9 owners); `currentValidatorSetSize()` = 100; `rootChain()`, `registry()`,
  `checkpointManagerAddress()`, `typeToPredicate(...)`, `getDepositManagerAddress()`
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-pos-checkpoint-validators/escrow.json)).
- CHECKED (Blockscout balances, 2026-11-17): escrow values below.
- CHECKED (precompile trace): `ecrecover` from StakeManager, 2,142,934 calls in 20,798 transactions in the trace year
  (`data/agg/y1_caller.parquet`).
- CHECKED (Xatu, any function): 8,717 transactions called StakeManager 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-pos-checkpoint-validators/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Held itself | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0x5e3ef299…` StakeManagerProxy → StakeManager | yes (Timelock, 0 delay) | USD 2.15B | USD 313.8M (POL stake) | 2026-11-16 | 8,717 |

Escrow released by a false checkpoint (2026-11-17): ERC20PredicateProxy `0x40ec…bbdf` USD 1.74B (USDC 1.05B, DAI
437M, WBTC 129M, …), EtherPredicateProxy `0x8484…2b30` 88,946.8 ETH (USD 161.7M), Plasma DepositManagerProxy
`0x401f…188b` USD 241.8M (3.06B POL), MintableERC20PredicateProxy `0x9923…74e4` USD 6.3M; NFT predicates not valued.
Total USD 2.15B (L2BEAT canonical TVS in `data/l2beat_tvs.parquet`: USD 2.30B).

The StakeManager's own POL (validator and delegator stake) is not released by a checkpoint; a forged checkpoint only
adds bounded checkpoint rewards, so the draft's `held` value was replaced by the escrow.

## Remediation

- Replace ECDSA checkpoint signatures with a post-quantum scheme (hash-based or lattice signatures from each validator,
  or a STARK proof of Heimdall consensus verified on L1): upgrade StakeManager `0x5e3e…d908` and RootChain
  `0x86e4…c287` through Timelock `0xcaf0…8cef` (Safe `0xfa7d…b74c`), and ship the Heimdall release in which the 100
  validators register post-quantum signer keys. Rotating to new ECDSA keys does not help.
- No protocol change needed; users can only bridge funds out before a CRQC exists.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (Timelock-controlled upgrade plus a validator release). Exposure changed from USD 313.8M held (POL stake, not released by a checkpoint) to USD 2.15B escrow in the PoS bridge predicates and Plasma DepositManager.

# Source excerpts: polygon-pos-checkpoint-validators

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x5e3ef299fddf15eaa0432e6e66473ace8c13d908` — StakeManagerProxy (verified source via sourcify)
