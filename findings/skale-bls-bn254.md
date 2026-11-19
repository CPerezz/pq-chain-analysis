---
id: skale-bls-bn254
title: "SKALE IMA: a quantum attacker who recovers an SKALE chain's BLS key (and one node key) can post forged exit messages to MessageProxyForMainnet and empty the IMA deposit boxes (about USD 9.3k)"
project: skale
status: confirmed
severity: MEDIUM
patterns: [PQ-6]
primitives: [bn254]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x32f50e2a898f14687f2a714d8b2d405317eb4641"
  implementation: "0x82146bb2b2997ccf5449bc6f162cd446f39a1251"
  name: AdminUpgradeabilityProxy -> SkaleVerifier
  upgradeable: "yes"
  admin: ProxyAdmin 0xf3f8b7594bf20a0e9502b3191cd4c2b90a1ab4f7, owner() Safe 0x13fd1622f0e7e50a87b79cb296cbaf18362631c0 (3 of 5), which also owns the IMA ProxyAdmin 0xa35d3ffc3812f6cad1ac64fde740a98bfb900627; read at block 26431553
  value_usd: 9257
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-08-28
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: SKALE, through Safe 0x13fd1622f0e7e50a87b79cb296cbaf18362631c0 (3 of 5), owner of ProxyAdmin 0xf3f8b7594bf20a0e9502b3191cd4c2b90a1ab4f7 (SkaleVerifier) and ProxyAdmin 0xa35d3ffc3812f6cad1ac64fde740a98bfb900627 (MessageProxyForMainnet and the deposit boxes)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/skale-bls-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

SKALE's mainnet bridge (IMA) accepts messages from a SKALE chain when they carry the chain's threshold BLS signature
on BN254, checked by `SkaleVerifier` (`0x32f50e2a…4641`) with the pairing precompile (PQ-6). The chain's common BLS
public key is stored on-chain, so a quantum attacker can recover the secret, sign withdrawal messages, and (with the
ECDSA key of one node of that chain, needed to relay) release what the IMA deposit boxes hold: USD 9,257 at
2026-11-17 (2.37 ETH plus USD 4,956 of tokens). SKALE's 3-of-5 Safe can upgrade the verifier and the IMA contracts.
Rated LOW: MEDIUM by step 4 (contract upgrade), lowered one level by step 5 (under USD 50k measured).

## Mechanism

- `MessageProxyForMainnet.postIncomingMessages` (`contracts/mainnet/MessageProxyForMainnet.sol` 283–329) requires
  `isAgentAuthorized` (the sender is a node address of the source chain, `SkaleManagerClient.sol` 87–90) and
  `_verifyMessages` (510–530), which calls `Schains.verifySchainSignature` (`0x0fca003f…cbf6`, implementation
  `0xa4991b17…d14d`, `contracts/Schains.sol` 262 ff.); that fetches `SkaleVerifier` from the ContractManager and
  calls `verify` with the chain's common (or, during node rotation, previous) public key from `KeyStorage`. Verified messages are delivered by
  `_callReceiverContract` to `DepositBoxEth`/`DepositBoxERC20`/`ERC721`/`ERC1155`, which release funds.
- `SkaleVerifier.verify` (`contracts/SkaleVerifier.sol` 55–~110) checks the signature is in G1, the hash point
  matches `hashA`/`hashB` and the key is in G2, then `Precompiled.bn256Pairing` (line 90; `staticcall` to 8 in
  `contracts/utils/Precompiled.sol` 107–111).
- Keys come from SKALE's DKG (`SkaleDkg*`, also pairing checks) and rotate per chain, but stay BLS on BN254
  (`key-rotation-only`).
