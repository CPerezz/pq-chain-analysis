---
id: pendleberastonevaultsy-d7b2a47a-signed-shortcut-lost
format: 2
title: SY-beraSTONE holders whose accounts take real code lose permit
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing is locked: a holder whose account takes real code can still call approve itself.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd7b2a47ac9236d9685b573a2428f72ec45e97c45'
  name: PendleBeraStoneVaultSY
  code: verified
  code_url: https://etherscan.io/address/0xf18cf923d7437278189ceba1fc1ee1546c8b75ae#code
  proxy_of: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  copies: 2
  family: 8ddd18504e86eb8ec67dd9bacb87d286
  upgradeable: 'yes'
  admin: '0xa28c08f165116587d4f3e708743b4dee155c5e64'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders who plan to move their accounts to real code to approve spenders with approve instead of a
  signed permit.
evidence_level: source
checks:
- id: permit-recover
  source: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  file: contracts/sy/contracts/core/erc20/PendleERC20PermitUpg.sol
  line: 51
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer of the EIP-712 permit with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: permit-match
  source: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  file: contracts/sy/contracts/core/erc20/PendleERC20PermitUpg.sol
  lines:
  - 52
  - 54
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must be the owner, then the owner's allowance is set
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is a plain call to the ecrecover precompile
  for:
  - what
- id: approve
  source: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  file: contracts/sy/contracts/core/erc20/PendleERC20Upg.sol
  lines:
  - 144
  - 148
  has: _approve(owner, spender, amount);
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: name
  call: '0xd7b2a47ac9236d9685b573a2428f72ec45e97c45'
  fn: symbol()(string)
  is: SY-beraSTONE
  says: the token at this address is SY-beraSTONE
  for:
  - what
- id: supply
  call: '0xd7b2a47ac9236d9685b573a2428f72ec45e97c45'
  fn: totalSupply()(uint256)
  is: '32590962981277866242'
  says: the token has holders at the block
  for:
  - evidence-2
  - whose
- id: not-paused
  call: '0xd7b2a47ac9236d9685b573a2428f72ec45e97c45'
  fn: paused()(bool)
  is: false
  says: the token is not paused at the block
  for:
  - evidence-2
- id: copy-unused
  call: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the other address with this code, the implementation, was never initialized
  for:
  - evidence-2
- id: copy-empty
  call: '0xf18cf923d7437278189ceba1fc1ee1546c8b75ae'
  fn: totalSupply()(uint256)
  is: '0'
  says: the implementation has no supply, so this proxy is the copy in use
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-d7b2a47a, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. Pendle SY-beraSTONE (proxy, live, about 32.59 SY
    in supply): permit ECDSA-only (lines 51-52), approve direct. Its backing is unpriced beraSTONE, so the tool''s
    money line reads $0 in ETH and priced tokens. INFORMATIONAL (was LOW).'
related: []
---

## What happens

Pendle's SY-beraSTONE token lets a holder approve a spender with an ECDSA-signed permit. Its permits are rejected once the holder's account takes real code; an EIP-7702 delegation keeps working. The direct approve call still works.

## Evidence

- [permit](https://etherscan.io/address/0xf18cf923d7437278189ceba1fc1ee1546c8b75ae#code) recovers the signer with ECDSA and requires it to equal the owner; it has no ERC-1271 path.
- [approve](https://etherscan.io/address/0xf18cf923d7437278189ceba1fc1ee1546c8b75ae#code) sets the caller's own allowance with no signature; the token is live and not paused.

## Reviewer notes

### Mechanism

The proxy runs PendleBeraStoneVaultSY, which inherits SYBaseUpg -> PendleERC20PermitUpg. permit (PendleERC20PermitUpg.sol lines 36-55) builds the EIP-712 hash, calls ECDSA.recover (OZ ECDSA, plain ecrecover forwarding all gas, line 139), requires signer == owner and calls _approve(owner, spender, value). approve (PendleERC20Upg.sol lines 144-148) does the same _approve for msg.sender with no signature. Under EIP-8151 ecrecover returns nothing for an owner whose account has real code, so permit reverts with 'invalid signature' for that owner; approve is unaffected. Pausing only blocks transfers (_beforeTokenTransfer whenNotPaused), not approvals; at the block the token is not paused and has about 32.59 SY-beraSTONE in supply. The other address with this code is the implementation itself, never initialized (owner 0, supply 0), so this proxy is the copy in use.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path: permit compares the recovered address with owner only (lines 51-52); no isValidSignature anywhere in the source.
- Ruled out: a fixed gas amount for the recovery: OZ ECDSA uses the ecrecover builtin, which forwards the gas left (ECDSA.sol line 139).
- Ruled out: an unused address: this proxy has a supply of 32590962981277866242 and is not paused; the other copy (the implementation) is uninitialized with supply 0.
- Ruled out: a signature checked again after others relied on it: permit only sets an allowance once.
- Ruled out: replays: the dossier has none for this code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
