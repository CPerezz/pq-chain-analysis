---
id: simplemultisig-owner-keys
title: "Unidentified custody operator's SimpleMultiSig wallets (deployer 0x339257cb): a quantum attacker who recovers 2–3 owner ECDSA keys can execute any transfer from about USD 58M held"
project: unidentified-9cbdbd7f
status: confirmed
severity: MEDIUM
patterns: [PQ-12]
primitives: [ecrecover]
trigger: owner-keys
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x9cbdbd7fa768ad6e9546ff57238722fa9b925329"
  implementation: null
  name: SimpleMultiSig
  upgradeable: "no"
  admin: none (3-of-5 owner EOAs and threshold fixed at construction; operated by EOA 0x339257cb1a63c766dd1e415afa5917385225b4a2)
  value_usd: 25275072
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 893
- address: "0xc82abe4dfa94b9b5453d31274fb7500459a0d12d"
  implementation: null
  name: SimpleMultiSig
  upgradeable: "no"
  admin: none (3-of-6 owner EOAs and threshold fixed at construction; operated by EOA 0x339257cb1a63c766dd1e415afa5917385225b4a2)
  value_usd: 16528427
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-23
  txs_30d: 4
families:
- code: "0x9cbdbd7fa768ad6e9546ff57238722fa9b925329"
  name: SimpleMultiSig (same runtime code, same deployer; the 12 instances not listed above)
  instances: 12
  list: evidence/simplemultisig-owner-keys/siblings.json
  upgradeable: "no"
  value_usd: 15838067
  value_basis: held
  value_as_of: 2026-11-17
