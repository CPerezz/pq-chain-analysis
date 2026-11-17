---
id: near-omni-bridge-mpc-key
title: "NEAR Omni Bridge: a quantum attacker who recovers the bridge's one MPC-held ECDSA key can sign transfers that release the $50.9M escrowed in OmniBridge and mint bridged tokens"
project: near
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xe00c629afaccb0510995a2b95560e446a24c85b9"
  implementation: "0x53785920165fbdf33b3f56885dbc8d12854ac414"
  name: OmniBridge (ERC1967Proxy)
  upgradeable: "yes"
  admin: "DEFAULT_ADMIN_ROLE: Safe 0x2468603819bf09ed3fb6f3efeff24b1955f3cde1 (3 of 5) upgrades (UUPS) and sets nearBridgeDerivedAddress; read at block 26431457"
  value_usd: 50887232
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1506
families: []
fix:
  layer: contract-upgrade
  who_acts: "NEAR Omni Bridge admin Safe 0x2468603819bf09ed3fb6f3efeff24b1955f3cde1 (3 of 5) upgrades OmniBridge to a post-quantum check; NEAR's MPC network must provide a post-quantum signature or proof to verify"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/near-omni-bridge-mpc-key/classification.jsonl
  - evidence/near-omni-bridge-mpc-key/onchain.json
  - evidence/near-omni-bridge-mpc-key/activity.json
  - evidence/near-omni-bridge-mpc-key/source-excerpts.md
  - evidence/near-omni-bridge-mpc-key/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/near-omni-bridge-mpc-key/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

OmniBridge releases escrowed tokens and ETH, and mints bridged tokens, for any transfer signed by
`nearBridgeDerivedAddress`, one secp256k1 key held as a threshold-ECDSA share set by NEAR's MPC (chain signatures)
network. On Ethereum it is a single public key, so a quantum attacker recovers the key itself without breaking any
quorum (PQ-4) and can sign `finTransfer` messages that pay out the $50.9M the bridge holds. Rated MEDIUM (step 4): the
admin Safe can upgrade the contract to a post-quantum check.

## Mechanism

- `finTransfer(signatureData, payload)` (OmniBridge.sol l.190-242): Borsh-encodes the transfer (nonce, token, amount,
  recipient, fee recipient), `ECDSA.recover(keccak256(encoded), signatureData) != nearBridgeDerivedAddress` reverts
  (l.216); then sends ETH (l.221), calls a custom minter (l.225), mints a `BridgeToken` (l.227) or transfers the
  escrowed ERC-20 (l.229).
- `deployToken` (l.97-107) uses the same check to create bridged tokens.
- `setNearBridgeDerivedAddress` (l.316) and `_authorizeUpgrade` (l.334) are `onlyRole(DEFAULT_ADMIN_ROLE)`; the role
  rotates the key but cannot change the scheme without an upgrade.

Pattern PQ-4 (the draft's PQ-5 assumed a set of keys; the contract checks one). Excerpts:
[`source-excerpts.md`](../evidence/near-omni-bridge-mpc-key/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of `0x53785920…`, read 2026-11-17): the functions above
  ([`review-reads.json`](../evidence/near-omni-bridge-mpc-key/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0x53785920…`;
  `nearBridgeDerivedAddress()` = `0x22eb4d37677ed931d9de2218cece1a832a147490`; `hasRole(DEFAULT_ADMIN_ROLE)` true for
  Safe `0x2468603…` (threshold 3 of 5) and false for the deployer `0xd9cb0777…`, matching the RoleGranted (block
  22,224,025) and RoleRevoked (block 22,224,038) logs.
- CHECKED (pipeline read at block 26,431,214, top holdings re-checked on Blockscout 2026-11-17): 2,191 ETH, 766.6M
  AURORA (about $24.7M), 14.5M USDC, 3.9M USDT, 18 WBTC and others; $50.9M in total.
- CHECKED (precompile trace to March 2026): 4,334 pre-quantum calls in the year
  (`data/report/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 1,506 transactions (any function)
  ([`activity.json`](../evidence/near-omni-bridge-mpc-key/activity.json)).
- INFERRED: the key is NEAR chain-signatures' derived key (name of the variable and the classifier's reading); the
  MPC setup itself was not checked.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe00c629a…` OmniBridge (ERC1967Proxy) | yes | $50.9M | 2026-11-16 | 1,506 |

The held value is the escrow a forged `finTransfer` releases. Forged messages can also mint any `BridgeToken` the
bridge deployed without limit; the market value of those tokens was not measured.

## Remediation

- NEAR Omni Bridge admin (Safe `0x2468603…`): upgrade OmniBridge to verify a post-quantum authorisation: a threshold
  post-quantum signature from the MPC network, or a STARK proof of NEAR light-client state. Rotating
  `nearBridgeDerivedAddress` does not help.
- The admin Safe's five owners are EOAs (no code at block 26,431,457), so they need post-quantum signers too (PQ-12).
- Users: holders of NEAR-side (or other-chain) representations of tokens escrowed here depend on this escrow; bridging
  them back to Ethereum takes them out of it.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: admin Safe can upgrade). Pattern PQ-5 -> PQ-4 and trigger committee-keys -> operator-key: the contract checks one ECDSA key (`nearBridgeDerivedAddress`), so recovering that key suffices. Admin corrected from "UUPS owner (Ownable2Step)" to DEFAULT_ADMIN_ROLE held by Safe 0x2468603… (3 of 5), read at block 26,431,457.
