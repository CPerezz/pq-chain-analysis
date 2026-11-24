---
id: contract-1f6bd7a1-7702-own-key-only
format: 2
title: Self-owned Nexus account is locked if it takes the Nexus logic as real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the key holder makes this Nexus logic the account's real code; a validator with another
  key avoids it.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  code: verified
  code_url: https://etherscan.io/address/0x813d4a8747f5f2f67510f7ff364a6a46450ca2f0#code
  copies: 124
  family: 884665d9662698f1382a236f155d6021
value:
  usd: 201
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Install a validator owned by a separate key before giving this account the Nexus logic as real code; the
  EIP-7702 delegation keeps working.
evidence_level: source
checks:
- id: delegated
  code: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: delegation
  target: '0x813d4a8747f5f2f67510f7ff364a6a46450ca2f0'
  says: the account is an EIP-7702 delegation to Nexus
  for:
  - what
  - whose
- id: initialized
  call: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  fn: isInitialized()(bool)
  is: true
  says: the account is initialized
  for:
  - notes
- id: defaultvalidator
  call: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  fn: getDefaultValidator()(address)
  is: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  says: the default validator is SuperValidator 0xb46b…
  for:
  - what
- id: validators
  call: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  fn: getValidatorsPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 20
  is:
  - - '0xadeff5a0684392c4c273a9c638d1db8c5dfd0098'
  - '0x0000000000000000000000000000000000000001'
  says: the only installed validator besides the default is 0xadeff5a0…
  for:
  - what
- id: sv7702
  source: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  file: src/validators/SuperValidatorBase.sol
  lines:
  - 240
  - 242
  has: return signer == sender && isValid;
  says: while the account is a 7702 delegation, the accepted signer is the account itself
  for:
  - action
  - evidence-1
  - justification
  - what
- id: svstored
  source: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  file: src/validators/SuperValidatorBase.sol
  line: 244
  has: return signer == _accountOwners[sender] && isValid;
  says: otherwise the signer must be the stored owner
  for:
  - evidence-1
