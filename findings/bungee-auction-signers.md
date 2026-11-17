---
id: bungee-auction-signers
title: "Bungee auction (Socket): a quantum attacker who recovers the Solver signer key can make Bungee's Solver contract execute arbitrary calls (it holds USD 8), and with the MOFA key can submit auction batches to the BungeeGateway Entrypoint, but users still receive their signed minimum output"
project: socket
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xae68b7117be0026cbd4366303f74eecbb19e4042"
  implementation: null
  name: Solver
  upgradeable: config-only
  admin: "owner EOA 0xf76e73720ec93df7e823b755e10c38a877c34bd5 (setSolverSigner, rescueFunds); it is also the SOLVER_SIGNER"
  value_usd: 8
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-08
  txs_30d: 0
- address: "0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5"
  implementation: null
  name: Entrypoint
  upgradeable: config-only
  admin: "CONFIG_ROLE EOA 0x58a2f301e4bef98c78da7cc2b480d43ee5a4743b (setMofaSigner); owner EOA 0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0 grants roles; gateway CONFIG_ROLE (0xdaee…a6f0, 0x58a2…743b) can replace the Entrypoint via BungeeGateway.setEntrypoint"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-08-27
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "Bungee/Socket: Solver owner EOA 0xf76e73720ec93df7e823b755e10c38a877c34bd5 deploys a Solver with a post-quantum or caller-gated check; gateway CONFIG_ROLE (EOA 0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0 or 0x58a2f301e4bef98c78da7cc2b480d43ee5a4743b) points BungeeGateway 0xe772551f88e2c14aecc880df6b7cbd574561bf82 at a new Entrypoint"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bungee-auction-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/bungee-auction-signers.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [socket-dl-signature-verifier]
---

## Summary

Two Bungee auction contracts trust one secp256k1 key each (PQ-4). Forging the `SOLVER_SIGNER` key lets an attacker make
Bungee's own Solver contract perform any call, which takes what the Solver holds (USD 8 on 2026-11-17). Forging the
`MOFA_SIGNER` key lets an attacker submit request batches to the BungeeGateway as auction winner, but the gateway still
enforces each user's signed minimum output and settlement needs a Socket DL message, so nothing is released by that
key alone; at worst extracted requests sit until cancelled. Both are fixed by Bungee deploying new contracts and
repointing one setting. Rated LOW (step 5: a new-deployment fix, MEDIUM at step 4, with under USD 50k exposed).

## Mechanism

- Solver `0xae68…4042` (`src/solver/Solver.sol`): `performExtraction`, `performSettlement`, `performFulfilment`,
  `performBatchFulfilment` and `performActions` call `verifySignature(keccak256(abi.encode(block.chainid, this, nonce,
  …)), signature)`, which requires `SOLVER_SIGNER == AuthenticationLib.authenticate(hash, sig)` (an
  `eth_sign`-prefixed `ecrecover`, `AuthenticationLib.sol` 23–29, 65-byte only). On success the Solver sets token
  approvals and executes arbitrary `Action{target, value, data}` calls from its own balance.
