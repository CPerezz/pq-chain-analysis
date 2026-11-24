---
id: mdhpblocktoken-67ff9bc0-rotate-signer-before-migrating
format: 2
title: Mint signers must be replaced before their accounts move to real code
status: confirmed
severity: INFORMATIONAL
justification: Signed mints stop only if both signing accounts move to real code; the owner can replace either key
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  name: MDHPBlockToken
  code: verified
  code_url: https://etherscan.io/address/0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f#code
  copies: 2
  family: 2fe0c4aa088ea6387d4cde74e15e4b80
  upgradeable: 'no'
  admin: '0xf6643e60b9cf3bfb8ad9d06333800ed32839574d'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Call setMetadataManager with a fresh key before moving the manager's account to real code; keep one signer
  without code.
evidence_level: source
checks:
- id: recover
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  line: 86
  has: address signer = ECDSA.recover(digest, signature);
  says: the mint authorization is recovered with ECDSA only
  for:
  - evidence-1
  - justification
  - what
- id: compare
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  lines:
  - 87
  - 89
  has: if (signer != owner() && signer != metadataManager) {
  says: the mint reverts unless the recovered address is the owner or the stored metadata manager
  for:
  - action
  - evidence-1
  - justification
  - what
- id: caller
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  lines:
  - 71
  - 73
  has: if (msg.sender != to) {
  says: the signed mint is called by the account that receives the token
  for:
  - what
- id: mint
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  line: 91
  has: _safeMint(to, blockId);
  says: a valid signature mints the block to the caller
  for:
  - what
- id: set-manager
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  lines:
  - 144
  - 152
  has: function setMetadataManager(address newManager) external onlyOwner {
  says: the owner replaces the stored metadata manager (line 150 writes it)
  for:
  - action
  - evidence-3
  - justification
  - what
- id: set-manager-write
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  line: 150
  has: metadataManager = newManager;
  says: setMetadataManager writes the key the mint check reads
  for:
  - what
- id: transfer-owner
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: '@openzeppelin/contracts/access/Ownable.sol'
  lines:
  - 69
  - 72
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: the owner can hand ownership, and with it the owner signing key, to another account
  for:
  - justification
- id: direct-mint
  source: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  file: contracts/MDHPBlockToken.sol
  line: 54
  has: function mintBlock(address to, uint256 blockId, string calldata tokenURI_) external onlyOwner {
  says: the owner mints by a direct call with no signature
  for:
  - evidence-3
- id: owner
  call: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  fn: owner()(address)
  is: '0xf6643e60b9cf3bfb8ad9d06333800ed32839574d'
  says: 'the owner at the block: not renounced'
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: manager
  call: '0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f'
  fn: metadataManager()(address)
  is: '0x2edbbc41b4303dd294f4c3e252aff9e6d95f7d9f'
  says: 'the stored metadata manager at the block: set, and not the owner'
  for:
  - evidence-2
- id: owner-code
  code: '0xf6643e60b9cf3bfb8ad9d06333800ed32839574d'
  is: empty
  says: the owner is an account without code, so its signatures recover today
  for:
  - evidence-2
  - justification
- id: manager-code
  code: '0x2edbbc41b4303dd294f4c3e252aff9e6d95f7d9f'
  is: empty
  says: the metadata manager is an account without code, so its signatures recover today
  for:
  - evidence-2
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-67ff9bc0, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''); a fresh refuter agrees on every part; Claude read the changed sentences.
    Kept as before.'
related: []
---

## What happens

This NFT contract lets an account mint a block to itself with an ECDSA signature from the owner or the metadata manager. A signer whose account moves to real code stops counting. If both move, signed mints stop until the owner sets a new manager.

## Evidence

- [mintBlockAuthorized](https://etherscan.io/address/0x67ff9bc048f8d97f9fa7856454298cdd7637ee8f#code) recovers the signer with ECDSA and reverts unless it is the owner or the metadata manager.
- The [owner](https://etherscan.io/address/0xf6643e60b9cf3bfb8ad9d06333800ed32839574d) and the [manager](https://etherscan.io/address/0x2edbbc41b4303dd294f4c3e252aff9e6d95f7d9f) are accounts without code today.
- The [owner](https://etherscan.io/address/0xf6643e60b9cf3bfb8ad9d06333800ed32839574d) can replace the manager with setMetadataManager and can still mint directly with mintBlock.

## Reviewer notes

### Mechanism

mintBlockAuthorized (MDHPBlockToken.sol, lines 60-94) and mintBlocksAuthorized (lines 96-137) require msg.sender == to, build an EIP-712 digest, call ECDSA.recover (lines 86, 127) and revert unless the result is owner() or metadataManager (lines 87, 128); then they _safeMint to the caller. ECDSA.recover ends in the ecrecover precompile with all gas. There is no nonce: a signature is good until its deadline, and the token id can be minted once. metadataManager is one storage variable set in the constructor and by setMetadataManager (lines 144-152, onlyOwner). owner is OpenZeppelin Ownable: transferOwnership (Ownable.sol line 69, onlyOwner). mintBlock (line 54, onlyOwner) mints with no signature. At the block: owner 0xf664…574d, no code, nonce 4; metadataManager 0x2edb…7d9f, no code, nonce 0 (presumed live). If only one of the two moves to code the other's signatures still pass; if the owner moves it can still call setMetadataManager, mintBlock and transferOwnership from its account. Nothing is locked: the contract holds no value and tokens already minted are untouched.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path for a signer with code: lines 86-87 and 127-128 use only ECDSA.recover; no isValidSignature anywhere in the source.
- Ruled out: key unset or already a contract: owner() and metadataManager() are non-zero and both have empty code at the block.
- Ruled out: setter does nothing or cannot be called: setMetadataManager writes metadataManager (line 150) under onlyOwner; owner() is a live account (nonce 4), not renounced.
- Ruled out: path closed for good: the two signed mint functions have no pause, sale-end or switch; only the deadline in each signature.
- Ruled out: signed-shortcut-lost instead: the signer is the operator's key, not the minting user; the user has no direct mint (mintBlock is onlyOwner), so the stored-key issue fits.
- Ruled out: signature rechecked later: the recovery happens once, in the same call that mints.
- Ruled out: proxy or implementation-only code: no proxy slots, no delegatecall (tool facts); state is this address's own.
- Ruled out: the other names in the old note (setTransferValidator, setAutomaticApprovalOfTransfersFromValidator) do not touch the signer; only setMetadataManager and transferOwnership do.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
