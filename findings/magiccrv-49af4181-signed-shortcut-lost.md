---
id: magiccrv-49af4181-signed-shortcut-lost
format: 2
title: MagicCRV permit stops working for holders whose accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing is locked: a holder can still set the same allowance by calling approve, and no tokens exist
  at the block.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x49af4181b36b629089a3b26e046d313a115ec911'
  name: MagicCRV
  code: verified
  code_url: https://etherscan.io/address/0x49af4181b36b629089a3b26e046d313a115ec911#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Tell holders to call approve directly instead of signing a permit once their accounts take real code.
evidence_level: source
checks:
- id: inherits
  source: '0x49af4181b36b629089a3b26e046d313a115ec911'
  file: contracts/magic-crv/MagicCRV.sol
  line: 13
  has: contract MagicCRV is ERC20 {
  says: MagicCRV is solmate's ERC20 token, which carries permit
  for:
  - what
- id: recover
  source: '0x49af4181b36b629089a3b26e046d313a115ec911'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 141
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer of the permit digest with ecrecover
  for:
  - evidence-1
  - what
- id: match
  source: '0x49af4181b36b629089a3b26e046d313a115ec911'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 143
  has: require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
  says: the recovered address must be the token owner named in the call
  for:
  - action
  - evidence-1
  - what
  - whose
- id: sets
  source: '0x49af4181b36b629089a3b26e046d313a115ec911'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  line: 145
  has: allowance[recoveredAddress][spender] = value;
  says: on a match permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - what
- id: approve
  source: '0x49af4181b36b629089a3b26e046d313a115ec911'
  file: '@rari-capital/solmate/src/tokens/ERC20.sol'
  lines:
  - 71
  - 72
  has: allowance[msg.sender][spender] = amount;
  says: approve sets the caller's allowance by a direct call, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no1271
  selector: '0x49af4181b36b629089a3b26e046d313a115ec911'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code has no ERC-1271 check
  for:
  - notes
- id: supply
  call: '0x49af4181b36b629089a3b26e046d313a115ec911'
  fn: totalSupply()(uint256)
  is: '0'
  says: no MagicCRV tokens exist at the block
  for:
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

MagicCRV is a token whose permit sets an allowance when an ECDSA signature recovers to the holder. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps working. No tokens exist at the block.

## Evidence

- [permit](https://etherscan.io/address/0x49af4181b36b629089a3b26e046d313a115ec911#code) recovers the signer with ecrecover and sets the allowance only if it equals the owner.
- [approve](https://etherscan.io/address/0x49af4181b36b629089a3b26e046d313a115ec911#code) sets the same allowance from a direct call by the holder.
- [totalSupply](https://etherscan.io/address/0x49af4181b36b629089a3b26e046d313a115ec911#readContract) is zero at the block.

## Reviewer notes

### Mechanism

MagicCRV (MagicCRV.sol line 13) inherits solmate's ERC20 with EIP-2612 permit. permit (ERC20.sol lines 119-149) builds the EIP-712 digest, calls ecrecover (line 141), requires the result to be non-zero and equal to the owner argument (line 143), then writes allowance[owner][spender] (line 145). Under EIP-8151 ecrecover returns nothing for an owner whose account holds real code, so the require fails. approve (lines 71-77) writes allowance[msg.sender][spender] from a direct call and needs no signature, so the holder keeps the same right. ecrecover is the Solidity builtin with all remaining gas, so no fixed gas budget. The contract is not a proxy and has no owner or pause. totalSupply is 0 at block 26,438,999, so no holder is affected today; mint/mintFor are open and route CRV to curveVoter 0x6C46...B548.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for owners with code: permit has none (lines 141-143) and the code has no isValidSignature selector.
- Ruled out: a fixed gas budget for the precompile: ecrecover is the Solidity builtin, which forwards the remaining gas (line 141).
- Ruled out: unused implementation code: the address is not a proxy target; it has its own name and state at the block.
- Ruled out: signature checked again after others relied on it: a permit only sets an allowance once, nobody relies on it later.
- Ruled out: a sender gas-limit issue beside this notice: the scan shows no window calls and no replays for this code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
