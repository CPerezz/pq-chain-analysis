---
id: taiko-zk-verifiers
title: "Taiko: the live ZkRequiredVerifier accepts RISC Zero Groth16 and SP1 Plonk proofs on BN254; with a quantum computer forged proofs finalize a false L2 state that releases the L1 bridge and vaults (USD 9.9M)"
project: taiko
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x7284aac05555ae6559bdad8b4221ec9584254eec"
  implementation: null
  name: ZkRequiredVerifier (Shasta inbox proofVerifier)
  upgradeable: "no"
  admin: none (immutable sub-verifier addresses, no owner); replaced by upgrading Shasta inbox proxy 0x6f21c543a4af5189ebdb0723827577e1ef57ef1f (UUPS, owner TaikoDAOController 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a)
  value_usd: 9946783
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: 1355
- address: "0x73a0db393ef87ce781ac7957be10d6628432100f"
  implementation: null
  name: SP1Verifier (Taiko wrapper, SP1_RETH) → SP1VerifierGateway 0x3b6041173b80e77f038f3f2c0f9744f04837185e
  upgradeable: config-only
  admin: not a proxy; Ownable2Step owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController) sets trusted program vkeys; remote verifier immutable; gateway routes set by Succinct (owner 0xcafef00d348adbd57c37d1b77e0619c6244c6878)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: 690
- address: "0x059daf31f571da48ab4e74ae12f64f907681cd8b"
  implementation: null
  name: Risc0Verifier (Taiko wrapper, RISC0_RETH) → RiscZeroVerifierRouter 0x8eab2d97dfce405a1692a21b3ff3a172d593d319
  upgradeable: config-only
  admin: not a proxy; Ownable2Step owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController) sets trusted image IDs; router immutable; router routes set by RISC Zero (owner 0x0b144e07a0826182b6b59788c34b32bfa86fb711)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-02
  txs_30d: 665
- address: "0x68593ad19705e9ce919b2e368f5cb7baf04f7371"
  implementation: null
  name: SP1Verifier (Plonk v4.0.0-rc.3, Taiko-deployed copy, retired)
  upgradeable: "no"
  admin: none; not referenced by any live Taiko verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-06-03
  txs_30d: 0
- address: "0xff5adab685362dc4c33536a65af5873738d1216b"
  implementation: null
  name: SP1Verifier (Plonk v5.0.0, Taiko-deployed, retired Pacaya path)
  upgradeable: "no"
  admin: none; remote verifier of the retired Pacaya TaikoSP1Verifier proxy 0xbee1040d0aab17ae19454384904525ae4a3602b9
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-04-02
  txs_30d: 0
- address: "0xf31de43cc0cf75245ade63d3dabf58d4332855e9"
  implementation: null
  name: RiscZeroGroth16Verifier (1.2.0, Taiko-deployed, retired)
  upgradeable: "no"
  admin: none; not referenced by any live Taiko verifier (selector 0xc101b42b removed from the RISC Zero router)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-17
  txs_30d: 0
- address: "0x34eda8bffb539aec33078819847b36d221c6641c"
  implementation: null
  name: RiscZeroGroth16Verifier (2.2.0, Taiko-deployed, retired)
  upgradeable: "no"
  admin: none; not referenced by any live Taiko verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-10-01
  txs_30d: 0
