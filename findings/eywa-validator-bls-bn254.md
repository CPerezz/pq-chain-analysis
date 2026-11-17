---
id: eywa-validator-bls-bn254
title: "EYWA: a quantum attacker who forges the 21-member BN254 BLS epoch committee (BridgeV3, formerly BridgeV2) can unlock EYWA PortalV2's escrow on Ethereum (about USD 2k)"
project: eywa
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xece9cf6a8f2768a3b8b65060925b646afeaa5167"
  implementation: null
  name: BridgeV2
  upgradeable: config-only
  admin: "DEFAULT_ADMIN_ROLE Safe 0x31bbfa956c5b5fae168990b0df61d569dad05b1f (1 of 3); OPERATOR_ROLE EOAs 0x117274dde02bc94006185af87d78beab28ceae06, 0xc9049154314edfc34f0c9686c03e60cd1ce5244b (setState); VALIDATOR_ROLE EOA 0x94a365ca808029af8db18257ecd296c16c61ac05 (receiveV2, updateEpoch)"
  value_usd: 1996
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-12-25
  txs_30d: 0
- address: "0x9291c5586217348542720c5fb1028c9c976c7b50"
  implementation: null
  name: BridgeV3
  upgradeable: config-only
  admin: "DEFAULT_ADMIN_ROLE EOA 0x624e0bd3114e333375f10883b0d7621547939cd5; OPERATOR_ROLE EOAs 0xf8e3961792c0a9d8bff4aac772ef35edde700416, 0x6f4cee4154513a6677effbc4261b0d935c68bdba (setReceiver, setState); VALIDATOR_ROLE EOA 0xa7a8f525d4f9c8150079dd2218c63241a7724674 (receiveV3, updateEpoch)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-21
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "EYWA admin EOA 0x624e0bd3114e333375f10883b0d7621547939cd5 (DEFAULT_ADMIN_ROLE of Receiver 0x53173e5803be85bc81e47ea1d917783eacefae26 and BridgeV3, owner of PortalV2 0xac8f44ceca92b2a4b30360e5bd3043850a0ffcbe): revoke BridgeV3's RECEIVER_ROLE or replace it with a post-quantum bridge; BridgeV2 Safe 0x31bbfa956c5b5fae168990b0df61d569dad05b1f can revoke BridgeV2's VALIDATOR_ROLE"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/eywa-validator-bls-bn254/classification.jsonl
  - evidence/eywa-validator-bls-bn254/onchain.json
  - evidence/eywa-validator-bls-bn254/activity.json
  - evidence/eywa-validator-bls-bn254/source-excerpts.md
  - evidence/eywa-validator-bls-bn254/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review16 (verified source of BridgeV2, BridgeV3, Receiver, UnifiedRouterV2, PortalV2; on-chain reads at block 26,431,537)
  ref: evidence/eywa-validator-bls-bn254/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

EYWA's cross-chain messages into Ethereum are accepted when a 21-member committee's aggregate BN254 BLS signature
over an EYWA-chain block header verifies against the stored epoch key (PQ-6). A quantum attacker who recovers the
committee's BLS secret keys (and the ECDSA key of the single relayer EOA that holds `VALIDATOR_ROLE`) can forge a
block with an unlock request and drain EYWA PortalV2 `0xac8f44ce…`, which holds about USD 2.0k of tokens
(2026-11-17), or mint any amount of EYWA's nine synthetic tokens through SynthesisV2, which have no price or market on
Ethereum (USD 0 measured). The live path is BridgeV3 `0x9291c558…`; the registry's BridgeV2 `0xece9cf6a…` is still
active on-chain but its router is paused and PortalV2 no longer accepts it. Rated LOW: the fix is a new bridge the
admin points the Receiver at (MEDIUM, step 4), lowered one level because under USD 50k is exposed on Ethereum (step 5).

## Mechanism

- BridgeV2 `receiveV2(ReceiveParams[])` (`onlyRole(VALIDATOR_ROLE)`, `contracts/bridge/BridgeV2.sol` lines 150–199)
  picks the current or previous epoch by `Block.epochHash(blockHeader)`, calls `verifyEpoch` → `Block.verify`
  (`contracts/utils/Block.sol` lines 45–58: more than 2/3 of `participantsCount` bits set in `votersMask`) →
  `Bls.verifyMultisig` (`contracts/utils/Bls.sol` lines 113–144): hash-to-curve on G1 via `modexp`, then a three-pair
  BN254 pairing check (precompile `0x08`, lines 190–217) against the epoch's aggregate G2 public key. It then proves
  the request transaction into the header's tx root (`Merkle.prove`), decodes `(requestId, data, to, chainIdTo)`,
  and calls `to.functionCall(check)` and `to.functionCall(data)`. In practice `to` was UnifiedRouterV2
  `0xa2a786ff…`, whose `receiveValidatedData`/`resume` (`onlyBridge`) run `PortalV2.unlock` or SynthesisV2 minting.