- id: svowner
  source: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  file: src/validators/SuperValidatorBase.sol
  line: 172
  has: if (owner.code.length == 0 || _is7702Account(owner.code)) {
  says: an owner is checked by ECDSA only if it has no code or a delegation
  for:
  - evidence-1
  - what
- id: sv1271
  source: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  file: src/validators/SuperValidatorBase.sol
  line: 186
  has: try IERC1271(owner).isValidSignature(messageHash, sigData.signature) returns (bytes4 result) {
  says: an owner with real code is asked through ERC-1271
  for:
  - what
- id: selfowner
  call: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  fn: getAccountOwner(address)(address)
  args:
  - '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  says: the default validator's stored owner for this account is the account itself
  for:
  - evidence-1
  - justification
  - what
- id: dstowner
  call: '0xadeff5a0684392c4c273a9c638d1db8c5dfd0098'
  fn: getAccountOwner(address)(address)
  args:
  - '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  says: the installed destination validator's stored owner is also the account itself
  for:
  - evidence-2
  - what
- id: dstcheck
  source: '0xadeff5a0684392c4c273a9c638d1db8c5dfd0098'
  file: src/validators/SuperDestinationValidator.sol
  line: 56
  has: bool isValid = _isSignatureValid(signer, sender, sigData.validUntil);
  says: the destination validator applies the same owner check
  for:
  - evidence-2
- id: dstexec
  call: '0x6ac58e854798d4aae5989b18ad5a1c0ff17817ef'
  fn: SUPER_DESTINATION_VALIDATOR()(address)
  is: '0xadeff5a0684392c4c273a9c638d1db8c5dfd0098'
  says: the installed bridge executor checks signatures with that destination validator
  for:
  - evidence-2
  - what
- id: install
  source: '0x813d4a8747f5f2f67510f7ff364a6a46450ca2f0'
  file: contracts/nexus/Nexus.sol
  lines:
  - 262
  - 271
  has: onlyEntryPointOrSelf
  says: installModule adds a validator when called by the EntryPoint or the account itself
  for:
  - action
  - justification
- id: copyimpl
  storage: '0x6c5df9e7e9d54147af3ab4100b420fdeb217fbd1'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x000000000000000000000000813d4a8747f5f2f67510f7ff364a6a46450ca2f0'
  says: the richest copy is an ERC-1967 proxy to the same Nexus code
  for:
  - notes
- id: copyowner
  call: '0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e'
  fn: getAccountOwner(address)(address)
  args:
  - '0x6c5df9e7e9d54147af3ab4100b420fdeb217fbd1'
  is: '0x337866b3487919c9c436a9c6f67a4abf2dc90756'
  says: that proxy's validator owner is a separate key
  for:
  - notes
- id: copyownereoa
  code: '0x337866b3487919c9c436a9c6f67a4abf2dc90756'
  is: empty
  says: that owner has no code, so it is checked by ECDSA
  for:
  - notes
- id: nonce-before
  nonce: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: 0
  at: 26373152
  says: the account's nonce was 0 the block before its delegation
  for:
  - notes
- id: nonce-at-delegation
  nonce: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: 1
  at: 26373153
  says: 'the account''s only nonce bump: its own EIP-7702 authorization, applied in this block'
  for:
  - notes
- id: nonce-pin
  nonce: '0x1f6bd7a141d73d4162993e44cc4931e53e02edd1'
  is: 1
  says: 'still 1 at the block read: the account has sent no transaction itself'
  for:
  - whose
- id: deleg-tx
  tx: '0xc28b5ed092de6c2436a96666dfdfedbe00f6a48afd6893a9f0bd7f8ecd111a7e'
  to: '0xec6b5d04c195eea62ca2991a7db94aab3502effd'
  ok: true
  says: the relayer's transaction that carried the account's authorization, signed by the account's own key
  for:
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-1f6bd7a1, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-20): an EIP-7702 account delegating to Nexus whose two validators store
    the account itself as owner; if the account takes the Nexus logic as real code no signature can succeed and
    its 0.111 ETH locks. Claude fixed the first refuter''s two points (the nonce came from its own authorization
    in a relayer''s tx, not a sent tx; the code link now goes to the Nexus delegate via a renderer fix). Fresh refuter
    agrees; Claude read the sheet.'
related: []
---

## What happens

This account runs Nexus through an EIP-7702 delegation, and both of its signature validators accept only the account's own key. If the account takes this Nexus logic as its real code, its key stops counting and both validators ask the account itself to approve, so what it holds is locked.

## Evidence

- [SuperValidator](https://etherscan.io/address/0xb46b4773c5f53ff941533f5dfeffd0713f5f9f8e#code) accepts a delegated account's own key; otherwise it asks the stored owner, here the account itself.
- The account's [destination validator](https://etherscan.io/address/0xadeff5a0684392c4c273a9c638d1db8c5dfd0098#code), used by its bridge executor, also has the account itself as owner.

## Reviewer notes

### Mechanism

0x1f6b… is a 23-byte EIP-7702 delegation to Nexus 0x813d…, initialized. Nexus sends every user operation (Nexus.sol 138-140) and every ERC-1271 check (431-449) to a validator: the default SuperValidator 0xb46b…, or an installed one. The only installed validator is SuperDestinationValidator 0xadeff5a0… (its validateUserOp reverts; it serves the bridge executor's processBridgedExecution). Both share SuperValidatorBase: _isSignatureValid (240-244) accepts signer == sender while the sender's code is a delegation, else signer == _accountOwners[sender]; for this account both validators store the account itself as owner. With real code, line 240 no longer applies, and _processSignatureForAccountType (166-193) asks the owner through ERC-1271 (186), i.e. the account itself, whose isValidSignature (445) goes back to a validator with the same self owner: no ECDSA key ever authorizes. The installed executors give no other way: SuperExecutor.execute acts only for msg.sender, SuperDestinationExecutor requires that same validator. No hook is installed. An account with real code cannot send transactions (EIP-3607). While still delegated, the key holder can install a validator with another owner.

### Checks

- Header facts: this address alone, at block 26,438,999; 124 addresses run this code.
- Ruled out: Nexus's own recoveries (initializeAccount 7702 branch 365-388, PREP 129-136) are setup paths gated by !isInitialized(); this account is initialized, so they play no part. The hazard is the validator owner, set to the account itself.
- Ruled out: erc1271: SuperValidatorBase asks an owner with real code through ERC-1271 (186), but the owner here is the account itself, routing back to a validator with the same self owner; no other key.
- Ruled out: direct-path: the only installed executors are SuperExecutor (acts for msg.sender only) and the bridge executor (checks the same self-owned validator); getActiveHook is zero.
- Ruled out: other copies are not this card: of 24 listed I read 11; 9 proxy to the same Nexus with a separate no-code owner key (e.g. 0x6c5d…fbd1: checks copyimpl, copyowner, copyownereoa), so no lock there; 1 proxies elsewhere, 2 now delegate elsewhere; ~113 unread. The value is this account's own.
- Ruled out: breaks-by-itself: the recovery here is OpenZeppelin ECDSA, not a fixed-gas call; nothing fails under EIP-8151 with nobody migrating.
- Ruled out: children: the self-key check sits in the validators this account installed, not Nexus itself; the card speaks of this account's setup.
- Ruled out: other real code: if the account takes code other than this Nexus logic, these validators are not consulted at all; the lock described is specific to this Nexus logic as real code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
