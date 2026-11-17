---
id: velora-delta-order-code-first
title: "Velora Delta (Portikus adapter): user orders are checked through ERC-1271 for accounts with real code, so a post-quantum account is not forgeable here; not affected beyond the account's own key"
project: paraswap
status: not-affected
severity: NONE
patterns: [PQ-13]
primitives: [ecrecover]
trigger: none
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0x0000000000bbf5c5fd284e657f01bd000933c96d"
  implementation: null
  name: Adapter (Portikus V2)
  upgradeable: config-only
  admin: owner TimelockController 0x0abfd500b000f206400bee0e0409000380090896 (min delay 0) whose proposer and admin is Safe 0xaab95c7b7e0b9bf646ab839fd5880a2ae15f6406 (5 of 12); installs and uninstalls modules (read at block 26,431,539)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 5047
families: []
fix:
  layer: none
  who_acts: none needed; module changes go through TimelockController 0x0abfd500b000f206400bee0e0409000380090896 (proposer Safe 0xaab95c7b7e0b9bf646ab839fd5880a2ae15f6406, 5 of 12)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-delta-order-code-first
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [velora-augustus-rfq-maker-sig]
---

## Summary

The Portikus V2 adapter (`0x0000000000bbf5…`) behind Velora Delta settles users' signed swap and bridge orders through
delegatecalled modules whose `SignatureLib.verify` asks first whether the order owner has code: accounts with real code
are checked through ERC-1271 with the full signature, and an empty signature falls back to an on-chain pre-signature
(PQ-13). Only addresses without code, or with an EIP-7702 delegation, are checked with `ecrecover`; those are still
controlled by their ECDSA key anyway. A user who moves to a post-quantum smart account (or converts a 7702 address to
real code) is not forgeable here. Rated NONE: no exposure beyond the account's own key.

## Mechanism

- The adapter has no signature code of its own; its fallback looks up the module for the called selector and
  delegatecalls it. `getModules()` lists 34 installed modules (settlement, bridge, TWAP, Delta token, signer registry).
- Current settlement modules (e.g. `SwapSettlementModule` 2.3.0 at `0x7123c40f…`) call
  `orderWithSig.signature.verify(orderHash, order.owner)` in `_verify`. `SignatureLib.verify`: empty signature →
  `isPreSigned(owner, hash)`; `_isEOA(owner)` (no code, or a 23-byte `0xef0100` EIP-7702 delegation) → 64-byte EIP-2098
  signature through `ecrecover`; otherwise `IERC1271(owner).isValidSignature(hash, signature)` with the full signature.
  The 1.0.0 modules use `signer.code.length == 0` instead, with the same effect for accounts with real code.
- The 7702 branch means an EOA that only delegates to a post-quantum wallet is still verified by its old key here. That
  key still controls the account at the protocol level (EIP-8151 also exempts delegated EOAs), so this adds nothing; the
  account reaches ERC-1271 once it has real code (EIP-8298 or EIP-8141 conversion).
- Separate check, not rated here: for cross-chain orders `BridgeCosignatureLib.verifyCosignature` recovers a protocol
  cosigner with `ecrecover` and requires it to be approved in the signers registry. The cosignature only chooses the
  bridge module and its `protocolData`; the user's signed order fixes destination chain, output token, amounts and
  beneficiary, and `swapSettle` is callable only by authorised agents.
- Excerpts: [`source-excerpts.md`](#source-excerpts-velora-delta-order-code-first) (empty for this
  contract, since the check sits in the modules); module list and sources read: [`modules.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-delta-order-code-first/modules.json).

## Evidence

- CHECKED (Sourcify, fetched 2026-11-17): `src/adapter/Adapter.sol` (module dispatch, `install`/`uninstall` behind
  `onlyOwner`); `SignatureLib.sol` and `BridgeCosignatureLib.sol` in `SwapSettlementModule` 2.3.0 `0x7123c40f…` and
  `DeltaTokenModule` 1.0.1 `0x47b3d821…`; `SignatureLib.sol` in `SwapSettlementModule` 1.0.0 `0x7d178cd1…` and
  `DirectSettlementModule` 1.0.0 `0xd76e73ae…`.
- CHECKED (on-chain read at block 26,431,539): `getModules()` returns 34 modules; 8 are not verified on Sourcify and
  were not read. `owner()` = TimelockController `0x0abfd500…` (`getMinDelay()` = 0); its proposer, executor,
  canceller and admin roles were granted at creation to Safe `0xaab95c7b…`, which has threshold 5 of 12 owners.
- CHECKED (on-chain read at block 26,431,214): the adapter is not a proxy; it holds 1.43 ETH and about USD 5.3k of
  tokens (fee and dust balances, not exposure) ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-delta-order-code-first/onchain.json)).
- CHECKED (Xatu, any function): 5,047 transactions called the adapter 2026-10-16 to 2026-11-16, 4,714 directly; last on
  2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/velora-delta-order-code-first/activity.json)).
- CHECKED (precompile trace, year to March 2026, `studies/top-callers-classification/results/curated_contracts.csv`): 21,098 transactions with an
  `ecrecover` call (`txs_y1`), about USD 1.18B moved in them (`usd_tx_y1`).
- INFERRED: the 8 unverified modules (older settlement versions, `PreSignatureModule`, `ExternalSettlementModule`,
  `Signers Registry Module`, `TWAPDeltaTokenModule`) use the same `SignatureLib`; not confirmed from source.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…` Adapter (Portikus V2) | config-only | — (USD 7.8k fee/dust balance, not exposure) | 2026-11-16 | 5,047 |

No user exposure beyond each account's own key. Users approve their tokens to the adapter; those approvals are spent only
against an order signed by the owner (ECDSA for code-less or 7702 addresses, ERC-1271 for accounts with code) or
pre-signed on-chain. The bridge cosigner key (a protocol operator key, PQ-4) is an auxiliary check: a forged
cosignature can change which bridge carries a user's order but not its destination, token, amount or beneficiary
(INFERRED from `Bridge.sol` and `BridgeLib._resolveProtocol`; whether a forged `protocolData` could misroute funds in a
specific bridge module was not analysed). Velora's AugustusRFQ is covered in `velora-augustus-rfq-maker-sig`.

## Remediation

None needed for user orders. Users who want post-quantum orders use a smart account with a post-quantum ERC-1271
signer, or pre-sign on-chain. If Velora replaces the bridge cosigner with a post-quantum scheme, it installs a new module
through the timelock `0x0abfd500…` (proposer Safe `0xaab95c7b…`, 5 of 12). No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review19): NONE kept (PQ-13). Module sources read (7702-delegated owners go to `ecrecover`, accounts with real code to full ERC-1271); owner resolved to a zero-delay TimelockController controlled by a 5-of-12 Safe; held balance removed as not exposure; bridge cosigner check noted as a separate auxiliary operator-key check, not rated here. Linked `velora-augustus-rfq-maker-sig`.

# Source excerpts: velora-delta-order-code-first

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0000000000bbf5c5fd284e657f01bd000933c96d` — Adapter (verified source via sourcify)
