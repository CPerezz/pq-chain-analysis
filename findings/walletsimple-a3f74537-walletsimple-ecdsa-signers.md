---
id: walletsimple-a3f74537-walletsimple-ecdsa-signers
format: 2
title: Quantum attacker with two BitGo signer keys can drain this wallet
status: confirmed
severity: HIGH
justification: Signers are fixed ECDSA keys checked by ecrecover; HIGH as owners must move funds to a new BitGo
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa3f74537f048b893d726c173cb322fd21a28b18a'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 19296547
  basis: held
activity:
  txs_90d: 7
impact: funds-loss
action: Provide a post-quantum-capable wallet so signers can co-sign moving all funds out of this multisig.
evidence_level: source
checks:
- id: c1
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address is recovered with ECDSA ecrecover.
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

This 2-of-3 BitGo multisig accepts the second signer's approval only as an ECDSA signature recovered with ecrecover. A quantum attacker who derives the sending key and a co-signer key from public signatures can send the funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer address via ecrecover.

## Reviewer notes

### Mechanism

The wallet is a proxy clone running 0xe5dcdc13 WalletSimple. Per kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig. verifyMultiSig sets otherSigner = recoverAddressFromSignature(operationHash, signature) and requires it to be a signer distinct from msg.sender. recoverAddressFromSignature (lines 513-547) unpacks r, s and v, enforces a low s value, and returns ecrecover(operationHash, v, r, s) at line 546. There is no ERC-1271 path. Signers are set once by init and cannot be changed, and the contract is not upgradeable. An attacker with two recovered ECDSA signer keys therefore passes both checks, and the fix is moving the funds to a new wallet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgrade or signer rotation: kev reports no function changes signers and no upgrade path.
- Ruled out: activateSafeMode: restricts sends to signer addresses, which the attacker controls.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