- Pattern PQ-6. Excerpts: [`source-excerpts.md`](#source-excerpts-skale-bls-bn254).

## Evidence

- CHECKED (verified source, Sourcify): `SkaleVerifier` implementation `0x82146bb2…1251` and
  `MessageProxyForMainnet` implementation `0xd1ffc52c…788b`, lines above.
- CHECKED (on-chain reads at block 26,431,553): `MessageProxyForMainnet` `0x8629703a…a404`
  `contractManagerOfSkaleManager()` = `0xc04a10fd…a310`, whose `getContract("SkaleVerifier")` = `0x32f50e2a…`;
  `messageProxy()` of DepositBoxEth `0x49f583d2…df94`, DepositBoxERC20 `0x8fb1a35b…7669`, DepositBoxERC721
  `0x7343d31e…5f2d`, DepositBoxERC1155 `0x3c02fdee…871a` and CommunityPool `0x588801ca…1621` = `0x8629703a…`.
- CHECKED (same block): EIP-1967 admin slot of `0x32f50e2a…` = ProxyAdmin `0xf3f8b759…b4f7`; of the IMA proxies =
  ProxyAdmin `0xa35d3ffc…0627`; `owner()` of both = Safe `0x13fd1622…31c0`, threshold 3 of 5
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/skale-bls-bn254/escrow.json)).
- CHECKED (block 26,431,553): DepositBoxEth holds 2.374 ETH; DepositBoxERC20's priced tokens total USD 4,956 on
  Blockscout (largest GCR, DIVI; `balanceOf` checked for USDT 700, USDC 3.0, SKL 402); CommunityPool holds 13.33 ETH.
- CHECKED (precompile trace to March 2026): 390 transactions with `ecpairing` from `0x32f50e2a…` in the last year
  (last block 24,670,469).
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last 2026-08-28
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/skale-bls-bn254/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Escrow (IMA deposit boxes) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x32f50e2a…` AdminUpgradeabilityProxy -> SkaleVerifier | yes (Safe 3/5) | USD 9,257 (2026-11-17) | 2026-08-28 | 0 |

- Escrow: DepositBoxEth 2.374 ETH (USD 4,301 at USD 1,811.62/ETH) plus DepositBoxERC20 USD 4,956; NFTs in the
  ERC721/ERC1155 boxes are not priced.
- CommunityPool's 13.33 ETH (USD 24,142) holds users' gas deposits; forged messages could at most draw gas refunds
  from it [INFERRED], so it is not counted. Even counted, the total stays under USD 50k.
- `usd_tx_y1` (USD 1.42M) counts transfers in the year's bridge transactions, not what is held now.
- The draft's family entry (3 instances of the proxy code) is removed: that code hash is SKALE's generic
  AdminUpgradeabilityProxy, shared by KeyStorage, Nodes, ValidatorService and unrelated Syscoin contracts, not copies
  of SkaleVerifier. KeyStorage (`modexp`, 90 txs) and ValidatorService (`ecrecover`, 3 txs) are SKALE Manager
  internals not covered here.

## Remediation

- Post-quantum replacement: chain signatures with a post-quantum threshold scheme or hash-based signatures aggregated
  in a STARK, verified by a new `SkaleVerifier`/`Schains` implementation; node relayer keys moved to post-quantum
  accounts.
- Who must act: SKALE, through Safe `0x13fd1622…31c0` (3 of 5) upgrading via the two ProxyAdmins; the SKALE chains'
  nodes must adopt the new signature scheme. No protocol change needed.
- Users: withdraw bridged assets to mainnet if they do not need them on SKALE.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review05): MEDIUM -> LOW, step 5: escrow traced from `MessageProxyForMainnet` to the IMA deposit
  boxes and measured at USD 9,257 (block 26,431,553); admins re-read (both ProxyAdmins owned by the 3-of-5 Safe).
  Removed the family entry (shared proxy bytecode, not SkaleVerifier copies).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: skale-bls-bn254

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x32f50e2a898f14687f2a714d8b2d405317eb4641` — AdminUpgradeabilityProxy (verified source via sourcify)

## Implementation `0x82146bb2b2997ccf5449bc6f162cd446f39a1251` — SkaleVerifier (verified source via sourcify)

### `@skalenetwork/skale-manager-interfaces/ISkaleVerifier.sol`

