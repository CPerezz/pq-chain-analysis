---
id: thirdweb-signature-mint-signer
title: "thirdweb TokenERC1155 (Node Runner Glyphs, Coingecko X Moonbirds): a quantum attacker who recovers the shared minter EOA's key can sign mint vouchers and mint unlimited free tokens of both collections"
project: thirdweb
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xde63b92033aa77b115db1cec612029625d1c8fa5"
  implementation: "0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392"
  name: thirdweb clone → TokenERC1155 "Node Runner Glyphs"
  upgradeable: config-only
  admin: "DEFAULT_ADMIN_ROLE 0x60750ef4c25ec9cc4567807fe927a2b16d259f9f (EIP-7702 EOA) grants/revokes MINTER_ROLE; MINTER_ROLE: 0x60750ef4…, 0xa845193f0a80fc904666ca2fd80ac41a8b247726 (EOA), read at block 26431602"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 6
- address: "0xcf068d287b206f20e64e9259f44c4f7130be7297"
  implementation: "0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392"
  name: thirdweb clone → TokenERC1155 "Coingecko X Moonbirds"
  upgradeable: config-only
  admin: "DEFAULT_ADMIN_ROLE 0x2aa5ebd85ba9fbdc87a774c29cdad806d7892820 (EOA) grants/revokes MINTER_ROLE; MINTER_ROLE: 0x2aa5ebd8…, 0xa845193f0a80fc904666ca2fd80ac41a8b247726 (EOA), read at block 26431602"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 17
families: []
fix:
  layer: onchain-config
  who_acts: "Each collection's admin (0x60750ef4c25ec9cc4567807fe927a2b16d259f9f; 0x2aa5ebd85ba9fbdc87a774c29cdad806d7892820) revokes MINTER_ROLE from the ECDSA signers and mints with mintTo from a post-quantum account; thirdweb for a TokenERC1155 that verifies vouchers through ERC-1271/ERC-7913"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/thirdweb-signature-mint-signer/classification.jsonl
  - evidence/thirdweb-signature-mint-signer/onchain.json
  - evidence/thirdweb-signature-mint-signer/activity.json
  - evidence/thirdweb-signature-mint-signer/source-excerpts.md
  - evidence/thirdweb-signature-mint-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0x4cb2e48b, cast role reads at block 26431602
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [thirdweb-paymaster-signer]
---

## Summary

Two thirdweb `TokenERC1155` collections mint tokens for anyone holding a voucher signed by a `MINTER_ROLE` address,
checked with `ecrecover` only (PQ-4). Both collections share one minter EOA (`0xa845193f…`); a quantum attacker who
recovers its key (or an admin's) can sign vouchers with any quantity and a zero price and mint unlimited tokens of
either collection, diluting what holders own; the contracts hold nothing and the collections' market value was not
measured. Each collection's admin can revoke the ECDSA minters and mint directly with `mintTo` from a post-quantum
account. Rated LOW, step 4: one known party per collection changes a setting.

## Mechanism

- `mintWithSignature(req, signature)` → `verifyRequest` → `verify`: `recoverAddress` computes
  `_hashTypedDataV4(keccak256(_encodeRequest(req))).recover(signature)` (OZ ECDSA) and requires
  `hasRole(MINTER_ROLE, signer)` and an unused `uid`; it then mints `req.quantity` of `req.tokenId` (or a new id) to
  `req.to` and collects `req.pricePerToken` in `req.currency`, both chosen by the signer (`TokenERC1155.sol` lines
  205–271, 400–444).
- `mintTo` (lines 216–233) mints for a `MINTER_ROLE` caller (`_msgSender()`), with no signature: this is the path a
  post-quantum minter account can use.
- The clones are fixed (thirdweb clone bytecode → implementation `0x4cb2e48b…`); only the roles can change. Pattern PQ-4.

## Evidence

- CHECKED (Sourcify full source of implementation `0x4cb2e48b5235c0d1fd7ad1e3f7d7ff829c5b9392`, read 2026-11-17):
  the paths above ([`notes.md`](../evidence/thirdweb-signature-mint-signer/notes.md)).
- CHECKED (cast at block 26,431,602): clone bytecode and implementation; `getRoleMember` for `DEFAULT_ADMIN_ROLE` and
  `MINTER_ROLE` on both clones: the admins (one an EIP-7702 EOA, one a plain EOA) and the shared EOA `0xa845193f…` hold
  `MINTER_ROLE`.
- CHECKED (block 26,431,214): the clones hold nothing ([`onchain.json`](../evidence/thirdweb-signature-mint-signer/onchain.json)).
- CHECKED (Xatu, any function): 6 and 17 transactions in 2026-10-16 to 2026-11-16, last 2026-11-14
  ([`activity.json`](../evidence/thirdweb-signature-mint-signer/activity.json)); precompile trace, year to March 2026:
  205,878 (`0xde63b920…`) and 86,797 (`0xcf068d28…`) transactions calling `ecrecover`, $97k moved in the latter's
  (`curated_contracts.csv`).
- INFERRED: `0xa845193f…` is a shared minting backend (same signer on two unrelated collections); its operator was not
  identified.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xde63b920…` TokenERC1155 "Node Runner Glyphs" | config-only | not measured | 2026-11-14 | 6 |
| `0xcf068d28…` TokenERC1155 "Coingecko X Moonbirds" | config-only | not measured | 2026-11-14 | 17 |

- What can be taken: newly minted collection tokens (dilution of holders, and any mint price the voucher would have
  charged). Nothing pooled is held. The collections' market value was not measured, so the value step lowers nothing.
- Other thirdweb `TokenERC1155` clones of the same implementation exist; only these two are in the census.

## Remediation

- Setting: each collection's `DEFAULT_ADMIN_ROLE` holder revokes `MINTER_ROLE` from `0xa845193f…` and from its own
  ECDSA address, grants it to a post-quantum account, and mints with `mintTo`; admins also move `DEFAULT_ADMIN_ROLE`
  to a post-quantum account (the role is a plain `msg.sender` check).
- Replacement for signature mints: a new thirdweb `TokenERC1155` that verifies vouchers with ERC-1271/ERC-7913 (a new
  deployment, since the clones cannot be upgraded).
- Who acts: admins `0x60750ef4…` (Node Runner Glyphs) and `0x2aa5ebd8…` (Coingecko X Moonbirds); thirdweb for the
  implementation. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 4: one known party per collection (the admin) revokes the ECDSA minters and mints via `mintTo` from a post-quantum account. Roles read at block 26,431,602 (shared minter EOA 0xa845193f on both); implementation 0x4cb2e48b recorded; fix.layer new-deployment -> onchain-config.
