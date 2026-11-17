---
id: zkp-airdrop-supervisor-signer
title: "zkPass ZKP airdrop vault: a quantum attacker who recovers the supervisor's ECDSA key could sign any claim, but the vault is paused, past its claim deadline and empty"
project: zkpass
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xea9f5cc526ad14cf34d6055fb16a43d3cd293712"
  implementation: "0x85050b0bf4e83f3a61af7fe4709b0ea44dc8aef2"
  name: TransparentUpgradeableProxy -> AirdropVault
  upgradeable: "yes"
  admin: ProxyAdmin 0xf827bebef3815781995c548560d48d53b1a929d8 owned by EOA 0x182085ce8b0faddc8503d9921df6af076281a6a9, which also holds DEFAULT_ADMIN_ROLE (sets supervisors, deadline, emergency withdrawal)
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-01-28
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: zkPass admin EOA 0x182085ce8b0faddc8503d9921df6af076281a6a9 (ProxyAdmin 0xf827bebef3815781995c548560d48d53b1a929d8 owner and DEFAULT_ADMIN_ROLE)
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zkp-airdrop-supervisor-signer/classification.jsonl
  - evidence/zkp-airdrop-supervisor-signer/onchain.json
  - evidence/zkp-airdrop-supervisor-signer/activity.json
  - evidence/zkp-airdrop-supervisor-signer/source-excerpts.md
  - evidence/zkp-airdrop-supervisor-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review00 (Blockscout verified source of the implementation; proxy slots, roles, vault state and event logs)
  ref: evidence/zkp-airdrop-supervisor-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

zkPass distributed 15M ZKP from this AirdropVault: anyone could claim with an EIP-712 claim signed by an address
holding `SUPERVISOR_ROLE` (an EOA), checked with `ecrecover`. A quantum attacker who derives the supervisor's key
could sign claims for any amount, but the claim window closed on 2026-01-18, the vault was paused on 2026-01-20,
and the unclaimed balance was withdrawn on 2026-01-28: it holds nothing now. Rated LOW (step 4 gives MEDIUM, a fix by
the admin's upgrade; step 5 lowers it because USD 0 is exposed).

## Mechanism

- `claim(recipient, amount, orderId, signature)` and the supervisor-only batch `delegateClaim` call `processClaim`
  (`AirdropVault.sol` line 408): within `tgeBlock`…`claimDeadLineBlock`, an unused `orderId` and `totalAmount`, it
  calls `verifySupervisorSignature` (line 460): EIP-712 digest of `(recipient, amount, orderId)`,
  `ECDSA.tryRecover`, and `hasRole(SUPERVISOR_ROLE, signer)`; then transfers ZKP to the recipient (line 444).
- The admin (DEFAULT_ADMIN_ROLE) can add or remove supervisors (`updateSupervisor`), move the deadline
  (`updateClaimDeadLineBlock`, line 262) and, while paused, withdraw everything (`emergencyWithdraw`, line 296).
- Pattern PQ-4. Excerpts: [`source-excerpts.md`](../evidence/zkp-airdrop-supervisor-signer/source-excerpts.md);
  reads: [`notes.md`](../evidence/zkp-airdrop-supervisor-signer/notes.md).

## Evidence

- CHECKED (Blockscout verified source of implementation `0x85050b0b…`, `AirdropVault` 1.0.0, read 2026-11-17): the
  path above. The draft called it unverified; it is verified.
- CHECKED (`eth_call`, block 26,431,459): EIP-1967 implementation `0x85050b0b…`, admin ProxyAdmin `0xf827bebe…`,
  whose `owner()` is `0x182085ce…` (no code); `0x182085ce…` holds DEFAULT_ADMIN_ROLE; `zkpToken()` =
  `0xe1be424f…` (ZKPToken, symbol ZKP, zkPass); `getZKPBalance()` 0; `totalClaimed()` 10,236,865 of 15,000,000
  ZKP; `claimDeadLineBlock()` 24,261,243 (2026-01-18); `paused()` true.
- CHECKED (event logs): at creation (block 24,045,534, deployer `0x182085ce…`) SUPERVISOR_ROLE went to EOA
  `0x8b47684b…` (still held) and PAUSER_ROLE to `0x06700c6c…`; `Paused` at block 24,276,910 (2026-01-20);
  `EmergencyWithdraw` of the ZKP to `0xc70e0056…` at block 24,333,337 (2026-01-28).
- CHECKED (Xatu, any function): no transaction called the vault from block 24,700,000 to 2026-11-16
  ([`activity.json`](../evidence/zkp-airdrop-supervisor-signer/activity.json)).
- CHECKED (Blockscout): token `0xe1be424f…` is "zkPass" (ZKP); project identified from it (the draft's `zkp-token`
  placeholder).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xea9f5cc5…` AirdropVault (proxy) | yes | $0 | 2026-01-28 | 0 |

The vault holds no ZKP and no ETH. A forged supervisor signature would only matter if the admin refilled the vault,
unpaused it and moved the deadline. No other zkPass contract was checked.

## Remediation

- Nothing is exposed while the vault stays empty and paused. If zkPass reuses it, the admin EOA
  `0x182085ce8b0faddc8503d9921df6af076281a6a9` should upgrade the implementation to verify claims against a Merkle
  root or a post-quantum supervisor signature (an ERC-7913 verifier), and move the admin and supervisor roles to
  post-quantum accounts; rotating the supervisor's ECDSA key does not help.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review00): MEDIUM -> LOW, step 5: the vault is empty (claim deadline passed 2026-01-18, paused
  2026-01-20, balance withdrawn 2026-01-28), so USD 0 is exposed. Project identified as zkPass (token
  `0xe1be424f…`, ZKP); `project` zkp-token -> zkpass; implementation found verified on Blockscout, so `evidence.level`
  bytecode -> source-read and status candidate -> confirmed; admin and supervisor read from storage and logs.
