---
id: gonka-bridge-bls12-381-group-key
title: "Gonka: a quantum attacker who recovers a BLS12-381 epoch group key can withdraw the USDT/USDC locked in the Ethereum bridge (about USD 884k) and mint unbacked WGNK"
project: gonka
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bls12381]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x972a7a92d92796a98801a8818bcf91f1648f2f68"
  implementation: null
  name: BridgeContract (Wrapped Gonka, WGNK)
  upgradeable: config-only
  admin: owner() Safe 0x1d806d0e3c7df74c14a49d58de98c189614e1768 (2 of 3), only setGroupKey/resetToNormalOperation and only in ADMIN_CONTROL (after 30 days without an epoch key); epoch keys otherwise chained by submitGroupKey; no proxy (read at block 26431539)
  value_usd: 884224
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 843
- address: "0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b"
  implementation: null
  name: Wrapped Gonka (WGNK), earlier bridge deployment, unverified
  upgradeable: config-only
  admin: owner() EOA 0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6, setGroupKey only in ADMIN_CONTROL; no proxy
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-12-05
  txs_30d: 0
- address: "0xab3883735707d751291833ebfa7932c4f60a5821"
  implementation: null
  name: Wrapped Gonka (WGNK), earlier bridge deployment, unverified
  upgradeable: config-only
  admin: owner() EOA 0x5e462df25607418dfdf2f2b54ff3b34f1410fc25, setGroupKey only in ADMIN_CONTROL; no proxy
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-12-03
  txs_30d: 0
- address: "0xef3bba27779c4b08b3b3534407113747d6601180"
  implementation: null
  name: Wrapped Gonka (WGNK), earlier bridge deployment, unverified
  upgradeable: config-only
  admin: owner() EOA 0xce8cad52e9787b13ba41c92ad7e8dcc5921866b4, setGroupKey only in ADMIN_CONTROL; no proxy
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-25
  txs_30d: 0
- address: "0xdcd4cebe3917a8f1728b8af61299085edfd91f44"
  implementation: null
  name: Wrapped Gonka (WGNK), earlier bridge deployment, unverified
  upgradeable: config-only
  admin: owner() EOA 0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6, setGroupKey only in ADMIN_CONTROL; no proxy
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-21
  txs_30d: 0
- address: "0x27261349a8a623b9c798f2ff9388eba22e5b0525"
  implementation: null
  name: Wrapped Gonka (WGNK), earlier bridge deployment, unverified
  upgradeable: config-only
  admin: owner() EOA 0xce8cad52e9787b13ba41c92ad7e8dcc5921866b4, setGroupKey only in ADMIN_CONTROL; no proxy
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-11-21
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Gonka consensus (validator set and chain governance) must deploy a bridge with a post-quantum signature check, sign the migration of the locked ERC-20s to it and stop honouring the old contract; WGNK holders move to the new token. The owner Safe 0x1d806d0e3c7df74c14a49d58de98c189614e1768 cannot change the verification
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gonka-bridge-bls12-381-group-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

Gonka's Ethereum bridge `BridgeContract` (`0x972a7a92…2f68`, which is also the WGNK token) releases locked ERC-20s and
ETH (`withdraw`) and mints WGNK (`mintWithSignature`) on one BLS12-381 signature from the Gonka validator set's epoch
group key, checked with the EIP-2537 pairing precompile (PQ-6). The group public keys are stored on-chain, so a quantum
attacker who recovers the secret of a registered epoch group key can withdraw everything the bridge holds, about
USD 884k (mostly USDT) on 2026-11-17, and mint unbacked WGNK to burn for native GNK on Gonka. The contract has no upgrade
path and its owner cannot change the scheme. Rated MEDIUM (step 4): the fix is a new deployment that Gonka's
consensus migrates the locked funds to; no protocol change is needed.

## Mechanism

- `_verifyBLSSignature` (`bridge-source.md`, line 1730): maps `keccak256(message)` to G1 with `BLS12_MAP_FP_TO_G1`
  (0x10) and checks `e(sig, G2) · e(−H(m), groupKey) = 1` with `BLS12_PAIRING_CHECK` (0x0f).
- `withdraw(WithdrawalCommand)` (line 1449): looks up `epochGroupKeys[cmd.epochId]`, verifies the signature over
  `(epochId, GONKA_CHAIN_ID, requestId, ETHEREUM_CHAIN_ID, WITHDRAW_OPERATION, recipient, bridge, token, amount)` and
  transfers `amount` of `token` (or ETH) to `recipient`. `mintWithSignature(MintCommand)` (line 1513) does the same and
  `_mint`s WGNK.
