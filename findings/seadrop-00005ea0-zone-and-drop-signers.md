---
id: seadrop-00005ea0-zone-and-drop-signers
format: 2
title: OpenSea SeaDrop accepts ECDSA mint signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Drop signer keys are ECDSA; the fix needs OpenSea to deploy a post-quantum SeaDrop and creators to
  move drops to it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00005ea00ac477b1030ce78506496e8c2de24bf5'
  name: SeaDrop
  project: opensea
  code: verified
  code_url: https://etherscan.io/address/0x00005ea00ac477b1030ce78506496e8c2de24bf5#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 57
  basis: held
activity:
  txs_90d: 365765
impact: funds-loss
action: Deploy a SeaDrop that verifies a post-quantum signer and have creators move their drops to it.
evidence_level: source
checks:
- id: c1
  source: '0x00005ea00ac477b1030ce78506496e8c2de24bf5'
  file: src/SeaDrop.sol
  line: 402
  has: address recoveredAddress = digest.recover(signature);
  says: mintSigned recovers the signer address from the digest with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x00005ea00ac477b1030ce78506496e8c2de24bf5'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 152
  has: address signer = ecrecover(hash, v, r, s);
  says: OpenZeppelin ECDSA recovery uses ecrecover.
  for:
  - evidence-1
  - justification
- id: v-signer
  source: '0x00005ea00ac477b1030ce78506496e8c2de24bf5'
  file: src/SeaDrop.sol
  has: if (signedMintValidationParams.maxMaxTotalMintableByWallet == 0) {
  line: 434
  says: A signer without stored validation params is rejected.
  for:
  - evidence-2
  - what
- id: v-price
  source: '0x00005ea00ac477b1030ce78506496e8c2de24bf5'
  file: src/SeaDrop.sol
  has: if (mintParams.mintPrice < signedMintValidationParams.minMintPrice) {
  line: 439
  says: The signed mint price must be at least the creator's stored minimum.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; controller and owner reads)
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

SeaDrop mints NFTs for creators' drops; a signed mint goes ahead only if ECDSA recovers a signer the NFT contract stored validation parameters for. A quantum attacker who recovers that signer key can mint signed-drop NFTs at the lowest price the creator's bounds allow.

## Evidence

- [mintSigned](https://etherscan.io/address/0x00005ea00ac477b1030ce78506496e8c2de24bf5#code) recovers the signer of the mint digest with ECDSA.
- [_validateSignerAndParams](https://etherscan.io/address/0x00005ea00ac477b1030ce78506496e8c2de24bf5#code) rejects a signer with no stored validation parameters.
- [_validateSignerAndParams](https://etherscan.io/address/0x00005ea00ac477b1030ce78506496e8c2de24bf5#code) checks the signed mint price against the stored minimum price.

## Reviewer notes

### Mechanism

mintSigned (src/SeaDrop.sol lines ~340-416) checks quantity and fee recipient, builds the EIP-712 digest via _getDigest (line 382), rejects reused digests (lines 391-396), recovers the signer with OpenZeppelin ECDSA digest.recover(signature) (line 402, ecrecover at ECDSA.sol line 152) and calls _validateSignerAndParams (line 403). That function loads _signedMintValidationParams[nftContract][signer] (lines 427-430), reverts if maxMaxTotalMintableByWallet is zero (line 434) and checks mintPrice against minMintPrice (line 439) and the other bounds. Then _mintAndPay mints at the signed mintPrice (lines 407-415). A forged signature from a recovered signer key passes these checks for any terms inside the creator's bounds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Solmate ERC20 permit is library code in the verified source, not the drop-signer path of this finding.
- Ruled out: Public and allow-list mints take no signature.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
