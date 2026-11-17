---
id: datachain-lcp-enclave-keys
title: "TOKI (Datachain LCP): a quantum attacker who recovers the SGX enclave keys behind LCP client 0xee50fafc can forge IBC packets that release the TOKI bridge pools (about USD 3.7k)"
project: datachain
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xee50fafc11baad66d1898d712409866844a8f644"
  implementation: "0x1a8f920a3504a2707b49172a9a59ae4c503f30dc"
  name: ERC1967Proxy -> TokiLCPClientZKDCAP
  upgradeable: "yes"
  admin: UUPS owner() Safe 0x0c12a2f19c3e40b4098b389bd4e74baf049456f3 (2 of 3), which also owns IBC handler 0x0f4bdbe6735bfa859a73f8da9251662e1081ca9c; read at block 26431590
  value_usd: 3742
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-02-20
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Safe 0x0c12a2f19c3e40b4098b389bd4e74baf049456f3 (2 of 3) upgrades the client proxy 0xee50fafc… (UUPS) to verify post-quantum enclave signatures
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/datachain-lcp-enclave-keys/classification.jsonl
  - evidence/datachain-lcp-enclave-keys/onchain.json
  - evidence/datachain-lcp-enclave-keys/activity.json
  - evidence/datachain-lcp-enclave-keys/source-excerpts.md
  - evidence/datachain-lcp-enclave-keys/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [vsg-lcp-enclave-keys]
---

## Summary

TOKI's Ethereum bridge relies on Datachain's LCP (Light Client Proxy) client `0xee50fafc…f644`, which accepts IBC
state updates and packet proofs signed by secp256k1 keys generated inside SGX enclaves, optionally with an operator
threshold (PQ-5). Those signatures are published on-chain, so a quantum attacker can recover the enclave (and
operator) keys, sign a false counterparty state, and prove packets that release the TOKI pools: USD 3,742 at
2026-11-17. A 2-of-3 Safe can upgrade the client. Rated LOW: MEDIUM by step 4 (contract upgrade), lowered one level by
step 5 (under USD 50k measured).

## Mechanism

- `LCPClientBase.updateClient` (`@datachainlab/lcp-solidity/contracts/LCPClientBase.sol`) calls
  `verifySignatures(clientStorage, keccak256(proxy_message), signatures)`: with no operators, one signature must
  recover to an active enclave key; with operators, each signature must recover to an active enclave key registered
  for that operator, and `ensureSufficientValidSignatures` applies the threshold. `verifyECDSASignature` is
  `ECDSA.recover` (lines 495–500). `verifyMembership` checks packet commitments with the same enclave signatures
  (`verifyCommitmentProofs`).
- Enclave keys are registered by `LCPClientZKDCAPBase.zkDCAPRegisterEnclaveKey`, which checks a RISC Zero Groth16
  proof of Intel DCAP verification with the immutable `riscZeroVerifier` `0xffeb02a0…4aa1` (BN254, a separate
  verifier contract). That route is pre-quantum too, but recovering an already active enclave key is enough.
- The client is called only by its IBC handler (`onlyIBC`); a forged update lets the relayer submit `recvPacket`
  proofs that the handler routes to the TOKI Bridge, which releases pool tokens.
- `updateOperators` rotates the operator set, but only to other ECDSA keys (`key-rotation-only`).
- Pattern PQ-5. Excerpts: [`source-excerpts.md`](../evidence/datachain-lcp-enclave-keys/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): `TokiLCPClientZKDCAP` implementation `0x1a8f920a…30dc`, functions above;
  `_authorizeUpgrade` is `onlyOwner`.
- CHECKED (Sourcify constructor arguments): `ibcHandler` = `0x0f4bdbe6…ca9c` (ERC1967Proxy ->
  `OwnableUpgradeableIBCHandler` `0xe85d582b…7718`).
- CHECKED (on-chain reads, blocks 26,431,528–26,431,590): client implementation slot = `0x1a8f920a…`, `owner()` =
  Safe `0x0c12a2f1…56f3`, threshold 2 of 3; handler `owner()` = the same Safe and `getIBCModuleByPort("toki")` =
  `0x58f86c44…12a4` (Bridge); Bridge `poolRepository()` = `0x340601b9…0696`, pools 1–3 hold 927.28 USDC, 461.70 USDT
  and 1.2988 tokiETH (backed 1:1 by 1.2988 ETH in `0x9c3bdd45…55ef`) at block 26,431,530
  ([`escrow.json`](../evidence/datachain-lcp-enclave-keys/escrow.json)).
- CHECKED (Blockscout): the handler carries port `toki` packets; last `updateClient` 2026-02-20, then
  `transferOwnership` 2026-02-26.
- CHECKED (precompile trace to March 2026): 41,584 transactions with `ecrecover` (last block 24,496,806).
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/datachain-lcp-enclave-keys/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Escrow (TOKI pools) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xee50fafc…` ERC1967Proxy -> TokiLCPClientZKDCAP | yes (UUPS, Safe 2/3) | USD 3,742 (2026-11-17) | 2026-02-20 | 0 |

- Escrow: pools `0xd0934c19…b38b` (USDC, USD 927), `0x24402148…082b` (USDT, USD 462) and `0xe0b31584…d3e0` (tokiETH,
  1.2988 ETH = USD 2,353 at USD 1,811.62/ETH); the Bridge proxy itself holds dust.
- Yearly pre-quantum use (`txs_y1`): 41,531 transactions; activity stopped in February 2026.
- The other LCP client in the draft, `0x21fd9803…`, is operated by a different party for a VSG redeem bridge; it is
  now `vsg-lcp-enclave-keys`.

## Remediation

- Post-quantum replacement: enclave keys that sign with a post-quantum scheme (verified by an ERC-7913-style verifier
  in the client), and attestation verified with a hash-based proof instead of the Groth16 wrapper; or a ZK light
  client of the counterparty with a hash-based proof.
- Who must act: Safe `0x0c12a2f1…56f3` (2 of 3) upgrades the client proxy (UUPS); it also owns the IBC handler.
  Datachain maintains the LCP library. No protocol change needed.
- Users: nothing beyond not leaving liquidity in the pools.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review05): MEDIUM -> LOW, step 5: escrow measured through the client's IBC handler and the TOKI
  Bridge pools, USD 3,742 (block 26,431,530). `alternative` sole -> key-rotation-only (operators and enclave keys
  rotate, the scheme does not).
- 2026-11-17 review (Review05): split `0x21fd9803…` (immutable LCPClient of a VSG redeem bridge, operator EOA
  `0x7b88f333…`) into `vsg-lcp-enclave-keys`, with its evidence; `rsa` dropped from primitives (only that client used
  it). LOW unchanged, step 5 (TOKI escrow alone USD 3,742).
