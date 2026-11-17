---
id: relay-allocator-signer
title: "Relay Protocol RelayDepository: a recovered allocator ECDSA key signs arbitrary calls that drain the depository (USD 920k); the owner can switch the allocator to an ERC-1271 contract"
project: relay
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x4cd00e387622c35bddb9b4c962c136462338bc31"
  implementation: null
  name: RelayDepository
  upgradeable: config-only
  admin: owner() EOA 0xf61a305199fa1135d76ffab3752d42f55cbd775a (Solady Ownable) can setAllocator; allocator() is EOA 0x63c1d3e9c646184529c5694630a01c00df171b56 (read at block 26,431,564)
  value_usd: 920119
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 678812
families: []
fix:
  layer: onchain-config
  who_acts: Relay; owner EOA 0xf61a305199fa1135d76ffab3752d42f55cbd775a calls setAllocator with an ERC-1271 contract that verifies post-quantum (or threshold) signatures, and moves ownership to a post-quantum account
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/relay-allocator-signer/classification.jsonl
  - evidence/relay-allocator-signer/onchain.json
  - evidence/relay-allocator-signer/activity.json
  - evidence/relay-allocator-signer/source-excerpts.md
  - evidence/relay-allocator-signer/onchain-review.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review02 (registry review)
  ref: evidence/relay-allocator-signer/onchain-review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

RelayDepository holds Relay's mainnet deposits (USD 920k on 2026-11-17) and executes any list of calls signed by its
`allocator`. The allocator is an EOA, so its signature is checked with `ecrecover`; its public key is exposed by the
signatures in every `execute` transaction, and a quantum attacker who recovers the key can sign a call request that
transfers everything out (PQ-4). The contract already verifies through ERC-1271 when the allocator has code, so Relay's
owner can remove the exposure with one `setAllocator` call to a contract that checks a post-quantum signature. Rated
LOW (step 4: one known operator changes a setting); the owner is itself an ECDSA EOA and should move too.

## Mechanism

- `RelayDepository.execute(CallRequest request, bytes signature)` hashes the request (EIP-712), checks expiry, requires
  `allocator.isValidSignatureNow(eip712Hash, signature)` and replay protection, then `_executeCalls` performs each
  `c.to.call{value: c.value}(c.data)` from the depository (`src/RelayDepository.sol` lines 155–224). A signed request
  can therefore transfer any ETH or token the depository holds.
- Solady `SignatureCheckerLib.isValidSignatureNow` uses `ecrecover` only when `extcodesize(allocator) == 0`; otherwise it
  calls the allocator's ERC-1271 `isValidSignature` with the full signature (PQ-13 ordering on the library side).
- `setAllocator(address)` is `onlyOwner` (lines 92–96).
- Excerpts: [`source-excerpts.md`](../evidence/relay-allocator-signer/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): the path above; no proxy, no upgrade function.
- CHECKED (on-chain read at block 26,431,564, [`onchain-review.json`](../evidence/relay-allocator-signer/onchain-review.json)):
  `allocator()` = `0x63c1d3e9…` (no code, nonce 0: it never sent a transaction, its key is exposed through its
  signatures), `owner()` = `0xf61a3051…` (no code, nonce 5), EIP-1967 slot empty, ETH balance 95.62.
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](../evidence/relay-allocator-signer/onchain.json)): holdings
  95.14 ETH plus USD 747,756 in tokens (USDC 587,825, DAI 100,047, USDT 50,046, others) = USD 920,119.
- CHECKED (Xatu, [`activity.json`](../evidence/relay-allocator-signer/activity.json)): 678,812 transactions
  2026-10-16 to 2026-11-16; 50,791 pre-quantum transactions in the last year (`txs_y1`,
  `data/report/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4cd00e38…` RelayDepository | config-only | $920k | 2026-11-16 | 678,812 |

The depository holds the deposits it releases, so the held value is the exposure. No other RelayDepository
deployment on mainnet is in the census data.

## Remediation

- Replacement: an allocator contract implementing ERC-1271 that verifies a post-quantum signature (ML-DSA or
  hash-based) or a threshold of post-quantum signers; RelayDepository needs no code change.
- Who acts: Relay's owner EOA `0xf61a305199fa1135d76ffab3752d42f55cbd775a` calls `setAllocator`, and should
  `transferOwnership` to a post-quantum account, because the owner's own ECDSA key could otherwise set a forged
  allocator. No protocol change is needed.
- Depositors: the contract has no user withdrawal path of its own (every outflow goes through `execute`), so users
  can only limit what they leave deposited.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review02): LOW unchanged, step 4: one known operator (owner EOA 0xf61a3051…) switches the allocator to an ERC-1271 contract with a setting. Allocator and owner read at block 26,431,564 (both EOAs); fix.layer new-deployment -> onchain-config.
