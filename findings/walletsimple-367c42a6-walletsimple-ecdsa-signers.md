---
id: walletsimple-367c42a6-walletsimple-ecdsa-signers
format: 2
title: Quantum attacker with two ECDSA signer keys can drain this BitGo wallet
status: confirmed
severity: HIGH
justification: Co-signer approval is an ECDSA signature and signers are fixed, so owners must move funds to a new
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x367c42a6f261ec54ffbecf5f41c226be12a3dca0'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 24103989
  basis: held
activity:
  txs_90d: 4699
impact: funds-loss
action: Move the funds to a post-quantum-capable wallet, co-signed by two of the three signers.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address comes from ecrecover over the operation hash.
  for:
  - action
  - evidence-1
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (source read, one real transaction replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

This 2-of-3 wallet accepts the second signer's approval when ecrecover on the operation hash returns a signer address. A quantum attacker who derives two signers' ECDSA keys can approve transfers of the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) returns ecrecover(operationHash, v, r, s) as the co-signer.

## Reviewer notes

### Mechanism

The wallet is a clone whose calls run code at 0xe8e847cf (FlattenedWalletSimple.sol). According to kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig. verifyMultiSig takes otherSigner from recoverAddressFromSignature, which ends with ecrecover at line 599. It then requires isSigner(otherSigner) and otherSigner != msg.sender before executing. The finding also says signers are set once by init with three addresses and cannot be changed, and there is no ERC-1271 path. Kev reports this wallet's signers as three EOAs, including a sending key shared with other wallets. Anyone holding two signer private keys can send funds anywhere. activateSafeMode only limits sends to signer addresses, which an attacker holding a signer key controls.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgrade: the contract is not upgradeable.
- Ruled out: Safe mode does not protect the funds against a holder of a signer key.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
