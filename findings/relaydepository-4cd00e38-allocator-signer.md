---
id: relaydepository-4cd00e38-allocator-signer
format: 2
title: Relay depository trusts an ECDSA allocator key a quantum attacker could recover
status: confirmed
severity: LOW
justification: A recovered allocator key drains held deposits; LOW because the owner can switch the allocator with
  one setting.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  name: RelayDepository
  project: relay
  code: verified
  code_url: https://etherscan.io/address/0x4cd00e387622c35bddb9b4c962c136462338bc31#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf61a305199fa1135d76ffab3752d42f55cbd775a'
value:
  usd: 918147
  basis: held
activity:
  txs_90d: 3043330
impact: funds-loss
action: Set the allocator to an ERC-1271 contract verifying post-quantum signatures and move ownership to a post-quantum
  account.
evidence_level: source
checks:
- id: c1
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: src/RelayDepository.sol
  line: 167
  has: if (!allocator.isValidSignatureNow(eip712Hash, signature)) {
  says: execute requires the allocator's signature to be valid.
  for:
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: lib/solady/src/auth/Ownable.sol
  line: 174
  has: function transferOwnership(address newOwner) public payable virtual onlyOwner {
  says: The owner can transfer ownership.
  for:
  - action
- id: s-exec
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: src/RelayDepository.sol
  has: execution of allocator-signed requests
  line: 14
  says: The contract executes allocator-signed requests.
  for:
  - what
- id: s-call
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: src/RelayDepository.sol
  has: 'c.to.call{value: c.value}('
  line: 203
  says: Each signed call is executed from the depository with value.
  for:
  - evidence-2
  - what
- id: s-setalloc
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: src/RelayDepository.sol
  has: function setAllocator(address _allocator) external onlyOwner
  line: 92
  says: The owner can replace the allocator.
  for:
  - action
  - evidence-3
  - justification
- id: s-ecrec
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: lib/solady/src/utils/SignatureCheckerLib.sol
  has: if iszero(extcodesize(signer)) {
  line: 42
  says: A code-less signer is verified with ecrecover.
  for:
  - justification
  - what
- id: s-1271
  source: '0x4cd00e387622c35bddb9b4c962c136462338bc31'
  file: lib/solady/src/utils/SignatureCheckerLib.sol
  has: isValidSignature(bytes32,bytes)
  line: 63
  says: A signer with code is verified via ERC-1271.
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

RelayDepository holds deposits and executes any list of calls signed by its allocator. When the allocator has no code, the signature is checked with ecrecover, so a quantum attacker who recovers the allocator key can sign calls that transfer out what the depository holds.

## Evidence

- [execute](https://etherscan.io/address/0x4cd00e387622c35bddb9b4c962c136462338bc31#code) reverts unless the allocator's signature over the request hash is valid.
- [_executeCalls](https://etherscan.io/address/0x4cd00e387622c35bddb9b4c962c136462338bc31#code) sends each signed call, with its value, from the depository.
- [setAllocator](https://etherscan.io/address/0x4cd00e387622c35bddb9b4c962c136462338bc31#code) lets the owner replace the allocator; contract allocators are checked via ERC-1271.

## Reviewer notes

### Mechanism

execute (RelayDepository.sol 155-181) hashes the CallRequest via EIP-712, checks expiration, then at line 167 calls allocator.isValidSignatureNow. In Solady SignatureCheckerLib.isValidSignatureNow (line 32), line 42 takes the ecrecover path when extcodesize(signer) is zero (line 56); otherwise it calls ERC-1271 isValidSignature (lines 62-71). After replay marking (172-177), _executeCalls (188-224) runs c.to.call{value: c.value}(c.data) at line 203 for each call, so a forged allocator signature moves any ETH or token held. setAllocator (92-96) is onlyOwner and accepts any non-zero address, so pointing it at an ERC-1271 contract that verifies post-quantum signatures removes the ecrecover path without code change. The owner (Ownable) is itself an ECDSA key and transferOwnership (Ownable line 174) should move it too.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or upgrade function in the verified source.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