fix:
  layer: new-deployment
  who_acts: the operator behind deployer/executor EOA 0x339257cb1a63c766dd1e415afa5917385225b4a2 (each wallet's owner quorum signs a transfer of all funds to a post-quantum wallet)
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/simplemultisig-owner-keys/classification.jsonl
  - evidence/simplemultisig-owner-keys/onchain.json
  - evidence/simplemultisig-owner-keys/activity.json
  - evidence/simplemultisig-owner-keys/source-excerpts.md
  - evidence/simplemultisig-owner-keys/siblings.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (full Sourcify source, owner/threshold reads, deployer's 3,146 creations grouped by code hash)
  ref: evidence/simplemultisig-owner-keys/siblings.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Fourteen wallets with identical code, all deployed and operated by EOA `0x339257cb…`, accept a transaction only when
`threshold` owner ECDSA signatures recover to fixed owner addresses. Every owner key has signed `execute` calldata
on-chain, so a quantum attacker who derives 3 of 5 (or 3 of 6, 2 of n) owner keys can call `execute` and send
everything out: about USD 57.6M held across the wallets at block 26,431,214–26,431,532. The owner set cannot change,
but the wallets belong to one active operator who can move the funds to a post-quantum wallet. Rated MEDIUM (step 4:
the fix is one operator moving funds to a new deployment). The contract is a 2025 Solidity 0.8.28 rewrite of
Christian Lundkvist's SimpleMultiSig; the party that must act is the unidentified operator, not Lundkvist.

## Mechanism

- `SimpleMultiSig.execute(sigV, sigR, sigS, destination, value, data, executor, gasLimit)` builds an EIP-712 hash of
  the call and `nonce`, then `validateSignatures` runs `ecrecover(totalHash, sigV[i], sigR[i], sigS[i])` per signature
  (`source/SimpleMultiSig-v2.0.1.sol` line 71), requiring strictly increasing recovered addresses that are `isOwner`
  and at least `threshold` signatures; it then calls `destination` with `value` and `data`.
- `threshold`, `isOwner` and `ownersArr` are set only in the constructor; there is no function to change owners,
  no ERC-1271 path and no module. `executor` may be `address(0)`, so anyone holding the signatures can submit.
- Pattern PQ-12. Excerpts: [`source-excerpts.md`](../evidence/simplemultisig-owner-keys/source-excerpts.md).

## Evidence

- CHECKED (Sourcify exact match, read 2026-11-17): the full source of both listed contracts is the same file; mechanism
  as above. Both deployed by EOA `0x339257cb1a63c766dd1e415afa5917385225b4a2` (blocks 21,846,094 and 22,239,422).
- CHECKED (`cast`, block 26,431,521): `0x9cbdbd7f…` threshold 3, owners `0x1c2d661d…`, `0x3bfde25b…`, `0xba7d68f3…`,
  `0xda80812a…`, `0xf083e8c8…`, nonce 8,602; `0xc82abe4d…` threshold 3, six owners (`0x14189451…` … `0xcbde3ab8…`),
  nonce 35. All owners are code-less EOAs with transaction nonce 0: they never sent a transaction, and their
  signatures appear only in `execute` calldata, which is enough to derive their public keys.
- CHECKED (Blockscout txlist + `scripts/rpc.py` probe, block 26,431,532): the deployer created 3,146 contracts; 14
  have this runtime code, 3,128 are `Forwarder` deposit contracts (`flushTokens`)
  ([`siblings.json`](../evidence/simplemultisig-owner-keys/siblings.json)).
- CHECKED (Blockscout): every recent `execute` on `0x9cbdbd7f…`, `0xc82abe4d…`, `0x47a0b4fa…`, `0x26cce142…` and
  `0xacf38570…` was sent by the deployer EOA; `0xacf38570…` and `0x26cce142…` share owner `0x1c2d661d…` with
  `0x9cbdbd7f…`.
- CHECKED (on-chain, block 26,431,214): holdings of the two listed wallets
  ([`onchain.json`](../evidence/simplemultisig-owner-keys/onchain.json)); Xatu activity
  ([`activity.json`](../evidence/simplemultisig-owner-keys/activity.json)).
- INFERRED: the deployer is a custodian or exchange back end (deposit forwarders swept into multisig wallets holding
  PAXG, RLUSD, USDG, USDC, USDT); its identity was not found (no ENS, tags or source attribution).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9cbdbd7f…` SimpleMultiSig (3 of 5) | no | $25.3M | 2026-11-16 | 893 |
| `0xc82abe4d…` SimpleMultiSig (3 of 6) | no | $16.5M | 2026-10-23 | 4 |
| 12 more instances (family) | no | $15.8M | — | — |

Held value is ETH plus priced tokens (2026-11-17). Among the 12 other instances, three hold value: `0xacf38570…`
USD 12.5M RLUSD, `0x47a0b4fa…` USD 2.02M (2-of-n), `0x26cce142…` USD 1.32M USDG; the other nine hold under USD 200
together. Total about USD 57.6M. Yearly pre-quantum calls (`data/report/curated_contracts.csv`, `txs_y1`): 3,625
`ecrecover` calls on `0x9cbdbd7f…`, 25 on `0xc82abe4d…`.

## Remediation

The wallet code cannot verify anything but ECDSA owner signatures and the owner set is fixed, so the operator behind
`0x339257cb1a63c766dd1e415afa5917385225b4a2` must deploy a post-quantum-capable wallet (for example a Safe whose owners
are post-quantum ERC-1271 signers) and have each wallet's owner quorum sign `execute` calls moving all ETH and tokens
there, before owner keys can be recovered. The 3,128 forwarders that sweep deposits into these wallets must be
repointed or replaced too. No protocol change is needed; EIP-8151 would not help, because the owners are code-less
keys that only sign off-chain.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: signer set fixed in code; funds must move, and many independent owners may not act).
- 2026-11-17 review (Review18): HIGH -> MEDIUM, step 4: all 14 wallets are deployed and operated by one active EOA
  (`0x339257cb…` submits every `execute`), so the fix is one operator moving funds to a new deployment, not many
  independent owners. Project changed from `simple-multisig` (Christian Lundkvist, who cannot act) to
  `unidentified-9cbdbd7f`; added the 12 other same-code wallets (USD 15.8M) as a family; `fix.layer` new-deployment.
