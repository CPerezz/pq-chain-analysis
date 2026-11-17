---
id: socket-dl-signature-verifier
title: "Socket DL (Socket/Bungee): with forged transmitter and executor ECDSA keys, a quantum attacker can deliver fake cross-chain messages to Socket plugs on Ethereum and release the USD 5.6M held in their token vaults; watchers' ECDSA trips are the only brake"
project: socket
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98"
  implementation: null
  name: SignatureVerifier
  upgradeable: "no"
  admin: "none on the verifier; TransmitManager 0xed037afbffc65a94e9cc592947e851fb2f730341 can repoint (setSignatureVerifier); FastSwitchboard and ExecutionManagerDF hold it immutably; all owned by Socket Safe 0xeef6520437a6545b4f325f6675c4cd49812d457b (2 of 3)"
  value_usd: 5589023
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 2171
families: []
fix:
  layer: new-deployment
  who_acts: "Socket Safe 0xeef6520437a6545b4f325f6675c4cd49812d457b (2 of 3) sets a post-quantum verifier on TransmitManager, deploys a new FastSwitchboard and ExecutionManager and sets the latter on Socket 0x943ac2775928318653e91d350574436a1b9b16f9; every plug owner (mostly EOA 0xb0bbff6311b7f245761a7846d3ce7b1b100c1836, also others such as 0x3b88d6a4ccbd93c22c211c7f6e3ea8b1d30f81bf) reconnects its plug to the new switchboard"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/socket-dl-signature-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/socket-dl-signature-verifier.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [bungee-auction-signers]
---

## Summary

Every signature in Socket's messaging layer (Socket DL) on Ethereum, from transmitters, watchers, executors and fee
updaters, is checked by `SignatureVerifier.recoverSigner`, a plain `ECDSA.recover` (PQ-5). A quantum attacker who
recovers one transmitter key and one executor key can propose a fake packet root and, once the FastSwitchboard's
2-hour timeout passes without a watcher trip, execute fake inbound messages on Socket plugs; the token vaults behind
those plugs held USD 5.59M on 2026-11-17. Fixing it needs Socket's 2-of-3 Safe to replace the verifier, the switchboard
and the execution manager, and every plug owner to reconnect. Rated MEDIUM (step 4: new deployments and several
parties acting; exposure above USD 50k).

## Mechanism

- `SignatureVerifier.recoverSigner(digest, sig)` (`contracts/utils/SignatureVerifier.sol` 35–44) returns
  `ECDSA.recover(eth_sign(digest), sig)`; callers check the role of the returned address.
- Socket `proposeForSwitchboard` -> `TransmitManager.checkTransmitter` (`TransmitManager.sol` 82): transmitter
  signature over the packet root, `TRANSMITTER_ROLE` per source chain.
- `FastSwitchboard.attest` (`FastSwitchboard.sol` 108): watcher signatures; `allowPacket` is true when attestations
  reach `totalWatchers`, **or when `block.timestamp - proposeTime > timeoutInSeconds` (7,200 s)** unless a watcher
  (again by signature, `SwitchboardBase.sol` 165–305) trips the path or proposal.
- Socket `execute` -> `ExecutionManager.isExecutor` (`ExecutionManager.sol` 193): executor signature,
  `EXECUTOR_ROLE`; then the plug's `inbound` runs, and a Vault releases tokens to the message's receiver.