- address: "0x7cca385bdc790c25924333f5adb7f4967f5d1599"
  implementation: null
  name: RiscZeroGroth16Verifier (3.0.0, Taiko-deployed, retired Pacaya path)
  upgradeable: "no"
  admin: none; Groth16 verifier of the retired Pacaya Risc0Verifier proxy 0x73ee496da20e5c65340c040b0d8c3c891c1f74ae
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: 0
- address: "0xfb3ca570a5348fd101e65303eecdb5bf43c5548a"
  implementation: null
  name: RiscZeroGroth16Verifier (Taiko-deployed, retired Pacaya path)
  upgradeable: "no"
  admin: none (immutable); its only consumer, Pacaya Risc0Verifier proxy 0x73ee496da20e5c65340c040b0d8c3c891c1f74ae, was upgraded to an implementation that uses 0x7cca385bdc790c25924333f5adb7f4967f5d1599 instead
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-07-24
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Taiko DAO 0x9cdf589c941ee81d75f34d3755671d614f7cf261 (Aragon OSx; standard proposals from Security Council multisig 0xd7da1c25e915438720692bc55eb3a7170ca90321, 3 of 5 signers, through optimistic token voting 0x989e348275b659d36f8751ea1c10d146211650be; emergency multisig 0x2affadeb2ef5e1f2a7f58964ee191f1e88317ecd, 4 of 5) acting through TaikoDAOController 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a, owner of the Shasta inbox proxy 0x6f21c543a4af5189ebdb0723827577e1ef57ef1f
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/taiko-zk-verifiers/classification.jsonl
  - evidence/taiko-zk-verifiers/onchain.json
  - evidence/taiko-zk-verifiers/activity.json
  - evidence/taiko-zk-verifiers/source-excerpts.md
  - evidence/taiko-zk-verifiers/escrow.json
  - evidence/taiko-zk-verifiers/prove_scan.py
  - evidence/taiko-zk-verifiers/fb3ca570-classification.jsonl
  - evidence/taiko-zk-verifiers/fb3ca570-onchain.json
  - evidence/taiko-zk-verifiers/fb3ca570-activity.json
  - evidence/taiko-zk-verifiers/fb3ca570-source-excerpts.md
  - evidence/taiko-zk-verifiers/fb3ca570-notes.md
  - evidence/taiko-zk-verifiers/fb3ca570-merge-reads.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier, SP1Verifier and Risc0Verifier wrappers; on-chain reads at block 26,431,535)
  ref: evidence/taiko-zk-verifiers/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  who: Review15 (review of the former finding unidentified-fb3ca570-snark-verifier, merged here)
  ref: evidence/taiko-zk-verifiers/fb3ca570-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [taiko-sgx-instance-keys]
---

## Summary

Taiko's L1 inbox finalises an L2 state when `ZkRequiredVerifier` accepts two sub-proofs. Every accepted pair contains a RISC Zero Groth16 or SP1 Plonk proof, both checked with BN254 pairings. A quantum attacker can recover those setups' trapdoors and forge RISC0 + SP1 proofs, which `ZkRequiredVerifier` accepts with no SGX signature at all. The attacker can also pair a forged ZK proof with an SGX signature from a recovered instance key (see `taiko-sgx-instance-keys`). The false state root then lets the attacker withdraw from the L1 Bridge and ERC20Vault, which held USD 9.9M on 2026-11-17. Rated MEDIUM at step 4: the Taiko DAO can fix it by upgrading the inbox to post-quantum verifiers. None of the four originally listed verifiers is still wired in; the live path runs through the Succinct and RISC Zero routers.

## Mechanism

Live path (Shasta, since 2026-04-02):

1. `MainnetInbox.prove(_data, _proof)` on the inbox proxy `0x6f21c543…` (implementation `0xa18431d4…`, `Inbox.sol` lines 321–399) calls `_signalService.saveCheckpoint(blockNumber, stateRoot, blockHash)` on SignalService `0x9e0a2496…`, then `_proofVerifier.verifyProof(proposalAge, commitmentHash, _proof)`. A failed verification reverts the whole transaction. Only whitelisted provers may call `prove` (ProverWhitelist `0xea798547…`, 2 provers). The active prover `0xa5cb34b7…` is an EOA whose public key is on chain, so this is no barrier for a CRQC holder.
2. `_proofVerifier` = `ZkRequiredVerifier` `0x7284aac0…`. `ComposeVerifier.verifyProof` calls each `SubProof` verifier by ID. `areVerifiersSufficient` accepts exactly: [SGX_GETH or SGX_RETH] + [RISC0_RETH or SP1_RETH], or RISC0_RETH + SP1_RETH. Sub-verifiers (immutables): SGX_GETH `0x41e79eb4…`, SGX_RETH `0x9d3c595b…`, RISC0_RETH `0x059daf31…`, SP1_RETH `0x73a0db39…`.
3. SP1 leg: Taiko's `SP1Verifier.verifyProof` (`0x73a0db39…`, lines 50–84) checks the aggregation and block-program vkeys against `isProgramTrusted`. It then `staticcall`s the immutable `sp1RemoteVerifier` = SP1VerifierGateway `0x3b604117…` (Succinct). The gateway routes by the proof's first 4 bytes. All SP1 proofs in the window used selector `0x5a093a2f`, which routes to `0xc3c6dddac8829b233dc6536ec024775a57b0af2a` (`SP1Verifier` v6.1.0, `SP1VerifierPlonk`, BN254 Plonk, not frozen).
4. RISC Zero leg: Taiko's `Risc0Verifier.verifyProof` (`0x059daf31…`, lines 49–81) checks `isImageTrusted` for both image IDs and `staticcall`s the immutable `riscoGroth16Verifier` = RiscZeroVerifierRouter `0x8eab2d97…` (RISC Zero). All RISC Zero proofs in the window used selector `0x73c457ba`. That routes to emergency-stop wrapper `0x9f9994eb…` (not paused), which calls `RiscZeroGroth16Verifier` `0x2a098988600d87650fb061ffaff08b97149fa84d` (3.0.0, BN254 Groth16).
5. With the false checkpoint saved, `Bridge.processMessage` (`0xd60247c6…`) accepts storage proofs through `signalService.proveSignalReceived` and releases ETH, and the vaults release tokens.

