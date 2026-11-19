---
id: circle-cctp-attesters
title: "Circle CCTP: a quantum attacker who recovers 2 of Circle's attester ECDSA keys can forge burn messages and mint up to $966M of USDC on mainnet through the V1 and V2 MessageTransmitters"
project: circle
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-18]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x0a992d191deec32afe36203ad87d7d289a738f81"
  implementation: null
  name: MessageTransmitter (CCTP V1)
  upgradeable: config-only
  admin: "owner 0x4aa5bf962852dcc59695f600d346d3f751b0d920 (EOA); attesterManager 0x358a85e032aa9507a1303683b2b6a1d1cac3c252 (EOA) enables/disables attesters and sets the threshold; no upgrade path (read at block 26431457)"
  value_usd: 105437276
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 12342
- address: "0x81d40f21f12a8f0e3252bccb954d722d4c464b64"
  implementation: "0xa30c41865729c248067704d4db9f38385cbe1186"
  name: MessageTransmitterV2 (AdminUpgradableProxy)
  upgradeable: "yes"
  admin: "proxy admin 0xb7569e9eb64eaed5c4166e510b4f6ff54ef42258 (EOA); owner 0xb43aa882f497c0ecb395a5a54f8fa29d12289f65 (EOA); attesterManager 0xc16b03f84563c1467017c9f7216f8ad6098dc95a (EOA) (read at block 26431457)"
  value_usd: 860775320
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 151786
families: []
fix:
  layer: contract-upgrade
  who_acts: "Circle: V2 proxy admin 0xb7569e9eb64eaed5c4166e510b4f6ff54ef42258 upgrades Attestable to post-quantum attestations; V1 cannot be upgraded, so Circle (USDC masterMinter) removes the V1 TokenMinter 0xc4922d64a24675e16e1586e3e3aa56c06fabe907 as a minter or moves V1 traffic to V2"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-cctp-attesters
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
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-cctp-attesters/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families db178bca, ac1ef7c2"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [circle-gateway-burn-signer, circle-gateway-minter-attestation-key, circle-usdc-permit-code-first]
---

## Summary

CCTP's MessageTransmitters accept a cross-chain message when `signatureThreshold` (2) enabled attesters, Circle's
ECDSA keys, have signed it (PQ-5). A quantum attacker who recovers two attester keys can forge a "burned on the source
chain" message, and TokenMessenger mints USDC to any recipient through its TokenMinter, up to the minter's USDC
allowance: 105.4M USDC through V1 and 860.8M USDC through V2 at block 26,431,457. Rated MEDIUM (step 4): V2 is
upgradeable by Circle's proxy admin, and Circle can remove V1's mint power as USDC master minter.

## Mechanism

- `MessageTransmitterV2.receiveMessage(message, attestation)` (l.206) -> `_verifyAttestationSignatures` (call at l.287;
  Attestable.sol l.227-263): the attestation is `signatureThreshold` × 65-byte signatures, each
  `ECDSA.recover(digest, signature)` (`_recoverAttesterSignature`, l.271-275), in increasing address order, each an
  enabled attester. It then calls the recipient's `handleReceiveFinalizedMessage` / `handleReceiveUnfinalizedMessage`
  (l.226-242).
- V1 `MessageTransmitter.receiveMessage` -> `Attestable._verifyAttestationSignatures`: same scheme, `ecrecover` on 65-byte
  signatures (excerpt l.2880).
- Recipient TokenMessenger (V1 `0xbd3fa81b58ba92a82136038b25adec7066af3155`, V2
  `0x28b5a0e9c621a5badaa536219b3a228c8168cf5d`) mints through its `localMinter()` (V1 TokenMinter `0xc4922d64…`, V2
  TokenMinterV2 `0xfd78ee91…`), both USDC minters.
- Attesters and threshold are managed by `attesterManager` (`enableAttester`, `disableAttester`,
  `setSignatureThreshold`); this rotates keys, not the scheme.

