---
id: pyth-wormhole-receiver
title: "Pyth on Ethereum (receivers 0x3a2dd09b and 0x74f09cb3, PythLazer 0xacea761c): a quantum attacker who forges the receivers' ECDSA guardian quorums or the Lazer signer key can publish false prices and run Pyth governance"
project: pyth
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-4]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x3a2dd09b4739d905183d503d594c8fb3e3d41820"
  implementation: "0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8"
  name: Pyth price-feed Wormhole receiver (ERC1967Proxy, implementation unverified)
  upgradeable: config-only
  admin: "guardian set follows submitNewGuardianSet VAAs signed by its current set (index 1, 5 keys, block 26431744); no upgrade selector; consumer Pyth 0x4305fb66699c3b2702d4d05cf36551390a4c69c6 can be repointed by Pyth governance"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: null
- address: "0x74f09cb3c7e2a01865f424fd14f6dc9a14e3e94e"
  implementation: "0x87047526937246727e4869c5f76a347160e08672"
  name: Pyth Lazer governance Wormhole receiver (ERC1967Proxy, implementation unverified)
  upgradeable: config-only
  admin: "guardian set follows Wormhole guardian-signed submitNewGuardianSet VAAs (set 7, 19 keys, block 26431744); no upgrade selector; consumer Pyth executor 0xccd7e24e71ba746cbc758c39cbab11f4e0dfc46f can be repointed by Pyth governance"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-30
  txs_30d: 2
- address: "0xacea761c27a909d4d3895128ebe6370fde2df481"
  implementation: "0xa089a10d05ce37f4b99dc4f1824ba253434a779e"
  name: PythLazer (UUPS proxy)
  upgradeable: "yes"
  admin: "owner = Pyth executor 0xccd7e24e71ba746cbc758c39cbab11f4e0dfc46f (self-owned, acts on governance VAAs verified by 0x74f09cb3): upgrade, updateTrustedSigner"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: null
families: []
fix:
  layer: contract-upgrade
  who_acts: "Pyth governance (data source chain 1, emitter 0x5635979a221c34931e32620b9293a463065555ea71fe97cd6237ade875b12e9e): executeGovernanceInstruction on 0x4305fb66699c3b2702d4d05cf36551390a4c69c6 to upgrade or repoint to a post-quantum receiver; executor 0xccd7e24e71ba746cbc758c39cbab11f4e0dfc46f upgrades PythLazer and its own receiver; the receivers' guardians must sign with post-quantum keys"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/pyth-wormhole-receiver/classification.jsonl
  - evidence/pyth-wormhole-receiver/onchain.json
  - evidence/pyth-wormhole-receiver/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x74f09cb3
  ref: data/curation/out_0.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (PythLazer source, bytecode selectors, on-chain reads, Blockscout internal calls)
  ref: evidence/pyth-wormhole-receiver/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [wormhole-guardian-signatures]
---

## Summary

Pyth's Ethereum contracts accept prices and governance actions on ECDSA signatures. Price updates to Pyth
`0x4305fb66…` are checked against Wormhole-style VAAs verified by the receiver `0x3a2dd09b…`, whose guardian set has 5
keys. Pyth Lazer prices are signed by one trusted ECDSA key in PythLazer `0xacea761c…`, and Lazer governance runs on
VAAs verified by the receiver `0x74f09cb3…` with the Wormhole guardians' 19 keys. A quantum attacker who recovers
enough of those keys can publish false prices to every protocol that reads them, or take over the contracts through
governance. Pyth can upgrade and repoint all of them through its governance path, so the rating is MEDIUM (step 4:
contract upgrade); the value that relies on these prices was not measured.

## Mechanism

- `0x3a2dd09b…`: `parseAndVerifyVM` checks the VAA's ECDSA signatures against its current guardian set (index 1,
  5 keys; quorum 4 if it uses Wormhole's `quorum()`, INFERRED from the selectors). Pyth `0x4305fb66…` uses it for
  `updatePriceFeeds` (price data source chain 26) and `executeGovernanceInstruction` (governance data source chain 1).
  The set changes only by `submitNewGuardianSet` VAAs signed by the current set (PQ-5).