Pattern PQ-7: BN254 pairings with a trusted setup, so with the trapdoor false proofs verify.

The four originally listed contracts, plus two more Taiko-deployed RISC Zero copies (`0x7cca385b…`, and `0xfb3ca570…` merged from `unidentified-fb3ca570-snark-verifier`), are BN254 verifiers that are no longer on any path that releases funds:

- `0x68593ad1…` SP1 Plonk v4.0.0-rc.3, `0xf31de43c…` RISC Zero 1.2.0 and `0x34eda8bf…` RISC Zero 2.2.0: not referenced by any live Taiko wrapper. The RISC Zero router reports `SelectorRemoved` for 1.2.0's selector. Their last calls were 2025-06-03, 2025-04-17 and 2025-10-01.
- `0xff5adab6…` SP1 Plonk v5.0.0: remote verifier of the Pacaya `TaikoSP1Verifier` proxy `0xbee1040d…`.
- `0x7cca385b…` RISC Zero 3.0.0: Groth16 verifier of the Pacaya `Risc0Verifier` proxy `0x73ee496d…` (its current
  `riscoGroth16Verifier()`, read at block 26,431,723). It was deployed at block 23,472,891 (2025-09-30) and never
  verified a proof: no pairing call in the precompile trace to block 24,683,719 (only `sha256` in its constructor
  transaction), and no call frame to it or to `0x73ee496d…` in Xatu traces for blocks 24,683,000–26,423,999
  ([`fb3ca570-merge-reads.md`](../evidence/taiko-zk-verifiers/fb3ca570-merge-reads.md)). The live RISC Zero router
  routes the same selector `0x73c457ba` to estop `0x9f9994eb…`, not to `0x7cca385b…`.
- `0xfb3ca570…` RISC Zero Groth16 (stock `risc0-ethereum` `RiscZeroGroth16Verifier`, same deployer `0xcdcebd75…`):
  the Pacaya `Risc0Verifier` proxy `0x73ee496d…` called it from block 22,679,611 to 22,986,441 (2025-07-24, 936
  transactions; last tx `0x1135dd3c…`: ProverSet `0x68d30f47…` -> Pacaya inbox `0x06a9ab27…` -> `MainnetVerifier`
  `0xb16931e7…` -> `0x73ee496d…` -> `staticcall 0xfb3ca570…`). The proxy was then upgraded to implementation
  `0xdf6327ca…`, whose immutable verifier is `0x7cca385b…`; its runtime code does not contain `0xfb3ca570…`
  ([`fb3ca570-notes.md`](../evidence/taiko-zk-verifiers/fb3ca570-notes.md),
  [`fb3ca570-source-excerpts.md`](../evidence/taiko-zk-verifiers/fb3ca570-source-excerpts.md)).

Both Pacaya wrappers sit in `MainnetVerifier` `0xb16931e7…`, which only the Pacaya inbox `0x06a9ab27…` (`inbox.based.taiko.eth`) calls. That path is retired: every Pacaya batch is verified, and after the Shasta fork timestamp the Pacaya inbox no longer writes to SignalService, which only accepts checkpoints from the Shasta inbox.

Source excerpts: [`source-excerpts.md`](../evidence/taiko-zk-verifiers/source-excerpts.md).

## Evidence

