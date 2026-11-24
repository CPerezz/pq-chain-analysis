---
id: governancetoken-d8dd38ca-signed-shortcut-lost
format: 2
title: Swing token holders whose accounts take real code lose signed permits
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing is locked: a holder whose account takes real code still approves and delegates by direct
  call.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  name: GovernanceToken
  code: verified
  code_url: https://etherscan.io/address/0xd8dd38ca016f3e0b3bc545d33cce72af274ce075#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1d3f7972f1f9281ffb69b83310e53a136c2cc2f8'
value:
  usd: 43
  basis: held
activity:
  txs_90d: 13
  last: 2026-10-13
impact: liveness
action: Tell holders that permit and delegateBySig stop working once their account takes real code; approve and
  delegate still work.
evidence_level: source
checks:
- id: permit-owner
  source: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  file: contracts/token/Swing.sol
  lines:
  - 1141
  - 1144
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit recovers the signer with ECDSA, requires it to be the token owner, then sets that owner's allowance
  for:
  - action
  - evidence-1
  - what
- id: delegate-sig
  source: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  file: contracts/token/Swing.sol
  lines:
  - 1669
  - 1676
  has: _delegate(signer, delegatee);
  says: delegateBySig recovers the signer with ECDSA and delegates the signer's votes
  for:
  - action
  - what
- id: recover-zero
  source: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  file: contracts/token/Swing.sol
  lines:
  - 872
  - 875
  has: return (address(0), RecoverError.InvalidSignature);
  says: when ecrecover returns nothing, the recovery fails as an invalid signature
  for:
  - what
- id: approve
  source: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  file: contracts/token/Swing.sol
  lines:
  - 282
  - 285
  has: _approve(owner, spender, amount);
  says: approve sets the caller's own allowance with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: delegate
  source: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  file: contracts/token/Swing.sol
  lines:
  - 1653
  - 1655
  has: _delegate(_msgSender(), delegatee);
  says: delegate moves the caller's own votes with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: supply
  call: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  fn: totalSupply()(uint256)
  is: '1000000000000000000000000000'
  says: one billion SWING are minted, so the token is in use
  for:
  - notes
- id: no-1967
  storage: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - upgradeable
- id: no-upgrade
  selector: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgradeTo function
  for:
  - upgradeable
- id: no-upgrade-call
  selector: '0xd8dd38ca016f3e0b3bc545d33cce72af274ce075'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: the code has no upgradeToAndCall function
  for:
  - upgradeable
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-d8dd38ca, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. Swing (SWING): permit and delegateBySig through ECDSA.tryRecover,
    no ERC-1271; approve and delegate direct. The $43 of USDT at the token is unrelated. INFORMATIONAL (was LOW).'
related: []
---

## What happens

The Swing (SWING) token lets a holder approve a spender with a signed permit and delegate votes with a signed message, or do both by a direct call. A holder whose account takes real code loses both signed paths; an EIP-7702 delegation keeps them.

## Evidence

- [permit](https://etherscan.io/address/0xd8dd38ca016f3e0b3bc545d33cce72af274ce075#code) recovers the signer with ECDSA and requires it to be the token owner; it has no ERC-1271 path.
- [approve and delegate](https://etherscan.io/address/0xd8dd38ca016f3e0b3bc545d33cce72af274ce075#code) act for the caller and need no signature.

## Reviewer notes

### Mechanism

permit (lines 1126-1145) hashes the EIP-712 Permit struct with the owner's nonce, calls ECDSA.recover and requires the result to equal owner before _approve. delegateBySig (lines 1660-1677) recovers the signer of a Delegation struct and delegates the signer's votes. ECDSA.tryRecover (line 872) calls ecrecover and returns InvalidSignature when it yields zero, so recover reverts. Under EIP-8151 ecrecover returns nothing for an account with real code, so both signed paths revert for that holder; an EIP-7702 delegation still recovers. approve (282-286) and delegate (1653-1655) act for msg.sender with no signature, so the same acts stay open. At block 26,438,999: totalSupply 1e27 (1,000,000,000 SWING), owner 0x1d3f...c2f8 is an EOA (empty code) that can only mint; no pause.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for holders with code: permit and delegateBySig call only ECDSA.recover (lines 1141-1142, 1669-1675).
- Ruled out: a fixed gas budget to the precompile: ecrecover is the Solidity builtin at line 872, which forwards the available gas; the scanner found no gas constant.
- Ruled out: a closed path: the contract has no pause; permit and delegateBySig check only the deadline/expiry and the nonce.
- Ruled out: a proxy or unused implementation: EIP-1967/1822/beacon slots empty, the token has 1e27 supply and 13 transactions in 90 days.
- Ruled out: the $43 of USDT at the address is not holders' funds (whose left empty: whose it is cannot be shown) and no function of this contract moves it; it does not change the notice.
- Ruled out: upgradeability: the scaffold left it empty citing a DELEGATECALL opcode or upgrade selector; the verified source has no delegatecall and no upgrade function, the EIP-1967 slot is empty and upgradeTo/upgradeToAndCall are absent, so stated as no.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