- `0x74f09cb3…`: same interface with the Wormhole guardian set 7 (19 keys, 13 needed). The Pyth executor `0xccd7e24e…`
  staticcalls it to verify a governance VAA and then calls PythLazer as its owner (PQ-5).
- PythLazer `verifyUpdate(update)` (`src/PythLazer.sol` 130-172): `ECDSA.tryRecover(keccak256(payload), v, r, s)` must
  be a trusted, unexpired signer; one signer `0x26fb61a8…` is trusted until 2035-10-30 (PQ-4). The owner can add or
  remove signers and upgrade (`_authorizeUpgrade` is `onlyOwner`), but not change the scheme without an upgrade.

## Evidence

- CHECKED (Sourcify exact match of PythLazer implementation `0xa089a10d…`): `verifyUpdate`, `updateTrustedSigner`,
  `_authorizeUpgrade` ([`review-notes.md`](../evidence/pyth-wormhole-receiver/review-notes.md)).
- CHECKED (bytecode selectors, latest block): both receivers have `parseAndVerifyVM` and `submitNewGuardianSet` and no
  upgrade selector; the executor and the Pyth implementation have `upgradeTo`; Pyth has `executeGovernanceInstruction`
  ([`onchain.json`](../evidence/pyth-wormhole-receiver/onchain.json)).
- CHECKED (on-chain, block 26,431,744): `0x3a2dd09b…` guardian set 1 = 5 keys;
  `0x74f09cb3…` set 7 identical to the core's; Pyth `wormhole()` = `0x3a2dd09b…`; PythLazer `owner()` = executor,
  executor `owner()` = itself; one Lazer trusted signer.
- CHECKED (Blockscout internal calls of tx `0x960a2d4c…`, block 26,306,172): executor → `0x74f09cb3…` → PythLazer.
- CHECKED (Blockscout, 2026-11-17): Pyth 866 direct transactions 2026-10-16 to 2026-11-16; `0x3a2dd09b…` and PythLazer
  called internally up to 2026-11-17 (their 30-day counts were not established); `0x74f09cb3…` 2 transactions in the
  Xatu window, last 2026-10-30 (`evidence/wormhole-guardian-signatures/activity.json`).
- INFERRED: the receivers' implementations follow Wormhole's core `Messages` logic (same selectors and getters);
  their source is not verified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3a2dd09b…` price-feed receiver | config-only | $0 | 2026-11-17 | — |
| `0x74f09cb3…` Lazer governance receiver | config-only | $0 | 2026-10-30 | 2 |
| `0xacea761c…` PythLazer | yes | ~$0 | 2026-11-17 | — |

The contracts hold dust (Pyth `0x4305fb66…` 0.0034 ETH of fees, PythLazer 59,200 wei). The exposure is whatever
Ethereum protocols secure with Pyth and Pyth Lazer prices (lending collateral, derivatives), which these contracts do
not show; `value_usd` is null and the value step lowers nothing.

## Remediation

- Pyth moves its price attestations and governance to a post-quantum scheme (hash-based or ML-DSA signatures, or a
  STARK over them) and uses its governance path to deploy receivers that verify it: `executeGovernanceInstruction` on
  `0x4305fb66…` (upgrade or new receiver) and the executor `0xccd7e24e…` for PythLazer and its own receiver. Both paths
  are themselves gated by these ECDSA quorums, so the move must happen while the keys are safe.
- PythLazer: an upgrade that verifies a post-quantum signer instead of `ECDSA.tryRecover`; rotating the trusted signer
  does not help.
- The Wormhole guardian set used by `0x74f09cb3…` is covered in
  [`wormhole-guardian-signatures`](wormhole-guardian-signatures.md).
- No protocol change needed.

## History

- 2026-11-04: `0x74f09cb3…` classified from bytecode in the hand classification pass (`data/curation/`), grouped under Wormhole.
- 2026-11-17 review (Review17): finding created; `0x74f09cb3…` moved here from `wormhole-guardian-signatures` (it is Pyth's receiver), and `0x3a2dd09b…` and PythLazer `0xacea761c…` added. Rated MEDIUM, step 4: Pyth governance can upgrade or repoint every contract; exposure unmeasured, so step 5 does not apply.
