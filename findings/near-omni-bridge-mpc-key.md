---
id: near-omni-bridge-mpc-key
title: "NEAR Omni Bridge: a quantum attacker who recovers the bridge's one MPC-held ECDSA key can sign transfers that release the $50.9M escrowed in OmniBridge and mint bridged tokens"
project: near
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/near-omni-bridge-mpc-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/near-omni-bridge-mpc-key/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 528d1fb8"
  date: 2026-11-19
  verdict: reported
  rating: LOW
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
[`source-excerpts.md`](#source-excerpts-near-omni-bridge-mpc-key).

## Evidence

- CHECKED (Sourcify verified source of `0x53785920…`, read 2026-11-17): the functions above
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/near-omni-bridge-mpc-key/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0x53785920…`;
  `nearBridgeDerivedAddress()` = `0x22eb4d37677ed931d9de2218cece1a832a147490`; `hasRole(DEFAULT_ADMIN_ROLE)` true for
  Safe `0x2468603…` (threshold 3 of 5) and false for the deployer `0xd9cb0777…`, matching the RoleGranted (block
  22,224,025) and RoleRevoked (block 22,224,038) logs.
- CHECKED (pipeline read at block 26,431,214, top holdings re-checked on Blockscout 2026-11-17): 2,191 ETH, 766.6M
  AURORA (about $24.7M), 14.5M USDC, 3.9M USDT, 18 WBTC and others; $50.9M in total.
- CHECKED (precompile trace to March 2026): 4,334 pre-quantum calls in the year
  (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 1,506 transactions (any function)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/near-omni-bridge-mpc-key/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: admin Safe can upgrade). Pattern PQ-5 -> PQ-4 and trigger committee-keys -> operator-key: the contract checks one ECDSA key (`nearBridgeDerivedAddress`), so recovering that key suffices. Admin corrected from "UUPS owner (Ownable2Step)" to DEFAULT_ADMIN_ROLE held by Safe 0x2468603… (3 of 5), read at block 26,431,457.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: near-omni-bridge-mpc-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe00c629afaccb0510995a2b95560e446a24c85b9` — ERC1967Proxy (verified source via sourcify)

## Implementation `0x53785920165fbdf33b3f56885dbc8d12854ac414` — OmniBridge (verified source via sourcify)

### `src/omni-bridge/contracts/OmniBridge.sol`

```solidity
    4  import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
    5  import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
    6  import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
    7  import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    8  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    9  import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
   10  import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
   11  import {ICustomMinter} from "../../common/ICustomMinter.sol";
   12  
  ...
  103              bytes1(metadata.decimals)
  104          );
  105          bytes32 hashed = keccak256(borshEncoded);
  106  
  107          if (ECDSA.recover(hashed, signatureData) != nearBridgeDerivedAddress) {
  108              revert InvalidSignature();
  109          }
  110  
  111          require(!isBridgeToken[nearToEthToken[metadata.token]], "ERR_TOKEN_EXIST");
  ...
  212                  : bytes.concat(bytes("\x01"), Borsh.encodeString(payload.feeRecipient))
  213          );
  214          bytes32 hashed = keccak256(borshEncoded);
  215  
  216          if (ECDSA.recover(hashed, signatureData) != nearBridgeDerivedAddress) {
  217              revert InvalidSignature();
  218          }
  219  
  220          if (payload.tokenAddress == address(0)) {
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`
