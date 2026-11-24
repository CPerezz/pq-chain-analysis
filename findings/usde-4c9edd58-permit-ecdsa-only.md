---
id: usde-4c9edd58-permit-ecdsa-only
format: 2
title: USDe permit accepts only ECDSA, which a quantum computer could forge
status: confirmed
severity: HIGH
justification: Holders' USDe stays forgeable after they move to post-quantum keys, and the permit code cannot be
  changed.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  name: USDe
  code: verified
  code_url: https://etherscan.io/address/0x4c9edd5852cd905f086c759e8383e09bff1e68b3#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe8dc0fab349ea169283c48ccfd09d797e6db7c94'
value:
  usd: 4843864245
  basis: market-cap
activity: {}
impact: funds-loss
action: Tell holders that permit keeps trusting their old ECDSA key, so a holder who adopts post-quantum keys should
  move USDe to a new address.
evidence_level: source
checks:
- id: usde-permit
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: contracts/USDe.sol
  line: 14
  has: contract USDe is Ownable2Step, ERC20Burnable, ERC20Permit, IUSDeDefinitions {
  says: USDe inherits OpenZeppelin ERC20Permit and does not override permit
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-recover
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  lines:
  - 64
  - 65
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit recovers the signer with ECDSA and requires it to be the holder's address
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  lines:
  - 64
  - 67
  has: _approve(owner, spender, value);
  says: after the check, permit sets the spender's allowance on the holder's balance
  for:
  - evidence-1
  - what
- id: recover-ecdsa
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover is a plain ecrecover, with no ERC-1271 call
  for:
  - evidence-1
  - what
- id: transfer-from
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 158
  - 160
  has: _spendAllowance(from, spender, amount);
  says: a spender with an allowance moves the holder's tokens with transferFrom
  for:
  - what
- id: approve
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 136
  - 138
  has: _approve(owner, spender, amount);
  says: a holder can approve directly, without a signature
  for:
  - notes
- id: no-proxy
  storage: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
  - what
- id: no-upgrade
  selector: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgradeTo
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-upgrade-call
  selector: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the code has no upgradeToAndCall
  for:
  - evidence-2
  - justification
  - what
- id: set-minter
  source: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  file: contracts/USDe.sol
  lines:
  - 22
  - 25
  has: function setMinter(address newMinter) external onlyOwner {
  says: the owner's own function sets the minter; nothing else in USDe.sol is owner-only besides the blocked renounce
  for:
  - notes
- id: owner
  call: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  fn: owner()(address)
  is: '0xe8dc0fab349ea169283c48ccfd09d797e6db7c94'
  says: the owner at the block
  for:
  - notes
- id: supply
  call: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  fn: totalSupply()(uint256)
  is: '4845824575566377595823503861'
  says: about 4.85 billion USDe are held by holders at the block
  for:
  - notes
- id: replay-8151
  replay: '0x4af3c36b1e713e5de509d1c96798006fe01511295ba39e06c16e205b4e209329'
  run: eip8151
  ok: true
  says: a real transaction recovering through this code still succeeds under EIP-8151 alone
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews:
- who: r-4c9edd58, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: 'kept: Kev''s first-study finding, HIGH (PQ-1): USDe''s permit is OZ ERC20Permit (ECDSA only, no ERC-1271),
    no proxy or upgrade; the owner can only set the minter. Token supply affected (upper bound) $4.84B, the market-cap
    basis now computed by the tool (the first refuter''s only objection). Both refuters agree; Claude read the sheet.
    Waits for Anon''s sign-off before filing. sUSDe, sENA and USDtb are their own rows.'
related: []
---

## What happens

USDe lets a holder approve a spender with an offline permit signature, checked with ECDSA only. A quantum attacker who recovers a holder's key can sign a permit to itself and move the holder's USDe. Moving to post-quantum keys at the same address does not stop this, and the token cannot be upgraded.

## Evidence

- [permit](https://etherscan.io/address/0x4c9edd5852cd905f086c759e8383e09bff1e68b3#code) recovers the signer with ECDSA, requires it to equal the holder, then sets the allowance; there is no ERC-1271 path.
- The [token](https://etherscan.io/address/0x4c9edd5852cd905f086c759e8383e09bff1e68b3#code) is not a proxy and has no upgrade function.

## Reviewer notes

### Mechanism

USDe (USDe.sol line 14) inherits OpenZeppelin ERC20Permit without overriding permit. permit (ERC20Permit.sol lines 49-68) builds the EIP-712 digest with the holder's nonce, calls ECDSA.recover(hash, v, r, s), which is a plain ecrecover (ECDSA.sol line 139), requires the result to equal the holder address and calls _approve(owner, spender, value). The spender then takes the balance with transferFrom (ERC20.sol lines 158-160). The check compares against the holder's address and never looks at account code or calls isValidSignature, so the holder's old secp256k1 key keeps working after the holder adopts post-quantum authorisation at that address. The address is not a proxy (EIP-1967 slot empty, no upgradeTo or upgradeToAndCall selector); the owner (0xe8dc0fab..., read at the block) can only set the minter (USDe.sol lines 22-25) and hand over ownership. Total supply at the block is about 4.85 billion USDe; that is what holders keep in this token, an upper bound of what is exposed. The contract itself holds $32,100 of priced tokens.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path: permit and ECDSA.recover have none (ERC20Permit.sol lines 64-65, ECDSA.sol line 139).
- Ruled out: unused implementation or closed path: the address is not a proxy and is live; the dossier's two-week trace window shows 232 recoveries by this code from 141 signers up to block 26,438,474, and totalSupply is about 4.85 billion USDe at the block.
- Ruled out: an owner fix: the owner (0xe8dc0fab349ea169283c48ccfd09d797e6db7c94) can only call setMinter and the Ownable2Step transfer; nothing replaces permit.
- Ruled out: direct path: a holder can still call approve directly (ERC20.sol lines 136-138), so post-quantum holders are not locked out of approvals; this does not stop a forged permit.
- Ruled out: breaks by itself under EIP-8151: the dossier's replay 0x4af3c36b... succeeds under EIP-8151 alone; with real code at the signer it reverts and with a 7702 delegation it succeeds. Not cited on the card: the transaction's other calls were not read.
- Ruled out: value: the $32,100 the address holds is tokens sent to the token contract itself; whose they are cannot be shown without logs, so whose is left empty. The exposure is holders' balances, not this figure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
