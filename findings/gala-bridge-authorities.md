---
id: gala-bridge-authorities
title: "Gala bridge (0x9f452b7c): a quantum attacker who recovers its single ECDSA authority key can release the $2.6M it holds, mint GALA, and sign its own upgrade"
project: gala
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-5, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x9f452b7cc24e6e6fa690fe77cf5dd2ba3dbf1ed9"
  implementation: "0xc664692f38d2528710edbb74f65db6599bc7dee6"
  name: GalaBridge (proxy) / Bridge
  upgradeable: "yes"
  admin: "upgrade(VSM) and changeAuthorities(VSM) signed by the authority set (1 key, 0xf6901089c82b056858eea367bd252615b7634af0, block 26431535); owner EOA 0x7c63e722a7d3ca4fafc29270d82b07e6b07fc564 for token setup and pause"
  value_usd: 2643462
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1835
families: []
fix:
  layer: contract-upgrade
  who_acts: "Gala (GalaChain governance): a governance message signed by authority 0xf6901089c82b056858eea367bd252615b7634af0 calls upgrade(VSM) on 0x9f452b7c with a post-quantum verifier; must happen while the ECDSA key is still safe"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gala-bridge-authorities
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
  who: Review17 (Sourcify source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gala-bridge-authorities/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1da56785"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

The GalaChain ↔ Ethereum bridge releases or mints tokens when a message is signed by a quorum of its ECDSA
"authorities", and the same quorum signs upgrades and key changes. Today the set has one authority key, so one
signature is a quorum. A quantum attacker who recovers that key can release the $2.64M the bridge holds, mint GALA
(the bridge holds GALA's minter role), and upgrade the bridge to code of their choosing. Gala can fix it with an
upgrade signed by that same key before a CRQC exists, so the rating is MEDIUM (step 4: fix by contract upgrade).

## Mechanism

- `bridgeIn(VSM)` (`contracts/BridgeIn.sol` 29-96) calls `Authority.verifyMessage`: it requires
  `3 * signatures >= 2 * authoritiesLength()` and `ECDSA.tryRecover(digest, v, r, s) == getAuthority(index)` for every
  signature (`contracts/Authority.sol` 20-44). It then transfers ERC-20/721/1155 tokens to the recipient, minting the
  shortfall (`mintBulk`) for burning bridges such as GALA.
- `Governance.upgrade(VSM)` and `Governance.changeAuthorities(VSM)` use the same check plus an emitter match
  (`governanceContract()`), then `_upgradeToAndCall` or `setAuthorities`.
- With one authority the committee check (PQ-5) reduces to one operator key (PQ-4). Rotating the key does not help:
  the scheme must change.

## Evidence

- CHECKED (Sourcify source of implementation `0xc664692f…`): `verifyMessage`, `bridgeIn`, `bridgeInERC20` minting,
  `upgrade`, `changeAuthorities`, `Admin` ([`review-notes.md`](#review-reads-gala-bridge-authorities-2026-11-17-review17),
  [`source-excerpts.md`](#source-excerpts-gala-bridge-authorities)).
- CHECKED (on-chain read at block 26,431,535): EIP-1967 implementation `0xc664692f…`, admin slot empty;
  `authoritiesLength()` = 1, authority `0xf6901089…`; `owner()` = EOA `0x7c63e722…`; not paused.
- CHECKED (latest block, 2026-11-17): GALA `isBurningBridge` = true; the bridge holds GALA `MINTER_ROLE`; GALA
  circulating market cap $70.05M (Blockscout).
- CHECKED (block 26,431,214): $2.64M of tokens held ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gala-bridge-authorities/onchain.json)).
- CHECKED (Xatu, any function): 1,835 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gala-bridge-authorities/activity.json)); 28,231 `ecrecover` transactions in the
  yearly window (`studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x9f452b7c…` GalaBridge | yes (authority-signed `upgrade`) | $2.64M | 2026-11-15 | 1,835 |

Held: WETH $884k, WBTC $748k, USDT $232k, WXRP $197k, USDC $156k (block 26,431,214). Beyond that, a forged
`bridgeIn` can mint GALA without limit (the bridge is a minter); GALA's $70M circulating market cap bounds the
market damage, not the amount held. Other Gala token bridges or chains were not checked.

## Remediation

- Gala signs a governance message with the current authority key that calls `upgrade(VSM)` to an implementation
  verifying a post-quantum scheme (ML-DSA or hash-based signatures from GalaChain, or a STARK over them), then
  `changeAuthorities` to post-quantum keys. Because upgrades are gated by the same ECDSA key, this must be done before
  the key can be recovered; afterwards nobody can safely upgrade.
- Adding more authorities raises the quorum but not the scheme; it does not help against a CRQC.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review17): MEDIUM kept, step 4: fix by an authority-signed upgrade. The authority set has one key (read at block 26,431,535), so PQ-4 added and trigger set to operator-key; GALA minting through the bridge noted.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: gala-bridge-authorities

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x9f452b7cc24e6e6fa690fe77cf5dd2ba3dbf1ed9` — GalaBridge (verified source via sourcify)

### `contracts/Authority.sol`

```solidity
   28          bytes32 digest = keccak256(abi.encodePacked(message.emitter, message.chainId, message.sequence, message.nonce, message.payload));
   29  
   30          for (uint256 i = 0; i < message.signatures.length; i++) {
   31              Structs.Signature memory signature = message.signatures[i];
   32              if (ecrecover(digest, signature.v, signature.r, signature.s) != getAuthority(signature.index)) {
   33                  return (false, "INVALID_SIGNATURE");
   34              }
   35          }
   36          return (true, "");
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol`

```solidity
   32       * For more information on the signature format, see the
   33       * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
   34       * section].
   35       */
   36      function permit(
   37          address owner,
   38          address spender,
   39          uint256 value,
   40          uint256 deadline,
  ...
```

### `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
   90          bytes32 r,
   91          bytes32 s
   92      ) internal {
   93          uint256 nonceBefore = token.nonces(owner);
   94          token.permit(owner, spender, value, deadline, v, r, s);
   95          uint256 nonceAfter = token.nonces(owner);
   96          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
   97      }
   98  
  ...
