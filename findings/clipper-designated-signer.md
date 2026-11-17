---
id: clipper-designated-signer
title: "Clipper Caravel exchange: forging the one immutable quote-signer ECDSA key lets an attacker sign deposits, withdrawals and swaps that drain the USD 343k pool"
project: clipper
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x655edce464cc797526600a462a8154650eee4b77"
  implementation: null
  name: ClipperApproximateCaravelExchange
  upgradeable: "no"
  admin: DESIGNATED_SIGNER 0x08938a61ba9523298dbcacee0cda5b371fb7f1f8 is immutable; owner Safe 0xd8cc0304de58fce5147796606db14500d94b5ef2 (3 of 9) can only add assets and set the triage role that halts trading (triageRole unset, block 26,431,542)
  value_usd: 342856
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 11
families: []
fix:
  layer: new-deployment
  who_acts: Clipper, through owner Safe 0xd8cc0304de58fce5147796606db14500d94b5ef2 (3 of 9) and its off-chain quote signer, deploying a new exchange; liquidity providers withdraw with burnToWithdraw and move
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/clipper-designated-signer
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
  who: review (Review04)
  ref: Sourcify source of 0x655edce4; cast reads at block 26,431,542
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Every deposit, single-asset withdrawal and swap on Clipper's Caravel exchange needs an EIP-712 signature from one
immutable secp256k1 key, `DESIGNATED_SIGNER` `0x08938a61…` (PQ-4). The key signs every quote, so its public key is
public; a quantum attacker who recovers it can sign a deposit that mints pool tokens for nothing and then withdraw the
whole pool, or sign swaps at any price. The pool holds USD 343k (WETH, USDC, DAI, USDT). Rated MEDIUM, step 4: the
signer cannot be changed, so Clipper must deploy a new exchange and liquidity providers must move; that is one team's
release, and the value (over USD 50k) does not lower it.

## Mechanism

- `ClipperCommonExchange.verifyDigestSignature` (source lines 361–370) runs `ECDSA.recover(digest, v, r, s)` and
  accepts if the result is `DESIGNATED_SIGNER`, or if `ECDSA.recover(keccak256(digest, tx.origin), …)` is. No
  ERC-1271 path.
- Called by `deposit`, `depositSingleAsset`, `transmitAndDeposit(SingleAsset)` (mints `poolTokens` stated in the
  signed message), `withdrawSingleAsset` (pays `assetAmount` stated in the message), and `swap`, `transmitAndSwap`,
  `sellEthForToken`, `sellTokenForEth`, `transmitAndSellTokenForEth` (output amount and the packed off-chain
  balances for the Caravel invariant come from the signed `goodUntil`).
- `DESIGNATED_SIGNER` is `immutable` (set in the constructor, line 38); the contract is not a proxy. The owner can
  only `addAsset`, `setTriageRole` and transfer ownership; the triage role can `stopTrade`, which blocks every signed
  path (`marketIsRunning`) and leaves only unsigned `burnToWithdraw`.
- The pool token itself also has an ECDSA-only EIP-2612 `permit` (PQ-1, auxiliary; it moves LP tokens only).
- Source excerpts: [`source-excerpts.md`](#source-excerpts-clipper-designated-signer).

## Evidence

- CHECKED (Sourcify-verified source, full file): the functions above; `DESIGNATED_SIGNER` immutable; no setter.
- CHECKED (`cast call` at block 26,431,542): `DESIGNATED_SIGNER() = 0x08938a61ba9523298dbcacee0cda5b371fb7f1f8`,
  `owner() = 0xd8cc0304…` (Safe, threshold 3 of 9 per [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/clipper-designated-signer/onchain.json),
  block 26,431,214), `triageRole() = 0x0`, `isTradeHalted() = false`, `nTokens() = 5`.
- CHECKED (on-chain read at block 26,431,214): holdings USD 342,856: WETH 121k, USDC 93k, DAI 70k, USDT 58k.
- CHECKED (precompile trace, `studies/top-callers-classification/results/curated_contracts.csv`): 69,138 transactions with `ecrecover` in the year to
  March 2026 (`txs_y1`); last ecrecover block 24,238,924.
- CHECKED (Xatu, any function): 11 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/clipper-designated-signer/activity.json)).
- CHECKED (`data/caller_master.parquet`): no other contract named Clipper called a pre-quantum precompile in the trace.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x655edce4…` ClipperApproximateCaravelExchange | no | $343k | 2026-11-15 | 11 |

The exposure is the pool itself (held, 2026-11-17): a forged deposit signature mints arbitrary pool tokens and
`burnToWithdraw` then pays out the whole pool pro rata. Activity is low now (11 transactions in 30 days) but the path
is live.

## Remediation

- Post-quantum replacement: a new exchange whose quote check verifies a post-quantum signature (for example through
  an ERC-7913 verifier or an ERC-1271 signer contract), with a new post-quantum quote key.
- Who acts: Clipper, via owner Safe `0xd8cc0304de58fce5147796606db14500d94b5ef2` (3 of 9) and the quote-signing
  service; liquidity providers withdraw with `burnToWithdraw` (no signature needed) and deposit into the new
  exchange. Emergency mitigation: the owner Safe sets a triage address that calls `stopTrade`, which disables every
  signed path. No protocol change is needed; EIP-8151 does not apply (the signer is an EOA key).
- The owner Safe's own owners are ECDSA keys (PQ-12), which matters for the triage mitigation.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review04): MEDIUM kept (step 4: new deployment by one team; value USD 343k). Read the signer address, owner powers and triage state on-chain; corrected `admin`/`who_acts` (the owner Safe can halt trading but not change the signer).

# Source excerpts: clipper-designated-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x655edce464cc797526600a462a8154650eee4b77` — ClipperApproximateCaravelExchange (verified source via sourcify)

