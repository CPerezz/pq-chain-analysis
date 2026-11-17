---
id: coinbase-commerce-operator-sig
title: "Coinbase Commerce: Transfers accepts payment intents only with an ECDSA operator signature; a quantum attacker can issue intents in Coinbase's name, but every payment is still funded and authorised by the payer, and the contract holds $136"
project: coinbase
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: liveness
alternative: key-rotation-only
role: core
contracts:
- address: "0x1fa57f879417e029ef57d7ce915b0aa56a507c31"
  implementation: null
  name: Transfers (Coinbase Commerce Onchain Payment Protocol)
  upgradeable: "no"
  admin: "Ownable owner 0x8899cecfd929504414696c734eaf6300fdbb428c (EOA; pause, setSweeper only), read at block 26431459; operators self-register"
  value_usd: 136
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-24
  txs_30d: 1
families: []
fix:
  layer: new-deployment
  who_acts: "Coinbase (operator 0x8fccc78dae0a8f93b0fe6799de888d4c57e273db; owner 0x8899cecfd929504414696c734eaf6300fdbb428c): deploy a Transfers version that verifies operator intents through ERC-1271/ERC-7913, or pause this one"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-commerce-operator-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, cast reads at block 26431459, Blockscout logs and transactions
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Coinbase Commerce's `Transfers` contract processes a payment only with a `TransferIntent` signed by an operator, checked
with `ECDSA.recover` (PQ-4). A quantum attacker who recovers the operator key (EOA `0x8fccc78d…`) can issue intents in
Coinbase's name, but each intent is bound to the payer, and the payer funds it (with `msg.value`, their own allowance
or their own permit signature), so nothing can be taken through the check; a post-quantum operator cannot sign intents
at all. The contract holds $136 and has had no successful payment since 2026-04-01. Rated LOW, step 4: nothing can be
taken through the check (and step 5: under $50k held).

## Mechanism

- Every payment function (`transferNative`, `transferToken`, `transferTokenPreApproved`, `wrapAndTransfer`,
  `unwrapAndTransfer*`, `swapAndTransferUniswapV3*`, `subsidizedTransferToken`) carries the `validIntent(intent,
  sender)` modifier (`Transfers.sol` lines 79–124): it hashes the intent fields with `chainid`, `sender` and the
  contract address, applies the EIP-191 or a custom prefix, and requires `ECDSA.recover(hash, intent.signature) ==
  intent.operator`; then `operatorIsRegistered` requires a fee destination for that operator.
- `sender` is `msg.sender` in all functions but `subsidizedTransferToken`, where it is the payer whose EIP-2612 permit
  is consumed. The contract then pulls exactly `recipientAmount + feeAmount` from that payer and pays the recipient and
  the operator's fee destination (`transferFundsToDestinations`, lines 728–745).
- Operators register themselves (`registerOperator`, line 789; permissionless). The operator signature therefore
  certifies a quote under one operator's name; it does not authorise moving anyone's funds.
- Pattern PQ-4 (one operator ECDSA key); the payer side (Permit2, `msg.sender`) already works for contract accounts.

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): the modifier and payment paths above
  ([`notes.md`](#review-notes-review12-2026-11-17), [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-commerce-operator-sig/source-excerpts.md)).
- CHECKED (cast at block 26,431,459): no proxy (on-chain read at block 26,431,214); `owner()` = `0x8899cecf…`, an EOA;
  `paused()` = false.
- CHECKED (block 26,431,214): holds $136 (USDC $116, USDT $20) ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-commerce-operator-sig/onchain.json)).
- CHECKED (Blockscout logs): the last `Transferred` events are at block 24,787,942 (2026-04-01), all with operator
  `0x8fccc78dae0a8f93b0fe6799de888d4c57e273db` (no code). Later calls revert (2026-10-24, `ExpiredIntent()`).
- CHECKED (Xatu, any function): 1 transaction 2026-10-16 to 2026-11-16, last 2026-10-24
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/coinbase-commerce-operator-sig/activity.json)); precompile trace, year to March 2026:
  122,767 transactions calling `ecrecover`, $55.2M moved in them (`curated_contracts.csv`, `txs_y1`, `usd_tx_y1`).
- INFERRED: whether Coinbase's off-chain system credits a merchant charge from a `Transferred` event without checking
  recipient and amount was not checked; if it does, forged intents under Coinbase's operator id could mark charges
  paid with attacker-chosen values.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1fa57f87…` Transfers | no | $136 | 2026-10-24 | 1 |

- On-chain: nothing pooled. The contract holds funds only within a payment transaction; $136 of dust sits there now.
- A forged operator signature lets an attacker create intents with Coinbase's operator id: burn intent ids (mark them
  processed) and emit `Transferred` events for payments the attacker funds. A post-quantum operator cannot sign
  intents (`liveness`).
- Siblings: other `Transfers` deployments on mainnet were not looked up.

## Remediation

- Replacement: a new `Transfers` deployment that verifies operator intents through ERC-1271/ERC-7913 (so a post-quantum
  operator account can sign), or retiring this one, which is no longer processing payments.
- Who acts: Coinbase, as operator `0x8fccc78d…` and owner `0x8899cecf…` (an EOA; can `pause`). The contract is
  immutable. No protocol change needed.
- Payers need do nothing: the check never authorises spending their funds.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 4: nothing can be taken through the operator check (intents are bound to and funded by the payer; operators self-register); also step 5, $136 held. Impact funds-loss -> liveness. Owner read from storage (EOA 0x8899cecf); last successful payment 2026-04-01.

# Review notes (Review12, 2026-11-17)

- Source: Sourcify full source of `0x1fa57f879417e029ef57d7ce915b0aa56a507c31`, `contracts/transfers/Transfers.sol`.
  - `validIntent(_intent, sender)` (lines 79–124): hash of (recipientAmount, deadline, recipient, recipientCurrency,
    refundDestination, feeAmount, id, operator, chainid, sender, this); `ECDSA.recover(...)` must equal
    `_intent.operator`; then deadline, non-zero recipient, intent id not yet processed.
  - `sender` is `_msgSender()` in every payment function (lines 153, 172, 225, 272, 298, 347, 390, 417, 463) except
    `subsidizedTransferToken` (line 513), where it is the payer whose EIP-2612 permit is consumed.
  - `operatorIsRegistered` (line 128) only requires `feeDestinations[operator] != 0`; `registerOperator()` /
    `registerOperatorWithFeeDestination()` (lines 789–797) are permissionless.
  - Owner: `pause`/`unpause` (lines 809–814), `setSweeper`; sweeper: `sweepETH` etc. (`Sweepable.sol`).
- cast at block 26,431,459: `owner()` = 0x8899cecfd929504414696c734eaf6300fdbb428c (no code: EOA); `paused()` = false.
- Blockscout logs (v2 `addresses/<addr>/logs`, read 2026-11-17): latest `Transferred` events are at block 24,787,942
  (2026-04-01), operator 0x8fccc78dae0a8f93b0fe6799de888d4c57e273db.
- Blockscout transactions: later calls revert (2026-10-24 `swapAndTransferUniswapV3Native`, revert `ExpiredIntent()`,
  tx 0x9ebc6de5…; 2026-08-04 `sweepETH` reverts; 2026-07-21 reverted payment).
