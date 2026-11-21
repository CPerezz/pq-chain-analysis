---
id: ethena-minting-order-sig
title: "Ethena EthenaMinting: a recovered ECDSA key of a whitelisted benefactor (or its delegated signer) can sign USDe mint and redeem orders for it, even after the benefactor moves to post-quantum keys"
project: ethena
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0xe3490297a08d6fc8da46edb7b6142e4f461b62d3"
  implementation: null
  name: EthenaMinting
  upgradeable: "no"
  admin: DEFAULT_ADMIN_ROLE and owner EthenaTimelockController 0xe8dc0fab349ea169283c48ccfd09d797e6db7c94 (1-day delay); the same timelock owns USDe and can set a new minter
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 2010
families: []
fix:
  layer: new-deployment
  who_acts: Ethena, through EthenaTimelockController 0xe8dc0fab349ea169283c48ccfd09d797e6db7c94 (deploys a minting contract without the EIP712/ecrecover branch and calls USDe.setMinter); benefactors can sign with EIP1271 from smart accounts and revoke approvals
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-minting-order-sig
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
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-minting-order-sig/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: [usde-4c9edd58-permit-ecdsa-only, stakedusdev2-9d39a5de-permit-signature, anchoragetokenusdtb-c139190f-permit-signature, stakedena-8be3460a-permit-ecdsa-only]
---

## Summary

`EthenaMinting` lets the signer of a USDe mint or redeem order choose the scheme: `EIP712` goes to `ECDSA.recover`, `EIP1271` to the benefactor's `isValidSignature` (PQ-2). A quantum attacker who recovers the ECDSA key of a whitelisted benefactor, or of a signer the benefactor delegated to, can sign orders that move that benefactor's collateral or USDe, including after the benefactor has moved to post-quantum authorisation at the same address. Orders are only executed by Ethena's MINTER/REDEEMER role holders, and collateral goes only to the benefactor or beneficiaries it approved on-chain, so the contract's own $73.1M is not what is exposed; the benefactors' approvals and USDe are, and they are not measured. Rated MEDIUM (step 4): Ethena's timelock can point USDe at a new minting contract without the ECDSA branch.

## Mechanism

- `mint(order, route, signature)` (L234, `onlyRole(MINTER_ROLE)`) and `redeem(order, signature)` (L304, `onlyRole(REDEEMER_ROLE)`) call `verifyOrder`.
- `verifyOrder` (L496-535): `signature_type == EIP712` → `ECDSA.recover(taker_order_hash, signature_bytes)` must equal `order.benefactor` or a signer with `delegatedSigner[signer][benefactor] == ACCEPTED`; `EIP1271` → `IERC1271(order.benefactor).isValidSignature(hash, signature_bytes)` with the full signature. The signer, not the benefactor's account, picks the branch. Then: benefactor must be whitelisted (L518), and a beneficiary other than the benefactor must be in the benefactor's approved list (L521-525, set by the benefactor itself through `setApprovedBeneficiary`).
- What a valid order releases: `mint` pulls the benefactor's collateral (`safeTransferFrom(benefactor, custody…)`, L637) and mints USDe to the beneficiary; `redeem` burns the benefactor's USDe (`burnFrom`, L318) and sends collateral from the contract to the beneficiary.
- Pattern PQ-2: a benefactor that keeps its address (EIP-7702 or similar) and moves to post-quantum authorisation stays forgeable through the EIP712 branch with its old key. A benefactor with real contract code is reachable through EIP712 only via a delegated EOA signer it accepted.

Source excerpts: [`source-excerpts.md`](#source-excerpts-ethena-minting-order-sig).

## Evidence

- CHECKED (verified source, Sourcify full file `contracts/EthenaMinting.sol`, 2026-11-17): `mint`, `redeem`, `verifyOrder`, `setApprovedBeneficiary`, `_transferCollateral` as above; `USDe.setMinter` is `onlyOwner`.
- CHECKED (on-chain, block 26,431,494): EthenaMinting `owner()` and DEFAULT_ADMIN_ROLE = EthenaTimelockController `0xe8dc0fab…` (`getMinDelay()` 86,400 s); USDe `minter()` = EthenaMinting, USDe `owner()` = the same timelock; no proxy ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-minting-order-sig/review.json), [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-minting-order-sig/onchain.json)).
- CHECKED (precompile trace, all mainnet transactions to March 2026): ecrecover; 17,750 transactions with a pre-quantum call in the last year (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, any function): 2,010 transactions 2026-10-16 to 2026-11-16, last 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-minting-order-sig/activity.json)).
- INFERRED: which benefactors are EOAs, have delegated signers, or have open approvals to the contract; the whitelist is an internal set and was not enumerated.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x4019acd53df0c918eeb47cc4d633abdd4dee4b238c5fe9b63c160e31cfc98604` (block 26,409,914, position 3), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (190,815 gas); under EIP-8151 it also succeeds (193,915 gas). With one byte of code at the recovered signer
  `0xae0a739c3724bb5cd2bdcf73764c87a5a6ec21a3`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `e1ebe203` (EthenaMinting).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe3490297…` EthenaMinting | no | $73.1M (not the exposure) | 2026-11-16 | 2,010 |