Forging a transmitter and an executor key therefore suffices if no honest watcher trips within 2 hours; forging the
watcher set removes that brake. Pattern PQ-5. Excerpt:
[`source-excerpts.md`](#source-excerpts-socket-dl-signature-verifier).

## Evidence

- CHECKED (verified source, Sourcify, Socket, TransmitManager, FastSwitchboard, ExecutionManager): the paths above;
  `signatureVerifier__` is settable only in TransmitManager (`setSignatureVerifier`, 151–156) and immutable in
  `SwitchboardBase` and `ExecutionManager`; Socket `setTransmitManager`/`setExecutionManager` need `GOVERNANCE_ROLE`.
- CHECKED (block 26,431,597, [`notes.md`](#review-notes-review15-2026-11-17)): Socket uses
  TransmitManager `0xed03…0341` and ExecutionManagerDF `0x98ca…e57c`; TransmitManager, FastSwitchboard and
  ExecutionManagerDF all use `0xf1ab…af98`; their owner is Safe `0xeef6…457b` (2 of 3), which holds
  `GOVERNANCE_ROLE`; FastSwitchboard `timeoutInSeconds() = 7200`.
- CHECKED (Blockscout `PlugConnected` logs and holdings, block 26,431,564, [`plugs.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/socket-dl-signature-verifier/plugs.json),
  [`escrow-hubs.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/socket-dl-signature-verifier/escrow-hubs.json)): 159 plugs, 242 of 249 connections
  inbound through the FastSwitchboard; the 123 vaults/controllers behind them hold USD 5,589,023.
- CHECKED (precompile trace to March 2026): `ecrecover`, 56,706 pre-quantum calls in the last year (USD 334M moved
  in those transactions; `curated_contracts.csv`).
- CHECKED (Xatu, any function): 2,171 transactions 2026-10-16 to 2026-11-16 called the verifier; last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/socket-dl-signature-verifier/activity.json)).
- INFERRED: transmitter and executor keys have signed on-chain (their signatures are in calldata), so their public
  keys are known.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf1abf110…` SignatureVerifier | no (repointable only in TransmitManager) | USD 5.59M (escrow: Socket plug vaults) | 2026-11-15 | 2,171 |

Escrow: Vault `0x5f3b301b4967623fdb3ae52bb8ff4db01c460cd3` (sUSDe, USD 3.60M), Vault
`0xdff78a949e47c1e90f3dd6dd7fe2fa72b42a75f7` (USDC, USD 1.61M), and smaller WETH, WBTC and wstETH vaults; total over
123 hubs at block 26,431,564. SuperToken controllers hold nothing; what a forged message could mint there is not
counted. Bungee auction settlement also rides on Socket DL messages (see
[`bungee-auction-signers`](bungee-auction-signers.md)).

## Remediation

- Socket deploys a post-quantum `ISignatureVerifier` (ERC-7913-style key registry) and sets it on TransmitManager;
  deploys a FastSwitchboard and an ExecutionManager that use it, and sets the latter on Socket
  (`setExecutionManager`). Actor: Safe `0xeef6…457b`.
- Each plug owner reconnects its plug (`connect`) to the new switchboard; for the large vaults that is EOA
  `0xb0bbff63…`, for others their own owners.
- Raising the FastSwitchboard timeout or requiring attestations reduces the window but does not remove the ECDSA
  dependency. No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review15): MEDIUM confirmed (step 4: new deployments plus every plug owner reconnecting). Escrow measured (USD 5.59M in 123 plug vaults); fix layer onchain-config -> new-deployment (switchboard and execution manager hold the verifier immutably); linked to bungee-auction-signers.

# Source excerpts: socket-dl-signature-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98` — SignatureVerifier (verified source via sourcify)

### `contracts/utils/SignatureVerifier.sol`

```solidity
    1  // SPDX-License-Identifier: GPL-3.0-only
    2  pragma solidity 0.8.19;
    3  
    4  import "../interfaces/ISignatureVerifier.sol";
    5  import "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
    6  import "../libraries/RescueFundsLib.sol";
    7  import "../utils/AccessControl.sol";
    8  import {RESCUE_ROLE} from "../utils/AccessRoles.sol";
    9  
  ...
   39          bytes32 digest = keccak256(
   40              abi.encodePacked("\x19Ethereum Signed Message:\n32", digest_)
   41          );
   42          // recovered signer is checked for the valid roles later
   43          signer = ECDSA.recover(digest, signature_);
   44      }
   45  
   46      /**
   47       * @notice Rescues funds from the contract if they are locked by mistake.
  ...
```

### `lib/contracts/contracts/tunnel/FxBaseRootTunnel.sol`

```solidity
   99  
  100          bytes32 receiptRoot = payload.getReceiptRoot();
  101          // verify receipt inclusion
  102          require(
  103              MerklePatriciaProof.verify(receipt.toBytes(), branchMaskBytes, payload.getReceiptProof(), receiptRoot),
  104              "FxRootTunnel: INVALID_RECEIPT_PROOF"
  105          );
  106  
  107          // verify checkpoint inclusion
  ...
```

### `lib/solmate/src/tokens/ERC20.sol`

```solidity
  112      /*//////////////////////////////////////////////////////////////
  113                               EIP-2612 LOGIC
  114      //////////////////////////////////////////////////////////////*/
  115  
  116      function permit(
  117          address owner,
  118          address spender,
  119          uint256 value,
  120          uint256 deadline,
  ...
  126  
  127          // Unchecked because the only math done is incrementing
  128          // the owner's nonce which cannot realistically overflow.
  129          unchecked {
  130              address recoveredAddress = ecrecover(
  131                  keccak256(
  132                      abi.encodePacked(
  133                          "\x19\x01",
  134                          DOMAIN_SEPARATOR(),
  ...
```

### `lib/contracts/contracts/lib/MerklePatriciaProof.sol`

```solidity
   11       * @param rlpParentNodes The rlp encoded stack of nodes.
   12       * @param root The root hash of the trie.
   13       * @return The boolean validity of the proof.
   14       */
   15      function verify(
   16          bytes memory value,
   17          bytes memory encodedPath,
   18          bytes memory rlpParentNodes,
   19          bytes32 root
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`

# Review notes (Review15, 2026-11-17)

## Deployment

Socket DL mainnet addresses from `SocketDotTech/socket-DL` `deployments/prod_addresses.json` (key `"1"`):
Socket `0x943ac2775928318653e91d350574436a1b9b16f9`, TransmitManager `0xed037afbffc65a94e9cc592947e851fb2f730341`,
FastSwitchboard `0xd5a83a40f262e2247e6566171f9adc76b745f5cd`, OptimisticSwitchboard
`0xeaa15fd42d68b8334a3bb1e9bf8ca85babe83790`, ExecutionManager `0xfb4dcd94a051a1d2cf3eaf713a2ef686653884e0`,
ExecutionManagerDF `0x98cad9a205f1f7a7150241ef2d565d1702bce57c`, SignatureVerifier
`0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98`, SocketSafeProxy `0xeef6520437a6545b4f325f6675c4cd49812d457b`.

## Reads (RPC publicnode, block 26,431,597)

| Read | Result |
|---|---|
| Socket `owner()` | Safe `0xeef6…457b` (2 of 3: `0xf0e5b92c…`, `0xacee765b…`, `0xb0bbff63…`) |
| Socket `transmitManager__()` | `0xed037afb…` |
| Socket `executionManager__()` | `0x98cad9a2…` (ExecutionManagerDF) |
| TransmitManager `owner()` / `signatureVerifier__()` | Safe `0xeef6…` / `0xf1abf110…` |
| FastSwitchboard `owner()` / `signatureVerifier__()` (immutable) | Safe `0xeef6…` / `0xf1abf110…` |
| FastSwitchboard `timeoutInSeconds()` | 7200 |
| ExecutionManagerDF `owner()` / `signatureVerifier__()` (immutable) | Safe `0xeef6…` / `0xf1abf110…` |
| `hasRole(GOVERNANCE_ROLE, Safe)` on Socket and TransmitManager | true / true |
| Vault `0x5f3b…0cd3`, Vault `0xdff7…75f7`, ConnectorPlug `0x2dba…7d06` `owner()` | EOA `0xb0bbff6311b7f245761a7846d3ce7b1b100c1836` (nonce 910; also a Safe owner) |
| ConnectorPlug `0x4ab7…3660` `owner()` | EOA `0x3b88d6a4ccbd93c22c211c7f6e3ea8b1d30f81bf` |

## Escrow measurement

`plugs.json`: all `PlugConnected` logs of Socket since block 19,398,570 (Blockscout `getLogs`): 253 logs, 159 plugs
(152 ConnectorPlug); inbound switchboard of 242 of 249 connections is the FastSwitchboard.

`escrow-hubs.json`: for each plug, `hub__()` or `bridge__()` (the Vault/Controller behind a ConnectorPlug), then
Blockscout ETH + priced ERC-20 balances of the 123 distinct hubs at block 26,431,564: USD 5,589,023 in total
(Vault `0x5f3b…0cd3` sUSDe 3.60M, Vault `0xdff7…75f7` USDC 1.61M, WETH 148k, WBTC 145k, wstETH 88k). Controllers
(mint/burn SuperTokens) hold nothing; what a forged message could mint on them is not counted. Five plugs exposed
neither getter (`unresolved_plugs`; counters and switchboard plugs) and hold nothing (`plugs.json`).
