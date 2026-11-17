---
id: hyperlane-multisig-ism-validators
title: "Hyperlane on Ethereum: a quantum attacker who recovers a validator quorum's ECDSA keys (2 to 4 keys per origin chain) can forge inbound messages that every app on the Mailbox default ISM accepts, through 136 multisig ISM clones covering 68 origin chains"
project: hyperlane
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xeb2a48ddc7d660ffb79a71b201cb6fd8daba850f"
  implementation: "0x5371942d3ed75b10d77f0f4184ddc85cc35a1420"
  name: StaticMessageIdMultisigIsm (meta-proxy, 3 of 5, Base origin 8453; live under the default ISM)
  upgradeable: "no"
  admin: none (validators and threshold are immutable args); routing ISM 0xb9343ec5ca3e46cd47a0fb7122d733a15e88c72a and Mailbox owned by Safe 0x562dfaac27a84be6c96273f5c9594da1681c0da7
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: null
- address: "0x5eb42b1b45c70b56a4d5f4d7cd874b5863933bd5"
  implementation: "0xd4dacca08737d2a910b4ad401f805f83d0c170f3"
  name: StaticMerkleRootMultisigIsm (meta-proxy, 3 of 5, Base origin 8453; live under the default ISM)
  upgradeable: "no"
  admin: none (validators and threshold are immutable args); routing ISM 0xb9343ec5ca3e46cd47a0fb7122d733a15e88c72a and Mailbox owned by Safe 0x562dfaac27a84be6c96273f5c9594da1681c0da7
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: null
- address: "0x5bdfda33f5a1f81b6a526aeb2fc413a6523a116d"
  implementation: "0x5371942d3ed75b10d77f0f4184ddc85cc35a1420"
  name: StaticMessageIdMultisigIsm (meta-proxy, 3 of 5, Base origin; retired from the default ISM at block 25,991,130)
  upgradeable: "no"
  admin: none (validators and threshold are immutable args); no longer referenced by the default ISM
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-09-16
  txs_30d: 0
- address: "0x572c56742bf8bc6629b85f24db40070e4d1b71b8"
  implementation: "0x5371942d3ed75b10d77f0f4184ddc85cc35a1420"
  name: StaticMessageIdMultisigIsm (meta-proxy, 4 of 6, Superseed origin; retired from the default ISM at block 25,991,130)
  upgradeable: "no"
  admin: none (validators and threshold are immutable args); no longer referenced by the default ISM
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-09-01
  txs_30d: 0
families:
- code: "0x5371942d3ed75b10d77f0f4184ddc85cc35a1420"
  name: StaticMessageIdMultisigIsm meta-proxies under routing ISM 0xb9343ec5… (one per origin chain; the Base one is listed above)
  instances: 67
  list: evidence/hyperlane-multisig-ism-validators/live-isms.json
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0xd4dacca08737d2a910b4ad401f805f83d0c170f3"
  name: StaticMerkleRootMultisigIsm meta-proxies under routing ISM 0xb9343ec5… (one per origin chain; the Base one is listed above)
  instances: 67
  list: evidence/hyperlane-multisig-ism-validators/live-isms.json
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: onchain-config
  who_acts: Hyperlane Mailbox and routing-ISM owner Safe 0x562dfaac27a84be6c96273f5c9594da1681c0da7 (6 of 10) points the default ISM (or each origin's routing entry) at a post-quantum ISM; the validators of all 68 origin chains (74 distinct validator keys) must sign with post-quantum keys; apps with their own ISM repoint it
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/hyperlane-multisig-ism-validators/classification.jsonl
  - evidence/hyperlane-multisig-ism-validators/onchain.json
  - evidence/hyperlane-multisig-ism-validators/activity.json
  - evidence/hyperlane-multisig-ism-validators/source-excerpts.md
  - evidence/hyperlane-multisig-ism-validators/notes.md
  - evidence/hyperlane-multisig-ism-validators/live-isms.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (implementation sources from Sourcify, full read of the live default-ISM tree, historical default ISM reads, Mailbox Process events)
  ref: evidence/hyperlane-multisig-ism-validators/live-isms.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Every Hyperlane message delivered on Ethereum to an app that uses the Mailbox default ISM is accepted when, for its
origin chain, either a merkle-root or a message-id multisig ISM clone finds a threshold of ECDSA validator signatures
(2 of 2 up to 4 of 6). The default ISM routes 68 origin chains to 136 such clones that cannot be changed. A quantum
attacker who derives one origin's quorum of validator keys (they sign checkpoints publicly) can forge messages from
that chain, minting synthetic tokens, releasing collateral or proving intents to every default-ISM app. The Mailbox
delivered 154 messages in about 6.5 hours on 2026-11-16, 97 of them to default-ISM apps. The value those apps hold
or can mint was not measured. Rated MEDIUM (step 4): one Hyperlane Safe can switch the ISM, but the 74 validator keys
behind it must also move to post-quantum signatures, which takes several parties.

## Mechanism

- `Mailbox.process(metadata, message)` on `0xc005dc82818d67af737725bd4bf75435d065d239` calls
  `recipientIsm(recipient).verify(metadata, message)`; for apps without their own ISM this is the default ISM
  `0xb05bbc47…`. That is an aggregation of a pausable module `0xcb6e681c…` and routing ISM `0xb9343ec5…` (both
  required). The routing ISM picks, per origin domain, an aggregation ISM that needs 1 of 2: a
  `StaticMerkleRootMultisigIsm` clone or a `StaticMessageIdMultisigIsm` clone, both with the same validators.
- Both clone types are EIP-3448 meta-proxies (immutable args = validators, threshold) of verified implementations
  `0xd4dacca0…` and `0x5371942d…`. `AbstractMultisigIsm.verify` (line 71) runs
  `ECDSA.recover(_digest, signatureAt(_metadata, i))` for `threshold` signatures (line 87) and requires signers in
  validator order (line 96). The digest commits to the origin merkle-tree hook, checkpoint root and index, and the
  message id (or a merkle proof of it).
- Pattern PQ-5. Details: [`notes.md`](../evidence/hyperlane-multisig-ism-validators/notes.md); the live tree:
  [`live-isms.json`](../evidence/hyperlane-multisig-ism-validators/live-isms.json).

## Evidence

- CHECKED (Sourcify): `0x5371942d…` = `StaticMessageIdMultisigIsm`, `0xd4dacca0…` = `StaticMerkleRootMultisigIsm`
  (`contracts/isms/multisig/StaticMultisigIsm.sol`); `AbstractMultisigIsm.verify` as above.
- CHECKED (`eth_call`, block 26,431,755): routing ISM `0xb9343ec5…` `domains()` lists 68 origin domains. Each maps to an
  aggregation ISM of threshold 1 over one merkle-root and one message-id clone with identical validators. That gives
  136 clones in total, all meta-proxies of the two implementations above. Thresholds/validator counts: 2/2 (25 origins),
  2/3 (14), 3/5 (12), 3/4 (9), 4/6 (7), 3/3 (1); 74 distinct validator addresses.
- CHECKED (`cast`): Mailbox `defaultIsm()` = `0xb05bbc47…` since block 25,991,130 (2026-09-16); before that it was
  `0x7e1cdfb6…`, which routed Base to `0x5bdfda33…` and Superseed to `0x572c5674…` (both now retired; Superseed has
  no route). `Mailbox.owner()` and routing ISM `owner()` = Safe `0x562dfaac…` (6 of 10); pausable module owner EOA
  `0x60cc386c…`, `paused()` false.
- CHECKED (Blockscout Mailbox logs, blocks 26,424,299–26,426,223, 2026-11-16 01:29–07:54 UTC): 154 `Process`
  events. 97 of them went to recipients whose `recipientIsm` is the default ISM: HyperProver `0xec08fb46…`,
  HyperlaneAdapter `0x4aaff8cf…`, HypERC20Pausable `0xc210b2cb…`, HypFiatToken `0x94a766eb…` and HypERC20Collateral
  `0x7e5db36f…`. Their origins were Arbitrum (34), Polygon (31), Base (23) and 4 others.
- CHECKED (Xatu, old clones): last calls 2026-09-16 and 2026-09-01; none in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/hyperlane-multisig-ism-validators/activity.json)). The 30-day call counts of the
  live clones were not measured (they are not in the activity scan).