- CHECKED (precompile trace, all mainnet transactions to March 2026): `ecpairing`/`ecmul`/`ecadd` and BN254 field arithmetic in the four listed verifiers.
- CHECKED (verified source, Sourcify and Blockscout): Shasta `MainnetInbox`/`Inbox` `0xa18431d4…`, `ZkRequiredVerifier`/`ComposeVerifier` `0x7284aac0…`, Taiko `SP1Verifier` `0x73a0db39…`, Taiko `Risc0Verifier` `0x059daf31…`, `SP1Verifier` v6.1.0 `0xc3c6ddda…` (`SP1VerifierPlonk.sol`), Pacaya `MainnetInbox` `0x38dd73fe…` and `MainnetVerifier` `0x8c520bb7…`, `TaikoDAOController` `0x4347df63…`.
- CHECKED (on-chain reads at block 26,431,535, 2026-11-17; [`escrow.json`](../evidence/taiko-zk-verifiers/escrow.json)):
  - Shasta inbox: `getConfig()`, `owner()`, EIP-1967 implementation.
  - ZkRequiredVerifier: the six verifier immutables; no EIP-1967 implementation, no owner.
  - Wrappers: `sp1RemoteVerifier()`, `riscoGroth16Verifier()`, `owner()`.
  - Routes: gateway `routes(0x5a093a2f)`, `routes(0x1b34fe11)` and `routes(0xd4e8ecd2)` (both frozen, to Succinct's own copies); router `getVerifier` for each listed selector; estop `paused()`.
  - `VERSION()`/`SELECTOR()`/`VERIFIER_HASH()` of the listed verifiers.
  - Pacaya `MainnetVerifier` sub-verifiers and wrapper targets; governance chain as in `taiko-sgx-instance-keys`.
- CHECKED (proof composition; [`prove_scan.py`](../evidence/taiko-zk-verifiers/prove_scan.py), run on the remote box): decoded all 1,369 `prove` transactions to the Shasta inbox in blocks 26,208,000–26,431,535. 704 were SGX_GETH + SP1 (selector `0x5a093a2f`, last block 26,426,198); 665 were SGX_GETH + RISC0 (selector `0x73c457ba`, last block 26,325,763, 2026-11-02). In the 30-day window 2026-10-16 to 2026-11-16 there were 1,355 (690 SP1, 665 RISC0).
- CHECKED (Xatu activity, any function): no calls to the four listed verifiers in 2026-10-16 to 2026-11-16. `0xff5adab6…` was last called 2026-04-02; the other three have no call since 2026-03-18, and their last pre-quantum calls in the trace are listed above.
- INFERRED: the ERC20Vault releases bridged tokens after `Bridge.processMessage` (standard Taiko design; vault source not read here).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7284aac0…` ZkRequiredVerifier (live) | no | 0 (escrow USD 9.9M) | 2026-11-17 | 1,355 |
| `0x73a0db39…` SP1Verifier wrapper (live) | config-only | 0 | 2026-11-17 | 690 |
| `0x059daf31…` Risc0Verifier wrapper (live) | config-only | 0 | 2026-11-02 | 665 |
| `0x68593ad1…` SP1Verifier (Plonk v4.0.0-rc.3, retired) | no | 0 | 2025-06-03 | 0 |
| `0xff5adab6…` SP1Verifier (Plonk v5.0.0, Pacaya, retired) | no | 0 | 2026-04-02 | 0 |
| `0xf31de43c…` RiscZeroGroth16Verifier 1.2.0 (retired) | no | 0 | 2025-04-17 | 0 |
| `0x34eda8bf…` RiscZeroGroth16Verifier 2.2.0 (retired) | no | 0 | 2025-10-01 | 0 |
| `0x7cca385b…` RiscZeroGroth16Verifier 3.0.0 (Pacaya, retired) | no | 0 | never verified a proof | 0 |
| `0xfb3ca570…` RiscZeroGroth16Verifier (Pacaya, retired) | no | 0 | 2025-07-24 | 0 |

Escrow: what a false finalised state root can release, read at block 26,431,535. Addresses come from resolver `0x8efa0156…`.

- Bridge `0xd60247c6848b7ca29eddf63aa924e53db6ddd8ec`: 878.04 ETH = USD 1,590,675 at USD 1,811.62.
- ERC20Vault `0x996282ca11e5deb6b5d122cc3b9a1fcaad4415ab`: USD 8,356,107 in priced tokens (Blockscout `exchange_rate`). Includes:
  - 137,975,153 TAIKO at USD 0.058361 = USD 8,052,368;
  - 221,690 USDC;
  - 20.70 WETH;
  - 33,928 USDT.
- ERC721Vault `0x0b470dd3a0e1c41228856fb319649e7c08f419aa` and ERC1155Vault `0xaf145913ea4a56be22e120ed9c24589659881702`: NFTs only, not priced.

Total USD 9,946,783, entered on `0x7284aac0…`. It is the same escrow as in `taiko-sgx-instance-keys` and is not additive. QuotaManager `0xbacb003f…` caps withdrawals per 24 hours (250 ETH, 10M TAIKO, 250k USDC), and a 4-of-6 Safe `0x9cbee534…` can pause the Bridge. These slow a drain but do not prevent it.

The live BN254 verifiers themselves belong to their vendors:

- `0xc3c6ddda…` (SP1 v6.1.0) is not yet in any finding. It belongs in `succinct-sp1-verifier`.
- `0x2a098988…` is in `risc-zero-groth16-verifier`.

The retired verifiers hold nothing and are reachable from no path that releases funds; on their own they would rate LOW at step 1 or because the path is dormant.

## Remediation

- Post-quantum replacement: STARK/FRI (or WHIR) verification of the SP1 and RISC Zero receipts instead of the BN254 Plonk/Groth16 wrappers, deployed as new verifier contracts. Then a new compose verifier that accepts only post-quantum ZK legs, so a forged SGX signature or BN254 proof is never enough.
- Who acts: the Taiko DAO through TaikoDAOController `0x75ba7640…`. `ZkRequiredVerifier` and both wrappers hold their targets as immutables, and the inbox holds `proofVerifier` as an immutable. So the fix is new deployments plus an upgrade of the Shasta inbox proxy `0x6f21c543…` (UUPS, owner TaikoDAOController).
- Succinct (gateway owner `0xcafef00d…`) and RISC Zero (router owner `0x0b144e07…`) could add post-quantum routes. Taiko would then only need to trust new program vkeys or image IDs, and to stop accepting the BN254 selectors. Today the wrappers have no selector allowlist, so Taiko cannot block the BN254 routes without the vendors freezing them or an inbox upgrade.
- No Ethereum protocol change is needed. Users cannot protect bridged funds themselves, other than by withdrawing them to L1.
- The retired Taiko-deployed verifiers need no action.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> MEDIUM, step 4: none of the four listed verifiers is on the live path; all are retired. Added the live ZkRequiredVerifier `0x7284aac0…` and Taiko's SP1/Risc0 wrappers, and the retired Taiko-deployed RISC Zero 3.0.0 `0x7cca385b…`. The live legs route to vendor BN254 verifiers (SP1 v6.1.0 `0xc3c6ddda…`, RISC Zero 3.0.0 `0x2a098988…`). RISC0 + SP1 is accepted without SGX, and SGX + ZK falls too. Admin corrected from "none" to the Taiko DAO via TaikoDAOController (inbox upgrade); fix layer changed from onchain-config to contract-upgrade. Escrow measured: USD 9,946,783.
- 2026-11-17 review (Review15, finding `unidentified-fb3ca570-snark-verifier`): LOW confirmed (step 1). Consumer identified as Taiko's Pacaya Risc0Verifier `0x73ee496d…` (project -> taiko), which no longer uses this verifier (impact funds-loss -> none, fix layer -> none). Belongs in taiko-zk-verifiers; successor `0x7cca385b…` missing there at the time.
- 2026-11-17 merge (Review16): `unidentified-fb3ca570-snark-verifier` merged into this finding at Main's request; its contract `0xfb3ca570…` and evidence (`evidence/taiko-zk-verifiers/fb3ca570-*`) moved here, the source finding deleted. `0x7cca385b…` checked: it is the Pacaya Risc0Verifier's verifier, not on the live Shasta path (the live RISC Zero leg is wrapper `0x059daf31…` -> router `0x8eab2d97…` -> estop `0x9f9994eb…` -> `0x2a098988…`, read at block 26,431,723), and it never verified a proof (precompile trace and Xatu traces). Rating unchanged: MEDIUM (step 4) from the live path; the retired verifiers add no exposure.
