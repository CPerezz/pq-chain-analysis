---
id: lithium-cc4c47cf-signature-rechecked
format: 2
title: Lithium channel parties moving to real code can void co-signed states
status: confirmed
severity: CRITICAL
justification: A party that relied on a co-signed state loses its balance, and nobody can change the contract.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  name: Lithium
  project: hydranet
  code: verified
  code_url: https://etherscan.io/address/0xcc4c47cf0175aa8108e78679c2586a0a6abb242a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 12358
  whose: users
  basis: held
activity:
  txs_90d: 1013
impact: funds-loss
action: Deploy a version that asks channel parties with real code through ERC-1271 and move channels to it before
  EIP-8151 activates.
evidence_level: source
checks:
- id: verify-both
  source: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  file: src/libraries/LithiumVerification.sol
  lines:
  - 95
  - 100
  has: if (ECDSA.recover(ethSignedHash, signedAssetState.bobSignature) != bob) {
  says: a channel state counts only if both Alice's and Bob's ECDSA signatures recover to them
  for:
  - action
  - evidence-1
  - justification
  - what
- id: settle-verify
  source: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  file: src/libraries/LithiumSettler.sol
  line: 86
  has: LithiumVerification.verifyAssetChannelStateSignaturesCalldata(channelConfig, signedAssetState);
  says: every disputed or overriding state goes through the two-signature check
  for:
  - justification
  - what
- id: revoke-verify
  source: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  file: src/libraries/LithiumVerification.sol
  lines:
  - 206
  - 209
  has: revoker = ECDSA.recover(ethSignedHash, signedRevocation.revokerSignature);
  says: a penalty needs the revoker's ECDSA signature to recover to Alice or Bob
  for:
  - justification
  - what
- id: confirm-pays
  source: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  file: src/libraries/LithiumSettler.sol
  lines:
  - 537
  - 558
  has: LithiumTransfer.payoutOrEscrow(store, bob, assetVariant, assetAddress, tokenNumberId, bobAmount);
  says: after the deadline the stored dispute balances are paid to the two parties with no signature
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: no-proxy
  storage: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0xcc4c47cf0175aa8108e78679c2586a0a6abb242a'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-cc4c47cf, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: reader-1, the reader who settled the row
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: Lithium (Hydranet) payment channels: a channel state counts only when both parties'' ECDSA signatures
    recover to them, and a revocation only when the revoker''s does. A party that disputes with a stale state and
    then moves its account to real code voids the counterparty''s newer state and revocation, and the stale balances
    are paid after the deadline without a signature. PQ-15, CRITICAL: no proxy and no upgrade function, and the
    honest party loses. Fix: a new deployment that asks parties with real code through ERC-1271, channels moved
    before activation. Refuter agreed with no objection; no correction by the reader. The two replays that fail
    under EIP-8151 alone belong to the address''s queued sender-gas-limits row, not to this card.'
related: []
---

## What happens

Lithium settles a channel dispute only with a state both parties signed with ECDSA, and punishes a revoked state by the cheater's signed revocation. A party that disputes with an old state, then moves its account to real code, voids the newer state and the revocation, so the old balances are paid.

## Evidence

- [verifyAssetChannelStateSignatures](https://etherscan.io/address/0xcc4c47cf0175aa8108e78679c2586a0a6abb242a#code) requires ECDSA recovery of both Alice and Bob for every channel state.
- [confirmUnilateralSettlement](https://etherscan.io/address/0xcc4c47cf0175aa8108e78679c2586a0a6abb242a#code) pays the disputed balances after the deadline without any signature; the contract has no proxy or upgrade.

## Reviewer notes

### Mechanism

unilateralSettleChannel verifies each asset state with verifyAssetChannelStateSignaturesCalldata, which recovers Alice's and Bob's signatures with OpenZeppelin ECDSA and reverts unless both match. A newer co-signed state overrides an open dispute only through the same check. penalizeRevokedChannel recovers the revoker from its signed revocation and reverts unless it is Alice or Bob. confirmUnilateralSettlement needs no signature: after the dispute deadline it pays the stored dispute balances to Alice and Bob. So a party that opens a dispute with a stale state and then moves its account to real code makes both the counterparty's newer state and its revocation fail under EIP-8151, and the stale balances are paid. The contract is not a proxy and has no upgrade or admin function.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: An ERC-1271 path for parties with code: the verification has none (LithiumVerification lines 57-62, 175-178).
- Ruled out: Signer can take back without migrating: channel funds leave only through a co-signed state or a dispute; the pool withdrawal moves only a provider's own pool liquidity.
- Ruled out: Replays 0x5c9d2001… and 0x9278bf51… fail under EIP-8151 alone (revert and out of gas) with no code at the signer, so they do not isolate this check; that is a separate sender gas limit matter for the reader to link, and they are not cited here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
