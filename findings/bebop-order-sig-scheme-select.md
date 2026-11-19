---
id: bebop-order-sig-scheme-select
title: "Bebop: a quantum attacker can sign BebopSettlement orders as any maker or taker with a recovered ECDSA key, draining tokens they approved, even after the address moves to post-quantum authorisation"
project: bebop
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xbbbbbbb520d69a9775e85b458c58c648259fad5f"
  implementation: null
  name: BebopSettlement
  upgradeable: "no"
  admin: none (non-proxy)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 71690
families: []
fix:
  layer: account-migration
  who_acts: nobody can change BebopSettlement (no proxy, no owner); Bebop can deploy a settlement without the EIP712/ETHSIGN types and move its front end and makers to it; users protect themselves by revoking approvals to 0xbbbbbbb520d69a9775e85b458c58c648259fad5f and moving funds to a fresh post-quantum account; EIP-8151 would stop ecrecover for addresses with real code
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bebop-order-sig-scheme-select
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

`BebopSettlement` (`0xbbbbbbb5…fad5f`) settles RFQ orders signed by makers and takers. The signer picks the scheme per
order through a flag: EIP-712 or `eth_sign` (both `ecrecover`) or ERC-1271 (PQ-2). A quantum attacker who recovers the
ECDSA key of any address that has approved tokens to the contract can sign an order as that taker or maker, set the
receiver to themselves and pull those tokens; this still works after the address moves to post-quantum authorisation
(EIP-7702 code or EIP-8141), because the ECDSA type stays selectable. The exposure is users' approvals to the contract,
not measured; the contract itself holds dust. Rated HIGH (step 4): users' own funds stay forgeable after they migrate,
in a contract with no admin.

## Mechanism

- `BebopSigning._validateSignature` (`src/base/BebopSigning.sol` lines 142–168 in the excerpt): for
  `Signature.Type.EIP712` and `ETHSIGN` it calls `ecrecover` and accepts the result if it equals the maker or taker
  address (or, for makers, a signer the maker registered with `registerAllowedOrderSigner`); for `EIP1271` it calls
  `isValidSignature(hash, signature)` with the full signature bytes.
- The type comes from the order: makers' `makerSignature.flags` (`Signature.extractMakerFlags`, lines 208/223/269) and
  takers' `order.flags` (`Order.extractSignatureType`, lines 290/312/336). Nothing ties an address to one scheme.
- What it releases: `settleSingle`/`settleMulti`/`settleAggregate` (and the `…AndSignPermit`/`…AndSignPermit2`
  variants) check the taker signature when `msg.sender != order.taker_address`, then `_executeSingleOrder` etc. move
  the taker's tokens to the maker and the maker's tokens to `order.receiver` using the parties' ERC-20 approvals (or
  Permit2) to the settlement contract.
- Pattern PQ-2 (signer chooses the scheme). Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bebop-order-sig-scheme-select/source-excerpts.md).
  The taker-permit helpers in `BebopTransfer.sol` call the token's own `permit`/Permit2; those checks belong to the
  token and Permit2, not to this finding.

## Evidence

- CHECKED (verified source, Sourcify `match`, read 2026-11-17): `_validateSignature` and its callers as above; no
  `owner`, `onlyOwner` or upgrade function in `src/` (only the per-user `registerAllowedOrderSigner`).
- CHECKED (on-chain read at block 26,431,214): 24,163 bytes of code, no EIP-1967 implementation or admin, no `owner()`;
  holds 2e-18 ETH and under USD 0.01 in tokens ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bebop-order-sig-scheme-select/onchain.json)).
- CHECKED (precompile trace to March 2026): `ecrecover` calls; 195,818 pre-quantum calls in the last year
  (`txs_y1`, `studies/top-callers-classification/results/curated_contracts.csv`).
- CHECKED (Xatu, any function): 71,690 transactions called the contract 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bebop-order-sig-scheme-select/activity.json)).
- INFERRED: the amount users have approved to the contract; not read (would need every approver's allowance and
  balance per token).
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xa53877631bff8eec49b7b7ca50c42e87a6c6771356f622fb1b5e0bc12d898026` (block 26,437,313, position 0), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (2,239,068 gas); under EIP-8151 it also succeeds (2,258,468 gas). With one byte of code at the recovered
  signer `0x67336cec42645f55059eff241cb02ea5cc52ff86`, it still ends without error but with 30 logs instead of 87:
  the order or request signed by that address is refused inside the transaction; with a 7702 delegation there it
  succeeds. Study family `7bedb484` (BebopSettlement).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xbbbbbbb5…` BebopSettlement | no | dust (< USD 0.01) | 2026-11-16 | 71,690 |

- Exposure: the tokens each maker and taker has approved to `0xbbbbbbb520d69a9775e85b458c58c648259fad5f`, capped by
  their balances. Not measured; the contract's own balance is not the exposure, so `value_usd` is null.
- Who is newly exposed: an address that keeps its ECDSA key but moves to post-quantum authorisation (EIP-7702 code,
  EIP-8141). For a plain EOA the ECDSA type is no worse than its own key. Smart-contract wallets with no ECDSA key are
  not forgeable here (they can only use the ERC-1271 type).
- Makers' registered order signers (`orderSignerRegistry`) are ECDSA keys too; a maker that registered one is
  exposed through that key whatever its own account does.
- Yearly pre-quantum use: 195,818 transactions, USD 10.2 billion `usd_tx_y1` (transfers in those transactions, counted
  per transaction, not a balance).

## Remediation

- Post-quantum replacement: a settlement that accepts only ERC-1271 (full signature bytes) for addresses with code,
  as in PQ-13, or that lets each address disable the ECDSA types.
- Who must act: nobody can change this deployment. Bebop can deploy a new settlement and move its API and makers to
  it; users then revoke approvals here.
- Users: revoke approvals to `0xbbbbbbb5…fad5f` before or when moving to a post-quantum account; makers stop
  registering ECDSA order signers and use the ERC-1271 type.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for migrated addresses with real code.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review21): HIGH kept, step 4: source and on-chain state confirm no proxy and no owner; the
  signer-selected ECDSA types keep migrated addresses forgeable; approvals are the exposure and are not measured.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.
