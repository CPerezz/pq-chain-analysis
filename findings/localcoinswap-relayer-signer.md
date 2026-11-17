---
id: localcoinswap-relayer-signer
title: "LocalCoinSwap: a quantum attacker who recovers a seller's key, or the arbitrator's key, can release open P2P escrows in LocalCoinSwap's two escrow contracts ($70k) to the trade's buyer"
project: localcoinswap
status: confirmed
severity: MEDIUM
patterns: [PQ-1, PQ-4]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd"
  implementation: null
  name: LocalCoinSwapEthereumEscrow
  upgradeable: config-only
  admin: "owner EOA 0x7ab685a614d0aac012e85f778fcc36913f3b2271 (setRelayer, setArbitrator, setOwner); relayer and arbitrator EOA 0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5; read at block 26,431,454"
  value_usd: 31136
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-03
  txs_30d: 0
- address: "0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2"
  implementation: null
  name: LocalCoinSwapV2Escrow
  upgradeable: config-only
  admin: "owner EOA 0x7ab685a614d0aac012e85f778fcc36913f3b2271 (setRelayer, setArbitrator, setOwner); relayer and arbitrator EOA 0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5; read at block 26,431,454"
  value_usd: 38820
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-09-14
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "LocalCoinSwap (owner EOA 0x7ab685a614d0aac012e85f778fcc36913f3b2271; relayer EOA 0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5 signs the invitations that open escrows) deploys an escrow that verifies trader instructions through ERC-1271 or a post-quantum scheme and stops inviting trades into these two"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/localcoinswap-relayer-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/localcoinswap-relayer-signer/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

LocalCoinSwap's escrows hold a seller's crypto until the seller releases it to the buyer. Relayed instructions are
accepted on an `ecrecover` signature alone (PQ-1): a buyer who recovers the seller's key with a quantum computer can
release the escrow to themselves without paying; with the arbitrator EOA's key (it sends `resolveDispute`), a buyer can
have any of their open escrows paid out to themselves. The operator's ECDSA invitation key (PQ-4) only gates opening escrows with the caller's
own money, so nothing is taken through it. The two contracts held $70k of open trades on 2026-11-17. Rated MEDIUM
(step 4): the contracts cannot change, but LocalCoinSwap controls which contract new trades open in.

## Mechanism

- `relay` / `batchRelay` → `getRelayedSender`: `ecrecover` over `(tradeID, instructionByte, maximumGasPrice)`. A seller
  signature with `RELEASE_ESCROW` runs `doRelease`, paying the escrow (minus fees) to the trade's buyer; a buyer
  signature with `BUYER_CANCELS` returns it to the seller (LocalCoinSwapV2.sol `relay`, EthereumEscrow.sol line 267ff).
- `resolveDispute`: `msg.sender == arbitrator` and an `ecrecover` signature of the buyer or seller over
  `(tradeID, RESOLVE_DISPUTE)`; the arbitrator sets the buyer's share (0–100%).
- `createEscrow` / `relayEscrow`: `recoverAddress(keccak256(tradeHash)) == relayer`; the funds come from `msg.sender`, so
  forging the relayer's invitation takes nothing.
- Direct `release` (seller) and `buyerCancel` (buyer) are checked by `msg.sender`, so post-quantum smart accounts can
  trade here; but a trader's old ECDSA key keeps working in `relay` after they migrate, because the contract does not
  check for account code.

## Evidence

