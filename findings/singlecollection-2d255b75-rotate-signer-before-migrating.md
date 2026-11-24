---
id: singlecollection-2d255b75-rotate-signer-before-migrating
format: 2
title: Fluffy PunkCats mint signers must rotate keys before moving to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code; the owner can add a new signer key
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  name: SingleCollection
  code: verified
  code_url: https://etherscan.io/address/0x2d255b756dd75a11d75cf701abad7c6d64b0aedd#code
  copies: 1
  upgradeable: 'no'
  admin: '0x5dd379a975f650845ad9b42d80fa7402a82c317e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
  last: 2026-11-11
impact: liveness
action: Add a new signer with addSigner and sign mints with it before moving a current signer's account to real
  code.
evidence_level: source
checks:
- id: recover
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  line: 57
  has: require(isSigner(prepareMessage(tokenId, this, tokenURI).recover(v, r, s)), "signer should sign tokenId");
  says: mint requires the address recovered from the signature to be a signer
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: libs.sol
  lines:
  - 308
  - 317
  has: return ecrecover(keccak256(fullMessage), v, r, s);
  says: recover is a plain ecrecover of the prefixed message, with no branch for a signer with code
  for:
  - evidence-1
  - justification
  - what
- id: isstored
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: Roles.sol
  lines:
  - 168
  - 170
  has: return _signers.has(account);
  says: isSigner reads the stored signer set
  for:
  - evidence-1
  - what
- id: zero
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: Roles.sol
  lines:
  - 34
  - 37
  has: 'require(account != address(0), "Roles: account is the zero address");'
  says: a recovery that returns no address makes the signer lookup revert
  for:
  - what
- id: price
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  line: 58
  has: require(msg.value == 3e16*tokenId.length, "(mint) incorrect msg.value");
  says: a signed mint costs 0.03 ETH per token
  for:
  - what
- id: forward
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  line: 64
  has: beneficiary.transfer(msg.value);
  says: mint sends the payment on to the beneficiary, so the contract keeps none
  for:
  - notes
- id: batch
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  lines:
  - 67
  - 68
  has: require(isOwner() || isMinter(msg.sender), "Only for owner and minters minting");
  says: mintBatch, the mint without a signature, is for the owner and minters only
  for:
  - notes
- id: add
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  lines:
  - 91
  - 93
  has: function addSigner(address account) public override onlyOwner { _addSigner(account); }
  says: addSigner, owner only, adds an address to the signer set
  for:
  - action
  - evidence-3
  - justification
  - what
- id: remove
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: SingleCollection.sol
  lines:
  - 97
  - 99
  has: function removeSigner(address account) public onlyOwner { _removeSigner(account); }
  says: removeSigner, owner only, removes an address from the signer set
  for:
  - evidence-3
- id: onlyowner
  source: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  file: Roles.sol
  lines:
  - 99
  - 109
  has: return _msgSender() == _owner;
  says: onlyOwner requires the caller to be the stored owner
  for:
  - action
  - evidence-3
  - justification
  - what
- id: owner
  call: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  fn: owner()(address)
  is: '0x5dd379a975f650845ad9b42d80fa7402a82c317e'
  says: the owner that can add and remove signers
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: ownercode
  code: '0x5dd379a975f650845ad9b42d80fa7402a82c317e'
  is: empty
  says: the owner is an account without code
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: ownernonce
  nonce: '0x5dd379a975f650845ad9b42d80fa7402a82c317e'
  is: 32
  says: the owner has sent 32 transactions
  for:
  - evidence-3
- id: ownersigner
  call: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  fn: isSigner(address)(bool)
  args:
  - '0x5dd379a975f650845ad9b42d80fa7402a82c317e'
  is: true
  says: the owner is itself a signer
  for:
  - evidence-2
- id: signer2
  call: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  fn: isSigner(address)(bool)
  args:
  - '0xd3fe775d09c4ea2b3e36efac3c34e97d66f38868'
  is: true
  says: the signer given at deployment is still a signer
  for:
  - evidence-2
- id: signer2code
  code: '0xd3fe775d09c4ea2b3e36efac3c34e97d66f38868'
  is: empty
  says: that signer is an account without code
  for:
  - evidence-2
- id: signer2nonce
  nonce: '0xd3fe775d09c4ea2b3e36efac3c34e97d66f38868'
  is: 0
  says: that signer has never sent a transaction
  for:
  - notes
