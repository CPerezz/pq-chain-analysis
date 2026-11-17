---
id: unidentified-5ba2f06c-signer-key
title: "Unidentified RFQ market maker (0x5ba2f06c): forging its one ECDSA quote signer lets an allowlisted caller pull the maker vault's approved tokens (vault empty now)"
project: unidentified-5ba2f06c
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x5ba2f06c91be4495243ffdc9faa9618ca0f5f2ae"
  implementation: null
  name: unverified RFQ settlement contract (setSigners, usedQuote, setCounterparty)
  upgradeable: config-only
  admin: owner EOA 0xc493f943a1fd910d01dcabea86e61415ce43e787 (setOwner, setSigners, setCounterparty, rescue); not a proxy
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-05-07
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: the market maker, owner EOA 0xc493f943a1fd910d01dcabea86e61415ce43e787 (deployer 0x9e056868b204ffe34351eb00a404e3fc9eec5192); revoking vault 0x9ba0cf1588e1dfa905ec948f7fe5104dd40eda31's approvals removes the exposure at once
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-5ba2f06c-signer-key/classification.jsonl
  - evidence/unidentified-5ba2f06c-signer-key/onchain.json
  - evidence/unidentified-5ba2f06c-signer-key/activity.json
  - evidence/unidentified-5ba2f06c-signer-key/source-excerpts.md
  - evidence/unidentified-5ba2f06c-signer-key/rfq.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review04)
  ref: evidence/unidentified-5ba2f06c-signer-key/rfq.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

`0x5ba2f06c…` settles a private market maker's RFQ quotes: an allowlisted caller submits a quote signed by the one
signer `0xfc799370…`, and the contract moves the taker's tokens into maker vault `0x9ba0cf15…` and the vault's tokens
to the taker with `transferFrom` (PQ-4). A quantum attacker who recovers the signer key can sign quotes that pay out
everything the vault has approved (USDC, USDT, WETH, POL, all unlimited), but the vault holds nothing of those tokens
now and the contract has not been called since 2026-05-07. Rated LOW: MEDIUM at step 4 (one operator must deploy a
contract that verifies a different scheme), lowered at step 5 (measured exposure USD 0).

## Mechanism

- Unverified bytecode (6.8 KB). Selectors and errors (4byte): `setSigners(address[])`, `signers(uint256)`,
  `usedQuote(bytes32)`, `eip712Domain()`, `setCounterparty(address,bool)`, `counterparty(address)`, `setOwner`,
  `rescue`, `setDiff`, and OpenZeppelin `ECDSAInvalidSignature()`/`ECDSAInvalidSignatureLength(uint256)`,
  `InvalidSignature()`, `UnauthorizedCaller()`, `DeadlineExpired()`; no ERC-1271 selector. INFERRED: the fill
  function recovers the EIP-712 quote signer with OpenZeppelin `ECDSA.recover`, requires it to be in `signers`,
  marks the quote used, and requires `msg.sender` to be an allowlisted counterparty.
- Settlement path (sample transaction `0x1b2fd2d8…`, 2026-03-18): `RelayRouterV3` → caller `0x63242a4e…` →
  `0x5ba2f06c…`, which calls `USDC.transferFrom` (taker to vault) and `POL.transferFrom` (vault to taker).
- The signer list can be rotated by the owner (`setSigners`), but only to other ECDSA keys.
- No verified source ([`source-excerpts.md`](../evidence/unidentified-5ba2f06c-signer-key/source-excerpts.md)).

## Evidence

- CHECKED (bytecode selector scan and 4byte lookup, block 26,431,578): the selectors above.
- CHECKED (precompile trace): the contract called `ecrecover` in 22,092 transactions in the year to March 2026
  (`txs_y1`, `data/report/curated_contracts.csv`), last block 24,683,714.
- CHECKED (`eth_call` at block 26,431,578): `signers(0) = 0xfc7993707b79f25a937c8e5ba0357c52f680a1d2`,
  `signers(1)` reverts (one signer); `owner() = 0xc493f943…` (EOA); `counterparty(0x63242a4e…) = true`.
- CHECKED (Blockscout): contract and vault `0x9ba0cf15…` both created by EOA `0x9e056868…`; no name, tag or ENS
  name, so the market maker stays unidentified.
- CHECKED (90 receipts: 80 random and the last 10 of the year's transactions): vault `0x9ba0cf15…` is a transfer
  party in 83 of them; the caller `0x63242a4e…` in 87.
- CHECKED (`allowance`, balances at block 26,431,578): vault approves this contract for unlimited USDC, USDT, WETH and
  POL; it holds 0 ETH and none of those tokens (USD 1.46 of other tokens) ([`rfq.json`](../evidence/unidentified-5ba2f06c-signer-key/rfq.json)).
- CHECKED (on-chain read at block 26,431,214): the contract holds nothing ([`onchain.json`](../evidence/unidentified-5ba2f06c-signer-key/onchain.json));
  CHECKED (Xatu): last call 2026-05-07, none in 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/unidentified-5ba2f06c-signer-key/activity.json)).
- INFERRED: the counterparty allowlist means an attacker also needs an allowlisted caller (or the owner key, also
  ECDSA, to add one); this does not change the rating.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x5ba2f06c…` RFQ settlement (unverified) | config-only | — (escrow: vault `0x9ba0cf15…` USD 0 in approved tokens) | 2026-05-07 | 0 |

The exposure is the maker's inventory approved to the contract, which is empty now (2026-11-17). If the maker refunds
the vault without changing the contract, the exposure returns at that size.

## Remediation

- Post-quantum replacement: an RFQ contract that verifies quotes with a post-quantum signature (for example through
  an ERC-7913 verifier); rotating the ECDSA signer does not help.
- Who acts: the market maker (owner `0xc493f943…`). Until a replacement exists, revoking the vault's approvals to
  `0x5ba2f06c…` (or retiring the contract) removes the exposure. No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review04): MEDIUM -> LOW, step 5: the funds at risk sit in maker vault 0x9ba0cf15, which approves the contract for unlimited USDC/USDT/WETH/POL but holds none (block 26,431,578); measured exposure USD 0. Status candidate -> confirmed (bytecode plus precompile trace and on-chain reads).
