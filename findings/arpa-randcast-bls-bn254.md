---
id: arpa-randcast-bls-bn254
title: "ARPA Randcast Adapter: a quantum attacker who recovers a node group's BN254 BLS key can compute every mainnet randomness output in advance; only ARPA's own test consumers have used it"
project: arpa
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x4363154e1ec107f81239a4f0b1cb3ab5161129ca"
  implementation: "0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3"
  name: ERC1967Proxy → Adapter
  upgradeable: "yes"
  admin: UUPS owner 0xfdeede3aa92583a46a419190c3e58d035b1fe060 (EOA, ARPA deployer)
  value_usd: 182
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 13
families: []
fix:
  layer: contract-upgrade
  who_acts: ARPA, through the Adapter's UUPS owner 0xfdeede3aa92583a46a419190c3e58d035b1fe060 (an EOA, itself an ECDSA key)
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/arpa-randcast-bls-bn254/classification.jsonl
  - evidence/arpa-randcast-bls-bn254/onchain.json
  - evidence/arpa-randcast-bls-bn254/activity.json
  - evidence/arpa-randcast-bls-bn254/source-excerpts.md
  - evidence/arpa-randcast-bls-bn254/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/arpa-randcast-bls-bn254/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Randcast delivers randomness as the hash of a node group's threshold BLS signature on BN254, checked in
`Adapter.fulfillRandomness` with a pairing (PQ-6). A quantum attacker who recovers the group key from its public key
can compute the (unique) signature for any request seed as soon as the request is made, so it knows every output
before it is delivered and can act on consumer contracts (lotteries, games) accordingly; it can also deliver the
output itself. On mainnet the Adapter holds 0.10 ETH ($182) and only two consumers, both ARPA's own and both empty,
have ever received randomness (4 fulfilments). Rated LOW: a fix by the owner's UUPS upgrade (MEDIUM, step 4),
lowered one level for under $50k measured exposure (step 5).

## Mechanism

`fulfillRandomness(groupIndex, requestId, signature, requestDetail, partialSignatures)` (Adapter.sol line 530)
checks the request commitment, then `_verifySignature` verifies the group signature with
`BLS.verifySingle(BLS.decompress(signature), g.publicKey, BLS.hashToPoint(actualSeed))` (line 998) and the members'
partials with `BLS.verifyPartials` (line 1014), both BN254 pairing checks. The output is
`keccak256(abi.encode(signature))` (line 587), passed to the consumer's callback (line 593). A BLS signature is unique
for a key and message, so a forger cannot choose the output, but with the group secret key it learns it early; with
members' keys it can also produce the partials and fulfil. `_authorizeUpgrade` is `onlyOwner` (line 187). Lines:
[`notes.md`](../evidence/arpa-randcast-bls-bn254/notes.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x2b4045c4…`): the path above.
- CHECKED (`cast` at block 26,431,574): implementation slot = `0x2b4045c4…`; `owner()` = `0xfdeede3a…` (EOA, nonce
  207, deployer of proxy and implementation); `getRandomnessCount()` = 4; 0.1002 ETH held.
- CHECKED (Blockscout, all 44 Adapter transactions): successful fulfilments on 2024-07-31, 2024-08-09, 2025-11-15 and
  2025-12-23, all for subscription 1 owned by `0xfdeede3a…`, consumers `0xa265737e…` and `0x8acfc64b…` (created by
  the owner; 0 ETH and no tokens on 2026-11-17). Eleven new subscriptions were funded 2026-11-14 to 2026-11-16 with no
  consumer or fulfilment yet.
- CHECKED (precompile trace to March 2026): 2 transactions with BN254 pairing in the last year.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4363154e…` ERC1967Proxy → Adapter | yes | $182 | 2026-11-16 | 13 |

The funds that depend on Randcast are in consumer contracts, not the Adapter. On mainnet the only consumers that have
received randomness are ARPA's two test consumers, which hold nothing (2026-11-17), so the measured exposure is the
Adapter's $182 of subscription balances, which a forged fulfilment cannot redirect (payment goes to the group members
whose partials verify). If the new subscriptions add funded consumers, the exposure grows to what those consumers stake
on the outcome.

## Remediation

- ARPA upgrades the Adapter (UUPS, owner `0xfdeede3a…`) to a post-quantum randomness source: e.g. a threshold
  scheme on lattice or hash-based signatures, or a commit-reveal beacon with a STARK-verified proof; node software must
  change with it.
- The owner is a single EOA: it is itself an ECDSA key a quantum attacker could recover to upgrade the Adapter, so
  moving ownership to a post-quantum account is part of the fix.
- Consumers should not use Randcast output to settle value until then. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 5: measured exposure is the Adapter's $182; the only consumers
  ever served are ARPA's own and hold nothing. Owner identified as an EOA.