- BridgeV3 `receiveV3` (same `Block`/`Bls` libraries, same epoch logic) forwards the decoded payload to
  Receiver `0x53173e58…` `receiveData`/`receiveHash`. Receiver counts confirmations from its `RECEIVER_ROLE`
  bridges (BridgeV3, ReceiverLZ `0x0e46c66c…`, ReceiverAxelar `0xdf7eb07e…`); once the per-route threshold is met,
  anyone can call `execute`, which calls the target (Diamond router `0x50e95f8c…`), which calls
  `PortalV2.unlock` (`onlyRouter`: `AddressBook(0x9949ced5…).router(1)`) or SynthesisV2.
- Epoch keys rotate through `updateEpoch` (VALIDATOR_ROLE), which checks the new epoch announcement with the current
  epoch's BLS signature. The scheme is fixed in immutable code; only keys rotate.

Pattern PQ-6. Source excerpts: [`source-excerpts.md`](../evidence/eywa-validator-bls-bn254/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify full match for BridgeV2 `0xece9cf6a…`, Blockscout for BridgeV3, Receiver,
  UnifiedRouterV2, PortalV2): the code path above.
- CHECKED (precompile trace, all mainnet transactions to March 2026): BridgeV2 uses bn254 and sw_bn254
  (`txs_y1` 2,592 in `data/report/curated_contracts.csv`). BridgeV3 was not in the classified set; its use of the same
  `Bls.sol` was read in source (INFERRED same primitives).
- CHECKED (eth_call at block 26,431,537): BridgeV2 `state()` = 0 (Active), version 2.2.3, current epoch 303 with 21
  participants; roles as in the header; admin Safe `0x31bbfa95…` threshold 1 of 3 owners. BridgeV3 `state()` = 0,
  current epoch 23 with 21 participants, `receiver()` = Receiver `0x53173e58…`, roles as in the header. All role
  holders except the Safe have no code (EOAs).
- CHECKED (eth_call at block 26,431,537): Receiver `RECEIVER_ROLE` = BridgeV3, ReceiverLZ, ReceiverAxelar;
  `receiversCount` 3; all four configured thresholds are 1, including `getThreshold(Diamond, Diamond, 43114)` and
  `(…, 250)`, so BridgeV3 alone can trigger `execute`. Receiver not paused; DEFAULT_ADMIN_ROLE EOA `0x624e0bd3…`.
- CHECKED (eth_call at block 26,431,537): PortalV2 `addressBook()` = `0x9949ced5…`, whose `router(1)` is the Diamond
  `0x50e95f8c…`; the old AddressBook `0x78c97302…` (bridge = BridgeV2, router = UnifiedRouterV2) is no longer used by
  PortalV2 or SynthesisV2; UnifiedRouterV2 `paused()` = true. PortalV2 `owner()` = EOA `0x624e0bd3…`, which switched
  the AddressBook on 2025-12-27 (block 24,104,883, tx `0x8c564ea7…`).
- CHECKED (Blockscout transaction lists, read 2026-11-17): BridgeV2 91 `receiveV2` transactions since 2025-11-17,
  last on 2025-12-25 (block 24,087,519; it unlocked CRV from PortalV2 via UnifiedRouterV2). BridgeV3 175 transactions
  since 2025-11-17 (114 `receiveV3`, 29 `updateEpoch`, the rest operator/admin calls), last on 2026-06-21 (block 25,364,580);
  PortalV2's last unlock via Receiver/Diamond was tx `0x7deb0bec…` (block 25,364,582). No transactions in the
  2026-10-16 to 2026-11-16 window for either bridge.
