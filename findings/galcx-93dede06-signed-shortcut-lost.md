---
id: galcx-93dede06-signed-shortcut-lost
format: 2
title: gALCX holders whose accounts take real code lose permit; approve still works
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a holder moves its account to real code; that holder can still set allowances by calling
  approve.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  name: gALCX
  code: verified
  code_url: https://etherscan.io/address/0x93dede06ae3b5590af1d4c111bc54c3f717e4b35#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9e2b6378ee8ad2a4a95fe481d63caba8fb0ebbf9'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 52
  last: 2026-11-16
impact: liveness
action: Tell holders and integrators that permit signatures from accounts with real code stop working, and that
  those accounts call approve instead.
evidence_level: source
checks:
- id: permit-ec
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 141
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer of the EIP-712 digest with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: permit-eq
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 143
  has: require(recoveredAddress != address(0) && recoveredAddress == owner
  says: permit reverts unless the recovered address is the token owner, with no other branch
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-set
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 145
  has: allowance[recoveredAddress][spender] = value;
  says: a valid permit sets the owner's allowance for the spender
  for:
  - what
- id: approve
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  lines:
  - 71
  - 77
  has: allowance[msg.sender][spender] = amount;
  says: approve sets the caller's allowance directly, without a signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: mint
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: contracts/gALCX.sol
  line: 94
  has: _mint(msg.sender, gAmount);
  says: stake mints gALCX to the depositor
  for:
  - whose
- id: unstake
  source: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  file: contracts/gALCX.sol
  line: 106
  has: bool success = alcx.transfer(msg.sender, amount);
  says: unstake pays the staked ALCX back to the holder who burns gALCX
  for:
  - whose
- id: supply
  call: '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  fn: totalSupply()(uint256)
  args: []
  is: '283111218472230924278289'
  says: 283,111 gALCX are issued at the block
  for:
  - evidence-2
- id: staked
  call: '0xab8e74017a8cc7c15ffccd726603790d26d7deca'
  fn: getStakeTotalDeposited(address,uint256)(uint256)
  args:
  - '0x93dede06ae3b5590af1d4c111bc54c3f717e4b35'
  - 1
  is: '435449544561876557941298'
  says: the staking pool holds 435,449 ALCX deposited by gALCX in pool 1
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
- who: r-93dede06, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. gALCX: solmate permit (ECDSA only), direct approve;
    nothing breaks without a holder migrating (all gas forwarded). INFORMATIONAL (was LOW).'
related: []
---

## What happens

gALCX, a token for staked ALCX, lets a holder grant an allowance by signing a permit or by calling approve. A holder whose account takes real code can no longer use permit and calls approve instead; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x93dede06ae3b5590af1d4c111bc54c3f717e4b35#code) requires ecrecover to return the owner; approve needs no signature.
- At the block, 283,111 gALCX are issued, backed by 435,449 ALCX the [contract](https://etherscan.io/address/0x93dede06ae3b5590af1d4c111bc54c3f717e4b35#code) has staked.

## Reviewer notes

### Mechanism

gALCX inherits solmate ERC20. permit (ERC20.sol lines 119-149) builds the EIP-712 digest, calls ecrecover (line 141), requires the result to be non-zero and equal to owner (line 143), then sets allowance[owner][spender] (line 145). There is no ERC-1271 or code-size branch, so under EIP-8151 a permit from an owner with real code reverts INVALID_SIGNER. approve (lines 71-77) sets allowance[msg.sender][spender] with no signature, so the same act stays open by a direct call from the account. gALCX.sol adds stake (mints gALCX to msg.sender, line 94) and unstake (pays ALCX to msg.sender, line 106); neither uses a signature. ecrecover is the Solidity builtin with all gas forwarded, so the higher price breaks nothing by itself.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path in permit: none (ERC20.sol lines 119-149).
- Ruled out: a fixed gas amount for the recovery: permit uses the Solidity ecrecover builtin, which forwards the remaining gas; no rated gas finding.
- Ruled out: a later recheck of the permit: it sets the allowance at once (line 145); nothing checks the signature again.
- Ruled out: path closed: the contract has no pause; at block 26,438,999 totalSupply is 283,111 gALCX and 435,449 ALCX is staked for it, so it is live.
- Ruled out: proxy or copy: the tool reads no proxy and the dossier lists no copies; stake, unstake and approve are direct calls with no signature.
- Ruled out: the owner (a Safe at 0x9e2b…bbf9) can only transfer ownership and migrate the staking pool; it has no role in permit.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
