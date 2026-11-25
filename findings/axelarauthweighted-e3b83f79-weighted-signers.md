---
id: axelarauthweighted-e3b83f79-weighted-signers
format: 2
title: Axelar auth module trusts operator ECDSA keys a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forgeable ECDSA operator quorum, fixed by a governance upgrade to a post-quantum module and new validator
  keys
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  name: AxelarAuthWeighted
  project: axelar
  code: verified
  code_url: https://etherscan.io/address/0xe3b83f79fbf01b25659f8a814945ab82186a8ad0#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4f4495243837681061c4743b74b3eedf548d56a5'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 14357
impact: funds-loss
action: Upgrade the gateway to a post-quantum auth module and have the Axelar validators sign with post-quantum
  keys
evidence_level: source
checks:
- id: c1
  source: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  file: contracts/auth/AxelarAuthWeighted.sol
  line: 105
  has: address signer = ECDSA.recover(messageHash, signatures[i]);
  says: each signer is recovered with ECDSA
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  file: contracts/ECDSA.sol
  line: 63
  has: if ((signer = ecrecover(hash, v, r, s)) == address(0)) revert InvalidSignature();
  says: recover uses ecrecover
  for:
  - evidence-3
  - justification
  - what
- id: vp
  source: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  file: contracts/auth/AxelarAuthWeighted.sol
  has: _validateSignatures(messageHash, operators, weights, threshold, signatures);
  line: 42
  says: validateProof checks the proof's signatures
  for:
  - evidence-1
  - what
- id: thr
  source: '0xe3b83f79fbf01b25659f8a814945ab82186a8ad0'
  file: contracts/auth/AxelarAuthWeighted.sol
  has: if (weight >= threshold) return;
  line: 113
  says: proof accepted once signer weight reaches threshold
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review18 (gateway and both auth modules from Sourcify, historical authModule reads, gateway escrow)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This module checks Axelar gateway command proofs by recovering ECDSA signers and summing operator weights up to a threshold. A quantum attacker who derives a weighted quorum of operator keys can make proofs that it accepts.

## Evidence

- [validateProof](https://etherscan.io/address/0xe3b83f79fbf01b25659f8a814945ab82186a8ad0#code) passes each proof to _validateSignatures for the operator set's epoch.
- [_validateSignatures](https://etherscan.io/address/0xe3b83f79fbf01b25659f8a814945ab82186a8ad0#code) recovers each signer with ECDSA and accepts the proof once the summed weight reaches the threshold.
- [recover](https://etherscan.io/address/0xe3b83f79fbf01b25659f8a814945ab82186a8ad0#code) returns the signer from ecrecover.

## Reviewer notes

### Mechanism

validateProof (line 30) decodes operators, weights, threshold and signatures. It looks up the epoch of the operator-set hash and rejects sets older than OLD_KEY_RETENTION (16) epochs (line 40). It then calls _validateSignatures (line 42). That function calls ECDSA.recover(messageHash, signatures[i]) for each signature (line 105). ECDSA.recover ends in ecrecover (ECDSA.sol line 63). Each recovered signer is matched against the sorted operator list, and the function returns once the summed weight reaches the threshold (line 113). transferOperatorship (line 51) is onlyOwner, and the owner is the gateway. The gateway runs it when a command carries a valid proof, so a forged quorum can also install new operators. Anyone who derives operator private keys from their public signatures passes this check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The module holds no funds itself.
- Ruled out: Rotating ECDSA operators does not remove the exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
