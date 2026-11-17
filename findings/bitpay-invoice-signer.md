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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitpay-invoice-signer
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
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bitpay-invoice-signer/notes.md
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
[`notes.md`](#review-reads-bitpay-invoice-signer-2026-11-17-review07),
[`source-excerpts.md`](#source-excerpts-bitpay-invoice-signer).

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review07): MEDIUM -> LOW, step 4: the path is dormant since 2026-07-23 (swept, signer reset) and
  holds $14. Project identified as BitPay (Etherscan label "BitPay: Invoice"); `project` set to `bitpay`, id kept.
- 2026-11-17 integration: id renamed from `unidentified-34e15888-signer-key` (project identified).

# Source excerpts: bitpay-invoice-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x34e158883efc81c5d92fde785fba48db738711ee` — Invoice (verified source via sourcify)

### `Invoice.sol`

```solidity
   34      bytes memory prefix = "\x19Ethereum Signed Message:\n32";
   35      bytes32 ourHash = keccak256(abi.encodePacked(value, gasPrice, expiration, payload, tokenContract));
   36      bytes32 payloadHash = keccak256(abi.encodePacked(prefix, ourHash));
   37      isValid = isValid && ourHash == hash;
   38      isValid = isValid && (ecrecover(payloadHash, v, r, s) == quoteSigner);
   39      return isValid;
   40    }
   41  
   42    function validatePayment(
  ...
   55      bytes memory prefix = "\x19Ethereum Signed Message:\n32";
   56      bytes32 ourHash = keccak256(abi.encodePacked(value, gasPrice, expiration, payload, tokenContract));
   57      bytes32 payloadHash = keccak256(abi.encodePacked(prefix, ourHash));
   58      require(ourHash == hash, "Hash mismatch");
   59      require(ecrecover(payloadHash, v, r, s) == quoteSigner, "Signature mismatch for quote");
   60      return true;
   61    }
   62  
   63  
  ...
```

# Review reads: bitpay-invoice-signer (2026-11-17, Review07)

## Identity

- Etherscan public label for `0x34e158883efc81c5d92fde785fba48db738711ee`: "BitPay: Invoice" (web search result,
  etherscan.io address page). Verified contract name `Invoice` (Sourcify, solc 0.4.x). Deployed 2022-12-19 by
  `0xad4eb3c32785e0edd88261d2d6fcc3acb02ad430` (tx `0xba333614…6b4d`, Blockscout). The same address hosts a
  contract on Polygon (Polygonscan).

## Source (Sourcify, `Invoice.sol`)

- `pay(value, gasPrice, expiration, payload, hash, v, r, s, tokenContract)` (lines 64–85): calls `validatePayment`
  (lines 42–61), which requires `ecrecover(prefixed keccak(value, gasPrice, expiration, payload, tokenContract), v, r,
  s) == quoteSigner`, an unexpired quote and an unpaid `payload`; ETH (`msg.value`) or the token amount is taken from
  the payer; `isPaid[payload] = true`; `PaymentAccepted` emitted.
- `withdraw(tokenContract)` (lines 92–100), `setSigner` (102–104), `setAdmin` (105–107): `isAdmin` (owner only).

## On-chain reads (`cast`, publicnode, block 26,431,592)

- `owner()` = `quoteSigner()` = `0x2730ef3c0c180e7f7bcfca249c757421b208e333` (no code, nonce 27,550). ETH balance 0.

## Activity (Blockscout, latest pages)

- 2026-07-22: last `pay` calls; three `withdraw` calls by the owner, the largest sending 566,825.02 USDT and
  351,123.58 USDC to `0x2730ef3c…`.
- 2026-07-23: `setSigner` by the owner, after which `quoteSigner` equals the owner address; no `pay` since.
- Remaining tokens (Blockscout): dust (0.007 stETH and unpriced or spam tokens); onchain.json: $14 held.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 44,598, `usd_tx_y1` $67.3M (payment flow,
  not an exposure).
