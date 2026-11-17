---
id: unidentified-0bdf246b-signer-key
title: "PMMProtocol (RFQ market-maker contract, deployer 0xc6471559…, operator unidentified): ECDSA is tried before ERC-1271 on maker quotes, but its only maker is a Safe paid out through Permit2, so a quantum attacker can take nothing here beyond the maker's own Safe keys"
project: unidentified-0bdf246b
status: confirmed
severity: LOW
patterns: [PQ-2, PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x0bdf246b4aef9cfe4dd6eef153a1b645ac4bcbb6"
  implementation: null
  name: PMMProtocol
  upgradeable: "no"
  admin: "none (no owner, no proxy)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-31
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer 0xc64715599f5910ae6fd5c3900850c561a44bd413 (operator unidentified) for a contract that checks account code before ecrecover; market makers by signing only through ERC-1271 and Permit2 from contract accounts"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/unidentified-0bdf246b-signer-key/classification.jsonl
  - evidence/unidentified-0bdf246b-signer-key/onchain.json
  - evidence/unidentified-0bdf246b-signer-key/activity.json
  - evidence/unidentified-0bdf246b-signer-key/source-excerpts.md
  - evidence/unidentified-0bdf246b-signer-key/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/unidentified-0bdf246b-signer-key/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

PMMProtocol fills RFQ orders signed by a market maker; unless the taker sets a smart-contract flag, it tries `ecrecover`
on the maker's signature before ERC-1271 (PQ-2). A maker that is an ECDSA account, or an EIP-7702 account that moved to
post-quantum signing, stays forgeable here with its old key. Every observed fill came from one maker, a Safe, which no
`ecrecover` result can match, and its funds move through Permit2 signature transfers that Permit2 verifies itself; the
maker has approved nothing to this contract directly. Rated LOW (step 4): the ERC-1271 path is already the one in use and
nothing can be taken through this contract's check; the contract has been idle since 2026-03-31.

## Mechanism

- `fillOrderRFQ…` (PmmProtocol.sol lines 112–128, 171–182): with `_SIGNER_SMART_CONTRACT_HINT`, ERC-1271 only (the `(r, vs)`
  entry forwards 64 bytes, the `bytes` entry the full signature); otherwise `ECDSA.recoverOrIsValidSignature`
  (ECDSA.sol lines 99–133): `ecrecover`, then ERC-1271. The taker sets the flag.
- `_fillOrderRFQTo` pulls the maker asset with Permit2: `permitWitnessTransferFrom`/`permitTransferFrom` with the maker's
  `permit2Signature` (lines 268–290), or a Permit2 allowance transfer (line 293). Permit2 checks account code before
  `ecrecover` (PQ-13), so a contract maker is protected there regardless of this contract.
- No owner, proxy or admin: the code cannot change.

## Evidence

- CHECKED (verified source, Blockscout): the paths above
  ([`source-excerpts.md`](../evidence/unidentified-0bdf246b-signer-key/source-excerpts.md),
  [`notes.md`](../evidence/unidentified-0bdf246b-signer-key/notes.md)).
- CHECKED (on-chain read, block 26,431,214): no proxy, no owner, holds nothing
  ([`onchain.json`](../evidence/unidentified-0bdf246b-signer-key/onchain.json)).
- CHECKED (Blockscout logs, latest 50 fills): maker always Safe `0xb7131fc8…` (1 of 2), `usePermit2 = true`.
- CHECKED (on-chain read, block 26,431,557): the maker's ERC-20 and Permit2 allowances to this contract are 0 for USDC,
  WETH and USDT.
- CHECKED (Xatu, any function): no calls 2026-10-16 to 2026-11-16; last 2026-03-31
  ([`activity.json`](../evidence/unidentified-0bdf246b-signer-key/activity.json)).
- INFERRED: the operator. The deployer `0xc6471559…` also deployed four `DexRouter` contracts with OKX DEX's function
  names, but that does not establish who runs this contract.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0bdf246b…` PMMProtocol | no | none found (maker allowances to it are 0) | 2026-03-31 | 0 |

The contract holds nothing. The maker Safe holds about $2.36M, approved to Permit2, not to this contract; it is exposed
through its own 1-of-2 ECDSA owners (PQ-12 of that Safe), not through this check. Yearly pre-quantum count from the
census: 22,165 fills (`txs_y1`).

## Remediation

- A redeployment that checks account code before `ecrecover` (as Permit2 and current OpenZeppelin `SignatureChecker`
  do) removes the PQ-2 path; the operator is not identified (deployer `0xc6471559…`).
- Makers: sign only from contract accounts with post-quantum owners and keep approvals on Permit2; the maker Safe
  `0xb7131fc8…` needs post-quantum owners.
- EIP-8151 would help: `ecrecover` would fail for migrated EIP-7702 makers, closing the old-key path without the operator.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review11): LOW unchanged (step 4: the only maker already signs through ERC-1271 and is paid through Permit2; nothing can be taken through this check). Patterns [PQ-4] -> [PQ-2, PQ-4]; protocol change not-needed -> helps (EIP-8151). Operator still unidentified (deployer also deployed OKX-style DexRouters; not conclusive).
