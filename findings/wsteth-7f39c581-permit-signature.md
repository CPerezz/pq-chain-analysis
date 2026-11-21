---
id: wsteth-7f39c581-permit-signature
format: 2
title: wstETH permit trusts ECDSA, so a quantum attacker could take holders' wstETH
status: confirmed
severity: HIGH
justification: Holders' own tokens stay forgeable after they migrate, and nobody can change the contract.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  name: WstETH
  project: lido
  code: verified
  code_url: https://etherscan.io/address/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 8409991518
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Ask holders whose keys have signed on-chain to move wstETH to a fresh post-quantum account; the contract
  cannot change.
evidence_level: source
checks:
- id: permit
  source: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  file: WstETH.sol
  lines:
  - 978
  - 982
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit recovers the signer, requires it to equal owner and then sets owner's allowance for spender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: recover
  source: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  file: WstETH.sol
  line: 750
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls the ecrecover precompile
  for:
  - evidence-1
  - what
- id: no-1271
  bytecode: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  has: 631626ba7e
  absent: true
  says: the runtime code never pushes the ERC-1271 isValidSignature selector, so no signer is asked through ERC-1271
  for:
  - evidence-1
  - justification
  - what
- id: transfer-from
  source: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  file: WstETH.sol
  lines:
  - 474
  - 476
  has: _transfer(sender, recipient, amount);
  says: a spender with an allowance moves the owner's wstETH with transferFrom
  for:
  - what
- id: transfer
  source: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  file: WstETH.sol
  lines:
  - 437
  - 438
  has: _transfer(_msgSender(), recipient, amount);
  says: a holder moves its own wstETH by a direct call, with no signature
  for:
  - action
- id: no-proxy
  storage: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: wrap
  source: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  file: WstETH.sol
  lines:
  - 1070
  - 1075
  has: stETH.transferFrom(msg.sender, address(this), _stETHAmount);
  says: wrap takes the user's stETH into the contract and mints wstETH to that user
  for:
  - evidence-3
  - whose
- id: steth-held
  call: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  is: '4682948054121039215411734'
  says: the contract holds 4.68M stETH
  for:
  - evidence-3
  - whose
- id: supply
  call: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  fn: totalSupply()(uint256)
  is: '3747978954744044955869207'
  says: 3.75M wstETH are held by holders
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review07 (registry review)
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
reviews: []
related: []
---

## What happens

Lido's wstETH lets a holder approve a spender with a signed permit, checked only with ECDSA against the holder's address. A quantum attacker who recovers a holder's key can sign a permit and pull that holder's wstETH, even after the holder moves the address to post-quantum keys.

## Evidence

- [permit](https://etherscan.io/address/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0#code) recovers the signer with ECDSA, requires it to be the owner and sets the allowance; there is no ERC-1271 path.
- The [contract](https://etherscan.io/address/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0) is not a proxy and has no upgrade function.
- It holds 4.68M stETH that backs the 3.75M [wstETH](https://etherscan.io/token/0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0) its holders own.

## Reviewer notes

### Mechanism

permit(owner, spender, value, deadline, v, r, s) (lines 961-983, OpenZeppelin 3.4 ERC20Permit) hashes the EIP-712 Permit struct with the owner's nonce, calls ECDSA.recover (lines 736-754, the ecrecover precompile at line 750), requires the result to equal owner, increments the nonce and calls _approve(owner, spender, value). transferFrom (lines 474-478) then moves the owner's wstETH up to that allowance; unwrap (lines 1086-1092) turns it into the stETH the contract holds. Nothing on the path reads the owner's code or calls ERC-1271, so the old secp256k1 key of an address keeps signing permits after the address moves to post-quantum authorisation (EIP-8141 frames, a 7702 delegation). An attacker needs the holder's public key, so only addresses that have signed on-chain are exposed. The contract has no proxy slot, no DELEGATECALL, no owner and no upgrade function; the only fix without a protocol change is every exposed holder moving to a fresh address. EIP-8151 would close the path for holders whose accounts take real code; a 7702-delegated account stays exposed even then, and allowances already given stay valid.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch: the runtime code has no PUSH4 0x1626ba7e and permit (lines 961-983) reads no code.
- Ruled out: a proxy or upgrade: EIP-1967 implementation slot is zero, no upgradeTo selector, no owner() answer (tool facts).
- Ruled out: a direct path making it harmless: approve (lines 456-459) lets a holder approve without a signature, which keeps post-quantum accounts able to use wstETH, but does not switch permit off, so the forgery path stays open.
- Ruled out: the replay 0xae8dfb44... is not cited: its root call (0x61461954) is not wstETH and was not read step by step; card evidence stays source.
- Ruled out: stETH's own permit is a separate contract and a separate finding (lido-steth-permit-code-first).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
