---
id: walletsimple-004c2681-walletsimple-ecdsa-signers
format: 2
title: BitGo multisig trusts ECDSA co-signatures a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Co-signer approval is an ECDSA signature; signers are fixed, so funds must move to a new wallet BitGo
  provides.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x004c26816da9219cf3408e84edd9716df4b5739a'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 24451992
  basis: held
activity:
  txs_90d: 149
impact: funds-loss
action: Move the wallet's funds to a post-quantum-capable wallet, which BitGo has to provide.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address is recovered with ecrecover, an ECDSA check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x004c26816da9219cf3408e84edd9716df4b5739a'
  is: contract
  bytes: 45
  says: The wallet address holds contract code (a proxy).
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

This BitGo 2-of-3 multisig wallet accepts the second signer's approval by recovering an address from an ECDSA signature. A quantum attacker who derives the sending and co-signing keys can approve transfers of the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) returns the signer address computed by ecrecover from the 65-byte signature.

## Reviewer notes

### Mechanism

The wallet is a proxy clone of the FlattenedWalletSimple implementation at 0xe8e847cf. In that code, sendMultiSig, sendMultiSigToken and sendMultiSigBatch require msg.sender to be a signer. They then call verifyMultiSig. verifyMultiSig gets otherSigner from recoverAddressFromSignature(operationHash, signature), which calls ecrecover at line 599. It requires isSigner(otherSigner) and otherSigner != msg.sender, then runs the transfer. There is no ERC-1271 path. init sets the three signers once, and no function changes them. activateSafeMode only limits sends to signer addresses, which an attacker holding a signer key already is. The sending key's public key is exposed by its transactions, and the co-signer's by its signatures in calldata.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin can rotate signers
- Ruled out: Safe mode does not block a signer-key holder

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
