---
id: gala-bridge-authorities
title: "Gala bridge (0x9f452b7c): a quantum attacker who recovers its single ECDSA authority key can release the $2.6M it holds, mint GALA, and sign its own upgrade"
project: gala
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-5]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x9f452b7cc24e6e6fa690fe77cf5dd2ba3dbf1ed9"
  implementation: "0xc664692f38d2528710edbb74f65db6599bc7dee6"
  name: GalaBridge (proxy) / Bridge
  upgradeable: "yes"
  admin: "upgrade(VSM) and changeAuthorities(VSM) signed by the authority set (1 key, 0xf6901089c82b056858eea367bd252615b7634af0, block 26431535); owner EOA 0x7c63e722a7d3ca4fafc29270d82b07e6b07fc564 for token setup and pause"
  value_usd: 2643462
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1835
families: []
fix:
  layer: contract-upgrade
  who_acts: "Gala (GalaChain governance): a governance message signed by authority 0xf6901089c82b056858eea367bd252615b7634af0 calls upgrade(VSM) on 0x9f452b7c with a post-quantum verifier; must happen while the ECDSA key is still safe"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/gala-bridge-authorities/classification.jsonl
  - evidence/gala-bridge-authorities/onchain.json
  - evidence/gala-bridge-authorities/activity.json
  - evidence/gala-bridge-authorities/source-excerpts.md
  - evidence/gala-bridge-authorities/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (Sourcify source and on-chain reads)
  ref: evidence/gala-bridge-authorities/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

The GalaChain ↔ Ethereum bridge releases or mints tokens when a message is signed by a quorum of its ECDSA
"authorities", and the same quorum signs upgrades and key changes. Today the set has one authority key, so one
signature is a quorum. A quantum attacker who recovers that key can release the $2.64M the bridge holds, mint GALA
(the bridge holds GALA's minter role), and upgrade the bridge to code of their choosing. Gala can fix it with an
upgrade signed by that same key before a CRQC exists, so the rating is MEDIUM (step 4: fix by contract upgrade).

## Mechanism

- `bridgeIn(VSM)` (`contracts/BridgeIn.sol` 29-96) calls `Authority.verifyMessage`: it requires
  `3 * signatures >= 2 * authoritiesLength()` and `ECDSA.tryRecover(digest, v, r, s) == getAuthority(index)` for every
  signature (`contracts/Authority.sol` 20-44). It then transfers ERC-20/721/1155 tokens to the recipient, minting the
  shortfall (`mintBulk`) for burning bridges such as GALA.
- `Governance.upgrade(VSM)` and `Governance.changeAuthorities(VSM)` use the same check plus an emitter match
  (`governanceContract()`), then `_upgradeToAndCall` or `setAuthorities`.
- With one authority the committee check (PQ-5) reduces to one operator key (PQ-4). Rotating the key does not help:
  the scheme must change.

## Evidence

- CHECKED (Sourcify source of implementation `0xc664692f…`): `verifyMessage`, `bridgeIn`, `bridgeInERC20` minting,
  `upgrade`, `changeAuthorities`, `Admin` ([`review-notes.md`](../evidence/gala-bridge-authorities/review-notes.md),
  [`source-excerpts.md`](../evidence/gala-bridge-authorities/source-excerpts.md)).
- CHECKED (on-chain read at block 26,431,535): EIP-1967 implementation `0xc664692f…`, admin slot empty;
  `authoritiesLength()` = 1, authority `0xf6901089…`; `owner()` = EOA `0x7c63e722…`; not paused.
- CHECKED (latest block, 2026-11-17): GALA `isBurningBridge` = true; the bridge holds GALA `MINTER_ROLE`; GALA
  circulating market cap $70.05M (Blockscout).
- CHECKED (block 26,431,214): $2.64M of tokens held ([`onchain.json`](../evidence/gala-bridge-authorities/onchain.json)).
- CHECKED (Xatu, any function): 1,835 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/gala-bridge-authorities/activity.json)); 28,231 `ecrecover` transactions in the
  yearly window (`data/report/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9f452b7c…` GalaBridge | yes (authority-signed `upgrade`) | $2.64M | 2026-11-15 | 1,835 |

Held: WETH $884k, WBTC $748k, USDT $232k, WXRP $197k, USDC $156k (block 26,431,214). Beyond that, a forged
`bridgeIn` can mint GALA without limit (the bridge is a minter); GALA's $70M circulating market cap bounds the
market damage, not the amount held. Other Gala token bridges or chains were not checked.

## Remediation

- Gala signs a governance message with the current authority key that calls `upgrade(VSM)` to an implementation
  verifying a post-quantum scheme (ML-DSA or hash-based signatures from GalaChain, or a STARK over them), then
  `changeAuthorities` to post-quantum keys. Because upgrades are gated by the same ECDSA key, this must be done before
  the key can be recovered; afterwards nobody can safely upgrade.
- Adding more authorities raises the quorum but not the scheme; it does not help against a CRQC.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review17): MEDIUM kept, step 4: fix by an authority-signed upgrade. The authority set has one key (read at block 26,431,535), so PQ-4 added and trigger set to operator-key; GALA minting through the bridge noted.
