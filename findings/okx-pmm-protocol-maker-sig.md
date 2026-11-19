---
id: okx-pmm-protocol-maker-sig
title: "OKX Lab PMMProtocol: RFQ maker orders are checked with ecrecover first, so a quantum attacker who recovers a market maker's key can fill forged orders against everything the maker approved (at least $2.2M for the main maker), even after the maker's address gets post-quantum code"
project: okx
status: confirmed
severity: LOW
patterns: [PQ-2, PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1"
  implementation: null
  name: PMMProtocol ("OKX Lab PMM Protocol" 1.0)
  upgradeable: "no"
  admin: none (no proxy, no owner)
  value_usd: 2238335
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 3247
families: []
fix:
  layer: account-migration
  who_acts: "Each market maker (main maker 0x67336cec42645f55059eff241cb02ea5cc52ff86) quotes from a contract account that verifies a post-quantum signature through ERC-1271 and revokes approvals from its ECDSA address; OKX for a 1271-first PMMProtocol deployment"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-pmm-protocol-maker-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, Blockscout logs, cast allowance reads at block 26431692
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: [okx-wallet-link-groth16]
---

## Summary

`PMMProtocol` (EIP-712 name "OKX Lab PMM Protocol") settles RFQ quotes signed by market makers. Unless the filler asks
for the ERC-1271 path, a maker's signature is checked with `ecrecover` first (PQ-2), and the filler chooses the path.
A quantum attacker who recovers a maker's key signs orders at any price and fills them, pulling whatever the maker has
approved: the main maker (`0x67336cec…`, an EIP-7702 EOA) has unlimited approvals to the contract on USDT, USDC, WETH
and cbBTC worth $2.24M (2026-11-17). Adding post-quantum code to the maker's address does not help. A maker that quotes
from a contract account with no ECDSA key is not forgeable, and that path already exists. Rated LOW, step 4: an
existing alternative that each maker (one known party) can switch to.

## Mechanism

- `fillOrderRFQTo(order, signature, flagsAndAmount, target)` (`PmmProtocol.sol` lines 198–251; `fillOrderRFQCompact`
  110–173 the same with `r, vs`): if bit 254 (`_SIGNER_SMART_CONTRACT_HINT`) of the filler-supplied `flagsAndAmount` is
  set, `ECDSA.isValidSignature(maker, hash, signature)` (ERC-1271, full signature); otherwise
  `ECDSA.recoverOrIsValidSignature` (`ECDSA.sol` lines 118–131): `ecrecover` for 64/65-byte signatures, ERC-1271 only
  if that fails.
- `_fillOrderRFQTo` (line 253 ff.) then moves `makerAsset` from the maker to the filler (directly or through Permit2 when
  `order.usePermit2`) and `takerAsset` back, at the signed amounts.
- A forged order with a tiny `takerAmount` drains the maker's approved balance. For a maker address with an ECDSA key,
  the filler simply leaves the hint bit unset. Patterns PQ-2 (ECDSA tried before ERC-1271) and PQ-4 (one market-maker
  key authorises value).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): the paths above; no owner, proxy or admin function
  ([`notes.md`](#review-notes-review12-2026-11-17), [`source-excerpts.md`](#source-excerpts-okx-pmm-protocol-maker-sig)).
- CHECKED (block 26,431,214): no proxy, holds nothing ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-pmm-protocol-maker-sig/onchain.json)).
- CHECKED (Blockscout logs, latest 50 `OrderFilledRFQ`, blocks 26,381,407–26,386,162): makers `0x67336cec…` (48 fills;
  EIP-7702 EOA) and `0xce79b081…` (2; plain EOA).
- CHECKED (cast at block 26,431,692): `0x67336cec…` has maximum allowance to PMMProtocol (and to Permit2) for USDT, USDC,
  WETH, cbBTC; Blockscout balances of those tokens $1,618,442 + $235,943 + $202,184 + $181,766 = $2,238,335.
  `0xce79b081…` has 0 allowance to PMMProtocol for its two largest holdings.
