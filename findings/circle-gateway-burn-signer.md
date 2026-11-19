---
id: circle-gateway-burn-signer
title: "Circle Gateway: a quantum attacker who recovers Circle's burn-signer and TEE vouch ECDSA keys can debit depositors' $56M USDC balances in GatewayWallet"
project: circle
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-2, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x77777777dcc4d5a8b6e418fd04d8997ef11000ee"
  implementation: "0xf7a6d9d7df917c072ac8987a820c58aa27a0e798"
  name: ERC1967Proxy -> GatewayWallet
  upgradeable: "yes"
  admin: "UUPS owner 0x2a6a86466f181721ec8ff946967b56f1aa4758c5 (EOA; upgrades and adds/removes burn signers); read at block 26431457"
  value_usd: 56445665
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 3271
families: []
fix:
  layer: contract-upgrade
  who_acts: "Circle: GatewayWallet owner 0x2a6a86466f181721ec8ff946967b56f1aa4758c5 upgrades the implementation to verify post-quantum burn-signer and TEE signatures"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-burn-signer
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
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-burn-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 87c31271"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [circle-cctp-attesters, circle-gateway-minter-attestation-key, circle-usdc-permit-code-first]
---

## Summary

GatewayWallet holds USDC that depositors keep available for Circle Gateway's cross-chain transfers. Its
`gatewayBurn` debits and burns depositors' balances when a batch is signed by a Circle burn signer (one ECDSA key,
PQ-4) and each burn intent is signed by the depositor, or vouched for by a registered TEE ECDSA key; depositor
signatures are tried with `ecrecover` first and ERC-1271 only for allowlisted contracts (PQ-2). A quantum attacker who
recovers the burn-signer key and a TEE key (or a depositor's key) can burn depositors' balances, $56.4M of USDC now;
with Circle's GatewayMinter attestation key as well, the matching mint on the destination goes to the attacker.
Rated MEDIUM (step 4): Circle's owner key can upgrade the contract.

## Mechanism

- `Burns.gatewayBurn(calldataBytes, signature)` (l.173) -> `_verifyBurnSignerSignature` (l.253-258):
  `ECDSA.recover(keccak256(calldataBytes).toEthSignedMessageHash(), signature)` must be in `burnSigners`
  (`addBurnSigner` / `removeBurnSigner`, `onlyOwner`, l.214-231).
- For each intent, `_validateSignatureAndGetSigner` (l.316-359): `ECDSA.tryRecover(digest, signature)` first; accepted
  if it recovers the intent's source signer (EOA path) or any `isContractSignatureSigner` (TEE vouch path); otherwise
  ERC-1271 with the full signature, but only if the source signer `_wasEverAllowlistedContractSigner`.
- `_processIntentsAndBurn` (l.366 onward) debits the depositor's balance in the wallet, burns the tokens and sends the
  fee (at most the intent's `maxFee`) to `feeRecipient`.
- Withdrawals by depositors (`initiateWithdrawal` / `withdraw`, Withdrawals.sol l.76-104) need no signature.

Patterns PQ-4 (burn signer, TEE vouch key) and PQ-2 (depositor intents). Excerpts:
[`source-excerpts.md`](#source-excerpts-circle-gateway-burn-signer).

## Evidence

- CHECKED (Sourcify verified source of `0xf7a6d9d7…`, read 2026-11-17): the functions and lines above
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-burn-signer/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0xf7a6d9d7…`; `owner()` `0x2a6a8646…` (EOA, no
  code), `pendingOwner()` zero; `pauser()` `0x9812d5f0…`; `paused()` false; USDC balance 56,445,664.98.
- CHECKED (precompile trace to March 2026): `ecrecover`; 2,606 pre-quantum calls in the year
  (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 3,271 transactions called the wallet (any function)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-gateway-burn-signer/activity.json)).
- NOT READ: the current burn-signer and TEE signer sets (mappings; events not enumerated).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x77777777…` ERC1967Proxy -> GatewayWallet | yes | $56.4M (USDC) | 2026-11-16 | 3,271 |

The wallet's holdings are the depositors' balances and are what forged burns debit. The mint side, GatewayMinter
`0x2222222d7164433c4c09b0b0d809a9b52c04c205` (one ECDSA attestation signer; $136.6M of USDC, EURC and cirBTC minter
allowance at block 26,431,457), is covered in `circle-gateway-minter-attestation-key`.

## Remediation

- Circle (owner `0x2a6a8646…`): upgrade GatewayWallet so batches and TEE vouches are verified with a post-quantum
  scheme (ML-DSA or hash-based signatures, through an ERC-7913 verifier), and send depositor intents from accounts with
  code to ERC-1271 first instead of only allowlisted contracts. Rotating burn signers alone does not help.
- The owner key itself is an ECDSA EOA; moving ownership to a post-quantum account is part of the fix.
- Depositors: withdraw (`initiateWithdrawal` then `withdraw`) if Circle has not upgraded; balances in the wallet are
  exposed to forged burns.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: one owner key can upgrade). Mechanism read in verified source: burn-signer key plus depositor or TEE vouch signature needed; PQ-2 added for depositor intents; owner confirmed as an EOA at block 26,431,457; holdings re-read ($56.4M USDC); GatewayMinter found and filed as `circle-gateway-minter-attestation-key`.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: circle-gateway-burn-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x77777777dcc4d5a8b6e418fd04d8997ef11000ee` — ERC1967Proxy (verified source via sourcify)

## Implementation `0xf7a6d9d7df917c072ac8987a820c58aa27a0e798` — GatewayWallet (verified source via sourcify)

### `lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol`

```solidity
   12       * @dev Should return whether the signature provided is valid for the provided data
   13       * @param hash      Hash of the data to be signed
   14       * @param signature Signature byte array associated with _data
   15       */
   16      function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
   17  }
  ...
```

### `src/interfaces/IERC7597.sol`

```solidity
   31      /// @param value       Amount of allowance
   32      /// @param deadline    The time at which the signature expires (unix time), or max uint256 value to signal no
   33      ///                    expiration
   34      /// @param signature   Signature byte array signed by an EOA wallet or a contract wallet
   35      function permit(address owner, address spender, uint256 value, uint256 deadline, bytes memory signature) external;
   36  }
  ...