- CHECKED (Blockscout token balances, `exchange_rate` per token, read 2026-11-17): PortalV2 holds DAI 844.30,
  USDC 626.23, TUSD 526.21 and dust = USD 1,996 priced, no ETH; plus unpriced Curve LP tokens crvUSDUSDT-f 312.32
  and crvUSDUSDC-f 77.63 (about USD 390 if near USD 1 each, INFERRED). SynthesisV2, Diamond, Receiver,
  UnifiedRouterV2 hold nothing. Reads: [`escrow.json`](../evidence/eywa-validator-bls-bn254/escrow.json).
- CHECKED (all SynthesisV2 logs from Blockscout; eth_call at block 26,431,656): 9 `SynthRegistered` synths (uniUSD,
  WXFI, XUSD, wuWBTC, wuUSDT, uUSDT, uUSDC, WUNIT0, rEYWA; origins EYWA chain 88811, CrossFi 4158, Arbitrum 42161).
  `cap()` is 2^256−1 for eight of them and 1e26 for rEYWA, so a forged `mint`/`emergencyMint` (`onlyRouter` = Diamond)
  can mint any amount. Supply now: 2,500 WUNIT0 (one EOA holder), 0.589 uUSDT (two EYWA fee contracts), the other
  seven 0. None has a Blockscout `exchange_rate` and no DEX pool holds any of them, so they cannot be sold on Ethereum.
- CHECKED (Diamond facets, verified source on Blockscout): Core, Curve, OFT, Bungee, Rubic, Runner, Crosschain;
  apart from Portal unlock and Synthesis mint, these ops spend funds the Diamond holds (none at block 26,431,537) or
  funds in flight within one user operation. Runner collection needs a flag set in `resumeRC` (ACCOUNTANT_ROLE), not
  from the bridge (INFERRED from source).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xece9cf6a…` BridgeV2 | config-only | escrow USD 1,996 (PortalV2, shared with BridgeV3; reachable again only if the admin repoints PortalV2) | 2025-12-25 | 0 |
| `0x9291c558…` BridgeV3 | config-only | same PortalV2 escrow, reachable now | 2026-06-21 | 0 |

- Escrow: EYWA PortalV2 `0xac8f44ceca92b2a4b30360e5bd3043850a0ffcbe`, USD 1,996 priced (2026-11-17, block
  26,431,537), counted once on the BridgeV2 entry.
- Synthetic tokens: a forged message can mint unlimited amounts of the nine SynthesisV2 synths, but none has a price
  or liquidity on Ethereum (USD 0 measured, block 26,431,656). Burning them through the router sends unlock requests
  to their origin chains (EYWA chain, CrossFi, Arbitrum); those requests pass through EYWA's committee on that chain,
  so the cross-chain value belongs to EYWA's portals there and is outside this mainnet registry.
- Through BridgeV2 today: UnifiedRouterV2 is paused and PortalV2/SynthesisV2 point at a different router, so a forged
  BridgeV2 message reaches no funds unless the EOA `0x624e0bd3…` reverses those settings.
- The same EOA `0x624e0bd3…` alone controls Receiver, BridgeV3 and PortalV2; it is itself an ECDSA key with on-chain
  transactions (outside this finding's mechanism).

## Remediation

- Replace the BN254 BLS epoch committee with a post-quantum scheme (hash-based threshold signatures or a STARK proof
  of the EYWA chain's consensus) in a new bridge contract, then grant it `RECEIVER_ROLE` in Receiver and revoke
  BridgeV3's (admin EOA `0x624e0bd3114e333375f10883b0d7621547939cd5`). Raising the Receiver thresholds to require
  ReceiverLZ/ReceiverAxelar in addition only helps if those verify post-quantum.
- BridgeV2: its Safe `0x31bbfa956c5b5fae168990b0df61d569dad05b1f` (1 of 3) can revoke `VALIDATOR_ROLE` or an
  operator can `setState(Inactive)`, closing it for good.
- Move the admin, operator and validator roles from EOAs to post-quantum accounts.
- No protocol change is needed. Users can only avoid leaving tokens in PortalV2.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> LOW, step 5: whole Ethereum exposure measured: escrow PortalV2 `0xac8f44ce…` USD 1,996 at block 26,431,537, and SynthesisV2 synths mintable without limit but priced at USD 0 on Ethereum (no rate, no pool; block 26,431,656), Diamond holds nothing; added BridgeV3 `0x9291c558…`, the live successor with the same BLS check (BridgeV2's router is paused and PortalV2 moved to a new AddressBook on 2025-12-27); admin corrected from "AccessControl admin" to the role holders read on-chain; alternative changed to configurable-verifier (Receiver chooses its bridges).
