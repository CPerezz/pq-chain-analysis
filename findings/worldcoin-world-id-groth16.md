---
id: worldcoin-world-id-groth16
title: "World ID (Worldcoin): a BN254 Groth16 setup trapdoor would forge World ID membership proofs and operator tree updates on mainnet; no mainnet consumer holds value"
project: worldcoin
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0xcdbbcd1cb0b642f8e324ab29c73a967b0c80bad5"
  implementation: null
  name: SemaphoreVerifier (membership proofs, groups 0 and 1)
  upgradeable: "no"
  admin: none (immutable); WorldIDIdentityManager owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can replace it with setSemaphoreVerifier or upgrade the manager
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2023-08-22
  txs_30d: 0
- address: "0x443ad7acf39baa104b2e70fa5cf6fe32cc28abee"
  implementation: null
  name: SemaphoreVerifier (membership proofs, group 2)
  upgradeable: "no"
  admin: none (immutable); manager 0x5fb49f5b63421bd43c72f3a9d23547e977c63285 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 can replace it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: 0
- address: "0x4a5aef39fcf659e9b6396edb92546e6f5a87f55c"
  implementation: null
  name: SemaphoreVerifier (membership proofs, group 3)
  upgradeable: "no"
  admin: none (immutable); manager 0xd9f2a4fff0c1909272ea9b393613dcb2a27b1137 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 can replace it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: 0
- address: "0xe44c83b9e1971a24ec698829297a0c4026b0cef9"
  implementation: null
  name: Verifier (insertion_b1200t30; group 1 batch insertion, size 1200)
  upgradeable: "no"
  admin: none (immutable); VerifierLookupTable 0x4055b6d4018e92e4d000865e61e87b57a4e5ab49 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can update or disable it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-07-19
  txs_30d: 0
- address: "0x75cbc75e1c8a63faeb0470464a0497d3b7a90f85"
  implementation: null
  name: Verifier (insertion b100; group 3 batch insertion, size 100)
  upgradeable: "no"
  admin: none (immutable); VerifierLookupTable 0xfa6c61419bde2b5743d5d79c80c72e0a2a344405 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can update or disable it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 720
- address: "0x469449f251692e0779667583026b5a1e99512157"
  implementation: null
  name: Verifier (insertion b100; group 2 batch insertion, size 100)
  upgradeable: "no"
  admin: none (immutable); VerifierLookupTable 0x54aef6aba7e27e3b3698549449596e0f251962c4 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can update or disable it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 536
- address: "0xb5f23a0c92f2f4aee506fa3b1cc2813820d13258"
  implementation: null
  name: Verifier (insertion_b100t30; group 1 batch insertion, size 100)
  upgradeable: "no"
  admin: none (immutable); VerifierLookupTable 0x4055b6d4018e92e4d000865e61e87b57a4e5ab49 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can update or disable it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 448
- address: "0x43b68ccba7fc726540768fd1537c3179283140ed"
  implementation: null
  name: Verifier (deletion_b100t30; group 1 batch deletion, size 100)
  upgradeable: "no"
  admin: none (immutable); VerifierLookupTable 0x39ccb3b670651a14da8b3835f42924f49c2c5986 owner Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (4 of 6) can update or disable it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 43
families: []
fix:
  layer: contract-upgrade
  who_acts: "Worldcoin Safe 0xc534a745bffaf9466ed7b47fa23b0177b99a3e77 (Safe 1.3.0, 4 of 6; read at block 26431535): owner of WorldIDRouter 0x163b09b4fe21177c455d850bd815b6d583732432, the UUPS WorldIDIdentityManager proxies of groups 1-3 (0xf7134ce138832c1456f2a91d64621ee90c2bddea, 0x5fb49f5b63421bd43c72f3a9d23547e977c63285, 0xd9f2a4fff0c1909272ea9b393613dcb2a27b1137) and their six VerifierLookupTables; group 0 manager 0x3310846ee4250603e6ac6e4904e7e1667a1b248a is owned by contract 0xe71e46a8dd85bb3818fbbdaf8179da50a12d7166"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/worldcoin-world-id-groth16/classification.jsonl
  - evidence/worldcoin-world-id-groth16/onchain.json
  - evidence/worldcoin-world-id-groth16/activity.json
  - evidence/worldcoin-world-id-groth16/source-excerpts.md
  - evidence/worldcoin-world-id-groth16/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_2.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review16 (verified source of WorldIDIdentityManagerImplV2, WorldIDRouterImplV1, VerifierLookupTable, SemaphoreVerifier; on-chain reads; Xatu scan for consumers)
  ref: evidence/worldcoin-world-id-groth16/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

World ID on mainnet verifies two kinds of BN254 Groth16 proofs (PQ-7): batch insertion/deletion proofs that move each
identity tree's root, and Semaphore membership proofs that apps check through `WorldIDRouter.verifyProof`. With the
setup trapdoor, a quantum attacker could forge a membership proof (any nullifier, any signal) for any current root,
i.e. pass any World ID "unique human" check on mainnet; tree updates stay gated by the identity-operator EOAs, who can
already insert any commitments with an honest proof. No mainnet transaction has consumed a membership proof since
2023-08-22, so nothing on mainnet can be taken (escrow USD 0). Rated LOW: step 4 gives MEDIUM (the owner Safe must
swap verifiers or upgrade the managers), step 5 lowers it for a measured exposure of USD 0.