- Key rotation: `submitGroupKey` (line 1402, anyone) stores epoch n+1's 256-byte G2 key when signed by epoch n's key, so
  a forged key for one epoch also lets the attacker install their own next key. The owner's `setGroupKey` and
  `resetToNormalOperation` (lines 1346, 1381) work only in `ADMIN_CONTROL`, entered at deployment or by
  `checkAndHandleTimeout` after 30 days without a new key.
- The five earlier deployments in this finding run older builds of the same contract (unverified; selectors
  `mintWithSignature`, `withdraw`, `submitGroupKey`, `setGroupKey`, the same `GONKA_CHAIN_ID`; bytecode calls 0x0f and
  0x10 and contains the BLS12-381 field modulus).
- Pattern PQ-6 (a threshold group key; one public key to break). Excerpts:
  [`bridge-source.md`](#bridgecontract-0x972a7a92d92796a98801a8818bcf91f1648f2f68-blockscout-verified-read-2026-11-17); the generated
  [`source-excerpts.md`](#source-excerpts-gonka-bridge-bls12-381-group-key) covers only the five unverified contracts.

## Evidence

- CHECKED (verified source, Blockscout `BridgeContract`, solc 0.8.19, read 2026-11-17): the functions above; no proxy,
  no upgrade function. Gonka's documentation names this address as the bridge and WGNK token
  (https://gonka.ai/docs/cross-chain-transfers/ethereum-bridge/overview/).
- CHECKED (on-chain read at block 26,431,539): no EIP-1967 implementation; `owner()` = Safe `0x1d806d0e…1768`, 2 of 3;
  `getCurrentState()` = 1 (`NORMAL_OPERATION`); latest epoch 460, submitted 2026-11-16; holds 0.0035 ETH; Blockscout
  token balances: 884,150.87 USDT, 647.74 USDC, 259.5 WGNK, dust WETH; WGNK supply 12,393,951.6 (9 decimals), 1,008
  holders ([`bridge.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gonka-bridge-bls12-381-group-key/bridge.json)).
- CHECKED (Blockscout transaction list): 843 direct transactions 2026-10-16 to 2026-11-16 (290 `mintWithSignature`,
  7 `withdraw`, 32 `submitGroupKey`, the rest WGNK transfers and approvals); last 2026-11-16. Created 2026-05-13 (block
  25,088,104), after the March 2026 precompile trace, which is why the census missed it.
- CHECKED (earlier deployments, on-chain read at block 26,431,539 and 26,431,214): all in `NORMAL_OPERATION`, owners are
  EOAs, each holds USD 1–3 of USDT/USDC; their WGNK has one holder each and no market
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gonka-bridge-bls12-381-group-key/onchain.json), [`bridge.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gonka-bridge-bls12-381-group-key/bridge.json)). Bytecode of
  `0xb964f6fe…` read for the precompile calls.
- CHECKED (precompile trace to March 2026, Xatu activity): the earlier deployments called BLS12-381 precompiles; last
  active 2025-11-21 to 2025-12-05, no transactions in the 30-day window
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gonka-bridge-bls12-381-group-key/activity.json)).
- INFERRED: Gonka's chain releases native GNK from escrow when WGNK is burned on Ethereum (from Gonka's documentation;
  not read on the Gonka chain).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x972a7a92…` BridgeContract (WGNK) | config-only (keys) | USD 884,224 | 2026-11-16 | 843 |
| `0xb964f6fe…` WGNK, earlier deployment | config-only | USD 3 | 2025-12-05 | 0 |
| `0xab388373…` WGNK, earlier deployment | config-only | USD 1 | 2025-12-03 | 0 |
| `0xef3bba27…` WGNK, earlier deployment | config-only | USD 3 | 2025-11-25 | 0 |
| `0xdcd4cebe…` WGNK, earlier deployment | config-only | USD 3 | 2025-11-21 | 0 |
| `0x27261349…` WGNK, earlier deployment | config-only | USD 3 | 2025-11-21 | 0 |

- Held by the production bridge (2026-11-17): USD 883,527 USDT, USD 647 USDC, USD 38 WGNK, USD 6 ETH; a forged
  `withdraw` takes all of it.
- Beyond that: forged `mintWithSignature` creates unbacked WGNK, which can be sold into DEX liquidity or burned to
  claim native GNK from Gonka's escrow. WGNK market cap is USD 1.82 million (Blockscout, 12.39 million WGNK at
  USD 0.147); that is an upper bound on what the escrow backs, not counted in `value_usd`.
- The earlier deployments hold about USD 13 together and have no WGNK market.
- Owner-key path: if no epoch key is submitted for 30 days, anyone can switch the bridge to `ADMIN_CONTROL`, where the
  2-of-3 Safe (ECDSA owners) can set any group key. For the earlier deployments that owner is one EOA.

## Remediation

- Post-quantum replacement: a bridge that verifies a post-quantum threshold or aggregate signature (for example
  hash-based signatures aggregated in a STARK, or a STARK proof of Gonka consensus) instead of a BLS12-381 group key.
- Who must act: Gonka. The contract cannot be upgraded and the owner Safe `0x1d806d0e…1768` can only set BLS keys, so
  the validator set must deploy a new bridge, sign withdrawals moving the locked ERC-20s to it (a Gonka chain
  governance or software change) and stop accepting burns from the old WGNK; WGNK holders then move to the new token.
- No Ethereum protocol change needed. Users: keep only what they need in WGNK or locked in the bridge.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review21): MEDIUM kept, step 4: the verification is immutable, but Gonka's consensus can move the
  pooled funds to a new deployment. Added the production bridge `0x972a7a92…2f68` (deployed 2026-05-13, after the
  trace, named in Gonka's docs; USD 884k held); the five census contracts are earlier deployments holding USD 13.
  Source verified for the production bridge: `status` candidate -> confirmed, `evidence.level` bytecode -> source-read.

# Source excerpts: gonka-bridge-bls12-381-group-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb964f6fed8e5f6a9b85c95241a1c268fae04de9b`