- CHECKED (Xatu, any function): 3,247 transactions 2026-10-16 to 2026-11-16, last 2026-11-10
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/okx-pmm-protocol-maker-sig/activity.json)); precompile trace, year to March 2026:
  42,306 transactions calling `ecrecover`, $158.9M moved in them (`curated_contracts.csv`).
- INFERRED: attribution to OKX rests on the EIP-712 domain name in the verified source; the deployer
  (`0xf7745296…`, an EIP-7702 EOA) has no public label. Not confirmed with OKX.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x81e4edad34667f369a9d34fa3fd248b03a666cb353e1513a0c28ce6a4b0f0229` (block 26,384,210, position 0), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (408,888 gas); under EIP-8151 it also succeeds (415,088 gas). With one byte of code at the recovered signer
  `0x67336cec42645f55059eff241cb02ea5cc52ff86`, it still ends without error but with 3 logs instead of 17: the order
  or request signed by that address is refused inside the transaction; with a 7702 delegation there it succeeds.
  Study family `f1c998af` (PMMProtocol).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2bd541ab…` PMMProtocol | no | $2.24M (escrow: main maker's approved balances) | 2026-11-10 | 3,247 |

- Escrow: makers' balances approved to PMMProtocol. Measured for the main maker's four largest approved tokens only
  ($2,238,335); its other tokens and other makers were not summed, so this is a lower bound. Permit2 approvals
  (`usePermit2` orders) add to it but were not measured.
- Takers are not exposed through this check: they pay only what they send in their own transaction.

## Remediation

- Makers: quote from a contract account (ERC-1271) that verifies a post-quantum signature, holding the inventory there,
  and revoke the approvals of the ECDSA address. A 7702-delegated EOA is not enough: its ECDSA key still passes
  `ecrecover`.
- OKX: a new PMMProtocol deployment that checks the maker's code first (PQ-13 order) or lets the maker, not the filler,
  fix the scheme; the current contract is immutable.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for maker addresses with real account code.
- Who acts: each maker (main maker `0x67336cec…`); OKX for a new deployment.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review12): LOW -> LOW, step 4: makers can already quote from contract accounts (ERC-1271), which are not forgeable; each maker is one known party. Project identified as OKX from the EIP-712 domain name "OKX Lab PMM Protocol" (id kept). Added PQ-2 (ecrecover tried first; the filler chooses the path); escrow $2.24M measured from the main maker's allowances; fix.layer new-deployment -> account-migration, protocol_change -> helps.
- 2026-11-17 integration: id renamed from `unidentified-2bd541ab-signer-key` (project identified); linked with the other OKX finding, `okx-wallet-link-groth16`.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: okx-pmm-protocol-maker-sig

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1` — PMMProtocol (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol`

```solidity
   14       * @dev Should return whether the signature provided is valid for the provided data
   15       * @param hash      Hash of the data to be signed
   16       * @param signature Signature byte array associated with _data
   17       */
   18      function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
   19  }
  ...
```

### `lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol`

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

### `src/OrderRFQLib.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  
    3  pragma solidity 0.8.17;
    4  
    5  import "./libraries/ECDSA.sol";
    6  
    7  library OrderRFQLib {
    8      struct OrderRFQ {
    9          uint256 rfqId; // 0x00
  ...
   48                  order.takerAmount,
   49                  order.usePermit2
   50              )
   51          );
   52          return ECDSA.toTypedDataHash(domainSeparator, structHash);
   53      }
   54  }
  ...