## Mechanism

- Membership (b): `WorldIDRouterImplV1.verifyProof` (line 342) routes by `groupId` to the group's
  `WorldIDIdentityManager.verifyProof` (`WorldIDIdentityManagerImplV1.sol` lines 677-692), which checks
  `requireValidRoot(root)` (latest root, or a recent one within `rootHistoryExpiry` = 604,800 s) and calls
  `semaphoreVerifier.verifyProof(proof, [root, nullifierHash, signalHash, externalNullifierHash])`. The verifiers
  are snarkjs/Semaphore Groth16 templates (`SemaphoreVerifier.sol`: `Pairing.pairingCheck` for `0xcdbbcd1c…`;
  `staticcall(gas(), PRECOMPILE_VERIFY, …)` at lines 534/588 for `0x443ad7ac…` and `0x4a5aef39…`). The function is
  a `view` that returns nothing on success: double-signalling (nullifier) checks and any payout are the consuming
  app's job.
- Tree updates (a): `registerIdentities` (lines 376-417, `onlyIdentityOperator`, i.e. `msg.sender ==
  _identityOperator`) requires `preRoot == _latestRoot`, hashes the inputs and calls
  `batchInsertionVerifiers.getVerifierFor(n).verifyProof(insertionProof, [inputHash mod r])`; on success
  `_latestRoot = postRoot`. `deleteIdentities` (`WorldIDIdentityManagerImplV2.sol` line 112, same modifier) does
  the same with `batchDeletionVerifiers` (line 141). The five listed batch verifiers are Groth16 templates whose
  pairing check is `staticcall(gas(), PRECOMPILE_VERIFY, pairings, 0x300, output, 0x20)` (excerpt lines 461/499).
- Configurability: `setSemaphoreVerifier` (line 575), `setRegisterIdentitiesVerifierLookupTable` (line 537),
  `setDeleteIdentitiesVerifierLookupTable` (V2 line 184) are `onlyOwner` on the manager; `VerifierLookupTable`
  (`Ownable2Step`) `addVerifier`/`updateVerifier`/`disableVerifier` are `onlyOwner`; managers and router are UUPS
  proxies.

Pattern PQ-7. Source excerpts: [`source-excerpts.md`](../evidence/worldcoin-world-id-groth16/source-excerpts.md);
all reads: [`escrow.json`](../evidence/worldcoin-world-id-groth16/escrow.json).

## Evidence

- CHECKED (Sourcify verified source): `WorldIDIdentityManagerImplV2` `0x521e8fb3…` (implementation of the group 1
  manager), `WorldIDRouterImplV1` `0x31b0e17d…`, `VerifierLookupTable`, `SemaphoreVerifier` at the three addresses
  above; batch verifiers per the classifier's excerpts. INFERRED: groups 2 and 3 run the same code (their
  implementations `0x6c6727ea…` and `0xa1b0bd93…` carry the same contract name on Blockscout; not diffed).
- CHECKED (block 26,431,535): router `0x163b09b4…` (implementation `0x31b0e17d…`, `owner()` Safe `0xc534a745…`,
  `groupCount()` = 4) routes group 0 → `0x3310846e…`, 1 → `0xf7134ce1…`, 2 → `0x5fb49f5b…`, 3 → `0xd9f2a4ff…`
  (Blockscout labels `0xd9f2a4ff…` "WorldIDRouter"; it is an identity manager). Groups 1-3: `owner()` Safe
  `0xc534a745…` (Safe 1.3.0, threshold 4 of 6 owners), `pendingOwner()` 0 for group 1.
- CHECKED (block 26,431,535): `getSemaphoreVerifierAddress()` = `0xcdbbcd1c…` (groups 0 and 1), `0x443ad7ac…`
  (group 2), `0x4a5aef39…` (group 3). Lookup tables (all owned by Safe `0xc534a745…`):
  `0xb5f23a0c…` = group 1 insertion size 100, `0xe44c83b9…` = group 1 insertion 1200, `0x43b68ccb…` = group 1
  deletion 100, `0x469449f2…` = group 2 insertion 100, `0x75cbc75e…` = group 3 insertion 100.
- CHECKED (block 26,431,535): identity operators are EOAs (no code): `0xe2da0463…` (group 1, nonce 115,089),
  `0x41e8af78…` (group 2), `0x3e9c4ba4…` (group 3), `0x9ad4efaf…` (group 0). Sample transactions
  `0x3f1e6c18…` (block 26,431,298: `0x3e9c4ba4…` → `0xd9f2a4ff…registerIdentities` → `0x75cbc75e…`) and
  `0xe0a5bf05…` (block 26,431,239: `0x41e8af78…` → `0x5fb49f5b…` → `0x469449f2…`).