- id: signer2slot
  storage: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  slot: '0x1c2ec1dbdfd3db0dc665bb724e344a564d90322eebe0231704ac9bcdda43e884'
  is: 1
  says: the signer mapping holds true for the deployment-time signer
  for:
  - notes
- id: ownerslot
  storage: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  slot: '0xf0e48cca1f3553385ffba48b2f69f7c98fa7a7dd6238a9c652b3edf59bd3fba9'
  is: 1
  says: the signer mapping at slot 16 holds true for the owner
  for:
  - notes
- id: deploy
  tx: '0x08ed04c25a60b63676057fb557128dc7b4f4aa53a29ea678c8e4bb57d7fcd766'
  ok: true
  says: the deployment transaction, whose SignerAdded logs name the two first signers
  for:
  - notes
- id: name
  call: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  fn: name()(string)
  is: Fluffy PunkCats
  says: the token collection is named Fluffy PunkCats
  for:
  - what
- id: supply
  call: '0x2d255b756dd75a11d75cf701abad7c6d64b0aedd'
  fn: totalSupply()(uint256)
  is: 472
  says: 472 tokens exist, so the address is used on its own
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-2d255b75, the row's refuter
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
    Kept as before (Fluffy PunkCats). The signer set cannot be listed without logs; the card does not claim the
    two checked signers are all.'
related: []
---

## What happens

Fluffy PunkCats lets anyone mint a token for 0.03 ETH when one of its stored signers has signed the mint with ECDSA. A signer that moves its account to real code stops counting, and mints signed with its key revert. The owner can add a new signer.

## Evidence

- [mint](https://etherscan.io/address/0x2d255b756dd75a11d75cf701abad7c6d64b0aedd#code) recovers the signature with ECDSA and requires the recovered address to be a stored signer.
- The owner and [a second key](https://etherscan.io/address/0xd3fe775d09c4ea2b3e36efac3c34e97d66f38868) are signers, and both are accounts without code.
- addSigner and removeSigner are for the [owner](https://etherscan.io/address/0x5dd379a975f650845ad9b42d80fa7402a82c317e) only, an account without code that has sent 32 transactions.

## Reviewer notes

### Mechanism

mint (SingleCollection.sol line 57) builds the hex string of keccak256(abi.encode(token ids, this contract, token URIs)), prefixes it, and calls ecrecover directly (libs.sol lines 308-317). The result goes to isSigner, which reads the _signers mapping (Roles.sol lines 168-170, slot 16) and reverts on the zero address (Roles.sol line 35). A match mints to the caller for 0.03 ETH per token, sent on to beneficiary (line 64); the contract keeps no ETH. Signers change through addSigner and removeSigner (owner only, lines 91-99) and renounceSigner (the signer itself, Roles.sol lines 182-184). The constructor made two signers: the deployer, still the owner (0x5dd3...317e, no code, nonce 32), and its signer argument 0xd3fe...8868 (no code, nonce 0); the deployment tx's SignerAdded logs name them, and isSigner is true for both. Later additions are not listed; the set is a mapping and the full log history was not scanned. The owner is itself a signer, so once its account has code, addSigner needs that code to call it. mintBatch (line 68) is owner/minter only. The study's two-week window has no recovery here.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: mint has one check (line 57), recover calls ecrecover directly (libs.sol 316); the other recover in libs.sol (367) is never called.
- Ruled out: an unused implementation: the address is not a proxy target in the study's tables, name() is Fluffy PunkCats and totalSupply() is 472 at the block.
- Ruled out: an unset key or a key that is already a contract: isSigner is true for 0x5dd3...317e and 0xd3fe...8868, and both have empty code; their storage slots keccak(address, 16) hold 1.
- Ruled out: a setter nobody can call: owner() is 0x5dd3...317e, not renounced, an account without code with nonce 32. The second signer has nonce 0; a key that never sent a transaction is presumed live.
- Ruled out: a path closed for good: mint has no pause, deadline or supply cap; it requires only the signature and the price (lines 57-58).
- Ruled out: a direct path for the public: mintBatch requires the owner or a minter (line 68); a buyer has only mint.
- Ruled out: a later recheck: the signature is checked once, inside mint, and nothing relies on it afterwards.
- Ruled out: fixed gas: ecrecover is the Solidity builtin, which forwards all gas; the scanner found no constant.
- Ruled out: children or another verifier: the contract deploys nothing, and mint makes no external call except the transfer to beneficiary.
- Ruled out: whose is left empty: the address holds 0 ETH and no priced token, and mint sends each payment on to beneficiary (line 64).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
