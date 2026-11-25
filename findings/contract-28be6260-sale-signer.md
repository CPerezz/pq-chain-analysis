---
id: contract-28be6260-sale-signer
format: 2
title: Legion sale admits investors via an ECDSA key a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forged signer signature only admits investors paying their own USDC; sale ended. Legion fixes in
  new sales. LOW.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x28be6260dbb7872de5effc9a4a73c85b7405a8c0'
  project: legion
  code: bytecode
  code_url: https://etherscan.io/address/0x28be6260dbb7872de5effc9a4a73c85b7405a8c0#code
  copies: 1
value:
  usd: 527563
  basis: held
activity:
  txs_90d: 11
impact: liveness
action: Verify Legion's admission signature with a post-quantum verifier or on-chain allowlist in future sale implementations.
evidence_level: source
checks:
- id: c1
  source: '0x11077eddfc6db5abfdb9e019a64172b5d8e81a3a'
  file: src/LegionSale.sol
  line: 753
  has: if (_data.recover(_signature) != addressConfig.legionSigner) revert Errors.InvalidSignature();
  says: Admission reverts unless the ECDSA-recovered signer equals legionSigner.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x11077eddfc6db5abfdb9e019a64172b5d8e81a3a'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: Signature recovery uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: code
  code: '0x28be6260dbb7872de5effc9a4a73c85b7405a8c0'
  is: contract
  bytes: 44
  says: The address holds contract code (an EIP-1167 minimal proxy).
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This Legion sale clone admits an investor only if ECDSA recovers Legion's signer key from a signature over investor, sale and chain. A quantum attacker who recovers the signer key can sign admissions so that unapproved addresses invest their own USDC.

## Evidence

- [_verifyLegionSignature](https://etherscan.io/address/0x11077eddfc6db5abfdb9e019a64172b5d8e81a3a#code) reverts unless the recovered address equals legionSigner.
- [ECDSA.tryRecover](https://etherscan.io/address/0x11077eddfc6db5abfdb9e019a64172b5d8e81a3a#code) recovers the signer with the ecrecover precompile.

## Reviewer notes

### Mechanism

The clone delegates to implementation 0x11077edd…1a3a. invest(amount, signature) calls _verifyLegionSignature (LegionSale.sol 751-754): keccak256(abi.encodePacked(msg.sender, address(this), block.chainid)).toEthSignedMessageHash().recover(sig) must equal addressConfig.legionSigner (line 753), using OpenZeppelin ECDSA.tryRecover, which calls ecrecover (ECDSA.sol line 148). invest then checks the sale has not ended and pulls the investor's bidToken via safeTransferFrom. Per kev, refund, withdrawExcessInvestedCapital, claimTokenAllocation, withdrawRaisedCapital and emergencyWithdraw do not use the signer signature, and hasEnded is true, so invest now reverts. legionSigner can be re-synced from the registry by the bouncer, but only to another ECDSA key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Funds held by the sale are not released by the signer signature (per kev).
- Ruled out: The sale has ended, so invest reverts today (per kev).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
