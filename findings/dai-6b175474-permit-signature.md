---
id: dai-6b175474-permit-signature
format: 2
title: DAI permits stay forgeable for holders even after they migrate their accounts
status: confirmed
severity: HIGH
justification: A holder's DAI stays forgeable after the holder migrates, and nobody can change the token.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6b175474e89094c44da98b954eedeac495271d0f'
  name: Dai
  project: sky
  code: verified
  code_url: https://etherscan.io/address/0x6b175474e89094c44da98b954eedeac495271d0f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 4425692669
  basis: market-cap
activity: {}
impact: funds-loss
action: Tell holders to move their DAI to a fresh address when they move their account to post-quantum keys.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  line: 134
  has: require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
  says: permit accepts the signature only if ECDSA recovers the holder
  for:
  - evidence-1
  - justification
  - what
- id: permit-unlimited
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  lines:
  - 137
  - 138
  has: 'uint wad = allowed ? uint(-1) : 0; allowance[holder][spender] = wad;'
  says: a valid permit sets the spender's allowance to unlimited
  for:
  - evidence-1
  - what
- id: spend
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  lines:
  - 75
  - 81
  has: if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
  says: transferFrom moves the holder's balance for a spender with an allowance, and does not lower an unlimited
    one
  for:
  - what
- id: no-1271
  selector: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a signer through ERC-1271
  for:
  - evidence-1
  - justification
  - what
- id: no-proxy
  storage: '0x6b175474e89094c44da98b954eedeac495271d0f'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - action
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: auth-fns
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  lines:
  - 23
  - 24
  has: function rely(address guy) external note auth { wards[guy] = 1; } function deny(address guy) external note
    auth { wards[guy] = 0; }
  says: wards can add and remove wards; with mint (line 85) these are the only auth functions
  for:
  - evidence-2
  - justification
- id: auth-mint
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  line: 85
  has: function mint(address usr, uint wad) external auth {
  says: mint is the third and last auth function
  for:
  - evidence-2
  - justification
- id: transfer
  source: '0x6b175474e89094c44da98b954eedeac495271d0f'
  file: dai.sol
  lines:
  - 69
  - 71
  has: return transferFrom(msg.sender, dst, wad);
  says: a holder moves its own DAI by direct call, with no signature
  for:
  - action
- id: supply
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: totalSupply()(uint256)
  is: '4427849031765537012067233356'
  says: 4.43 billion DAI are in circulation at the block
  for:
  - evidence-3
  - what
- id: self-balance
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: '4439758586410847342518581'
  says: the token's own address holds 4.44M DAI, which makes up almost all of what it holds
  for:
  - notes
- id: proxy-empty
  call: '0xd16af9d4154d6f3ba289c5386910d116587fdc60'
  fn: totalSupply()(uint256)
  is: '0'
  says: the one proxy that runs this code has no DAI state of its own
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
  who: Review15 (finding review)
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
  pattern: PQ-1
reviews:
- who: r-6b175474, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: 'kept: Kev''s first-study finding, HIGH (PQ-1): DAI''s permit accepts only the holder''s ECDSA signature,
    sets an unlimited allowance, and the token cannot change (no proxy or upgrade; wards only rely, deny and mint).
    Token supply affected (upper bound) $4.43B. Both refuters agree; Claude read the sheet. Waits for Anon''s sign-off
    before filing.'
related: []
---

## What happens

DAI's permit gives a spender an unlimited allowance when the signature recovers to the holder with ECDSA; it has no other signature check. A quantum attacker who recovers a holder's key can sign a permit and take that DAI, even after the holder migrates. 4.43 billion DAI are in circulation.

## Evidence

- [permit](https://etherscan.io/address/0x6b175474e89094c44da98b954eedeac495271d0f#code) sets an unlimited allowance when `ecrecover` returns the holder; no ERC-1271 call.
- The [token](https://etherscan.io/address/0x6b175474e89094c44da98b954eedeac495271d0f#code) has no proxy and no upgrade function; its wards can only add or remove wards and mint.
- [totalSupply](https://etherscan.io/token/0x6b175474e89094c44da98b954eedeac495271d0f) is 4.43 billion DAI.

## Reviewer notes

### Mechanism

permit (lines 118-140) builds an EIP-712 digest over holder, spender, nonce, expiry and allowed, requires holder != 0 and holder == ecrecover(digest, v, r, s) (line 134), checks expiry and the holder's nonce, and sets allowance[holder][spender] to uint(-1) when allowed (lines 137-138). transferFrom (lines 72-84) then moves the holder's balance without lowering an unlimited allowance. The code has no ERC-1271 call and no code-size check, so the holder's secp256k1 key alone decides. A holder who moves the address to post-quantum authorisation (an EIP-7702 delegation or EIP-8141 frames) keeps the same address, so the old key still signs permits here; only EIP-8151, which this category does not assume, would stop it, and only for accounts with real code. The contract is not a proxy, has no upgrade function, and its auth functions are rely, deny (lines 23-24) and mint (line 85): nothing can change permit. Holders can still approve and transfer by direct call (lines 69-71, 100-104), so post-quantum accounts are not locked out.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path: the runtime code has no isValidSignature selector, and permit has no other branch (lines 133-136).
- Ruled out: unused implementation: proxy 0xd16af9d4154d6f3ba289c5386910d116587fdc60 points at this code but its own state is empty (totalSupply 0, DOMAIN_SEPARATOR 0); this address is the DAI token in use, with 4.43 billion DAI supply.
- Ruled out: the value on the header: the $4.46M is what the tool reads as held at the token's own address, almost all DAI credited to the token itself (balanceOf(DAI) = 4.44M DAI); no key holds that address, so permit cannot reach it, and whose it is was left open. The exposure is holders' balances, bounded by the supply.
- Ruled out: a fix by governance: wards can only rely, deny and mint (lines 23-24, 85); no function changes permit, DOMAIN_SEPARATOR or the recovery.
- Ruled out: rating as a migration notice: this is a first-study quantum-exposure row and keeps that rubric (HIGH, step 4: users' own funds stay forgeable after they migrate, in a contract that cannot change). Under EIP-8151 a separate notice (signed shortcut lost for holders whose accounts take real code; an EIP-7702 delegation keeps permit) would be INFORMATIONAL; the dossier lists no replay for this family.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