- INFERRED: apps with their own ISM (for example `CrossCollateralRouter` `0xeb1b48b2…`, `HypNative` `0x95abf44e…`)
  likely use other multisig ISM clones; they were not enumerated.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xeb2a48dd…` message-id ISM (3 of 5, Base) | no | default-ISM apps, not measured | 2026-11-16 | not measured |
| `0x5eb42b1b…` merkle-root ISM (3 of 5, Base) | no | default-ISM apps, not measured | 2026-11-16 | not measured |
| 67 + 67 clones for the other origins (families) | no | default-ISM apps, not measured | — | — |
| `0x5bdfda33…` (retired) | no | none since 2026-09-16 | 2026-09-16 | 0 |
| `0x572c5674…` (retired) | no | none since 2026-09-16 | 2026-09-01 | 0 |

What a forged message releases depends on the default-ISM apps: collateral routes hold tokens (for example
`HypERC20Collateral` `0x7e5db36f…` holds 9,883.5 USDC), synthetic routes (`HypERC20Pausable`, `HypFiatToken`) mint
tokens, and `HyperProver` `0xec08fb46…` (`PORTAL()` = Eco `Portal` `0xec000769…`) proves intent fulfilment, which
INFERRED lets the intent's reward be withdrawn (the Portal itself holds nothing). The full set of default-ISM apps and their value was not measured,
so `value_usd` stays null and the value step lowers nothing.

## Remediation

- Hyperlane: deploy an ISM that verifies post-quantum validator signatures (hash-based or lattice signatures, or a
  STARK proof over them). Then have Safe `0x562dfaac27a84be6c96273f5c9594da1681c0da7` set it as the default ISM or
  as the per-origin entries of routing ISM `0xb9343ec5…`. The 2026-09-16 switch shows this path works.
- The validators of every origin chain (74 keys across 68 chains) must generate and sign with post-quantum keys.
  Replacing ECDSA validators does not help.
- Apps with their own ISM (warp route owners) must repoint it.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. Confirmed clones and validator sets; found both clones were
  retired from the Mailbox default ISM at block 25,991,130 in favour of same-code successors; admin set to the
  Mailbox owner Safe. Exposure behind the current default ISM not measured.
- 2026-11-17 review (Review18, follow-up): added the live default-ISM tree: the Base pair `0xeb2a48dd…` /
  `0x5eb42b1b…` as contracts and the other 134 clones (68 origins) as two families. Old clones marked retired.
  Re-rated MEDIUM -> MEDIUM, step 4: one Safe switches the ISM, but 74 validator keys must also move (several
  parties). Value not measured (step 5 lowers nothing).
