---
id: curiousaddys-82712d00-rotate-signer-before-migrating
format: 2
title: Mint signer must be replaced before its account moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the signer moves its account to real code, and the owner can set a new signer
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x82712d0052c6d8185383b5554a071c440b902992'
  name: CuriousAddys
  code: verified
  code_url: https://etherscan.io/address/0x82712d0052c6d8185383b5554a071c440b902992#code
  copies: 1
  upgradeable: 'no'
  admin: '0x52ea5f96f004d174470901ba3f1984d349f0d3ef'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 68
  last: 2026-11-12
impact: liveness
action: Set a new signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  line: 153
  has: return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
  says: the address recovered with ECDSA must equal the stored signerAddress; there is no other branch
  for:
  - evidence-1
  - justification
  - what
- id: mintreq
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  line: 174
  has: require(verifyAddressSigner(messageHash, signature), "SIGNATURE_VALIDATION_FAILED");
  says: mint reverts unless the signer check passes
  for:
  - evidence-1
  - what
- id: saleguard
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  line: 171
  has: require(isFirstSaleActive || isSecondSaleActive, "SALE_IS_NOT_ACTIVE");
  says: mint reverts while both sale flags are off
  for:
  - what
- id: setter
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  lines:
  - 97
  - 100
  has: signerAddress = _signerAddress;
  says: setSignerAddress, onlyOwner, writes a new signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: reopen
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  lines:
  - 89
  - 91
  has: function setSecondSaleState(bool _secondSaleActiveState) public onlyOwner {
  says: only the owner sets the second sale flag
  for:
  - evidence-3
  - what
- id: signer
  storage: '0x82712d0052c6d8185383b5554a071c440b902992'
  slot: 14
  is: '0x000000000000000000000000abcb40408a94e94f563d64ded69a75a3098cbf59'
  says: the stored signerAddress (slot 14) is 0xabcb40408a94e94f563d64ded69a75a3098cbf59
  for:
  - evidence-2
  - what
- id: signercode
  code: '0xabcb40408a94e94f563d64ded69a75a3098cbf59'
  is: empty
  says: the signer account has no code
  for:
  - evidence-2
- id: owner
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: owner()(address)
  is: '0x52ea5f96f004d174470901ba3f1984d349f0d3ef'
  says: the owner that can replace the signer and reopen a sale
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: ownercode
  code: '0x52ea5f96f004d174470901ba3f1984d349f0d3ef'
  is: empty
  says: the owner is an account without code
  for:
  - notes
- id: ownernonce
  nonce: '0x52ea5f96f004d174470901ba3f1984d349f0d3ef'
  min: 385
  says: the owner account has sent transactions
  for:
  - notes
- id: first
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: isFirstSaleActive()(bool)
  is: false
  says: the first sale is off
  for:
  - evidence-3
  - what
- id: second
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: isSecondSaleActive()(bool)
  is: false
  says: the second sale is off
  for:
  - evidence-3
  - what
- id: supply
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: totalSupply()(uint256)
  is: 5000
  says: 5,000 tokens exist
  for:
  - evidence-3
- id: max
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: maxSupply()(uint256)
  is: 10000
  says: the cap is 10,000 tokens, so mints remain
  for:
  - evidence-3
- id: reopenfirst
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  lines:
  - 80
  - 82
  has: function setFirstSaleState(bool _firstSaleActiveState) public onlyOwner {
  says: only the owner sets the first sale flag
  for:
  - what
- id: giftsrc
  source: '0x82712d0052c6d8185383b5554a071c440b902992'
  file: contracts/CuriousAddys.sol
  lines:
  - 205
  - 206
  has: function gift(address[] calldata receivers, uint256 mintNumber) external onlyOwner {
  says: gift is onlyOwner and mints with no signature and no sale-flag check
  for:
  - evidence-1
  - what
- id: giftruns
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: gift(address[],uint256)()
  args:
  - - '0x000000000000000000000000000000000000dead'
  - 1
  from: '0x52ea5f96f004d174470901ba3f1984d349f0d3ef'
  is: null
  says: the owner's gift of one token succeeds with both sales off and no signature
  for:
  - what
- id: giftstranger
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: gift(address[],uint256)()
  args:
  - - '0x000000000000000000000000000000000000dead'
  - 1
  from: '0x000000000000000000000000000000000000dead'
  reverts: true
  says: gift reverts for a caller that is not the owner
  for:
  - notes
- id: notpaused
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: paused()(bool)
  is: false
  says: the contract is not paused
  for:
  - notes
- id: reservedone
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: reserveMintCompleted()(bool)
  is: true
  says: the reserve is minted, so mintReserveSupply is spent
  for:
  - notes
- id: refundover
  call: '0x82712d0052c6d8185383b5554a071c440b902992'
  fn: refundGuaranteeActive()(bool)
  is: false
  says: the refund window is over
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This NFT contract sells tokens only to buyers who bring a signature from one stored signer key. Both sales are closed now; only the owner can reopen one. If the signer moves to real code and a sale reopens, no buyer can mint until the owner sets a new signer; the owner can still gift tokens.

## Evidence

- The [verified source](https://etherscan.io/address/0x82712d0052c6d8185383b5554a071c440b902992#code) lets a buyer mint only when the address recovered with ECDSA equals the stored signer.
- The signer is [0xabcb…bf59](https://etherscan.io/address/0xabcb40408a94e94f563d64ded69a75a3098cbf59), an account without code; `setSignerAddress` lets the owner replace it.
- Both sale flags are off and 5,000 of 10,000 tokens exist; the [owner](https://etherscan.io/address/0x52ea5f96f004d174470901ba3f1984d349f0d3ef) can reopen the second sale.

## Reviewer notes

### Mechanism

mint (CuriousAddys.sol, lines 165-200) requires a sale flag to be on (171), that messageHash equals keccak256(abi.encode(msg.sender, maximumAllowedMints)) (173), and verifyAddressSigner (174). verifyAddressSigner (152-154) recovers the signer of the eth-signed message hash with OpenZeppelin ECDSA.recover (plain ecrecover, ECDSA.sol line 170) and compares it with the private stored signerAddress (declared line 55, storage slot 14). setSignerAddress (97-100, onlyOwner) writes that slot. gift (205-214, onlyOwner) mints with no signature and no sale flag, so the owner can still mint for free; only the paid mint depends on the signer. At the block: signerAddress is 0xabcb...bf59, the initial value, an account with no code and nonce 0; owner is 0x52ea...d3ef, an account with no code and nonce 385. Both sale flags are false, so mint reverts today with SALE_IS_NOT_ACTIVE; totalSupply is 5,000 of maxSupply 10,000 (reserve of 200 already minted), so setSecondSaleState(true) by the owner (89-95) would make mint reachable again (line 183). The contract is not paused and refundGuaranteeActive() is false.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch for a signer with code: verifyAddressSigner (lines 152-154) only compares the ECDSA-recovered address with signerAddress.
- Ruled out: the path closed for good: both sale flags are false, but totalSupply is 5,000 below maxSupply 10,000 and setSecondSaleState is onlyOwner with a live owner (no code, nonce 385), so the sale can be reopened; first-sale supply (5,000) is used up, so only the second sale can admit mints.
- Ruled out: the key unset or already a contract: slot 14 holds 0xabcb...bf59, which has no code at the block.
- Ruled out: the setter not working: setSignerAddress (lines 97-100) writes signerAddress and is onlyOwner; owner() is not zero.
- Ruled out: a direct path without a signature: a buyer has none, but the owner has one. gift (lines 205-214, onlyOwner) mints with no signature and no open sale; the owner's call succeeds at the block and a stranger's reverts. The card says so. mintReserveSupply (219) is also onlyOwner and is spent (reserveMintCompleted is true).
- Ruled out: a later recheck of the signature: the signature is used once, inside mint; nothing stores or rechecks it.
- Ruled out: implementation behind proxies: the dossier shows no proxy pointing here, one address in the family, and state (5,000 tokens) lives at this address.
- Ruled out: recoveries in the two-week window: none recorded (scan.window null), consistent with the sale being closed.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
