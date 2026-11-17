---
id: alchemy-paymaster-signer
title: "Alchemy: a quantum attacker who recovers the paymaster's verifyingSigner ECDSA key can sponsor any user operation from its EntryPoint deposit (about USD 1.2k)"
project: alchemy
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x2cc0c7981d846b9f2a16276556f6e8cb52bfb633"
  implementation: "0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4"
  name: ERC1967Proxy → VerifyingPaymaster (implementation unverified)
  upgradeable: "yes"
  admin: UUPS, owner() 0xddf32240b4ca3184de7ec8f0d5aba27dec8b7a5c (EOA), read at block 26431527
  value_usd: 1166
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 115042
families: []
fix:
  layer: contract-upgrade
  who_acts: Alchemy, through the UUPS owner 0xddf32240b4ca3184de7ec8f0d5aba27dec8b7a5c (EOA), upgrading the implementation to verify a post-quantum sponsor signature
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/alchemy-paymaster-signer/classification.jsonl
  - evidence/alchemy-paymaster-signer/onchain.json
  - evidence/alchemy-paymaster-signer/activity.json
  - evidence/alchemy-paymaster-signer/source-excerpts.md
  - evidence/alchemy-paymaster-signer/paymaster.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

Alchemy's ERC-4337 v0.7 paymaster (`0x2cc0c798…b633`) sponsors a user operation when its `paymasterAndData` carries an
ECDSA signature from one off-chain key, `verifyingSigner` `0x13dc4c44…dbc2` (PQ-4). Every sponsored operation
publishes such a signature, so the public key is known; a quantum attacker who recovers the key can sponsor any
operation and spend the paymaster's EntryPoint deposit, 0.644 ETH (about USD 1,166) at 2026-11-17. Users' own funds are
not at stake. Rated LOW: MEDIUM by step 4 (fix by a UUPS upgrade), lowered one level by step 5 (under USD 50k exposed).

## Mechanism

- `validatePaymasterUserOp(PackedUserOperation,bytes32,uint256)` (selector `0x52b7512c`, called by EntryPoint
  `0x0000000071727de22e5e9d8baf0edac6f37da032`) recovers the signer of the eth-signed hash of the operation and
  returns `SIG_VALIDATION_FAILED` unless it equals `verifyingSigner`; on success the EntryPoint charges the gas to the
  paymaster's deposit. `updateVerifyingSigner(address)` (owner) can only swap one ECDSA key for another.
- The implementation `0xb4e809ab…a3e4` is not verified on Sourcify or Blockscout. The classifier's description
  (`VerifyingPaymaster._validatePaymasterUserOp`, `toEthSignedMessageHash().recover`) matches its bytecode:
  selectors `verifyingSigner()`, `updateVerifyingSigner(address)`, `validatePaymasterUserOp` (v0.7), `postOp`,
  `upgradeToAndCall`, `withdrawTo`, `getDeposit`, `addStake`; the `"\x19Ethereum Signed Message:\n32"` prefix and
  the OpenZeppelin `ECDSA` malleability bound (secp256k1 n/2) are in the code.
- Pattern PQ-4. The proxy's verified source is a plain OpenZeppelin `ERC1967Proxy`
  ([`source-excerpts.md`](../evidence/alchemy-paymaster-signer/source-excerpts.md)).

## Evidence

- CHECKED (bytecode of `0xb4e809ab…`, read 2026-11-17): selectors and constants above
  ([`paymaster.json`](../evidence/alchemy-paymaster-signer/paymaster.json)).
- CHECKED (precompile trace to March 2026): `ecrecover` calls; 38,814 pre-quantum calls in the last year (`txs_y1`).
- CHECKED (on-chain read at block 26,431,527): EIP-1967 implementation slot = `0xb4e809ab…a3e4`, admin slot empty
  (UUPS); `owner()` = `0xddf32240…7a5c`, an EOA (no code, nonce 127); `verifyingSigner()` = `0x13dc4c44…dbc2`, an EOA
  that has never sent a transaction; `entryPoint()` = EntryPoint v0.7; `getDepositInfo(paymaster)` on the EntryPoint:
  deposit 0.643645 ETH, staked 0.1 ETH, unstake delay 86,400 s ([`paymaster.json`](../evidence/alchemy-paymaster-signer/paymaster.json)).
- CHECKED (Blockscout): the proxy was created at block 19,677,788 (2024-04-17) by the owner EOA; the current
  implementation was created at block 26,401,282 (2026-11-12) by `0x4f0cf2a1…0583` through the CREATE2 deployer, so
  it was installed after the 2026-11-04 classification.
- CHECKED (Xatu, any function): 115,042 transactions 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](../evidence/alchemy-paymaster-signer/activity.json)).
- INFERRED: attribution to Alchemy comes from third-party code that names this address the Alchemy paymaster
  (e.g. AvaProtocol/EigenLayer-AVS, satoraHQ/satora-sdk on GitHub); no Alchemy document listing it was found.

## Impact and exposure

| Contract | Upgradeable | Escrow (EntryPoint deposit) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2cc0c798…` ERC1967Proxy → VerifyingPaymaster | yes (UUPS, owner EOA) | 0.644 ETH, USD 1,166 (2026-11-17) | 2026-11-16 | 115,042 |

- Escrow: the paymaster's balance in EntryPoint v0.7 `0x0000000071727de22e5e9d8baf0edac6f37da032`, which a forged
  sponsorship signature spends on the attacker's gas. The 0.1 ETH stake is not spendable through sponsorship. The
  proxy itself holds nothing. Alchemy tops the deposit up, so the figure moves; it was USD 1,166 at the read.
- Yearly pre-quantum use: 38,814 transactions (`txs_y1`); `usd_tx_y1` (USD 69.6 million) counts transfers inside the
  sponsored operations, not money the paymaster can lose.
- Wider: the UUPS owner is itself one ECDSA EOA that has sent transactions; with its key an attacker could upgrade the
  paymaster or call `withdrawTo` on the deposit. Same value at stake.

## Remediation

- Post-quantum replacement: verify the sponsor signature with a post-quantum scheme (an ERC-7913 verifier) in a new
  implementation; EIP-8141 frame transactions can carry sponsorship natively.
- Who must act: Alchemy, via `upgradeToAndCall` from owner `0xddf32240…7a5c`; moving ownership to a post-quantum
  account also closes the owner-key path. No protocol change needed.
- Users: nothing to do; their funds are not exposed through this check.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review21): MEDIUM -> LOW, step 5: the exposure is the EntryPoint deposit, 0.644 ETH (USD 1,166),
  under USD 50k. Implementation `0xb4e809ab…` (installed 2026-11-12) is unverified, so `evidence.level` source-read ->
  bytecode; the check is unambiguous from selectors, constants and the `ecrecover` trace.
