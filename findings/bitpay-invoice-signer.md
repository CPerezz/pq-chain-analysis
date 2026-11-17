---
id: bitpay-invoice-signer
title: "BitPay Invoice contract (dormant since July 2026): a quantum attacker who recovers BitPay's quote-signer key could sign payment quotes and, with the same key as owner, withdraw what the contract holds (≈ $14)"
project: bitpay
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x34e158883efc81c5d92fde785fba48db738711ee"
  implementation: null
  name: Invoice
  upgradeable: config-only
  admin: owner 0x2730ef3c0c180e7f7bcfca249c757421b208e333 (EOA; also the current quoteSigner; setSigner/setAdmin/withdraw)
  value_usd: 14
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-23
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: BitPay (owner 0x2730ef3c0c180e7f7bcfca249c757421b208e333); a replacement invoice contract would verify quotes through ERC-1271 or a post-quantum scheme
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/bitpay-invoice-signer/classification.jsonl
  - evidence/bitpay-invoice-signer/onchain.json
  - evidence/bitpay-invoice-signer/activity.json
  - evidence/bitpay-invoice-signer/source-excerpts.md
  - evidence/bitpay-invoice-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/bitpay-invoice-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This `Invoice` contract (Etherscan label "BitPay: Invoice") accepts crypto payments for BitPay invoices only with a
quote signed by one ECDSA key, `quoteSigner` (PQ-4). A quantum attacker who recovers that key can sign quotes of its
choosing, e.g. mark an invoice paid for a token amount it chooses; and because the quote signer is now the owner
address, the same key also controls `withdraw`, `setSigner` and `setAdmin`. The contract was swept (≈ $918k of
USDT/USDC withdrawn) and its signer reset on 2026-07-22/23 and has not been used since; it holds ≈ $14. Rated LOW
(step 4): the path is dormant and holds nothing.

## Mechanism

`pay(value, gasPrice, expiration, payload, hash, v, r, s, tokenContract)` (Invoice.sol lines 64–85) calls
`validatePayment` (lines 42–61), which requires `ecrecover("\x19Ethereum Signed Message:\n32" ‖ keccak(value,
gasPrice, expiration, payload, tokenContract)) == quoteSigner`, an unexpired quote and an unpaid `payload`; it then
takes the ETH or tokens from the payer and records `isPaid[payload]`. The owner withdraws collected funds with
`withdraw` (lines 92–100) and can replace the signer with `setSigner` (lines 102–104). Pattern PQ-4; the owner being a
plain EOA adds an owner-key dependency (PQ-12) on the same key. Lines:
[`notes.md`](../evidence/bitpay-invoice-signer/notes.md),
[`source-excerpts.md`](../evidence/bitpay-invoice-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): the path above.
- CHECKED (`cast` at block 26,431,592): `owner()` = `quoteSigner()` = `0x2730ef3c…` (EOA, nonce 27,550); 0 ETH.
- CHECKED (Blockscout transactions and token transfers): last `pay` 2026-07-22; owner `withdraw` of 566,825 USDT and
  351,124 USDC the same day; `setSigner` on 2026-07-23; no calls since.
- CHECKED (precompile trace to March 2026): 44,598 transactions with `ecrecover` in the last year ($67.3M paid
  through them, a flow).
- CHECKED (web search): Etherscan labels the address "BitPay: Invoice"; deployer `0xad4eb3c3…` (2022-12-19).
- INFERRED: whether BitPay's back end still credits invoices from this contract's `PaymentAccepted` events, and which
  contract replaced it, was not established.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x34e15888…` Invoice | config-only (signer, owner) | $14 | 2026-07-23 | 0 |

While it was in use, the contract held customer payments between owner sweeps (up to ≈ $918k on 2026-07-22), which
the owner key could withdraw. Now it holds dust. A forged quote can only move the payer's own funds into the
contract; its effect is a false "paid" record for a BitPay invoice, which matters only if BitPay still reads this
contract. The Polygon deployment at the same address is out of scope.

## Remediation

- BitPay retires the contract (it is dormant), or, if it is reused, deploys a replacement that verifies quotes through
  ERC-1271 or a post-quantum scheme and is owned by a post-quantum account rather than the quote-signing EOA.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 4: the path is dormant since 2026-07-23 (swept, signer reset) and
  holds $14. Project identified as BitPay (Etherscan label "BitPay: Invoice"); `project` set to `bitpay`, id kept.
- 2026-11-17 integration: id renamed from `unidentified-34e15888-signer-key` (project identified).
