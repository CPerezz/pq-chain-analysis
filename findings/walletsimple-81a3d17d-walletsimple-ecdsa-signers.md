---
id: walletsimple-81a3d17d-walletsimple-ecdsa-signers
format: 2
title: BitGo multisig lets a quantum attacker forge ECDSA signer approvals
status: confirmed
severity: HIGH
justification: Two ECDSA signer keys move all funds; signers are fixed, so owners must move funds to a PQ wallet
  BitGo provides.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x81a3d17d143731a26b262f6739376d3f122bccea'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 18406521
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Provide a post-quantum-capable wallet and have signers move the funds there.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer is recovered with ecrecover, an ECDSA check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x81a3d17d143731a26b262f6739376d3f122bccea'
  is: contract
  bytes: 45
  says: The wallet address holds contract code (a proxy).
  for:
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This BitGo multisig wallet releases funds when a signer sends the transaction and a second signer's signature recovers via ecrecover. A quantum attacker who derives the keys of two signers can send the wallet's holdings to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) derives the co-signer with ecrecover over the operation hash.

## Reviewer notes

### Mechanism

The address is a 45-byte proxy delegating to 0xe8e847cf (FlattenedWalletSimple.sol). Per kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig, which sets otherSigner = recoverAddressFromSignature(operationHash, signature). That function (lines 566-600) unpacks r, s, v, enforces low-s, and returns ecrecover(operationHash, v, r, s) at line 599. verifyMultiSig requires isSigner(otherSigner) and otherSigner != msg.sender, then executes the transfer. Signers are set once by init and cannot be changed; there is no ERC-1271 path. A sender key and a co-signer key, both exposed on chain once used, are enough to drain the wallet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: activateSafeMode does not help: it only limits sends to signer addresses, which the attacker controls
- Ruled out: Not upgradeable; signers cannot be rotated

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
