---
id: unidentified-c6fd8084-p256
title: "Address-poisoning batch contract 0xc6fd8084: its calls to the P-256 precompile are a calldata-parsing artefact; it verifies no signature (not affected)"
project: unidentified-c6fd8084
status: not-affected
severity: NONE
patterns: []
primitives: []
trigger: none
impact: none
alternative: sole
role: auxiliary
contracts:
- address: "0xc6fd8084fb9b6a0768cf943c341049edd1085b82"
  implementation: null
  name: unverified 352-byte contract (selector 0xa9059cbb, batch transferFrom)
  upgradeable: "no"
  admin: none (no storage, no owner; called only by creator EOA 0xef7c73aa43254c2dc10ad786065590b9c88a0816)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-11
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: nobody; the contract performs no cryptographic check
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-c6fd8084-p256
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`0xc6fd8084…5b82` is not a passkey verifier. It is a 352-byte batch `transferFrom` contract used for address
poisoning: its creator EOA sends lists of (token, victim, look-alike, 0) and the contract calls
`transferFrom` on USDT, USDC, LINK and DAI with zero amounts. The 518 "P-256" calls in the precompile trace come from
a parsing artefact: the first call target is read from the ABI length word, which was `0x100` (the P-256 precompile
address) in those transactions. Nothing is verified and nothing is held, so a quantum attacker gains nothing here.
Rated NONE (not affected).

## Mechanism

- The only entry point is selector `0xa9059cbb`. It copies all calldata to memory, splits it into four word arrays and,
  for each index, sends `transferFrom(from, to, amount)` (`0x23b872dd`) to the target with a plain `CALL`, ignoring the
  result ([`bytecode.md`](#bytecode-notes-0xc6fd8084fb9b6a0768cf943c341049edd1085b82)). There is no `ecrecover`, no
  `STATICCALL` to a verifier, no stored key and no access control.
- The loop's base pointer (`PUSH1 0x44; ADD` at 0x9f) starts one word early, at calldata word 1, the length word of the
  `bytes` argument. When that word is `0x100`, the first `CALL` goes to the P-256 precompile with 100 bytes of
  `transferFrom` data; the precompile expects 160 bytes and returns nothing.
- No pattern applies (the classifier's PQ-9 is withdrawn).

## Evidence

- CHECKED (bytecode, `cast code`/`cast disassemble`, 2026-11-17): the loop and calls above; no storage reads or writes.
- CHECKED (`cast tx 0x950bb03f…dfe94`, block 24,430,785, the last call): 51 tuples on USDT/USDC/LINK/DAI, all amounts
  zero, sent by creator EOA `0xef7c73aa…0816` (nonce 285,272).
- CHECKED (`cast tx 0x97b0e5ab…6df7`, block 24,046,459, a transaction the trace lists as `p256verify`): calldata word 1
  is `0x100`; no other word is `0x100`.
- CHECKED (precompile trace to March 2026): 518 transactions with `p256verify` from this contract, blocks
  23,939,469–24,430,718, zero value.
- CHECKED (Blockscout): creator `0xef7c73aa…0816`; Blockscout marks the contract `is_scam` with tag
  `Fake_Phishing1309278`.
- CHECKED (on-chain read at block 26,431,214): no ETH or tokens held; no proxy
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-c6fd8084-p256/onchain.json)).
- INFERRED: that the length word is the first target follows from the loop offsets; it matches every transaction
  checked (word 1 is `0x100` in the trace-listed one and `0xd0`, an empty address, in the last one).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xc6fd8084…` batch transferFrom (unverified) | no | 0 | 2026-02-11 | 0 |

- No pre-quantum check, so no exposure. Zero-value `transferFrom` cannot move victims' tokens; the harm of address
  poisoning (users copying a look-alike address) is unrelated to quantum attacks.
- The curation note mentions 3 identical family members; they share this code and are equally not affected.

## Remediation

None needed for post-quantum security. Users: verify full recipient addresses rather than copying from history.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review05): HIGH -> NONE, status candidate -> not-affected: the bytecode verifies no signature; it
  is an address-poisoning batch `transferFrom`, and its P-256 precompile calls come from calldata word 1 (`0x100`)
  being used as the first call target. Patterns and primitives cleared.

# Source excerpts: unidentified-c6fd8084-p256

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xc6fd8084fb9b6a0768cf943c341049edd1085b82`

No verified source on Sourcify or Blockscout.

# Bytecode notes: 0xc6fd8084fb9b6a0768cf943c341049edd1085b82

Read 2026-11-17 with `cast code` / `cast disassemble` (352 bytes, solc 0.8.18 metadata, unverified).

Runtime code:

```
0x608060405234801561001057600080fd5b506004361061002b5760003560e01c8063a9059cbb14610030575b600080fd5b61004361003e366004610111565b610045565b005b600080368080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250845194955060046020602319909601959095049490940493925050505b8181101561010b57604483016020820281015160208484010282015160206002860285010283015160206003870286010284015193506040516323b872dd60e01b600052826004528160245284604452602060006064600080885af15060006060526040525050506001919091019050610096565b50505050565b60006020828403121561012357600080fd5b503591905056fea264697066735822122067d9eebf92a88f235f65a86b01b62d9f0f5b94d86347f6e4aad042b17bc3fdf764736f6c63430008120033
```

- One entry point, selector `0xa9059cbb` (named like `transfer(address,uint256)`), no caller check, no storage.
- 0x45–0x95: copies the whole calldata to memory and splits it into four equal word arrays.
- Loop 0x96–0x10a: for each index loads four words (target, from, to, amount), writes
  `0x23b872dd` (`transferFrom(address,address,uint256)`) with (from, to, amount) and does
  `CALL(gas, target, 0, mem, 0x64, 0, 0x20)` (0xf2), ignoring the result.
- No `STATICCALL`, no `ecrecover`, no hash of a message, no comparison against a key: the contract verifies nothing.

Transactions (Blockscout, `cast tx`):

- Creator and only caller: EOA `0xef7c73aa43254c2dc10ad786065590b9c88a0816` (nonce above 285,000), creation tx
  `0x16ace5294b363a886a4c7604e601fa4b7b3b533589121432b4373d32fc177df4`. Blockscout flags the contract
  `is_scam: true` with tag `Fake_Phishing1309278`.
- `0x950bb03f…dfe94` (block 24,430,785, 2026-02-11, last call): 51 tuples; targets USDT, USDC, LINK, DAI; amounts all
  zero; `from` victims, `to` look-alike addresses. This is zero-value `transferFrom` address poisoning.
- `0x97b0e5ab…6df7` (block 24,046,459, one of the 518 transactions the precompile trace counts as `p256verify`):
  calldata word 1 (the ABI length word of the `bytes` argument) is `0x100`. The loop's first target is read from that
  word, so the first `CALL` goes to address `0x100`, the P-256 precompile, with 100 bytes of `transferFrom` calldata.
  The precompile needs 160 bytes and returns nothing; the contract ignores the result. The "P-256 calls" are this
  parsing artefact, not signature checks.
