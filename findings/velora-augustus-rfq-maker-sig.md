---
id: velora-augustus-rfq-maker-sig
title: "Velora AugustusRFQ: an EOA maker that later converts to a post-quantum account stays forgeable here, so its old ECDSA key can still sign orders that spend the maker's approvals"
project: paraswap
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xe92b586627cca7a83dc919cc7127196d70f55a06"
  implementation: null
  name: AugustusRFQ
  upgradeable: "no"
  admin: none (no proxy, no owner; immutable, read at block 26,431,214)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 2050
families: []
fix:
  layer: account-migration
  who_acts: nobody can change AugustusRFQ (no admin); makers revoke their token approvals to 0xe92b586627cca7a83dc919cc7127196d70f55a06 before converting their address, or move funds to a fresh post-quantum account; Velora can stop quoting through it and route makers to a code-first settlement contract
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/velora-augustus-rfq-maker-sig/classification.jsonl
  - evidence/velora-augustus-rfq-maker-sig/onchain.json
  - evidence/velora-augustus-rfq-maker-sig/activity.json
  - evidence/velora-augustus-rfq-maker-sig/source-excerpts.md
  - evidence/velora-augustus-rfq-maker-sig/makers.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [velora-delta-order-code-first]
---

## Summary

AugustusRFQ (`0xe92b5866…`) settles market-maker and limit orders by checking the maker's signature with OpenZeppelin
4.4 `SignatureChecker`, which tries `ecrecover` first and only then ERC-1271 (PQ-2). A maker address that later
converts to a post-quantum smart account keeps its old ECDSA key valid here: a CRQC holder can sign orders that pull
whatever that address still has approved to AugustusRFQ. The contract is immutable and holds nothing; the exposure is
makers' standing approvals, which were not measured in full. In the 600 most recent fills, 597 came from one contract
maker (checked through its own ERC-1271, not the `ecrecover` path) and the two EOA makers had essentially nothing
approved. Rated HIGH, step 4: users' own funds stay forgeable after migration in a contract that cannot change.

## Mechanism

- Every fill function (`fillOrder`, `partialFillOrder*`, `fillOrderWithTarget*`, `batchFillOrderWithTarget`,
  `tryBatchFillOrder*`, and the NFT variants) calls `_fillOrder`/`_fillOrderNFT`, which hash the `Order` (EIP-712) and
  call `_checkOrder`. On the first fill of an order hash, `_checkOrder` requires
  `SignatureChecker.isValidSignatureNow(maker, orderHash, signature)` (`AugustusRFQ.sol` line 640).
- OpenZeppelin v4.4.0 `SignatureChecker.isValidSignatureNow` returns true if `ECDSA.tryRecover(hash, signature)` equals
  `maker`; otherwise it calls `maker.isValidSignature(hash, signature)` (ERC-1271) with the full signature.
- After the check, `transferTokens(order.makerAsset, maker, target, …)` pulls the maker's tokens through its approval
  to AugustusRFQ, and the taker pays `order.takerAsset`. The order fixes the price and an optional `taker`; a forged
  maker order with `taker = 0` and a token price of near zero empties the maker's approved balance.
- Pattern PQ-2: post-quantum accounts can make orders through ERC-1271, but an address that has a known ECDSA key and
  later gains real code is still accepted on the ECDSA branch. A pure contract maker (no private key for its address)
  is reached only through ERC-1271.
- Excerpts: [`source-excerpts.md`](../evidence/velora-augustus-rfq-maker-sig/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify exact match, fetched 2026-11-17): `contracts/AugustusRFQ.sol` `_checkOrder` and
  `_fillOrder`; `@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol` is v4.4.0 with `tryRecover` before the
  ERC-1271 call.
- CHECKED (on-chain read at block 26,431,214): no EIP-1967 implementation or admin, no `owner()`; ETH 0 and token dust
  ([`onchain.json`](../evidence/velora-augustus-rfq-maker-sig/onchain.json)).
- CHECKED (Blockscout logs, `OrderFilled` events, blocks 26,339,038–26,425,893): 600 fills by three makers.
  `0xbee3211ab312a8d065c4fef0247448e17a8da000` (597 fills) is a TransparentUpgradeableProxy contract; its USDC, USDT and
  WETH approvals to AugustusRFQ are unlimited, backed by about 2.15M USDC, 4.09M USDT and 1,521.6 WETH at block
  26,431,531. The two EOA makers had 0 and 0.0000019 WETH approved
  ([`makers.json`](../evidence/velora-augustus-rfq-maker-sig/makers.json)).
- CHECKED (Xatu, any function): 2,050 transactions called the contract 2026-10-16 to 2026-11-16, 6 of them directly;
  last on 2026-11-16 ([`activity.json`](../evidence/velora-augustus-rfq-maker-sig/activity.json)).
- CHECKED (precompile trace, year to March 2026, `data/report/curated_contracts.csv`): 67,258 transactions with an
  `ecrecover` call by this contract (`txs_y1`), about USD 1.02B moved in them (`usd_tx_y1`).
- INFERRED: the contract maker's ~USD 9M inventory is reached only through its own ERC-1271 implementation, so a CRQC
  attack on it is an attack on that maker's own signer, not on this check.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe92b5866…` AugustusRFQ | no | — (dust; not the exposure) | 2026-11-16 | 2,050 |

The value at risk is what maker EOAs that later convert to real account code still have approved to AugustusRFQ. That
needs a scan of every `Approval` to the contract and was not done; `value_usd` stays null. The active EOA makers in the
recent sample have almost nothing approved, so today's exposure through the `ecrecover` branch is small, but older
limit-order makers may hold unlimited approvals. Takers are not exposed: the taker side is always `msg.sender`.
Velora's Delta/Portikus settlement is covered in `velora-delta-order-code-first`.

## Remediation

- AugustusRFQ cannot be changed. Velora can stop routing orders to it and settle makers through a contract that checks
  account code first (as its Portikus `SignatureLib` does) or accepts ERC-1271/ERC-7913 only.
- Makers: revoke approvals to `0xe92b586627cca7a83dc919cc7127196d70f55a06` before converting an address to post-quantum
  code, or keep maker inventory in a contract maker (checked through ERC-1271) with a post-quantum signer.
- Protocol: EIP-8151 would make the `ecrecover` branch fail for converted addresses with real code and would protect
  makers who forget to revoke (`protocol_change: helps`).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review19): HIGH kept, step 4. Source and OZ 4.4.0 `SignatureChecker` re-read; title corrected (AugustusRFQ has no cosigner); recent maker set and approvals checked (main maker is a contract, EOA makers' approvals near zero); full approval exposure not measured, so step 5 does not apply. Linked `velora-delta-order-code-first`.