```

## Implementation `0xc664692f38d2528710edbb74f65db6599bc7dee6` — Bridge (verified source via sourcify)

### `contracts/Authority.sol`

```solidity
    1  //SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.7;
    3  
    4  import "./Getters.sol";
    5  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    6  
    7  /// @title Authority
    8  /// @notice This is a base contract to be used by other contracts which provide functionality based on messages
    9  /// signed by the authority. Furthermore it allows off-chain entities which are willing to send messages to the bridge
  ...
   31              //on subsequent iterations the signature index must be appropriate
   32              require(i == 0 || signature.index > lastIndex, "INVALID_SIGNER_ORDER");
   33              lastIndex = signature.index;
   34              require(lastIndex < authorityLength, "SIGNER_INDEX_OUT_OF_BOUNDS");
   35              (address authority, ECDSA.RecoverError error) = ECDSA.tryRecover(digest, signature.v, signature.r, signature.s);
   36              if (error != ECDSA.RecoverError.NoError || authority != getAuthority(signature.index)) {
   37                  return (false, "INVALID_SIGNATURE");
   38              }
   39          }
   40          return (true, "");
  ...
```

### `contracts/BridgeOut.sol`

```solidity
   93          bytes32 s
   94      ) external whenNotPaused {
   95          require(getTokenType(token) == TokenType.ERC20, "ERC20_ONLY");
   96  
   97          try IERC20Permit(token).permit(msg.sender, address(this), amount, deadline, v, r, s) {
   98              _bridgeOutInternal(msg.sender, token, amount, 0, destinationChainId, recipient);
   99          } catch Error(string memory reason) {
  100              revert(reason);
  101          } catch {
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol`

```solidity
   32       * For more information on the signature format, see the
   33       * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
   34       * section].
   35       */
   36      function permit(
   37          address owner,
   38          address spender,
   39          uint256 value,
   40          uint256 deadline,
  ...
```

### `@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
   90          bytes32 r,
   91          bytes32 s
   92      ) internal {
   93          uint256 nonceBefore = token.nonces(owner);
   94          token.permit(owner, spender, value, deadline, v, r, s);
   95          uint256 nonceAfter = token.nonces(owner);
   96          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
   97      }
   98  
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`

# Review reads: gala-bridge-authorities (2026-11-17, Review17)

Sourcify source of implementation `0xc664692f38d2528710edbb74f65db6599bc7dee6` (Bridge):

- `Authority.verifyMessage` (contracts/Authority.sol 20-44): requires `3 * signatures.length >= 2 * authoritiesLength()`,
  ascending signer indices, and `ECDSA.tryRecover(digest, v, r, s) == getAuthority(index)` for each signature.
- `BridgeIn.bridgeIn(VSM)` (contracts/BridgeIn.sol 29-96): `verifyMessage`, replay check, then releases or mints:
  `bridgeInERC20` mints the shortfall with `mintBulk` when the bridge balance is below the amount and transfers to the
  recipient; ERC-721 / ERC-1155 are minted or released likewise.
- `Governance.changeAuthorities(VSM)` and `Governance.upgrade(VSM)` (contracts/Governance.sol): both require
  `verifyGovernanceMessage` (emitter == `governanceContract()` plus the same authority quorum); `upgrade` calls
  `_upgradeToAndCall(newImplementation, init)`. Upgrades and key changes are therefore signed by the same ECDSA
  authority set.
- `Admin` (contracts/Admin.sol): `onlyOwner` token-bridge setup, enable/disable, destinations, `pause`/`unpause`.

On-chain reads at block 26,431,535 (2026-11-17, publicnode):

- EIP-1967 implementation slot = `0xc664692f…`; EIP-1967 admin slot = 0 (no ProxyAdmin; upgrades go through
  `upgrade(VSM)`).
- `owner()` = `0x7c63e722a7d3ca4fafc29270d82b07e6b07fc564` (no code: an EOA).
- `authoritiesLength()` = 1; `getAuthority(0)` = `0xf6901089c82b056858eea367bd252615b7634af0`. With one authority the
  quorum is one signature.
- `paused()` = false; `governanceContract()` = `0x159ae617db2bc67c1cef659ce3571b3de1236980c3a551e17ebae0674af60188`.
- GALA `0xd1d2eb1b1e90b638588728b4130137d262c87cae`: `isBurningBridge(GALA, 0)` = true, `getTokenType` = 1 (ERC20);
  `hasRole(keccak256("MINTER_ROLE"), bridge)` = true; `totalSupply()` = 46.09e9 GALA (8 decimals); bridge balance 0.
  Blockscout token page: price $0.001365, circulating market cap $70.05M.
- Holdings from onchain.json (block 26,431,214): $2.64M (WETH $884k, WBTC $748k, USDT $232k, WXRP $197k, USDC $156k).