- CHECKED (verified source, Sourcify): both contracts' signature paths
  ([`source-excerpts.md`](#source-excerpts-localcoinswap-relayer-signer),
  [`notes.md`](#review-notes-localcoinswap-relayer-signer-2026-11-17)).
- CHECKED (on-chain read, block 26,431,454): `owner()` EOA `0x7ab685a6…`; `relayer()` and `arbitrator()` the same EOA
  `0x877cf5f0…` in both contracts; no proxy code.
- CHECKED (on-chain read, block 26,431,214): V1 17.186 ETH ($31.1k, of which 1.78 ETH accrued fees), V2 $38.8k in
  stablecoins ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/localcoinswap-relayer-signer/onchain.json)).
- CHECKED (Xatu, any function): no calls 2026-10-16 to 2026-11-16; last calls 2026-09-03 (V1) and 2026-09-14 (V2)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/localcoinswap-relayer-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0e87bf52…` LocalCoinSwapEthereumEscrow | config-only | $31k | 2026-09-03 | 0 |
| `0x3bae89b2…` LocalCoinSwapV2Escrow | config-only | $39k | 2026-09-14 | 0 |

The held balances are the escrowed funds of open trades (plus accrued fees) and are the exposure: $70.0k on 2026-11-17.
An attacker gains only from trades where they are, or control, the buyer. Yearly pre-quantum counts from the census
(`txs_y1`): 62,911 (V1) and 29,340 (V2).

## Remediation

- LocalCoinSwap deploys an escrow whose relayed instructions and dispute signatures go through ERC-1271 for accounts
  with code (or a post-quantum signature scheme) and has the relayer `0x877cf5f0…` stop signing invitations for these two
  contracts; open trades then close out. The owner `0x7ab685a6…` can also move the arbitrator role to a post-quantum
  smart account with `setArbitrator`, which removes the arbitrator half of the dispute path.
- EIP-8151 would help: it makes `ecrecover` fail for traders who migrated to accounts with code, which closes `relay`
  for them without the team.
- Traders can use the direct `release` / `buyerCancel` calls and avoid signing relayed instructions.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM unchanged (step 4: new deployment the operator routes trades to; $70k held is over $50k). Trigger operator-key -> user-key and patterns [PQ-4] -> [PQ-1, PQ-4]: the relayer invitation cannot move funds; the seller's relayed release signature and the dispute signature can. Alternative key-rotation-only -> alternative-exists (direct release/cancel by msg.sender). Protocol change not-needed -> helps (EIP-8151).

# Source excerpts: localcoinswap-relayer-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd` — LocalCoinSwapEthereumEscrow (verified source via sourcify)

### `contracts/localcoinswap/EthereumEscrow.sol`

```solidity
  441          bytes32 _s
  442      ) private pure returns (address) {
  443          bytes memory _prefix = "\x19Ethereum Signed Message:\n32";
  444          bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
  445          return ecrecover(_prefixedHash, _v, _r, _s);
  446      }
  447  }
  ...
```


## Contract `0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2` — LocalCoinSwapV2Escrow (verified source via sourcify)

### `contracts/localcoinswap/LocalCoinSwapV2.sol`

```solidity
    4  import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    5  
    6  
    7  contract Token is IERC20 {
    8      function transferWithAuthorization(
    9          address from,
   10          address to,
   11          uint256 value,
   12          uint256 validAfter,
  ...
  119          require(_value > minimumTradeValue, "Escrow value must be greater than minimum value"); // Check escrow value is greater than minimum value
  120          require(recoverAddress(_invitationHash, _v, _r, _s) == relayer, "Transaction signature did not come from relayer");
  121  
  122          // Perform gasless send from seller to contract
  123          Token(_currency).transferWithAuthorization(
  124              msg.sender,
  125              address(this),
  126              _value,
  127              0,
  ...
  393          bytes32 _s
  394      ) private pure returns (address) {
  395          bytes memory _prefix = "\x19Ethereum Signed Message:\n32";
  396          bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
  397          return ecrecover(_prefixedHash, _v, _r, _s);
  398      }
  399  
  400      function getRelayedSender(
  401        bytes16 _tradeID,
  ...
```

# Review notes: localcoinswap-relayer-signer (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(`contracts/localcoinswap/EthereumEscrow.sol`, `contracts/localcoinswap/LocalCoinSwapV2.sol`, Solidity 0.5.17).

## Roles

| Contract | `owner()` | `relayer()` | `arbitrator()` |
|---|---|---|---|
| `0x0e87bf5286c4091e0eeb7814d802115dfbb4c4cd` LocalCoinSwapEthereumEscrow | EOA `0x7ab685a614d0aac012e85f778fcc36913f3b2271` | EOA `0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5` | same EOA `0x877cf5f0…` |
| `0x3bae89b27cc92c8f3fc97617cdd0f196e992e4b2` LocalCoinSwapV2Escrow | EOA `0x7ab685a6…` | EOA `0x877cf5f0…` | same EOA `0x877cf5f0…` |

No proxies. Owner functions: `setRelayer`, `setArbitrator`, `setOwner`, `withdrawFees` (accrued fees only), V2
`setMinimumValue`, and in V1 the ERC-20 helpers `transferToken`/`transferTokenFrom`/`approveToken` (V1 escrows hold ETH).
The verification code cannot be changed. V1 `feesAvailableForWithdraw()` = 1.7777 ETH of its 17.19 ETH.

## Signature checks (V2; V1 is the same shape with ETH)

- `createEscrow` / `relayEscrow`: `recoverAddress(keccak256(tradeHash), v, r, s) == relayer` (invitation). The escrowed
  funds come from `msg.sender` (`safeTransferFrom` / `transferWithAuthorization`; V1 `msg.value`). A forged invitation
  only lets someone open an escrow with their own money.
- `relay` / `batchRelay`: `getRelayedSender` = `ecrecover` over `(tradeID, instructionByte, maximumGasPrice)`. If the
  signer is the seller and the instruction is `RELEASE_ESCROW`, the escrow is paid to the trade's buyer
  (`doRelease` → `transferMinusFees(…, _buyer, …)`); if the signer is the buyer and the instruction is `BUYER_CANCELS`,
  it is returned to the seller.
- `resolveDispute`: `onlyArbitrator` (`msg.sender == arbitrator`) plus an `ecrecover` signature by the buyer or the seller
  over `(tradeID, RESOLVE_DISPUTE)`; the arbitrator chooses `_buyerPercent` (0–100).
- `release` (seller) and `buyerCancel` (buyer) also exist as direct calls checked by `msg.sender`, so a contract account
  can act without ECDSA.

## Holdings

`onchain.json` (block 26,431,214): V1 17.186 ETH ($31,136); V2 $38,820 (USDT $24,647, USDC $12,871, LCS $981, DAI $298, …).
These are the funds of open trades plus accrued fees.
