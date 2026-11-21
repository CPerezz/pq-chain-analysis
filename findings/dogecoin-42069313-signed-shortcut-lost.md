---
id: dogecoin-42069313-signed-shortcut-lost
format: 2
title: Dogecoin holders with real code lose permit and keep approve
status: confirmed
severity: INFORMATIONAL
justification: Permit fails only for a holder that moves its account to real code; that holder still sets allowances
  with approve.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4206931337dc273a630d328da6441786bfad668f'
  name: Dogecoin
  code: verified
  code_url: https://etherscan.io/address/0x4206931337dc273a630d328da6441786bfad668f#code
  copies: 1
  upgradeable: 'no'
  admin: '0x35ae5a983217f52652d038611c28ea7303fc8143'
value:
  usd: 26
  basis: held
activity:
  txs_90d: 16535
  last: 2026-11-18
impact: liveness
action: Tell holders and integrations to call approve instead of permit once a holder's account has real code.
evidence_level: source
checks:
- id: recover
  source: '0x4206931337dc273a630d328da6441786bfad668f'
  file: ERC20.sol
  line: 139
  has: address signer = ecrecover(hash, _v, _r, _s);
  says: permit recovers the signer of the permit hash with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: match
  source: '0x4206931337dc273a630d328da6441786bfad668f'
  file: ERC20.sol
  line: 140
  has: require (signer == _owner, "Invalid signature");
  says: permit reverts unless the recovered address is the owner named in the call; there is no other branch
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-sets
  source: '0x4206931337dc273a630d328da6441786bfad668f'
  file: ERC20.sol
  line: 142
  has: approveCore(_owner, _spender, _amount);
  says: after the signature matches, permit sets the owner's allowance for the spender
  for:
  - evidence-2
  - what
- id: approve
  source: '0x4206931337dc273a630d328da6441786bfad668f'
  file: ERC20.sol
  lines:
  - 47
  - 50
  has: return approveCore(msg.sender, _spender, _amount);
  says: approve sets the caller's allowance through the same internal function, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: approve-core
  source: '0x4206931337dc273a630d328da6441786bfad668f'
  file: ERC20.sol
  line: 42
  has: allowance[_owner][_spender] = _amount;
  says: approveCore writes the allowance that both permit and approve set
  for:
  - evidence-2
- id: permit-selector
  selector: '0x4206931337dc273a630d328da6441786bfad668f'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: the deployed code has the permit function
  for:
  - evidence-3
- id: no-1271
  bytecode: '0x4206931337dc273a630d328da6441786bfad668f'
  has: 1626ba7e
  absent: true
  says: the deployed code never uses the ERC-1271 isValidSignature selector, so a signer with code is not asked
    another way
  for:
  - evidence-3
  - what
- id: permit-live
  call: '0x4206931337dc273a630d328da6441786bfad668f'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)()
  args:
  - '0x35ae5a983217f52652d038611c28ea7303fc8143'
  - '0x0000000000000000000000000000000000000001'
  - '1'
  - '99999999999'
  - '27'
  - '0x0000000000000000000000000000000000000000000000000000000000000001'
  - '0x0000000000000000000000000000000000000000000000000000000000000001'
  reverts: true
  says: permit is reachable at the block and rejects a signature that does not recover to the named owner
  for:
  - evidence-3
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

Dogecoin's permit sets a token allowance when an ECDSA signature recovers to the holder named in the call. A holder whose account has real code gets no address recovered, so its permit reverts. That holder can still call approve directly.

## Evidence

- [permit](https://etherscan.io/address/0x4206931337dc273a630d328da6441786bfad668f#code) recovers the signer with ecrecover and reverts unless it equals the named owner.
- [approve](https://etherscan.io/address/0x4206931337dc273a630d328da6441786bfad668f#code) sets the same allowance for the caller and takes no signature.
- The [deployed code](https://etherscan.io/address/0x4206931337dc273a630d328da6441786bfad668f#code) has the permit function and no ERC-1271 call for signers with real code.

## Reviewer notes

### Mechanism

permit (ERC20.sol, lines 133-143) checks the deadline, builds the EIP-712 hash from nonces[_owner], calls ecrecover (line 139) and requires signer == _owner (line 140), then bumps the nonce and calls approveCore(_owner, _spender, _amount) (line 142). Under EIP-8151 ecrecover returns nothing for an owner with real code, Solidity reads that as address(0), and the require reverts with 'Invalid signature'. approve (lines 47-50) calls approveCore(msg.sender, ...) (line 49), which writes the same allowance mapping (line 42); increaseAllowance and decreaseAllowance go through approve. The contract is not a proxy and has no upgrade function, so permit itself cannot be changed. The other two ecrecover sites (Dogecoin.sol joinParty line 27, multiJoinParty line 48) compare the signer with the minters mapping; they are a different root issue and are not judged here. All 26 recoveries in the trace window are of that kind (selector 0xa1f6b2a7, one minter key); no permit call was seen in the window, and none is claimed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: no ERC-1271 or code-size branch in permit (lines 133-143); the runtime code does not contain the selector 1626ba7e.
- Ruled out: unused-implementation / wrong-code / children: not a proxy and no copies; the dossier's code hash is the verified Dogecoin source; totalSupply() at the block is 6429304407149600 (8 decimals), so the token is in use.
- Ruled out: path-closed: permit has no pause or switch; a call with a bad signature at the block reverts with 'Invalid signature', the require at line 140, so the function is reachable.
- Ruled out: direct-path: approve(address,uint256) is public, takes no signature and writes allowance[msg.sender][spender] through approveCore (lines 40-50).
- Ruled out: rechecked-later: permit consumes the signature once (nonce bump at line 141) and nothing rechecks it.
- Ruled out: breaks-by-itself: both replays in the dossier fail under EIP-8151 alone with out-of-gas, but they are joinParty (0xcef6d209) and multiJoinParty (0xa1f6b2a7) transactions, not permit; the scanner found no constant gas on the precompile call (ec_gas_const null) and Solidity's ecrecover forwards all gas. That belongs to the sender-gas-limits row for this address, not to this one.
- Ruled out: key-state: the key is each holder's own; none is stored.
- Ruled out: Edge: permit with _owner = address(0) passes the comparison for any bad signature, today and after the change; transferCore refuses _from = address(0), so that allowance moves nothing. Not part of this notice.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
