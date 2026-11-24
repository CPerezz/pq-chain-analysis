---
id: liquiditygaugev6-a0d26cfd-signed-shortcut-lost
format: 2
title: Curve gauge permit stops working for holders whose accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a holder moves to real code; that holder can still approve by a direct call.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  name: LiquidityGaugeV6
  project: curve
  code: verified
  code_url: https://etherscan.io/address/0xa0d26cfdd329777ab1398ac31bbacd4b12760f26#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 1
  last: 2026-10-30
impact: liveness
action: Tell holders to use approve from their own account, not permit, once their account takes real code.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  file: LiquidityGaugeV6.vy
  line: 573
  has: assert ecrecover(digest, _v, _r, _s) == _owner
  says: permit accepts a signature only when the ECDSA-recovered address equals the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  file: LiquidityGaugeV6.vy
  line: 527
  has: self.allowance[msg.sender][_spender] = _value
  says: approve sets the caller's allowance directly, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-1271
  selector: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the runtime code never calls ERC-1271 isValidSignature
  for:
  - evidence-1
  - what
- id: full-gas
  bytecode: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  has: 60015afa
  says: the call to the ecrecover precompile forwards all remaining gas
  for:
  - notes
- id: deposit-credit
  source: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  file: LiquidityGaugeV6.vy
  line: 425
  has: self.balanceOf[_addr] = new_balance
  says: deposits are credited to the depositors' own balances
  for:
  - whose
- id: supply-zero
  call: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  fn: totalSupply()(uint256)
  is: '0'
  says: nobody holds gauge tokens at the block
  for:
  - what
- id: not-killed
  call: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  fn: is_killed()(bool)
  is: 'false'
  says: the gauge is not killed
  for:
  - notes
- id: author
  source: '0xa0d26cfdd329777ab1398ac31bbacd4b12760f26'
  file: LiquidityGaugeV6.vy
  line: 6
  has: '@author Curve.Fi'
  says: the verified source names Curve.Fi as author
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
- who: r-a0d26cfd, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. Curve LiquidityGaugeV6 (crvInETH): permit ECDSA-only
    (line 573) though its docstring claims ERC-1271; approve and increaseAllowance direct. Q2-class: totalSupply
    0 at the block, as the card says. INFORMATIONAL.'
related: []
---

## What happens

This Curve gauge lets a holder grant a spending allowance by an ECDSA-signed permit or by calling approve directly. A holder whose account takes real code can no longer sign a permit; an EIP-7702 delegation keeps working. At the block the gauge holds no deposits.

## Evidence

- [permit](https://etherscan.io/address/0xa0d26cfdd329777ab1398ac31bbacd4b12760f26#code) sets the allowance only if the recovered signer equals the owner; it never asks a contract owner.
- [approve](https://etherscan.io/address/0xa0d26cfdd329777ab1398ac31bbacd4b12760f26#code) sets the same allowance for the caller with no signature.

## Reviewer notes

### Mechanism

permit (lines 534-579) builds the EIP-712 digest over owner, spender, value, nonce and deadline, and asserts ecrecover(digest, v, r, s) == _owner (line 573); it then writes allowance[_owner][_spender] and bumps the nonce. approve (lines 514-530) and increaseAllowance (582-597) write allowance[msg.sender][...] with no signature, so a holder with real code keeps the same act by a direct call. The ecrecover is a STATICCALL to address 1 with all remaining gas (bytes 6001 5a fa), not a fixed amount. The docstring at line 547 claims ERC-1271 support, but the ERC1271 interface (line 27) is never called and the isValidSignature selector is absent from the runtime code. At block 26,438,999 totalSupply is 0, is_killed is false and reward_count is 0: the gauge is open for deposits but nobody holds gauge tokens, so no allowance is at stake today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 path: the docstring at line 547 claims it, but permit only compares ecrecover with _owner (line 573) and the runtime code has no isValidSignature selector.
- Ruled out: fixed-gas recovery: the call to the precompile passes GAS (6001 5afa), no 3,000 constant.
- Ruled out: unused implementation: not a proxy; the constructor initialized it (name() returns the crvInETH gauge name).
- Ruled out: path closed: is_killed is false and does not gate permit; deposits remain open even though totalSupply is 0.
- Ruled out: breaks by itself: no replays and no window calls in the dossier; nothing here fails without a holder migrating.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