- Entrypoint `0x2837…4ef5` (`src/core/Entrypoint.sol`): `executeSOR(extractExecs, mofaSignature)` and
  `executeSR(swapExecs, mofaSignature)` call `_checkMofaSig`, `AuthenticationLib.authenticate(batchHash, sig) ==
  MOFA_SIGNER`, then `BUNGEE_GATEWAY.executeImpl(...)` with `msg.sender` as transmitter. In the gateway,
  `SingleOutputRequestImpl.extractRequests` requires `promisedAmount >= minOutputAmount`, pulls the user's tokens through
  Permit2 (the user's own signature) into a registered Bungee router, and pays the transmitter's beneficiary only when a
  Socket DL message reports `fulfilledAmount >= promisedAmount`; `SwapRequestImpl.fulfilRequests` reverts unless the
  receiver's balance rises by at least `fulfilAmount >= minOutputAmount`. So the MOFA key chooses who fills, not
  what users receive.

Pattern PQ-4. Excerpt: [`source-excerpts.md`](#source-excerpts-bungee-auction-signers).

## Evidence

- CHECKED (verified source: Sourcify for Solver, Blockscout for Entrypoint and the bundled gateway implementations):
  the paths above; `setSolverSigner` is `onlyOwner`, `setMofaSigner` is `onlyRole(CONFIG_ROLE)`, no proxy in either.
- CHECKED (block ~26,431,426, [`onchain-review.md`](#on-chain-reads-review15-2026-11-17)): Solver
  `owner()` and `SOLVER_SIGNER` (slot 2) are the same EOA `0xf76e…4bd5`; Entrypoint `MOFA_SIGNER` =
  `0x9033…5f40`; gateway `0xe772…bf82` `ENTRYPOINT()` is still this Entrypoint; CONFIG_ROLE on Entrypoint is held by
  EOA `0x58a2…743b` (from `RoleGranted` logs), and on the gateway by `0xdaee…a6f0` and `0x58a2…743b`.
- CHECKED (block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bungee-auction-signers/onchain.json)): Solver holds USD 8;
  Entrypoint holds nothing.
- CHECKED (precompile trace to March 2026): `ecrecover`; last-year pre-quantum calls: Solver 60,488, Entrypoint 29,621
  (USD 1.31B and USD 660M transferred in those transactions; `curated_contracts.csv`). These are flows, not balances.
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last active 2026-09-08 (Solver) and 2026-08-27
  (Entrypoint) ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/bungee-auction-signers/activity.json)).
- INFERRED: both signer keys have produced on-chain signatures, so their public keys are recoverable.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xae68b711…` Solver | config-only (signer only) | USD 8 (held) | 2026-09-08 | 0 |
| `0x28375939…` Entrypoint | config-only (signer only) | USD 0 (escrow released by MOFA key alone) | 2026-08-27 | 0 |

User funds of in-flight single-output requests sit in the registered Bungee routers and are released only by the
Socket DL settlement message, covered by [`socket-dl-signature-verifier`](socket-dl-signature-verifier.md); a forged
MOFA signature does not release them. Nobody approves tokens to the Solver, so its own balance is the whole exposure.

## Remediation

- Solver: Bungee deploys a new Solver whose actions are authorised by a post-quantum signature (ERC-7913 verifier) or
  by `msg.sender` being a post-quantum account, and moves inventory there; owner EOA `0xf76e…4bd5`. Rotating
  `SOLVER_SIGNER` does not help.
- Entrypoint: deploy an Entrypoint that checks the MOFA batch with a post-quantum signature, and call
  `BungeeGateway.setEntrypoint` from a CONFIG_ROLE holder (`0xdaee…a6f0` or `0x58a2…743b`).
- No protocol change needed. The admin keys are themselves ECDSA EOAs; moving them to post-quantum accounts is part of
  the fix.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review15): MEDIUM -> LOW, step 5: the Solver key takes only the Solver's own USD 8, and the MOFA key releases no escrow (users' minimum output enforced; settlement needs the Socket DL message). Admins corrected from storage and role logs (Entrypoint CONFIG_ROLE is EOA 0x58a2…743b, not the owner).

# Source excerpts: bungee-auction-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xae68b7117be0026cbd4366303f74eecbb19e4042` — Solver (verified source via sourcify)

### `permit2/src/interfaces/IAllowanceTransfer.sol`

```solidity
  126      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  127      /// @param owner The owner of the tokens being approved
  128      /// @param permitSingle Data signed over by the owner specifying the terms of approval
  129      /// @param signature The owner's signature over the permit data
  130      function permit(address owner, PermitSingle memory permitSingle, bytes calldata signature) external;
  131  
  132      /// @notice Permit a spender to the signed amounts of the owners tokens via the owner's EIP-712 signature
  133      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  134      /// @param owner The owner of the tokens being approved
  135      /// @param permitBatch Data signed over by the owner specifying the terms of approval
  136      /// @param signature The owner's signature over the permit data
  137      function permit(address owner, PermitBatch memory permitBatch, bytes calldata signature) external;
  138  
  139      /// @notice Transfer approved tokens from one address to another
  140      /// @param from The address to transfer from
  141      /// @param to The address of the recipient
  ...
```

### `solady/src/tokens/ERC20.sol`

```solidity
  385      /// @dev Sets `value` as the allowance of `spender` over the tokens of `owner`,
  386      /// authorized by a signed approval by `owner`.
  387      ///
  388      /// Emits a {Approval} event.
  389      function permit(
  390          address owner,
  391          address spender,
  392          uint256 value,
  393          uint256 deadline,
  ...
  455                  mstore(0x00, 0xddafbaef) // `InvalidPermit()`.
  456                  revert(0x1c, 0x04)
  457              }
  458              // Increment and store the updated nonce.
  459              sstore(nonceSlot, add(nonceValue, t)) // `t` is 1 if ecrecover succeeds.
  460              // Compute the allowance slot and store the value.
  461              // The `owner` is already at slot 0x20.
  462              mstore(0x40, or(shl(160, _ALLOWANCE_SLOT_SEED), spender))
  463              sstore(keccak256(0x2c, 0x34), value)
  ...
```

### `src/lib/AuthenticationLib.sol`

```solidity
   21      }
   22  
   23      function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
   24          (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
   25          return ecrecover(_ethSignedMessageHash, v, r, s);
   26      }
   27  
   28      function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
   29          require(sig.length == 65, "invalid signature length");
  ...
```


## Contract `0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5` — Entrypoint (verified source via blockscout)

### `permit2/src/interfaces/IAllowanceTransfer.sol`

```solidity
  126      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  127      /// @param owner The owner of the tokens being approved
  128      /// @param permitSingle Data signed over by the owner specifying the terms of approval
  129      /// @param signature The owner's signature over the permit data
  130      function permit(address owner, PermitSingle memory permitSingle, bytes calldata signature) external;
  131  
  132      /// @notice Permit a spender to the signed amounts of the owners tokens via the owner's EIP-712 signature
  133      /// @dev May fail if the owner's nonce was invalidated in-flight by invalidateNonce
  134      /// @param owner The owner of the tokens being approved
  135      /// @param permitBatch Data signed over by the owner specifying the terms of approval
  136      /// @param signature The owner's signature over the permit data
  137      function permit(address owner, PermitBatch memory permitBatch, bytes calldata signature) external;
  138  
  139      /// @notice Transfer approved tokens from one address to another
  140      /// @param from The address to transfer from
  141      /// @param to The address of the recipient
  ...
```

### `solady/src/tokens/ERC20.sol`

```solidity
  385      /// @dev Sets `value` as the allowance of `spender` over the tokens of `owner`,
  386      /// authorized by a signed approval by `owner`.
  387      ///
  388      /// Emits a {Approval} event.
  389      function permit(
  390          address owner,
  391          address spender,
  392          uint256 value,
  393          uint256 deadline,
  ...
  455                  mstore(0x00, 0xddafbaef) // `InvalidPermit()`.
  456                  revert(0x1c, 0x04)
  457              }
  458              // Increment and store the updated nonce.
  459              sstore(nonceSlot, add(nonceValue, t)) // `t` is 1 if ecrecover succeeds.
  460              // Compute the allowance slot and store the value.
  461              // The `owner` is already at slot 0x20.
  462              mstore(0x40, or(shl(160, _ALLOWANCE_SLOT_SEED), spender))
  463              sstore(keccak256(0x2c, 0x34), value)
  ...
```

### `src/lib/AuthenticationLib.sol`

```solidity
   21      }
   22  
   23      function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
   24          (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
   25          return ecrecover(_ethSignedMessageHash, v, r, s);
   26      }
   27  
   28      function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
   29          require(sig.length == 65, "invalid signature length");
  ...
```

# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, latest block ~26,431,426; logs from Blockscout `module=logs`.

## Solver `0xae68b7117be0026cbd4366303f74eecbb19e4042` (Sourcify `src/solver/Solver.sol`)

| Read | Result |
|---|---|
| `owner()` | `0xf76e73720ec93df7e823b755e10c38a877c34bd5` (EOA: code size 0, nonce 328) |
| storage slot 2 (`SOLVER_SIGNER`, internal) | `0xf76e73720ec93df7e823b755e10c38a877c34bd5` (same key as owner) |
| proxy slots | none (no proxy; `onchain.json`) |
| holdings | USD 8 (`onchain.json`, block 26,431,214) |

## Entrypoint `0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5` (Blockscout-verified `src/core/Entrypoint.sol`)

| Read | Result |
|---|---|
| `MOFA_SIGNER()` | `0x9033472ec5dcf3e2905ed93108de5f8961005f40` (EOA, nonce 0: signs off-chain only) |
| `BUNGEE_GATEWAY()` | `0xe772551f88e2c14aecc880df6b7cbd574561bf82` |
| gateway `ENTRYPOINT()` | `0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5` (still the live entrypoint) |
| `owner()` | `0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0` (EOA, nonce 494) |
| `hasRole(CONFIG_ROLE, owner)` | false |
| `RoleGranted(CONFIG_ROLE, …)` logs | `0x58a2f301e4bef98c78da7cc2b480d43ee5a4743b` (block 22,022,736; EOA, nonce 0); no `RoleRevoked` |

## BungeeGateway `0xe772551f88e2c14aecc880df6b7cbd574561bf82`

| Read | Result |
|---|---|
| `owner()` | `0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0` |
| `RoleGranted` logs | CONFIG_ROLE: `0xdaee…a6f0` (21,966,713), `0x58a2…743b` (22,022,736); RESCUE_ROLE: `0xdaee…a6f0`, `0x0e551461bc47ee6127d888679c5fcc3ac49b81be`; CANCEL_ROLE: `0x86c950fe91d96fa113a96ee23edc7c517b94bfdc` |

CONFIG_ROLE on the gateway can call `setEntrypoint(address)` (`BungeeGatewayBase.sol`).
