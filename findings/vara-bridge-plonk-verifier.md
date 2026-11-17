---
id: vara-bridge-plonk-verifier
title: "Vara (Gear) Ethereum bridge: a quantum attacker who recovers the gnark PLONK setup trapdoor can submit a false Vara Merkle root to MessageQueue and release the bridge's tokens or mint WVARA (about USD 150 bridged today)"
project: vara
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xb7142e82ceead0df5d0b3507240a503e99e1881e"
  implementation: null
  name: VerifierMainnet (current verifier of MessageQueue 0x8e01fbf1…)
  upgradeable: "no"
  admin: "none; MessageQueue proxy 0x8e01fbf136ca97627ca241db9eff1dfe3f2195f6 is upgraded by GovernanceAdmin 0x3681a3e25f5652389b8f52504d517e96352830c3 on bridged Vara governance messages"
  value_usd: 152
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-19
  txs_30d: null
- address: "0xddaac7f0814368d58d40216c6391a5e40a8cd47e"
  implementation: null
  name: Verifier (gnark Plonk; retired)
  upgradeable: "no"
  admin: none; no longer referenced by MessageQueue
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-05
  txs_30d: 0
- address: "0xface08781c083588ef0569ec1b497aab67b2a18f"
  implementation: null
  name: VerifierMainnet (retired)
  upgradeable: "no"
  admin: none; no longer referenced by MessageQueue
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-02
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Gear / Vara governance: a Vara governance message executed by GovernanceAdmin 0x3681a3e25f5652389b8f52504d517e96352830c3 upgrades MessageQueue 0x8e01fbf136ca97627ca241db9eff1dfe3f2195f6 to a post-quantum verifier; the emergency-stop observers and admin 0x2c25f37f170ac053a8e04a4e319b5f579b869a7f can halt root submission meanwhile"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/vara-bridge-plonk-verifier/classification.jsonl
  - evidence/vara-bridge-plonk-verifier/onchain.json
  - evidence/vara-bridge-plonk-verifier/activity.json
  - evidence/vara-bridge-plonk-verifier/source-excerpts.md
  - evidence/vara-bridge-plonk-verifier/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review13 (MessageQueue source on Blockscout; queue, governance and escrow reads)
  ref: evidence/vara-bridge-plonk-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

The Vara–Ethereum bridge's MessageQueue accepts a Vara block's message Merkle root only with a gnark PLONK proof checked
over BN254 by its verifier contract (PQ-7). A quantum attacker who recovers the setup trapdoor can prove a false root,
then call `processMessage` with forged messages: release whatever the bridge's ERC20Manager holds, mint Wrapped Vara,
or deliver forged governance messages (including a MessageQueue upgrade). Today that releases about USD 152 (USD 12 of
USDT/USDC in the ERC20Manager and 346,624 WVARA at USD 0.0004). Rated LOW: MEDIUM by step 4 (the queue is upgradeable
through Vara governance), lowered one level by step 5 (measured exposure under USD 50k). The draft listed two retired
verifiers and missed the current one, `0xb7142e82…`, which is added here.

## Mechanism

- `MessageQueue.submitMerkleRoot(blockNumber, merkleRoot, proof)` (`src/MessageQueue.sol` 287-…, anyone may call)
  packs the root and block number into two public inputs (lines 315-318) and requires
  `_verifier.safeVerifyProof(proof, publicInputs)` (line 320); the verifier (`src/VerifierMainnet.sol` 16-21) calls the
  gnark `PlonkVerifierMainnet.verifyProof`, a PLONK check with BN254 `ecadd`/`ecmul`/`ecpairing`.
- `processMessage(blockNumber, totalLeaves, leafIndex, message, proof)` (lines 406-466) looks up the stored root,
  waits 5 minutes (1 hour for admin messages), verifies a binary Merkle proof of the message and calls
  `IMessageHandler(message.destination).handleMessage(source, payload)`: ERC20Manager releases or mints tokens; the
  GovernanceAdmin contract executes admin messages.