Pattern PQ-5. Excerpts: [`source-excerpts.md`](#source-excerpts-circle-cctp-attesters).

## Evidence

- CHECKED (Sourcify verified source of `0xa30c4186…`, read 2026-11-17; V1 from the excerpt): the functions above.
- CHECKED (on-chain at block 26,431,457): both transmitters `signatureThreshold()` = 2 with 2 enabled attesters (V1
  `0xb0ea8e1b…`, `0xe2fefe09…`; V2 `0x725b06f7…`, `0x52ed4cbf…`); V1 has no proxy slots; V2 implementation `0xa30c4186…`,
  proxy admin `0xb7569e9e…`; owners, attester managers and the V2 proxy admin are EOAs
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-cctp-attesters/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): `TokenMessenger.localMessageTransmitter()` points at each transmitter;
  `localMinter()` gives the TokenMinters; USDC `isMinter` true for both, `minterAllowance` 105,437,275.81 (V1) and
  860,775,320.04 (V2); EURC `isMinter` false for both.
- CHECKED (precompile trace to March 2026): 261,712 (V1) and 248,721 (V2) pre-quantum calls in the year
  (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 12,342 and 151,786 transactions (any function)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-cctp-attesters/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Escrow (mint allowance) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0a992d19…` MessageTransmitter (V1) | config-only | $105.4M | 2026-11-16 | 12,342 |
| `0x81d40f21…` MessageTransmitterV2 | yes | $860.8M | 2026-11-16 | 151,786 |

The transmitters hold almost nothing ($11 of USDC in V2). The exposure is the USDC each TokenMinter can mint now
(`minterAllowance`), $966.2M together; Circle's master minter can raise it, so this is the current, not the maximum,
amount. Other applications that receive CCTP messages through the transmitters were not measured.

## Remediation

- V2 (proxy admin `0xb7569e9e…`): upgrade `Attestable` to verify post-quantum attestations (ML-DSA or hash-based
  signatures per attester, or one succinct proof over them). Rotating attesters does not help.
- V1 (immutable): Circle's USDC master minter sets the V1 TokenMinter's allowance to zero or removes it as a minter
  once V1 traffic has moved to V2.
- The owner, attester-manager and proxy-admin keys are ECDSA EOAs; they must also move to post-quantum control.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: V2 upgrade by Circle's proxy admin; V1 mint power removable by the USDC master minter). Exposure measured as the TokenMinters' USDC mint allowances ($105.4M V1, $860.8M V2, block 26,431,457) and set as `escrow`; V2's own $11 removed; attesters, thresholds and admins re-read.
- 2026-11-19 (study `eip-8151-impact`, PQ-18): under EIP-8151 a real transaction fails as sent and passes with more gas: whoever sends it must add gas on activation day. Executed: a real transaction reverts when its signer has code.

# Source excerpts: circle-cctp-attesters

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x0a992d191deec32afe36203ad87d7d289a738f81` — MessageTransmitter (verified source via sourcify)

### `MessageTransmitter.sol`

```solidity
 2876          );
 2877          require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
 2878  
 2879          // If the signature is valid (and not malleable), return the signer address
 2880          address signer = ecrecover(hash, v, r, s);
 2881          require(signer != address(0), "ECDSA: invalid signature");
 2882  
 2883          return signer;
 2884      }
  ...
 3167          internal
 3168          pure
 3169          returns (address)
 3170      {
 3171          return (ECDSA.recover(_digest, _signature));
 3172      }
 3173  }
 3174  
 3175  /**
  ...
```


## Contract `0x81d40f21f12a8f0e3252bccb954d722d4c464b64` — AdminUpgradableProxy (verified source via sourcify)

## Implementation `0xa30c41865729c248067704d4db9f38385cbe1186` — MessageTransmitterV2 (verified source via sourcify)

### `src/roles/Attestable.sol`

```solidity
   15   */
   16  pragma solidity 0.7.6;
   17  
   18  import "@openzeppelin/contracts/utils/EnumerableSet.sol";
   19  import "@openzeppelin/contracts/cryptography/ECDSA.sol";
   20  import "./Ownable2Step.sol";
   21  
   22  contract Attestable is Ownable2Step {
   23      // ============ Events ============
  ...
  271      function _recoverAttesterSignature(
  272          bytes32 _digest,
  273          bytes memory _signature
  274      ) internal pure returns (address) {
  275          return (ECDSA.recover(_digest, _signature));
  276      }
  277  
  278      /**
  279       * @notice Sets the threshold of signatures required to attest to a message.
  ...
```

Library files with the primitive itself (not excerpted): `lib/openzeppelin-contracts/contracts/cryptography/ECDSA.sol`