### `contracts/ClipperCommonExchange.sol`

```solidity
    6  import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
    7  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    8  import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    9  import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
   10  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
   11  import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
   12  
   13  import "./interfaces/WrapperContractInterface.sol";
   14  
  ...
  338    }
  339  
  340    function createSwapDigest(address inputToken, address outputToken, uint256 inputAmount, uint256 outputAmount, uint256 goodUntil, address destinationAddress) internal view returns (bytes32 digest){
  341      bytes32 hashedInput = hashInputOffer(inputToken, outputToken, inputAmount, outputAmount, goodUntil, destinationAddress);    
  342      digest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, hashedInput);
  343    }
  344  
  345    function createDepositDigest(address sender, uint256[] calldata depositAmounts, uint256 nDays, uint256 poolTokens, uint256 goodUntil) internal view returns (bytes32 depositDigest){
  346      bytes32 hashedInput = hashDeposit(sender, depositAmounts, nDays, poolTokens, goodUntil);    
  347      depositDigest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, hashedInput);
  348    }
  349  
  350    function createSingleDepositDigest(address sender, address inputToken, uint256 inputAmount, uint256 nDays, uint256 poolTokens, uint256 goodUntil) internal view returns (bytes32 depositDigest){
  351      bytes32 hashedInput = hashSingleDeposit(sender, inputToken, inputAmount, nDays, poolTokens, goodUntil);
  352      depositDigest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, hashedInput);
  353    }
  354  
  355    function createWithdrawalDigest(address tokenHolder, uint256 poolTokenAmountToBurn, address assetAddress, uint256 assetAmount,
  356                      uint256 goodUntil) internal view returns (bytes32 withdrawalDigest){
  357      bytes32 hashedInput = hashWithdrawal(tokenHolder, poolTokenAmountToBurn, assetAddress, assetAmount, goodUntil);
  358      withdrawalDigest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, hashedInput);
  359    }
  360  
  361    function verifyDigestSignature(bytes32 theDigest, Signature calldata theSignature) internal view {
  362      address signingAddress = ECDSA.recover(theDigest, theSignature.v, theSignature.r, theSignature.s);
  363  
  364      if(signingAddress != DESIGNATED_SIGNER){
  365        // Check for signing with embedded tx.origin
  366        signingAddress = ECDSA.recover(keccak256(abi.encodePacked(theDigest, tx.origin)), theSignature.v, theSignature.r, theSignature.s);
  367        if(signingAddress != DESIGNATED_SIGNER){
  368          revert ClipperDataValidation();
  369        }
  370      }
  ...
```

### `@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol`

```solidity
    4  pragma solidity ^0.8.0;
    5  
    6  import "./draft-IERC20Permit.sol";
    7  import "../ERC20.sol";
    8  import "../../../utils/cryptography/ECDSA.sol";
    9  import "../../../utils/cryptography/EIP712.sol";
   10  import "../../../utils/Counters.sol";
   11  
   12  /**
  ...
   45  
   46      /**
   47       * @dev See {IERC20Permit-permit}.
   48       */
   49      function permit(
   50          address owner,
   51          address spender,
   52          uint256 value,
   53          uint256 deadline,
  ...
   60          bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
   61  
   62          bytes32 hash = _hashTypedDataV4(structHash);
   63  
   64          address signer = ECDSA.recover(hash, v, r, s);
   65          require(signer == owner, "ERC20Permit: invalid signature");
   66  
   67          _approve(owner, spender, value);
   68      }
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

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`, `@openzeppelin/contracts/utils/cryptography/EIP712.sol`
