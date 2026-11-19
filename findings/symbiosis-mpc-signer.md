---
id: symbiosis-mpc-signer
title: "Symbiosis: forging the single MPC (threshold-ECDSA) key lets a quantum attacker release the Ethereum Portal's locked tokens through BridgeV2"
project: symbiosis
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x5523985926aa12ba58dc5ad00ddca99678d7227e"
  implementation: "0x1995bb51aabe557ce119249289c37e0bf5282f32"
  name: TransparentUpgradeableProxy → BridgeV2
  upgradeable: "yes"
  admin: ProxyAdmin 0x1da522b35363c1eda4833bc121c8f3c67b2caa75 and BridgeV2 owner(), both Safe 0x5112eba9bc2468bb5134cbfbeab9334edae7106a (3 of 5); mpc() = EOA 0x0b420240b32dd8722b869ae6d9ca9e3b9169ec08
  value_usd: 1420204
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 11729
families: []
fix:
  layer: onchain-config
  who_acts: "Symbiosis Safe 0x5112eba9bc2468bb5134cbfbeab9334edae7106a (3 of 5), BridgeV2 owner: changeMPC to a contract that verifies a post-quantum threshold signature through ERC-1271 (or upgrade via ProxyAdmin 0x1da522b35363c1eda4833bc121c8f3c67b2caa75); the MPC relayer network must produce that signature"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/symbiosis-mpc-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Blockscout-verified source of 0x1995bb51…; cast reads at block 26,431,623; Blockscout holdings
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 74b25166"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Symbiosis' Ethereum `BridgeV2` executes any cross-chain request that is signed by, or sent from, the `mpc()` address,
the single secp256k1 key produced by the relayers' threshold-ECDSA (MPC) network. A quantum attacker who derives that
key can call the whitelisted `Portal` and release its locked tokens (USD 1.42M on 2026-11-17), mint synthetic BTC
through `SynthesisBTC`, or hand the MPC role to themselves with `changeMPCSigned`. Rated MEDIUM: step 4: the 3-of-5
owner Safe can point `mpc` at a post-quantum ERC-1271 verifier contract, but that contract and the relayers' new
signature scheme do not exist yet.

## Mechanism

- `receiveRequestV2Signed(_callData, _receiveSide, signature)` is guarded by `onlySignedByMPC`, which calls
  OpenZeppelin 4.4.1 `SignatureChecker.isValidSignatureNow(mpc(), getRequestHash(...), signature)`: `ECDSA.tryRecover`
  first, then ERC-1271 on `mpc()` (`BridgeV2.sol` line 72-75). `receiveRequestV2` accepts the same request when
  `msg.sender == mpc()`, i.e. a transaction signed by the same key.
- `_processRequest` requires `isTransmitter[_receiveSide]` and then calls `_receiveSide.call(_callData)`. On Ethereum
  the receive sides seen are `Portal` 0xb8f275fb… (unlocks tokens to the recipient) and `SynthesisBTC` 0x416ebf83…
  (mints synthetic BTC); both have `bridge()` = this contract.
- `changeMPCSigned(_newMPC, signature)` lets the MPC key replace itself; `changeMPC` is open to the owner or the MPC.
  The MPC was last rotated on 2026-11-16 (`newMPCEffectiveTime` 1794812495; `oldMPC` 0xbe700bf5…), so rotation is
  routine, but every MPC key is secp256k1 and has signed on-chain.
- Pattern PQ-4: although the key is generated and used by a threshold group off-chain, on-chain it is one ECDSA
  public key; a CRQC needs one discrete logarithm, not a quorum. The draft's PQ-5/committee classification was changed
  accordingly.

## Evidence

- CHECKED (Blockscout-verified source of implementation 0x1995bb51…, `BridgeV2`, solc 0.8.19, OZ SignatureChecker
  v4.4.1): the path above.
- CHECKED (cast, block 26,431,623): `mpc()` = 0x0b420240…, no code (EOA); `owner()` = Safe 0x5112eba9…;
  `isTransmitter` true for Portal and SynthesisBTC; `Portal.bridge()` and `SynthesisBTC.bridge()` = BridgeV2
  ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/symbiosis-mpc-signer/escrow.json)).
