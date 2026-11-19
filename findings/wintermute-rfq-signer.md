---
id: wintermute-rfq-signer
title: "Wintermute market-maker contract 0x51c72848: a quantum attacker who recovers its RFQ signer key can sign Permit2/Bebop/1inch orders that pull its approved tokens (up to $70.6M)"
project: wintermute
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x51c72848c68a965f66fa7a88855f9f7784502a7f"
  implementation: null
  name: Bot (Wintermute market maker; Blockscout partial-match reconstruction)
  upgradeable: config-only
  admin: roles pushed by access-control registry 0x7ff4ed8ab94c849b812622eb462682208be06b93 (unverified), including the single rfqSigner; multiSigOwner Safe 0xce466fc694c971b95bb1193e494942e22197f759 (4 of 10) approves spenders; no proxy
  value_usd: 70639811
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 456045
families: []
fix:
  layer: new-deployment
  who_acts: Wintermute deploys a contract whose RFQ signature check accepts a post-quantum signer and moves the funds; until then the registry 0x7ff4ed8ab94c849b812622eb462682208be06b93 can revoke rfqSignerRole (stops the RFQ path)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wintermute-rfq-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review03 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wintermute-rfq-signer/bot.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4a2c7a03"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

0x51c72848 is Wintermute's Ethereum market-maker contract (Blockscout tag "Wintermute_1", Arkham "Wintermute:
Market Maker"), holding $70.6M. It answers ERC-1271 `isValidSignature` for Permit2, BebopSettlement and the 1inch
routers by `ecrecover`-ing against one stored RFQ signer EOA, and registers the same signer with 0x and AirSwap
(PQ-4). A quantum attacker who recovers that key can sign orders or Permit2 transfers that pull the contract's
approved tokens: Bebop has unlimited USDC/USDT/WETH allowances and Permit2 holds 9.5M USDC, 8.3M USDT and 2,759
WETH. The check is ECDSA-only, so the fix is a new contract from Wintermute (one known party). Rated MEDIUM (step 4).

## Mechanism

- `isValidSignature(bytes32 hash, bytes signature)` (`whenActive`) requires `_approvedRfqCallers[msg.sender]` and
  calls `_validateSignature`, which does `ECDSA.recover(hash, signature)` and returns `0x1626ba7e` only if the result
  equals `_rfqSigner` (source lines 689–704). `ECDSA.recover` is plain `ecrecover`: even a contract signer could not
  be used.
- Approved RFQ callers: BebopSettlement 0xbbbbbbb5…, Permit2 0x000000000022d473…, 1inch v5 0x11111112…960582 and
  1inch v6 0x11111112…842a65. Each verifies the maker's (this contract's) signature through ERC-1271 and then moves
  the maker's tokens under its allowance; Permit2's `permitTransferFrom` alone lets a forged signature pull up to
  the Permit2 allowances to any address.
- `registerZeroexSigner` / `authorizeAirswapSigner` (multisig only) register `_rfqSigner` with the 0x Exchange
  Proxy and AirSwap, which check the signer's ECDSA signature themselves; allowances to both are currently 0.
- `_rfqSigner` is set and cleared only by the registry (`onRoleGranted`/`onRoleRevoked` with `rfqSignerRole`);
  `killContract()` (operators, transferers, WETH handlers or the multisig) deactivates the contract and revokes all
  approvals.

## Evidence