```

### `src/PmmProtocol.sol`

```solidity
  124          orderHash = order.hash(_domainSeparatorV4());
  125          if (flagsAndAmount & _SIGNER_SMART_CONTRACT_HINT != 0) {
  126              if (flagsAndAmount & _IS_VALID_SIGNATURE_65_BYTES != 0) {
  127                  if (
  128                      !ECDSA.isValidSignature65(
  129                          order.makerAddress,
  130                          orderHash,
  131                          r,
  132                          vs
  133                      )
  134                  ) revert Errors.RFQ_BadSignature(order.rfqId);
  135              } else {
  136                  if (
  137                      !ECDSA.isValidSignature(
  138                          order.makerAddress,
  139                          orderHash,
  140                          r,
  141                          vs
  ...
  143                  ) revert Errors.RFQ_BadSignature(order.rfqId);
  144              }
  145          } else {
  146              if (
  147                  !ECDSA.recoverOrIsValidSignature(
  148                      order.makerAddress,
  149                      orderHash,
  150                      r,
  151                      vs
  ...
  215                  flagsAndAmount & _IS_VALID_SIGNATURE_65_BYTES != 0 &&
  216                  signature.length != 65
  217              ) revert Errors.RFQ_BadSignature(order.rfqId);
  218              if (
  219                  !ECDSA.isValidSignature(
  220                      order.makerAddress,
  221                      orderHash,
  222                      signature
  223                  )
  224              ) revert Errors.RFQ_BadSignature(order.rfqId);
  225          } else {
  226              if (
  227                  !ECDSA.recoverOrIsValidSignature(
  228                      order.makerAddress,
  229                      orderHash,
  230                      signature
  231                  )
  ...
```

### `src/interfaces/IDaiLikePermit.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.0;
    3  
    4  interface IDaiLikePermit {
    5      function permit(
    6          address holder,
    7          address spender,
    8          uint256 nonce,
    9          uint256 expiry,
  ...
```

### `src/interfaces/IPermit2.sol`

```solidity
   37          uint160 amount,
   38          address token
   39      ) external;
   40  
   41      function permit(
   42          address owner,
   43          PermitSingle memory permitSingle,
   44          bytes calldata signature
   45      ) external;
  ...
```

Library files with the primitive itself (not excerpted): `src/EIP712.sol`, `src/libraries/ECDSA.sol`

# Review notes (Review12, 2026-11-17)

- Source: Sourcify `src/PmmProtocol.sol` of 0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1 (contract `PMMProtocol`, solc
  0.8.17; deployment tx 0xacda054964ef9ea825c54badd4e2790260ebab4d9d9c01abab3e95889d65025f, block 23,395,278, deployer
  0xf7745296976daeeed7b0143e212885af7bca6a10, an EIP-7702 EOA).
  - EIP-712 domain: `_NAME = "OKX Lab PMM Protocol"`, `_VERSION = "1.0"` (lines 49–50).
  - `fillOrderRFQTo` (lines 198–251) and `fillOrderRFQCompact` (110–173): if the caller sets `_SIGNER_SMART_CONTRACT_HINT`
    (bit 254 of `flagsAndAmount`), `ECDSA.isValidSignature` (ERC-1271 with the full signature); otherwise
    `ECDSA.recoverOrIsValidSignature` (`src/libraries/ECDSA.sol` lines 118–131): `ecrecover` first for 64/65-byte
    signatures, ERC-1271 if that fails. `flagsAndAmount` is chosen by the filler (taker), not by the maker.
  - `_fillOrderRFQTo` (253 ff.): `safeTransferFrom(maker → taker)` of `makerAsset` (or through Permit2 if
    `order.usePermit2`), then taker → maker of `takerAsset`.
  - No owner, no proxy, no admin function.
- Blockscout `/api/v2/addresses/<pmm>/logs` (latest page, read 2026-11-17): 50 `OrderFilledRFQ` events in blocks
  26,381,407–26,386,162; makers 0x67336cec42645f55059eff241cb02ea5cc52ff86 (48; EIP-7702 EOA, delegate
  0x63c0c19a282a1b52b07dd5a65b58948a07dae32b, nonce 810) and 0xce79b081c0c924cb67848723ed3057234d10fc6b (2; EOA,
  nonce 38,313).
- cast (https://eth.drpc.org) at block 26,431,692: maker 0x67336cec has max (2^256-1, or close to it) `allowance` to
  PMMProtocol and to Permit2 for USDT, USDC, WETH and cbBTC; maker 0xce79b081 has 0 allowance to PMMProtocol for its two
  largest holdings (TBLLX, SPYX).
- Blockscout tokens (first page, 2026-11-17): maker 0x67336cec holds USDT $1,618,442, USDC $235,943, WETH $202,184,
  cbBTC $181,766 (sum $2,238,335 for these four approved tokens; $2.68M on the first page, more pages exist).