- CHECKED (on-chain read at block 26,431,214): ProxyAdmin 0x1da522b3… owned by Safe 0x5112eba9…, threshold 3 of 5
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/symbiosis-mpc-signer/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): the latest 50 transactions to BridgeV2 are `receiveRequestV2Signed` (47 to
  Portal, 3 to SynthesisBTC), all sent by relayer 0x67f9b3e5…; Portal holds USD 1,420,204 (USDC USD 972.8k, WETH USD
  192.3k, SIS USD 146.0k, USDT USD 73.4k, others); SynthesisBTC holds nothing.
- CHECKED (Xatu, any function): 11,729 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/symbiosis-mpc-signer/activity.json)); `curated_contracts.csv`: 97,357 ecrecover
  calls in the last year.
- INFERRED: synthetic BTC minted through SynthesisBTC is not counted in the escrow; its damage depends on liquidity.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x55239859…` BridgeV2 (proxy) | yes (ProxyAdmin, Safe 3/5) | $789 (fees, 2026-11-17); escrow $1.42M | 2026-11-16 | 11,729 |

- Escrow: Portal `0xb8f275fbf7a959f4bce59999a2ef122a099e81a8`, USD 1,420,204 (Blockscout, 2026-11-17), put on the
  BridgeV2 entry with basis `escrow`. The draft's `held` value (USD 789 of collected fees in BridgeV2) is not the
  exposure and was replaced.
- The draft listed a family of 63 contracts with code key `0x1995bb51…`. The census grouped them by the generic
  OpenZeppelin `TransparentUpgradeableProxy` runtime code (deBridge's SignatureVerifier is in the same group); they
  are not Symbiosis deployments, so the family was removed.

## Remediation

- Replace the MPC's threshold ECDSA with a post-quantum threshold or multi-signature scheme, verified on-chain by a
  contract that implements ERC-1271; set it with `changeMPC`. Because `SignatureChecker` tries `ecrecover` first, a
  contract `mpc()` cannot be matched by any ECDSA signature, so the ordering is not a problem once `mpc()` is a
  contract. Alternatively upgrade `BridgeV2` to verify the new scheme directly.
- Who acts: Safe 0x5112eba9… (3 of 5; its owners are ECDSA keys and must move to post-quantum signers first) and the
  Symbiosis relayer/MPC network. The change must land before a CRQC exists: an attacker holding the current MPC key
  can call `changeMPCSigned` first.
- No Ethereum protocol change is needed or would help.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review06): LOW -> MEDIUM, step 4: no post-quantum path exists today; the fix is a new ERC-1271 verifier contract the owner Safe points `mpc` at plus a new relayer signature scheme, with USD 1.42M escrow in Portal. Pattern PQ-5 -> PQ-4 (one threshold-ECDSA key on-chain), trigger committee-keys -> operator-key, alternative -> configurable-verifier; spurious proxy-bytecode family and fee balance removed.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: symbiosis-mpc-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x5523985926aa12ba58dc5ad00ddca99678d7227e` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x1995bb51aabe557ce119249289c37e0bf5282f32` — BridgeV2 (verified source via blockscout)

### `contracts/synth-core/bridge/BridgeV2.sol`

```solidity
    3  pragma solidity ^0.8.4;
    4  
    5  import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
    6  import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
    7  import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
    8  
    9  import "../../utils/AdminableUpgradeable.sol";
   10  import "../../utils/RevertMessageParser.sol";
   11  import "../metarouter/MetaRouteStructs.sol";
  ...
   69          _;
   70      }
   71  
   72      modifier onlySignedByMPC(bytes32 hash, bytes memory signature) {
   73          require(SignatureChecker.isValidSignatureNow(mpc(), hash, signature), "BridgeV2: invalid signature");
   74          _;
   75      }
   76  
   77      /// @dev the bridge has no local `paused` flag, so only safe mode is checked
  ...
```

### `@openzeppelin/contracts/interfaces/IERC1271.sol`

```solidity
   14       * @dev Should return whether the signature provided is valid for the provided data
   15       * @param hash      Hash of the data to be signed
   16       * @param signature Signature byte array associated with _data
   17       */
   18      function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
   19  }
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`, `@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol`