No verified source on Sourcify or Blockscout.


## Contract `0xab3883735707d751291833ebfa7932c4f60a5821`

No verified source on Sourcify or Blockscout.


## Contract `0xef3bba27779c4b08b3b3534407113747d6601180`

No verified source on Sourcify or Blockscout.


## Contract `0xdcd4cebe3917a8f1728b8af61299085edfd91f44`

No verified source on Sourcify or Blockscout.


## Contract `0x27261349a8a623b9c798f2ff9388eba22e5b0525`

No verified source on Sourcify or Blockscout.

# BridgeContract 0x972a7a92d92796a98801a8818bcf91f1648f2f68 (Blockscout verified, read 2026-11-17)

Excerpt from `BridgeContract.sol` (line numbers of the Blockscout flattened source).

```solidity
1251    address constant BLS12_PAIRING = 0x000000000000000000000000000000000000000F;       // BLS12_PAIRING_CHECK
1252    address constant BLS12_MAP_FP_TO_G1 = 0x0000000000000000000000000000000000000010;  // BLS12_MAP_FP_TO_G1
...
1346    function setGroupKey(uint64 epochId, bytes calldata groupPublicKey) external onlyOwner onlyAdminControl {
...
1402    function submitGroupKey(uint64 epochId, bytes calldata groupPublicKey, bytes calldata validationSig) public onlyNormalOperation {
...         require(_verifyTransitionSignature(prevGroupKeyStruct, newGroupKeyStruct, validationSig, epochId - 1), "Invalid transition signature");
...
1449    function withdraw(WithdrawalCommand calldata cmd) external nonReentrant onlyNormalOperation {
...         GroupKey memory groupKeyStruct = epochGroupKeys[cmd.epochId];
...         bytes32 messageHash = keccak256(abi.encodePacked(cmd.epochId, GONKA_CHAIN_ID, cmd.requestId, ETHEREUM_CHAIN_ID,
...             WITHDRAW_OPERATION, cmd.recipient, address(this), cmd.tokenContract, cmd.amount));
...         if (!_verifyBLSSignature(groupKey, messageHash, cmd.signature)) revert InvalidSignature();
...             IERC20(cmd.tokenContract).safeTransfer(cmd.recipient, cmd.amount);   // or ETH via call
...
1513    function mintWithSignature(MintCommand calldata cmd) external nonReentrant onlyNormalOperation {
...         if (!_verifyBLSSignature(groupKey, messageHash, cmd.signature)) revert InvalidSignature();
...         _mint(cmd.recipient, cmd.amount);
...
1601    function checkAndHandleTimeout() external {   // anyone; after 30 days without a new epoch -> ADMIN_CONTROL
...
1730    function _verifyBLSSignature(bytes memory groupPublicKey, bytes32 messageHash, bytes memory signature) internal view returns (bool) {
...         bytes memory hG1 = _mapMessageToG1(messageHash);
...         bytes memory negHG1 = _negateG1(hG1);
...         bytes memory pairingInput = abi.encodePacked(signature, G2_GENERATOR, negHG1, groupPublicKey);
...         (bool success, bytes memory result) = BLS12_PAIRING.staticcall(pairingInput);
```

No proxy, no upgrade function; the owner's only powers are `setGroupKey` and `resetToNormalOperation`, both
`onlyAdminControl`.