- CHECKED (consumers): in the precompile trace (all mainnet transactions to block 24,683,719), `0xcdbbcd1c…` made
  one `ecPairing` call (block 17,968,052, 2023-08-22); `0x443ad7ac…` and `0x4a5aef39…` none. A Xatu scan of
  transactions and call frames in blocks 24,700,000-26,423,999 (3,448 partitions) found no call to the three
  SemaphoreVerifiers or to the router proxy/implementation. Off-chain `eth_call` verification is not visible and
  moves nothing on mainnet.
- CHECKED (holdings, block 26,431,214/26,431,535 and Blockscout 2026-11-17): verifiers, router and managers hold
  0 ETH; the managers hold only 1 HEX of spam (USD 0.0005).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): batch verifier activity in the table below
  ([`activity.json`](../evidence/worldcoin-world-id-groth16/activity.json)).
- INFERRED (not read on mainnet): World ID roots are relayed from these managers to L2s (World Chain, Optimism,
  Base) by state-bridge contracts, and WLD grants (RecurringGrantDrop) and most World ID apps run on those L2s with
  their own Groth16 verifiers; those are outside this mainnet registry.

## Impact and exposure

| Contract | Role | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0xcdbbcd1c…` SemaphoreVerifier | membership, groups 0-1 | no (swappable) | 0 | 2023-08-22 | 0 |
| `0x443ad7ac…` SemaphoreVerifier | membership, group 2 | no (swappable) | 0 | never called | 0 |
| `0x4a5aef39…` SemaphoreVerifier | membership, group 3 | no (swappable) | 0 | never called | 0 |
| `0xe44c83b9…` Verifier insertion 1200 | group 1 tree update | no (swappable) | 0 | 2026-07-19 | 0 |
| `0x75cbc75e…` Verifier insertion 100 | group 3 tree update | no (swappable) | 0 | 2026-11-15 | 720 |
| `0x469449f2…` Verifier insertion 100 | group 2 tree update | no (swappable) | 0 | 2026-11-15 | 536 |
| `0xb5f23a0c…` Verifier insertion 100 | group 1 tree update | no (swappable) | 0 | 2026-11-15 | 448 |
| `0x43b68ccb…` Verifier deletion 100 | group 1 tree update | no (swappable) | 0 | 2026-11-15 | 43 |

Escrow: none. No mainnet contract consumed a World ID membership proof in a transaction since 2023-08-22, and no
WLD grant or airdrop contract on mainnet was found calling the router or a SemaphoreVerifier, so a forged
membership proof takes nothing on mainnet (`value_usd` 0, basis `escrow`, 2026-11-17). A forged insertion or deletion
proof can only be submitted by the group's identity operator EOA; since the operator can already insert arbitrary
commitments with a valid proof, the trapdoor adds nothing an outsider can use. (A CRQC holder who also recovers an
operator's secp256k1 key could rewrite a tree root, and through the relayed roots affect L2 consumers [INFERRED]; that
is an operator-key exposure, not this finding.)

Other Groth16 verifiers registered in the same lookup tables, checked but not listed (same mechanism, same admin):
group 1 `0xfc1c26e9…` (insertion 600, last trace call block 20,693,439), `0xf07d3efa…` (insertion 1000, block
18,986,757), `0xca7d6822…` (deletion 10, block 24,434,569); group 2 `0x54c0d1b3…`, `0x8308f4ef…`, `0xf0f626ca…`,
`0x289d124d…` (no trace calls), `0x72ef65c9…` (1 call); group 3 `0x720e02a6…`, `0x6485091d…`, `0xea94f90e…` (no trace
calls), `0x805dd45f…` (insertion 1200, 45 calls, last block 24,284,180), `0x49602c88…` (1 call). Group 0 manager
`0x3310846e…` (implementation `WorldIDIdentityManagerImplV1`, insertion table `0x78ec127a…` not read).

## Remediation

- Membership: a post-quantum World ID proof (hash-based/STARK membership circuit) with a matching verifier. The proof
  format (`uint256[8]`) is fixed in `verifyProof`, so the Safe `0xc534a745…` (4 of 6) must upgrade the UUPS managers
  and router; World App must ship the new prover and consuming apps must accept the new proof. Group 0 needs its owner
  `0xe71e46a8…` (or the router owner can `disableGroup`/`updateGroup`).
- Tree updates: replace the batch insertion/deletion verifiers with STARK/FRI verifiers through the lookup tables
  (`updateVerifier`, Safe `0xc534a745…`), and move the identity-operator role off an ECDSA EOA.
- No protocol change is needed. Users cannot protect themselves; mainnet apps should not gate value on World ID
  proofs until the verifiers are post-quantum.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> LOW, step 5: step 4 stays MEDIUM (Safe 0xc534a745, 4 of 6, must swap verifiers or upgrade the UUPS managers/router), but the measured exposure is USD 0: no mainnet transaction has consumed a membership proof since 2023-08-22 and batch updates are `onlyIdentityOperator`. Added the three SemaphoreVerifiers (the membership-proof verifiers), mapped each batch verifier to its group and lookup table, set impact `none` and fix.layer `contract-upgrade`.
