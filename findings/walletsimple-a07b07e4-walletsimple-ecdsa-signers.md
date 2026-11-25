---
id: walletsimple-a07b07e4-walletsimple-ecdsa-signers
format: 2
title: 'BitGo WalletSimple multisig: quantum attacker with two signer keys takes funds'
status: confirmed
severity: HIGH
justification: Co-signer approval is pure ECDSA and signers are fixed, so owners must move funds to a new wallet
  BitGo provides.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa07b07e4542bea95f38c54f39ec25750ffc3dfcd'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 19945802
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Provide a post-quantum-capable wallet and have the signers co-sign moving all funds into it.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address is recovered with ecrecover, so it depends on ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xa07b07e4542bea95f38c54f39ec25750ffc3dfcd'
  is: contract
  bytes: 45
  says: The wallet address holds contract code (a clone proxy).
  for:
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This wallet is a 2-of-3 multisig clone: the sender must be a signer and the second signer's approval is an ECDSA signature checked with ecrecover. A quantum attacker who derives the private keys of two signers can approve and send the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) returns the co-signer address from ecrecover over the operation hash.

## Reviewer notes

### Mechanism

The wallet at 0xa07b07e4 is a 45-byte proxy clone running 0xe8e847cf (FlattenedWalletSimple.sol). Per kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig. verifyMultiSig takes otherSigner from recoverAddressFromSignature, which ends at line 599 with ecrecover(operationHash, v, r, s). It then requires isSigner(otherSigner) and otherSigner != msg.sender before executing. There is no ERC-1271 path. Signers are set once in init, and no function changes them. Safe mode only restricts sends to signer addresses, which an attacker holding a signer key controls. Recovering the sender key and one co-signer key, both exposed through on-chain transactions and signatures, therefore lets an attacker drain the wallet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin can rotate signers
- Ruled out: Safe mode does not stop an attacker holding a signer key

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