- `_verifier` is set at initialisation; changing it needs a MessageQueue upgrade (`_authorizeUpgrade`,
  `onlyRole(DEFAULT_ADMIN_ROLE)`, line 204; the role is held by GovernanceAdmin).
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/vara-bridge-plonk-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source): verifiers on Sourcify (excerpts); MessageQueue implementation `0xadf9f599…` on Blockscout,
  lines as above.
- CHECKED (on-chain, block 26,431,661, [`escrow.json`](../evidence/vara-bridge-plonk-verifier/escrow.json)):
  MessageQueue proxy `0x8e01fbf1…` `verifier()` = `0xb7142e82…` (VerifierMainnet, created by the same deployer
  `0xa301086b…` as the two drafted verifiers); `governanceAdmin()` = `0x3681a3e2…`; emergency-stop admin and three
  observers set; not paused. ERC20Manager proxy `0x16fcff97…` (`messageQueue()` = `0x8e01fbf1…`) holds 0 ETH,
  11.05 USDT and 1.00 USDC; WrappedVara `0xb67010f2…` total supply 346,624 WVARA. VARA price USD 0.00040305
  (CoinGecko, 2026-11-17).
- CHECKED (Blockscout): last `submitMerkleRoot` 2026-10-19 (block 26,230,060), last `processMessage` 2026-10-20; since
  2026-10-29 an emergency-stop observer has called `challengeRoot` repeatedly.
- CHECKED (precompile trace, 12 months to March 2026): `ecpairing` in 327 transactions through `0xddaac7f0…` (to block
  23,947,953), 293 through `0xface0878…` (to 24,370,938) and 71 through `0xb7142e82…` (from 24,371,808): each replaced
  the previous one.
- CHECKED (on-chain, holdings at block 26,431,214): the verifiers hold nothing
  ([`onchain.json`](../evidence/vara-bridge-plonk-verifier/onchain.json)).
- INFERRED: the Vara-side lock of VARA backing WVARA is bounded by the WVARA supply.

## Impact and exposure

| Contract | Upgradeable | Exposed | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb7142e82…` VerifierMainnet (current) | no (queue upgradeable) | USD 152 (escrow) | 2026-10-19 | not measured |
| `0xddaac7f0…` Verifier (retired) | no | — | 2025-12-05 | 0 |
| `0xface0878…` VerifierMainnet (retired) | no | — | 2026-02-02 | 0 |

Escrow: ERC20Manager `0x16fcff97822fcf3345fa76d29c229b11c49eae12` (USD 12) plus the WVARA that forged messages could
mint and redeem (346,624 WVARA, USD 140). Siblings: on 2026-11-13 the same deployer created a second bridge stack
(MessageQueue `0xae4211017688cb681cb04796a47a528509bd29ec` with `VaraQueueRootVerifier` `0xf1ab01cc…` and
`BeefyClient` contracts, ERC20Manager `0x53654aec…` holding nothing); it uses a different verifier and is not part of
this finding or the registry yet.

## Remediation

- Post-quantum replacement: a hash-based (STARK/FRI) proof of Vara finality and of the queue root; the finality
  statement itself (GRANDPA ed25519 validator signatures) also needs a post-quantum scheme on the Vara side.
- Who acts: Vara governance sends an upgrade message that GovernanceAdmin `0x3681a3e2…` executes on MessageQueue.
  The emergency-stop observers (`challengeRoot`) and admin `0x2c25f37f…` can halt root submission without an upgrade.
  The retired verifiers need nothing.
- No Ethereum protocol change needed. Holders can bridge WVARA back and withdraw ERC20Manager balances.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review13): MEDIUM -> LOW, step 5: MEDIUM by step 4 (MessageQueue upgrade through Vara governance) and the measured escrow is USD 152 (ERC20Manager plus WVARA supply), under USD 50k. Added the current verifier `0xb7142e82…`; marked the two drafted verifiers retired; `fix.layer` onchain-config -> contract-upgrade.
