---
id: lagrange-groth16-verifier
title: "Lagrange LPNRegistryV1 0xf8e0efef: a quantum attacker who recovers the Groth16 setup trapdoor can feed false query results to client callbacks; dormant since 2025, no client holds value"
project: lagrange
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: unknown
alternative: sole
role: core
contracts:
- address: "0xf8e0efefaffa31f9c85f175147d64753e4ec8157"
  implementation: "0xbead7fe75b567ac0fc12526225451eb3f964d834"
  name: ERC-7760 proxy (Solady ERC1967Factory) → LPNRegistryV1
  upgradeable: "yes"
  admin: Safe 0xe7cda508feb53713fb7c69bb891530c924980366 (2 of 4), adminOf in ERC1967Factory 0x0000000000006396ff2a80c067f99b3d2ab4df24 and owner()
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-08-28
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Lagrange, through Safe 0xe7cda508feb53713fb7c69bb891530c924980366 (2 of 4) upgrading the proxy via ERC1967Factory 0x0000000000006396ff2a80c067f99b3d2ab4df24
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/lagrange-groth16-verifier/classification.jsonl
  - evidence/lagrange-groth16-verifier/onchain.json
  - evidence/lagrange-groth16-verifier/activity.json
  - evidence/lagrange-groth16-verifier/source-excerpts.md
  - evidence/lagrange-groth16-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review03 (registry review)
  ref: evidence/lagrange-groth16-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Lagrange's LPN registry answers SQL queries over Ethereum storage with a Groth16 proof on BN254 checked inside the
registry (PQ-7). A quantum attacker who recovers the setup trapdoor can forge `respond` calls that deliver arbitrary
query results to the requesting client's `lpnCallback`. The registry has not verified a proof since 2025-06-02 and
has seen no request since 2025-08-28; its only contract client, LPNQueryV1 0xcb170b5a, holds nothing, and the
0.16 ETH of fees in the registry is withdrawable only by the owner. Rated LOW (step 1: no activity in the last 12
months and nothing a proof can release); the draft's MEDIUM came from the upgrade path alone.

## Mechanism

- `QueryManager.request(...)` (payable, `requireGasFee`) stores a query for `msg.sender` as client.
- `QueryManager.respond(uint256 requestId_, bytes32[] data, uint256)` is callable by anyone: it deletes the request,
  runs `processQuery(data, query.input)` and calls `ILPNClientV1(query.client).lpnCallback(requestId_, result)`.
- `Groth16VerifierExtension.processQuery` → `verifyGroth16Proof` requires `inputs[0] == CIRCUIT_DIGEST` and calls
  `this.verifyProof(proofs, inputs)` (`Verifier.sol` line 567, gnark Groth16 with `ecpairing`), then checks the
  public inputs' sha256 and the query fields. With the trapdoor the proof verifies for any output.
- The verifier is compiled into the implementation, so replacing it needs a proxy upgrade.

## Evidence

- CHECKED (verified source of 0xbead7fe7…, Blockscout): `LPNRegistryV1 is QueryManager, RegistrationManager,
  OwnableWhitelist, Initializable`; `respond`, `processQuery`, `verifyGroth16Proof`, `withdrawFees` (onlyOwner) as
  above ([`source-excerpts.md`](../evidence/lagrange-groth16-verifier/source-excerpts.md)).
- CHECKED (on-chain read, block 26,431,557): EIP-1967 implementation slot = 0xbead7fe7…, admin slot empty; the
  runtime code takes the upgrade path only when the caller is Solady's ERC1967Factory 0x0000000000006396…;
  `ERC1967Factory.adminOf(proxy)` and `owner()` = Safe 0xe7cda508… (2 of 4); balance 0.16 ETH
  ([`escrow.json`](../evidence/lagrange-groth16-verifier/escrow.json)).
- CHECKED (Blockscout transactions and logs of the proxy): last `respond` 2025-06-02 (block 22,616,343); last
  `NewRequest` 2025-08-28 (block 23,241,587) from LPNQueryV1 0xcb170b5a; clients seen: LPNQueryV1 (13 requests,
  7 responses, holds $0) and two EOAs.
- CHECKED (Xatu, any function, 2026-03-18 to 2026-11-16): no call to the proxy; the only frame on the
  implementation is a direct `initialize(address)` on 2026-10-18 (tx 0x9cf3e3ea…), which does not touch the proxy
  ([`activity.json`](../evidence/lagrange-groth16-verifier/activity.json)). The draft's `last_active` 2026-10-18
  came from that call and is corrected to 2025-08-28.
- INFERRED: what a false result could cost depends on client contracts; none holding value was found.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf8e0efef…` ERC-7760 proxy → LPNRegistryV1 | yes (factory admin Safe 2/4) | 0.16 ETH fees, owner-only; escrow $0 | 2025-08-28 | 0 |

`txs_y1` = 7 pre-quantum calls in `curated_contracts.csv` (the seven `respond` transactions of April–June 2025).

## Remediation

- Post-quantum replacement: a hash-based (STARK/FRI) query proof verifier in a new implementation.
- Who acts: Lagrange, through Safe 0xe7cda508… (2 of 4) upgrading via ERC1967Factory; or retiring the registry,
  since it is unused. Client contracts that consume `lpnCallback` results should not rely on it for value.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review03): MEDIUM -> LOW, step 1: no proof verified since 2025-06-02 and no request since 2025-08-28; the only contract client holds nothing and the 0.16 ETH fees are owner-only. Admin read from ERC1967Factory `adminOf`; `last_active` corrected (the 2026-10-18 call was to the implementation); impact set to unknown (false query results, no funds path found).
