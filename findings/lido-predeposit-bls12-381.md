---
id: lido-predeposit-bls12-381
title: "Lido V3 PredepositGuarantee: a quantum attacker who recovers a validator's BLS key can front-run a stVault's 1 ETH predeposit, which the node operator's guarantee then repays (3 ETH held)"
project: lido
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bls12381, sw_bls12381]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xf4bf42c6d6a0e38825785048124dbad6c9eaaac3"
  implementation: "0xe78717192c45736df0e4be55c0219ee7f9addd0d"
  name: PredepositGuarantee (OssifiableProxy)
  upgradeable: "yes"
  admin: OssifiableProxy admin 0x3e40d73eb977dc6a537af587d48316fee66e9c8c (Lido Agent, controlled by Dual Governance executor 0x23e0b465633ff5178808f4a75186e2f2f9537021); not ossified
  value_usd: 5435
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-09
  txs_30d: 4
families: []
fix:
  layer: contract-upgrade
  who_acts: Lido DAO governance through Agent 0x3e40d73eb977dc6a537af587d48316fee66e9c8c (proxy admin); the beacon chain's move to post-quantum validator keys is upstream
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/lido-predeposit-bls12-381/classification.jsonl
  - evidence/lido-predeposit-bls12-381/onchain.json
  - evidence/lido-predeposit-bls12-381/activity.json
  - evidence/lido-predeposit-bls12-381/source-excerpts.md
  - evidence/lido-predeposit-bls12-381/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/lido-predeposit-bls12-381/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [lido-wsteth-permit, lido-steth-permit-code-first]
---

## Summary

Lido V3's PredepositGuarantee verifies each validator's BLS12-381 deposit signature with the EIP-2537 pairing
precompile before sending a stVault's 1 ETH predeposit to the deposit contract. The check itself gives an outsider
nothing (only the node operator's depositor can call `predeposit`, and a forged signature is also valid on the
beacon chain); the exposure is the beacon chain's BLS: a quantum attacker who recovers the validator key from the
pubkey can front-run the predeposit with its own withdrawal credentials, and the contract then repays the vault from
the node operator's locked 1 ETH guarantee. The guarantees held are 3 ETH ($5,435, 2026-11-17). Rated LOW: a fix by
DAO upgrade (MEDIUM, step 4), lowered one level for under $50k exposed (step 5).

## Mechanism

`predeposit(_stakingVault, _deposits, _depositsY)` (PredepositGuarantee.sol line 397) requires the caller to be the
node operator's depositor (line 406), locks 1 ETH of the operator's guarantee per validator and calls
`verifyDepositMessage` (line 438 → line 275), which runs `BLS12_381.verifyDepositMessage`: hash-to-G2 with
`BLS12_MAP_FP2_TO_G2`, then a `BLS12_PAIRING_CHECK` (0x0f) of the deposit signature against the validator pubkey
(BLS.sol lines 177–502). It then deposits `PREDEPOSIT_AMOUNT` = 1 ETH. If the validator turns out to have other
withdrawal credentials, `proveInvalidValidatorWC` (line 563) pays the vault 1 ETH out of the operator's locked
guarantee (lines 590–602). The pattern is PQ-6 (BLS), for a single validator signature, not a committee aggregate as
drafted. Excerpt: [`source-excerpts.md`](../evidence/lido-predeposit-bls12-381/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): the path above, the depositor-only restriction and the compensation from the
  guarantee ([`notes.md`](../evidence/lido-predeposit-bls12-381/notes.md)).
- CHECKED (`cast` at block 26,431,616): implementation `0xe7871719…`; `proxy__getAdmin()` = Agent `0x3e40d73e…`;
  not ossified; not paused; 3.0 ETH held.
- CHECKED (precompile trace to March 2026): 2 transactions with BLS12-381 pairing calls in the last year; Xatu: 4
  transactions in 2026-10-16 to 2026-11-16, last 2026-11-09.
- INFERRED: the front-run needs the validator's BLS secret key, recovered from the pubkey published in the
  `predeposit` transaction, before that transaction lands; a first deposit with valid signature sets the validator's
  withdrawal credentials on the beacon chain.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf4bf42c6…` PredepositGuarantee (OssifiableProxy) | yes | $5k (3 ETH guarantees) | 2026-11-09 | 4 |

Per front-run predeposit the attacker gains the vault's 1 ETH on the beacon chain and the vault is made whole from the
guarantor's locked balance in this contract, so the loss is bounded by the guarantees held here: 3 ETH ($5,435,
basis held). Staking vaults' funds beyond the 1 ETH predeposit are only sent after the withdrawal credentials are
proven (`proveWCAndActivate`), so they are not exposed through this path. Beacon-chain validator keys in general are
a protocol-level exposure outside this registry.

## Remediation

- The deposit signature scheme is set by the beacon chain; when Ethereum moves validators to post-quantum (hash-based)
  signatures, Lido DAO upgrades PredepositGuarantee through Agent `0x3e40d73e…` (OssifiableProxy admin) to verify the
  new scheme. A protocol change helps: post-quantum validator keys remove the front-run itself.
- Until then, Lido DAO can pause predeposits (`PausableUntilWithRoles`) and node operators can keep guarantees small.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 5: the exposure is the node operators' guarantees held in the
  contract (3 ETH, $5,435), under $50k. Trigger committee-keys -> operator-key (one validator's BLS key, not an
  aggregate); protocol change not-needed -> helps.
