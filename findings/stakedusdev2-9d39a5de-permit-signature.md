---
id: stakedusdev2-9d39a5de-permit-signature
format: 2
title: sUSDe permit lets a holder's old key approve its shares after it migrates
status: confirmed
severity: HIGH
justification: Holders' shares stay forgeable after they move to post-quantum accounts, and nothing can change the
  permit path.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  name: StakedUSDeV2
  project: ethena
  code: verified
  code_url: https://etherscan.io/address/0x9d39a5de30e57443bff2a8307a4256c8797a3497#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe8dc0fab349ea169283c48ccfd09d797e6db7c94'
value:
  usd: 1175800363
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Tell holders who move to post-quantum accounts to move their sUSDe to a fresh address first; this vault's
  permit cannot change.
evidence_level: source
checks:
- id: permit
  source: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  lines:
  - 64
  - 67
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA, requires it to equal owner and sets the allowance
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  has: 1626ba7e
  absent: true
  says: the runtime code holds no isValidSignature selector, so no ERC-1271 call
  for:
  - evidence-1
  - justification
  - what
- id: approve
  source: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 136
  - 138
  has: function approve(address spender, uint256 amount)
  says: approve sets an allowance by a direct call from the holder
  for:
  - what
- id: transfer-from
  source: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 158
  - 161
  has: _spendAllowance(from, spender, amount);
  says: transferFrom moves the holder's shares to whoever holds the allowance
  for:
  - what
  - whose
- id: shares-minted
  source: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol
  line: 222
  has: _mint(receiver, shares);
  says: shares are minted to the depositors who stake USDe
  for:
  - whose
- id: no-proxy
  storage: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - action
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: supply
  call: '0x9d39a5de30e57443bff2a8307a4256c8797a3497'
  fn: totalSupply()(uint256)
  is: '934914054108348445288883130'
  says: 'the vault is in use: 934.9M sUSDe shares outstanding'
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
  pattern: PQ-1
reviews:
- who: r-9d39a5de, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: 'kept: Kev''s first-study finding, HIGH (PQ-1): sUSDe''s permit checks only an ECDSA recovery and never
    asks the owner''s account, so a holder that moves to post-quantum authorisation at the same address stays forgeable
    through permit and transferFrom; the permit path cannot change (no proxy, no upgrade), though a live admin holds
    other roles (Claude''s justification fix after the first refuter). Token supply affected (upper bound) about
    $1.18B. Two refuters agree on the final card; Claude read the sheet. Waits for Anon''s sign-off.'
related: []
---

## What happens

Ethena's sUSDe vault lets a holder approve a spender by an ECDSA-signed permit as well as by a call. Permit never asks the holder's account, so a holder that moves to post-quantum authorisation at the same address can still have its shares taken with its old key.

## Evidence

- [permit](https://etherscan.io/address/0x9d39a5de30e57443bff2a8307a4256c8797a3497#code) recovers the signer with ECDSA, requires it to be the owner and sets the allowance; it never calls isValidSignature.
- No proxy and no upgrade function in the [contract](https://etherscan.io/address/0x9d39a5de30e57443bff2a8307a4256c8797a3497#code), so the permit code cannot change.

## Reviewer notes

### Mechanism

StakedUSDeV2 inherits OpenZeppelin ERC20Permit (StakedUSDe.sol line 19). permit (ERC20Permit.sol lines 49-68) builds the EIP-712 digest with the owner's nonce, calls ECDSA.recover(hash, v, r, s) (ecrecover at ECDSA.sol line 139), requires signer == owner and calls _approve(owner, spender, value). The spender then calls ERC20.transferFrom (lines 158-163), which spends the allowance and moves the holder's sUSDe shares. Shares are minted to depositors by ERC4626._deposit (line 222). The (v, r, s) interface carries no other signature form and the runtime code holds no isValidSignature selector (1626ba7e), so an owner whose account moved to post-quantum authorisation at the same address is still approved by any valid ECDSA signature from its old key. At block 26,438,999 the address has no EIP-1967 implementation slot and no upgradeTo selector; owner() is the timelock 0xe8dc…7c94, whose roles (blacklist, cooldown, rescue of non-USDe tokens, redistribution of fully restricted balances) do not touch permit. cooldownDuration is 86,400 s, so ERC4626 withdraw/redeem by allowance are off; transferFrom is the path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch for owners with code: permit has none (ERC20Permit.sol lines 49-68) and the runtime code has no 1626ba7e bytes.
- Ruled out: Upgrade: the EIP-1967 implementation slot is empty and the code has no upgradeTo(address) selector at block 26,438,999.
- Ruled out: Unused or retired address: totalSupply() is 934,914,054 sUSDe at block 26,438,999 and the dossier's two-week window shows 25 recoveries by this code from 24 signers.
- Ruled out: Path closed: permit has no pause; the admin's blacklist blocks only the listed addresses' transfers, not permit for others.
- Ruled out: Direct path: approve() and transferFrom need no signature, so post-quantum holders can still approve by a call; this does not close the ECDSA path for a migrated holder.
- Ruled out: EIP-8151 would close this path for holders whose accounts take real code (an EIP-7702 delegation keeps recovering); the exposure rubric does not assume it.
- Ruled out: Other contracts with the same permit (USDe, USDtb, sENA) were on the old shared card; each is its own row and is not judged here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