```

### `src/modules/wallet/Batches.sol`

```solidity
   16   * limitations under the License.
   17   */
   18  pragma solidity ^0.8.29;
   19  
   20  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
   21  import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
   22  import {GatewayCommon} from "src/GatewayCommon.sol";
   23  import {AddressLib} from "src/lib/AddressLib.sol";
   24  import {BatchedDelta} from "src/lib/BatchedDelta.sol";
  ...
  161          internal
  162          view
  163          returns (address)
  164      {
  165          address recoveredSigner = ECDSA.recover(keccak256(calldataBytes).toEthSignedMessageHash(), signature);
  166          if (!isBatchSigner(recoveredSigner)) {
  167              revert InvalidBatchSigner();
  168          }
  169  
  ...
```

### `src/modules/wallet/Burns.sol`

```solidity
   18  pragma solidity ^0.8.29;
   19  
   20  import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
   21  import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
   22  import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
   23  import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
   24  import {SignatureChecker} from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
   25  import {GatewayCommon} from "src/GatewayCommon.sol";
   26  import {IBurnableToken} from "src/interfaces/IBurnableToken.sol";
   27  import {AddressLib} from "src/lib/AddressLib.sol";
   28  import {BurnIntentLib} from "src/lib/BurnIntentLib.sol";
  ...
  250      ///
  251      /// @param calldataBytes   Calldata that includes all of intents, signatures, and fees
  252      /// @param signature       The signature on the `calldataBytes` from a valid burn signer
  253      function _verifyBurnSignerSignature(bytes calldata calldataBytes, bytes calldata signature) internal view {
  254          address recoveredSigner = ECDSA.recover(keccak256(calldataBytes).toEthSignedMessageHash(), signature);
  255          if (!isBurnSigner(recoveredSigner)) {
  256              revert InvalidBurnSigner();
  257          }
  258      }
  ...
  302          }
  303  
  304          // Validate signature and get the effective signer
  305          bytes32 digest = _hashTypedData(BurnIntentLib.getTypedDataHash(intent));
  306          address signer = _validateSignatureAndGetSigner(cursor, digest, signature);
  307          _processIntentsAndBurn(cursor, signer, fees);
  308      }
  309  
  310      /// Validates signature using ECDSA or EIP-1271 and returns the effective signer
  ...
  312      /// @param cursor      The cursor positioned at the burn intent(s)
  313      /// @param digest      The typed data hash to validate
  314      /// @param signature   The signature to validate
  315      /// @return signer     The validated signer address
  316      function _validateSignatureAndGetSigner(Cursor memory cursor, bytes32 digest, bytes memory signature)
  317          private
  318          view
  319          returns (address signer)
  320      {
  ...
  322          address sourceSigner = BurnIntentLib._getSourceSignerFromCursor(cursor);
  323  
  324          // Attempt ECDSA recovery - used by EOA and TEE vouch paths
  325          // Use tryRecover to gracefully handle non-standard signature formats that EIP-1271 contracts may accept
  326          (address recoveredSigner, ECDSA.RecoverError err,) = ECDSA.tryRecover(digest, signature);
  327  
  328          // If ECDSA recovery succeeded, check EOA and TEE paths
  329          if (err == ECDSA.RecoverError.NoError) {
  330              // Path 1: EOA (most common - optimized for gas efficiency)
  331              // Standard ECDSA signature where recovered signer matches source signer
  332              if (recoveredSigner == sourceSigner) {
  333                  return sourceSigner;
  ...
  341          }
  342  
  343          // Path 3: Allowlisted contracts use EIP-1271 signature validation
  344          if (_wasEverAllowlistedContractSigner(sourceSigner)) {
  345              if (!SignatureChecker.isValidERC1271SignatureNow(sourceSigner, digest, signature)) {
  346                  revert InvalidSignature();
  347              }
  348              return sourceSigner;
  349          }
  350  
  351          // If ECDSA recovery failed and no other path matched, invalid signature
  352          if (err != ECDSA.RecoverError.NoError) {
  353              revert InvalidSignature();
  354          }
  355  
  356          // ECDSA recovery succeeded but didn't match EOA or TEE paths
  ...
```

### `src/modules/wallet/Deposits.sol`

```solidity
  238          address depositor = owner;
  239          _increaseAvailableBalance(token, depositor, value);
  240  
  241          // Execute the permit and transfer the tokens from the depositor to this contract
  242          IERC7597(token).permit(depositor, address(this), value, deadline, signature);
  243          IERC20(token).safeTransferFrom(depositor, address(this), value);
  244  
  245          // Emit an event to signal the deposit
  246          emit Deposited(token, owner, owner, value);
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`, `lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol`
