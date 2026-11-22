---
id: signatureverifier-949b3b3c-oracle-signers
format: 2
title: deBridge oracle ECDSA signatures are forgeable by a quantum attacker
status: confirmed
severity: MEDIUM
justification: Forged oracle keys approve any bridge submission; MEDIUM because one admin Safe can upgrade the verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x949b3b3c098348b879c9e4f15cecc8046d9c8a8c'
  name: SignatureVerifier
  project: debridge
  code: verified
  code_url: https://etherscan.io/address/0xfe7de3c1e1bd252c67667b56347cabfc6df08df4#code
  proxy_of: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  copies: 1
  upgradeable: 'yes'
  admin: '0xe4427af3555cd9303d728c491364fadfdd7494fe'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6625
impact: funds-loss
action: Upgrade the verifier to post-quantum oracle signatures and have oracle operators register post-quantum keys.
evidence_level: source
checks:
- id: c1
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  line: 75
  has: address oracle = ecrecover(_submissionId.getUnsignedMsg(), v, r, s);
  says: submit recovers each oracle signer with ECDSA ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  line: 142
  has: address oracle = ecrecover(_submissionId.getUnsignedMsg(), v, r, s);
  says: isValidSignature recovers an oracle signer with ECDSA ecrecover
  for:
  - evidence-3
- id: valid
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  has: if (getOracleInfo[oracle].isValid) {
  line: 76
  says: a recovered address counts only if it is a registered oracle
  for:
  - evidence-1
  - what
- id: thr
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  has: if (confirmations < needConfirmations) revert SubmissionNotConfirmed();
  line: 113
  says: submission is approved once oracle confirmations reach the threshold
  for:
  - evidence-2
  - justification
  - what
- id: gate
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  has: if (msg.sender != debridgeAddress) revert DeBridgeGateBadRole();
  line: 35
  says: submit is called by the deBridge gate
  for:
  - what
- id: admin
  source: '0xfe7de3c1e1bd252c67667b56347cabfc6df08df4'
  file: contracts/transfers/SignatureVerifier.sol
  has: function setDebridgeAddress(address _debridgeAddress) external onlyAdmin {
  line: 127
  says: an admin role controls the verifier's configuration
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This verifier approves deBridge cross-chain submissions when enough registered oracles have signed them with ECDSA. A quantum attacker who derives enough oracle keys from their public keys can approve forged submissions that the gate then acts on.

## Evidence

- [submit](https://etherscan.io/address/0xfe7de3c1e1bd252c67667b56347cabfc6df08df4#code) recovers each oracle with ecrecover and counts it if registered as valid.
- [submit](https://etherscan.io/address/0xfe7de3c1e1bd252c67667b56347cabfc6df08df4#code) reverts unless the confirmations reach the required count.
- [isValidSignature](https://etherscan.io/address/0xfe7de3c1e1bd252c67667b56347cabfc6df08df4#code) accepts one oracle signature recovered by ecrecover.

## Reviewer notes

### Mechanism

DeBridgeGate calls SignatureVerifier.submit (onlyDeBridgeGate, line 62). submit splits _signatures into 65-byte chunks (line 74), runs ecrecover on getUnsignedMsg (line 75), counts oracles with getOracleInfo[oracle].isValid (line 76), and reverts at line 113 unless confirmations reach max(minConfirmations, _excessConfirmations). Per kev's on-chain reads, 12 oracles are registered, minConfirmations is 8 and requiredOraclesCount is 0, so 8 forged keys suffice. An approved submission lets the gate release locked tokens, mint deAssets, and, via CallProxy, call DlnSource claimUnlock/claimCancel to pay out open order funds. The verifier is a proxy whose ProxyAdmin is owned by a 5-of-8 Safe that can upgrade it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself holds no funds; the escrow is in DeBridgeGate and DlnSource.
- Ruled out: No Ethereum protocol change helps: oracles sign off-chain.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