```solidity
   23  
   24  import "./ISkaleDKG.sol";
   25  
   26  interface ISkaleVerifier {
   27      function verify(
   28          ISkaleDKG.Fp2Point calldata signature,
   29          bytes32 hash,
   30          uint counter,
   31          uint hashA,
  ...
```

### `contracts/SkaleVerifier.sol`

```solidity
   51      * - Hash is in G1.
   52      * - G2.one in G2.
   53      * - Public Key in G2.
   54      */
   55      function verify(
   56          ISkaleDKG.Fp2Point calldata signature,
   57          bytes32 hash,
   58          uint256 counter,
   59          uint256 hashA,
  ...
   86              G2Operations.isG2(publicKey),
   87              "Public Key not in G2"
   88          );
   89  
   90          return Precompiled.bn256Pairing({
   91              x1: signature.a,
   92              y1: newSignB,
   93              a1: g2.x.b,
   94              b1: g2.x.a,
  ...
```

### `contracts/dkg/SkaleDkgPreResponse.sol`

```solidity
  155                  value.b,
  156                  (indexOnSchain + 1) ** i
  157              );
  158              if (
  159                  !_checkPairing(
  160                      tmp,
  161                      verificationVector[i],
  162                      verificationVectorMultiplication[i]
  163                  )
  ...
  167          }
  168          return true;
  169      }
  170  
  171      function _checkPairing(
  172          ISkaleDKG.Fp2Point memory g1Mul,
  173          ISkaleDKG.G2Point memory verificationVector,
  174          ISkaleDKG.G2Point memory verificationVectorMultiplication
  175      ) private view returns (bool valid) {
  176          require(G1Operations.checkRange(g1Mul), "g1Mul is not valid");
  177          g1Mul.b = G1Operations.negate(g1Mul.b);
  178          ISkaleDKG.Fp2Point memory one = G1Operations.getG1Generator();
  179          return
  180              Precompiled.bn256Pairing({
  181                  x1: one.a,
  182                  y1: one.b,
  183                  a1: verificationVectorMultiplication.x.b,
  184                  b1: verificationVectorMultiplication.x.a,
  ...
```

### `contracts/dkg/SkaleDkgResponse.sol`

```solidity
  142  
  143          ISkaleDKG.G2Point memory g2 = G2Operations.getG2Generator();
  144  
  145          return
  146              Precompiled.bn256Pairing({
  147                  x1: share.a,
  148                  y1: share.b,
  149                  a1: g2.x.b,
  150                  b1: g2.x.a,
  ...
```

### `contracts/utils/Precompiled.sol`

```solidity
   72          require(success, "Multiplication failed");
   73          return (output[0], output[1]);
   74      }
   75  
   76      function bn256Pairing(
   77          uint256 x1,
   78          uint256 y1,
   79          uint256 a1,
   80          uint256 b1,
  ...
   85          uint256 a2,
   86          uint256 b2,
   87          uint256 c2,
   88          uint256 d2)
   89          internal view returns (bool pairing)
   90      {
   91          bool success;
   92          uint256[12] memory inputToPairing;
   93          inputToPairing[0] = x1;
   94          inputToPairing[1] = y1;
   95          inputToPairing[2] = a1;
   96          inputToPairing[3] = b1;
   97          inputToPairing[4] = c1;
   98          inputToPairing[5] = d1;
   99          inputToPairing[6] = x2;
  100          inputToPairing[7] = y2;
  101          inputToPairing[8] = a2;
  102          inputToPairing[9] = b2;
  103          inputToPairing[10] = c2;
  104          inputToPairing[11] = d2;
  105          uint256[1] memory out;
  106          // solhint-disable-next-line no-inline-assembly
  107          assembly {
  108              success := staticcall(not(0), 8, inputToPairing, mul(12, 0x20), out, 0x20)
  109          }
  110          require(success, "Pairing check failed");
  111          return out[0] != 0;
  112      }
  113  }
  ...
```
