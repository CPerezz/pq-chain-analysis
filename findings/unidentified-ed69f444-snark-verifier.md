---
id: unidentified-ed69f444-snark-verifier
title: "Unidentified RISC Zero block-history prover 0xed69f444: a recovered Groth16 setup trapdoor lets an attacker record false block metadata, which no on-chain contract was seen to use"
project: unidentified-ed69f444
status: candidate
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: unknown
alternative: sole
role: core
contracts:
- address: "0xed69f44448f597f55b3a9f1ad5bf61feee54c14c"
  implementation: "0x93d20f8b2798392db91b7cf9ebc111fe2e596378"
  name: ERC1967Proxy -> unverified implementation (verifyProof, setImageId, latestBlockMetadata)
  upgradeable: "yes"
  admin: UUPS upgradeToAndCall gated by DEFAULT_ADMIN_ROLE, held by deployer EOA 0x9db30c656fd33ba494ea605f78ae523e5ef55085 (read at block 26431614; other holders not enumerated)
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-29
  txs_30d: 38
families: []
fix:
  layer: contract-upgrade
  who_acts: DEFAULT_ADMIN_ROLE holder, deployer EOA 0x9db30c656fd33ba494ea605f78ae523e5ef55085, upgrading the implementation to a hash-based (STARK) verifier
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ed69f444-snark-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`0xed69f444…c14c` is a UUPS proxy whose unverified implementation accepts a Groth16 proof over BN254 (a RISC Zero
receipt, with `setImageId`) and then advances a stored "block metadata" record (height and a 32-byte digest) by 7,201
heights per submission (PQ-7). A quantum attacker who recovers the setup trapdoor could record any metadata. No
contract was seen reading it: every sampled transaction in the past year, and all 38 in the last 30 days, are direct
submissions from one whitelisted EOA, and the contract holds nothing, so the measured exposure is zero. Rated LOW:
MEDIUM by step 4 (one admin can upgrade), lowered by step 5 (nothing measured at stake); if an off-chain or future
consumer relies on it, it is MEDIUM.

## Mechanism

- Implementation `0x93d20f8b…6378` (unverified, 14,715 bytes) exposes `verifyProof(uint256[2],uint256[2][2],
  uint256[2],uint256[5])` (Groth16 with five public inputs, the RISC Zero layout), `setImageId(bytes32)`,
  `latestBlockMetadata()`, `initialBlockMetadata()`, `addUsers`/`removeUsers`/`isUser` (`USER_ROLE`), `pause`,
  OpenZeppelin `AccessControl` and `upgradeToAndCall`.
- Submissions use selector `0xe21962c8` (unnamed): eight proof words, the previous (height, digest) and the new
  (height, digest); the trace shows `sha256`, `ecadd`, `ecmul` and `ecpairing` in each, i.e. the claim digest and the
  pairing check.
- Pattern PQ-7. No verified implementation source
  ([`source-excerpts.md`](#source-excerpts-unidentified-ed69f444-snark-verifier)).

## Evidence

- CHECKED (bytecode and 4byte lookups, 2026-11-17): selectors above
  ([`state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ed69f444-snark-verifier/state.json)).
- CHECKED (on-chain reads at blocks 26,431,563–26,431,614): implementation slot = `0x93d20f8b…`, admin slot empty (UUPS);
  `hasRole(DEFAULT_ADMIN_ROLE, 0x9db30c65…5085)` = true (deployer EOA, nonce 4); `isUser(0xdb8455a4…484c)` = true;
  `paused()` = false; `latestBlockMetadata()` = height 22,264,417 with digest `0xa0ce3ec1…b830`;
  `initialBlockMetadata()` = height 10,100,488.
- CHECKED: the digest is not Ethereum's block hash at that height (`0xf0121ca9…dcc1`), so the tracked chain or the
  digest's meaning is not identified.
- CHECKED (Blockscout): the deployer only created the implementation and proxy, called `addUsers` and `setImageId`;
  the submitter's transactions all go to this proxy.
- CHECKED (precompile trace): 993 transactions in the year (blocks 22,336,209–24,681,832); 12 random ones are all
  `0xe21962c8` sent directly by `0xdb8455a4…` to the proxy.
- CHECKED (Xatu, any function): 38 transactions 2026-10-16 to 2026-11-16, all direct (none from another contract);
  last 2026-10-29 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ed69f444-snark-verifier/activity.json)).
- INFERRED: the proof is a RISC Zero Groth16 receipt (five public inputs, `setImageId`, `sha256`); a prover-run
  history accumulator of some chain, consumed off-chain or not yet.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0xed69f444…` ERC1967Proxy -> unverified | yes (UUPS, admin EOA) | 0: no on-chain consumer seen (2026-11-17) | 2026-10-29 | 38 |

- The proxy holds no ETH or tokens (dust HEX only). No contract read it in the last 30 days, and none of the sampled
  transactions in the year involves a consumer, so nothing is measured as releasable. A consumer that reads it with
  `eth_call` off-chain, or another chain, would not show here.
- Project: not identified (deployer `0x9db30c65…5085`, submitter `0xdb8455a4…484c`, no ENS or labels).

## Remediation

- Post-quantum replacement: verify the RISC Zero STARK receipt directly (or another hash-based proof) instead of the
  Groth16 wrapper, via a UUPS upgrade.
- Who must act: the `DEFAULT_ADMIN_ROLE` holder (deployer EOA `0x9db30c65…5085`). No protocol change needed.
- Consumers, if any: do not rely on `latestBlockMetadata` for value.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review05): MEDIUM -> LOW, step 5: every transaction checked is a direct submission by one
  whitelisted EOA and no contract reads the stored metadata, so the measured escrow is zero; `impact` funds-loss ->
  unknown (no consumer identified). Admin role read on-chain (deployer EOA).

# Source excerpts: unidentified-ed69f444-snark-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xed69f44448f597f55b3a9f1ad5bf61feee54c14c` — ERC1967Proxy (verified source via blockscout)

## Implementation `0x93d20f8b2798392db91b7cf9ebc111fe2e596378`

No verified source on Sourcify or Blockscout.
