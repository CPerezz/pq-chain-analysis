---
id: usds-dc035d45-permit-ecdsa-first
format: 2
title: USDS permit still takes a holder's old ECDSA key after it migrates
status: confirmed
severity: MEDIUM
justification: Holders' USDS stays forgeable after they migrate in place; governance can fix it by upgrading the
  token.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  name: Usds
  code: verified
  code_url: https://etherscan.io/address/0x1923dfee706a8e78157416c29cbccfde7cdf4102#code
  proxy_of: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 5236173304
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade permit to ask an owner that has code through ERC-1271 only, and use ECDSA only for owners with no
  code.
evidence_level: source
checks:
- id: ecdsa-first
  source: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  file: src/Usds.sol
  lines:
  - 196
  - 207
  has: if (signer == ecrecover(digest, v, r, s)) {
  says: a 65-byte signature that ecrecover maps to the holder is accepted at once
  for:
  - action
  - evidence-1
  - justification
  - what
- id: erc1271-after
  source: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  file: src/Usds.sol
  lines:
  - 210
  - 217
  has: abi.encodeCall(IERC1271.isValidSignature, (digest, signature))
  says: ERC-1271 is asked only after the ECDSA branch, and only for a signer with code
  for:
  - action
  - evidence-1
  - what
- id: permit-allow
  source: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  file: src/Usds.sol
  lines:
  - 247
  - 249
  has: allowance[owner][spender] = value;
  says: a permit that passes the signature check sets the holder's allowance for the spender
  for:
  - what
  - whose
- id: transfer-from
  source: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  file: src/Usds.sol
  lines:
  - 127
  - 139
  has: balanceOf[from] = balance - value;
  says: transferFrom moves the holder's own balance once an allowance is set
  for:
  - what
  - whose
- id: auth-upgrade
  source: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  file: src/Usds.sol
  line: 73
  has: function _authorizeUpgrade(address newImplementation) internal override auth {}
  says: an upgrade is allowed to any address with a ward
  for:
  - action
  - evidence-2
  - justification
- id: upgrade-fn
  selector: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  fn: upgradeToAndCall(address,bytes)
  says: the implementation has the UUPS upgrade function
  for:
  - evidence-2
- id: impl-slot
  storage: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x1923dfee706a8e78157416c29cbccfde7cdf4102'
  says: the address is an EIP-1967 proxy to the Usds implementation
  for:
  - evidence-2
- id: supply
  call: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  fn: totalSupply()(uint256)
  is: '5236262792261922000577365769'
  says: '5.24 billion USDS are issued: holders'' balances are what a forged permit reaches'
  for:
  - evidence-2
- id: ward-pause
  call: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  fn: wards(address)(uint256)
  args:
  - '0xbe8e3e3618f7474f8cb1d074a26affef007e98fb'
  is: '1'
  says: the pause proxy holds a ward, so it can upgrade the token
  for:
  - action
  - evidence-2
  - justification
- id: pause-owner
  call: '0xbe8e3e3618f7474f8cb1d074a26affef007e98fb'
  fn: owner()(address)
  is: '0xbe286431454714f511008713973d3b053a2d38f3'
  says: the pause proxy is owned by the DSPause contract
  for:
  - evidence-2
  - justification
- id: pause-authority
  call: '0xbe286431454714f511008713973d3b053a2d38f3'
  fn: authority()(address)
  is: '0x929d9a1435662357f54adcf64dcee4d6b867a6f9'
  says: the DSPause contract takes its authority from a governance contract, so it can act
  for:
  - justification
- id: pause-delay
  call: '0xbe286431454714f511008713973d3b053a2d38f3'
  fn: delay()(uint256)
  is: '172800'
  says: actions through the pause wait 48 hours
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews:
- who: r-dc035d45, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-2): USDS''s _isValidSignature returns on an ecrecover match
    before the ERC-1271 branch, so a holder that migrates in place stays forgeable; the fix is a ward-gated UUPS
    upgrade behind Sky''s 48-hour pause proxy. Token supply affected (upper bound) $5.24B. Action corrected by Claude
    after the first refuter; two refuters agree on the final card; Claude read the sheet.'
related: []
---

## What happens

USDS sets an allowance on a signed permit and accepts any signature that ECDSA recovers to the holder, before it asks a smart account through ERC-1271. A holder that adopts a post-quantum key in place keeps its old key valid here, so a quantum attacker can sign a permit and take its USDS.

## Evidence

- `_isValidSignature` in the [verified source](https://etherscan.io/address/0x1923dfee706a8e78157416c29cbccfde7cdf4102#code) returns true when ecrecover matches the holder, before any code or ERC-1271 check.
- The [token](https://etherscan.io/address/0xdc035d45d973e3ec169d2276ddab16f1e407384f) is an upgradeable proxy with 5.24 billion USDS issued; a pause proxy behind a 48-hour delay can upgrade it.

## Reviewer notes

### Mechanism

permit(owner, spender, value, deadline, bytes) (Usds.sol 220-251; the v,r,s overload at 253-263 packs and forwards) builds the EIP-712 digest and requires _isValidSignature(owner, digest, signature) (191-218). For a 65-byte signature it returns true as soon as ecrecover(digest, v, r, s) == owner (196-207); only otherwise, if owner.code.length > 0, it asks IERC1271.isValidSignature (210-217). A valid permit sets allowance[owner][spender] = value (249), and transferFrom then moves the owner's balance (122-146). So an address that keeps its old secp256k1 key valid at the protocol level (an EIP-7702 delegation, or an account with real code while ecrecover still recovers it) stays forgeable by whoever recovers that key. Upgrade: UUPS, _authorizeUpgrade is gated by auth = wards[msg.sender] == 1 (55-58, 73). At block 26,438,999 wards(pause proxy 0xbe8e…98fb) = 1 and wards(UsdsJoin 0x3c0f…7feb) = 1; the pause proxy's owner() is DSPause 0xbe28…38f3, whose authority() is 0x929d…a6f9 and delay() is 172,800 s. totalSupply() = 5,236,262,792 USDS: holders' balances are the exposure; the $48 the proxy itself holds is not.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 rescue: the ERC-1271 branch exists (lines 210-217) but runs only after the ECDSA branch fails, so it does not stop a forged ECDSA permit for a migrated address.
- Ruled out: Unused implementation: this address is the proxy users call; its implementation slot holds 0x1923…4102 and totalSupply() is 5.24 billion USDS at the block.
- Ruled out: Direct path: approve (148-154) lets a holder set allowances itself, but it does not close permit to an attacker.
- Ruled out: Closed path: Usds has no pause or switch on permit (whole source read).
- Ruled out: Replay 0xeaf3bb93…3bee: a 1inch router fill (to 0x1111…2a65, selector 0xf497df75) whose order signature is checked for the same signer, so its revert with code at the signer is not attributable to this contract; not cited.
- Ruled out: EIP-8151 would close the ECDSA branch for an account with real code, but not for an EIP-7702 delegation; the quantum-exposure rubric does not assume the protocol change.
- Ruled out: sUSDS (0xa3931d71…7fbd) was in the old finding; it is another contract and is its own row, not covered here.
- Ruled out: UsdsJoin 0x3c0f…7feb also holds a ward (wards = 1); it is not counted as the fixing party.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