- The contract holds $73.1M (USDC $31.1M, USDT $30.1M, USDtb $11.9M; block 26,431,214). A forged benefactor order cannot send it to the attacker: `redeem` pays only the benefactor or a beneficiary the benefactor approved on-chain, against the benefactor's own USDe. So `value_usd` is left null.
- Exposed: the collateral approvals and USDe of whitelisted benefactors whose ECDSA key (or delegated signer's key) is recoverable, moved without their consent into orders they did not sign. Not measured (whitelist and approvals not enumerated).
- Executing a forged order also needs a MINTER_ROLE or REDEEMER_ROLE holder to submit it. Those are Ethena's own keys; whether they are ECDSA EOAs was not checked here.
- Siblings: Ethena's tokens (USDe, sUSDe, sENA) are in [ethena-token-permit-ecdsa-only](ethena-token-permit-ecdsa-only.md).

## Remediation

- Ethena: deploy a minting contract that accepts only `EIP1271` (or checks `benefactor.code.length` first, PQ-13) and have EthenaTimelockController `0xe8dc0fab…` call `USDe.setMinter` to it. Meanwhile Ethena's minter service can refuse EIP712 orders for benefactors that have migrated, and the admin can remove benefactors from the whitelist.
- Benefactors: sign with `signature_type = EIP1271` from a smart account with a post-quantum signer, do not accept delegated EOA signers, and keep collateral approvals to the contract at zero between orders.
- Protocol change: EIP-8151 would help (it makes `ecrecover` fail for accounts with real code) but is not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review10): HIGH -> MEDIUM, step 4: the contract is immutable but replaceable by one known party: USDe's owner (EthenaTimelockController) sets the minter, and Ethena's role holders are the only submitters, so the fix is a new deployment. Removed the $73.1M held value: a forged order sends collateral only to benefactor-approved addresses. fix.layer account-migration -> new-deployment.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: ethena-minting-order-sig

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe3490297a08d6fc8da46edb7b6142e4f461b62d3` — EthenaMinting (verified source via sourcify)

### `contracts/EthenaMinting.sol`

```solidity
    6  
    7  import "./SingleAdminAccessControl.sol";
    8  import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
    9  import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
   10  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
   11  import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
   12  import "@openzeppelin/contracts/interfaces/IERC1271.sol";
   13  
   14  import "./interfaces/IUSDe.sol";
  ...
   52    /// @notice EIP712 domain hash
   53    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712_DOMAIN));
   54  
   55    /// @notice EIP 1271 magic value hash
   56    bytes4 private constant EIP1271_MAGICVALUE = bytes4(keccak256("isValidSignature(bytes32,bytes)"));
   57  
   58    /// @notice address denoting native ether
   59    address private constant NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
   60  
  ...
  473    }
  474  
  475    /// @notice hash an Order struct
  476    function hashOrder(Order calldata order) public view override returns (bytes32) {
  477      return ECDSA.toTypedDataHash(getDomainSeparator(), keccak256(encodeOrder(order)));
  478    }
  479  
  480    function encodeOrder(Order calldata order) public pure returns (bytes memory) {
  481      return abi.encode(
  ...
  500      returns (bytes32 taker_order_hash)
  501    {
  502      taker_order_hash = hashOrder(order);
  503      if (signature.signature_type == SignatureType.EIP712) {
  504        address signer = ECDSA.recover(taker_order_hash, signature.signature_bytes);
  505        if (!(signer == order.benefactor || delegatedSigner[signer][order.benefactor] == DelegatedSignerStatus.ACCEPTED))
  506        {
  507          revert InvalidEIP712Signature();
  508        }
  509      } else if (signature.signature_type == SignatureType.EIP1271) {
  510        if (
  511          IERC1271(order.benefactor).isValidSignature(taker_order_hash, signature.signature_bytes) != EIP1271_MAGICVALUE
  512        ) {
  513          revert InvalidEIP1271Signature();
  514        }
  515      } else {
  ...
```

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

### `lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol`

```solidity
   62       * section].
   63       *
   64       * CAUTION: See Security Considerations above.
   65       */
   66      function permit(
   67          address owner,
   68          address spender,
   69          uint256 value,
   70          uint256 deadline,
  ...
```

### `lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol`

```solidity
  102          bytes32 r,
  103          bytes32 s
  104      ) internal {
  105          uint256 nonceBefore = token.nonces(owner);
  106          token.permit(owner, spender, value, deadline, v, r, s);
  107          uint256 nonceAfter = token.nonces(owner);
  108          require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
  109      }
  110  
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol`