- CHECKED (Blockscout-verified source `Bot`, solc 0.8.19, partial match verified 2026-11-07): the source is a
  reconstruction with stand-in names for unknown selectors, compiled to the deployed bytecode except metadata;
  lines as above ([`source-excerpts.md`](#source-excerpts-wintermute-rfq-signer)). The
  draft called it unverified.
- CHECKED (on-chain read, block 26,431,604): `_rfqSigner` = 0xa0f1898f… (no code); `multiSigOwner` = Safe
  0xce466fc6… (4 of 10); `accessControlRegistry` = 0x7ff4ed8a…; `isActive` true; approved RFQ callers and the
  allowances above; ten approved spenders ([`bot.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wintermute-rfq-signer/bot.json)).
- CHECKED (on-chain read, block 26,431,214): holdings $70.6M (14.6M USDC, 12.6M USDT, 12.2M WETH, 4.9M cbBTC, 4.2M
  crvUSD, 224 ETH, others) ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wintermute-rfq-signer/onchain.json)).
- CHECKED (Xatu, any function): 456,045 transactions in 2026-10-16 to 2026-11-16, mostly operator swaps
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/wintermute-rfq-signer/activity.json)); `txs_y1` = 552,357 pre-quantum
  calls in `curated_contracts.csv`.
- CHECKED (Blockscout tags, Arkham label): operator is Wintermute.
- INFERRED: the per-token allowances beyond USDC/USDT/WETH were not read; the $70.6M held is an upper bound (the
  224 ETH is not reachable through allowances).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x51c72848…` Bot (Wintermute) | config-only (roles) | $70.6M | 2026-11-16 | 456,045 |

Reachable with a forged RFQ signature: everything approved to BebopSettlement (unlimited for USDC, USDT, WETH) and
to Permit2 (9.5M USDC, 8.3M USDT, 2,759 WETH). The predecessor bot 0x8712aa50… named in the source header was not
checked.

## Remediation

- Post-quantum replacement: a contract whose `isValidSignature` verifies a post-quantum signature (or delegates to
  an ERC-1271 signer contract with the full signature) and no longer registers an ECDSA signer with 0x/AirSwap;
  funds move to it. Rotating `_rfqSigner` to a new EOA does not help.
- Who acts: Wintermute. As a stopgap, the registry 0x7ff4ed8a… can revoke `rfqSignerRole`, or an operator can call
  `killContract()`, which stops the RFQ path and revokes approvals (and stops trading).
- Protocol change: not needed. EIP-8151 would not help; the signer is checked by this contract, not by an account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review03): MEDIUM unchanged (step 4: Wintermute redeploys). Project identified as Wintermute (Blockscout and Arkham labels); source found verified on Blockscout (partial match), so evidence level bytecode -> source-read and status candidate -> confirmed; RFQ callers and allowances read on-chain.
- 2026-11-17 integration: id renamed from `unidentified-51c72848-signer-key` (project identified).
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: wintermute-rfq-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x51c72848c68a965f66fa7a88855f9f7784502a7f` — Bot (verified source via blockscout)

### `lib/oz-v4.7.3/contracts/token/ERC20/extensions/draft-IERC20Permit.sol`

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

### `lib/oz-v4.7.3/contracts/token/ERC20/utils/SafeERC20.sol`

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

### `src/Bot.sol`

```solidity
    2  pragma solidity 0.8.19;
    3  
    4  import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    5  import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
    6  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    7  import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
    8  
    9  interface IUniswapV2Pair {
   10      function token0() external view returns (address);
  ...
  685          require(_approvedCoinbaseAddresses[block.coinbase], "H17");
  686          block.coinbase.call{value: tip, gas: 0}(""); // result ignored, as deployed
  687      }
  688  
  689      function isValidSignature(bytes32 hash, bytes memory signature) external view whenActive returns (bytes4) {
  690          require(_approvedRfqCallers_1CiVF7[msg.sender], "H19");
  691          return _validateSignature(hash, signature);
  692      }
  693  
  694      function _validateSignature(bytes32 hash, bytes memory signature) internal view returns (bytes4) {
  695          address signer = _rfqSigner;
  696          require(signer != address(0), "H23");
  697          address recovered = ECDSA.recover(hash, signature);
  698          require(recovered != address(0), "H21");
  699          if (recovered == signer) {
  700              return 0x1626ba7e;
  701          } else {
  ...
```

Library files with the primitive itself (not excerpted): `lib/oz-v4.7.3/contracts/utils/cryptography/ECDSA.sol`
