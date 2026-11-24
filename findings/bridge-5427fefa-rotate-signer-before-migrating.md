---
id: bridge-5427fefa-rotate-signer-before-migrating
format: 2
title: Bridge stops paying out if its signers move their accounts to real code
status: confirmed
severity: INFORMATIONAL
justification: Signers can replace their keys before moving to real code; a separate gas issue already hits two
  real withdrawals.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  name: Bridge
  label: 'Celer Network: cBridge V2'
  code: verified
  code_url: https://etherscan.io/address/0x5427fefa711eff984124bfbb1ab6fbf5e3da1820#code
  copies: 5
  family: f3969f727e902e067e61f557b2769805
  upgradeable: 'no'
  admin: '0xf380166f8490f24af32bf47d1aa217fba62b6575'
value:
  usd: 1487609
  whose: users
  basis: held
activity: {}
impact: liveness
action: Replace any signer key with updateSigners before moving that signer's account to real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 106
  has: address signer = _hash.recover(_sigs[i]);
  says: each signature is recovered with ECDSA; there is no other way to count a signer
  for:
  - evidence-1
  - what
- id: ecrecover
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 107
  has: address signer = ecrecover(hash, v, r, s);
  says: recover uses the ecrecover precompile
  for:
  - what
- id: nonzero
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 108
  has: 'require(signer != address(0), "ECDSA: invalid signature");'
  says: an empty recovery reverts, so such a signature cannot be included
  for:
  - what
- id: match
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  lines:
  - 114
  - 116
  has: if (signer == _signers[index]) {
  says: power is added only for a recovered address that is in the signer list
  for:
  - evidence-1
  - what
- id: sethash
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  lines:
  - 38
  - 39
  has: require(ssHash == h, "Mismatch current signers");
  says: the signer list given in the call must hash to the stored set
  for:
  - evidence-1
  - what
- id: quorum
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 100
  has: uint256 quorum = (totalPower * 2) / 3 + 1;
  says: the signers that sign must hold two thirds of the power plus one
  for:
  - evidence-1
  - what
- id: revert
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 122
  has: revert("quorum not reached");
  says: below the quorum the check reverts
  for:
  - evidence-1
  - what
- id: relay
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Bridge.sol
  line: 98
  has: verifySigs(abi.encodePacked(domain, _relayRequest), _sigs, _signers, _powers);
  says: relay checks the signers before anything else
  for:
  - what
- id: relay-pay
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Bridge.sol
  line: 118
  has: _sendToken(request.receiver, request.token, request.amount);
  says: relay then pays the receiver
  for:
  - what
- id: withdraw
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Pool.sol
  line: 73
  has: verifySigs(abi.encodePacked(domain, _wdmsg), _sigs, _signers, _powers);
  says: withdraw checks the signers before anything else
  for:
  - what
- id: withdraw-pay
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Pool.sol
  line: 86
  has: _sendToken(wdmsg.receiver, wdmsg.token, wdmsg.amount);
  says: withdraw then pays the receiver
  for:
  - what
- id: rotate
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  lines:
  - 64
  - 65
  has: verifySigs(abi.encodePacked(domain, _triggerTime, _newSigners, _newPowers), _sigs, _curSigners, _curPowers);
  says: updateSigners installs a new set once the current quorum has signed it
  for:
  - action
  - evidence-2
  - justification
  - what
- id: store
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 132
  has: ssHash = keccak256(abi.encodePacked(_signers, _powers));
  says: the new set replaces the stored one
  for:
  - action
  - evidence-2
  - justification
- id: reset
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 72
  has: function resetSigners(address[] calldata _signers, uint256[] calldata _powers) external onlyOwner {
  says: the owner can replace the signer set without the signers
  for:
  - evidence-2
  - what
- id: reset-time
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  line: 73
  has: require(block.timestamp > resetTime, "not reach reset time");
  says: a reset works only after the reset time
  for:
  - evidence-2
  - what
- id: notify
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  lines:
  - 78
  - 79
  has: resetTime = block.timestamp + noticePeriod;
  says: the owner sets the reset time one notice period ahead
  for:
  - evidence-2
  - what
- id: notice
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: noticePeriod()(uint256)
  is: 604800
  says: the notice period is 604,800 seconds, 7 days
  for:
  - evidence-2
  - what
- id: reset-pending
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: resetTime()(uint256)
  is: '115792089237316195423570985008687907853269984665640564039457584007913129639935'
  says: no reset is pending, so the notice has to be given first
  for:
  - notes
- id: owner
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: owner()(address)
  is: '0xf380166f8490f24af32bf47d1aa217fba62b6575'
  says: the owner that can reset the signers
  for:
  - evidence-2
  - what
- id: owner-code
  code: '0xf380166f8490f24af32bf47d1aa217fba62b6575'
  is: contract
  bytes: 10262
  says: the owner is a contract with code, not a renounced or dead address
  for:
  - what
- id: sshash
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: ssHash()(bytes32)
  is: '0xf3a6a73222248670559e329f7bd97f0438e405c59edcf5b86fa0e871b8ad3807'
  says: a signer set is stored at this address
  for:
  - notes
- id: updated
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: triggerTime()(uint256)
  is: 1794760130
  says: updateSigners has run at this address
  for:
  - notes
- id: not-paused
  call: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  fn: paused()(bool)
  is: false
  says: the bridge is not paused
  for:
  - notes
- id: used
  tx: '0x7d87f31517f77e0d256390644aa9d99c01ceff411026a54d47ca68948c275a75'
  to: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  ok: true
  says: a real transaction called this address directly and succeeded
  for:
  - notes
- id: deposit-send
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Bridge.sol
  line: 53
  has: IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
  says: send takes the tokens of whoever bridges
  for:
  - whose
- id: deposit-liquidity
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Pool.sol
  line: 53
  has: IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
  says: addLiquidity takes the tokens of whoever provides liquidity
  for:
  - whose
- id: public-verify
  source: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  file: contracts/Signers.sol
  lines:
  - 32
  - 37
  has: ) public view override {
  says: verifySigs is public, so other contracts can check signatures against this signer set
  for:
  - evidence-3
  - what
- id: vault-verifier
  call: '0x7510792a3b1969f9307f3845ce88e39578f2bae1'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: the vault uses this contract as its signature checker
  for:
  - evidence-3
  - what
- id: vault-weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7510792a3b1969f9307f3845ce88e39578f2bae1'
  is: '472876819621080703768'
  says: the vault holds 472.88 WETH
  for:
  - evidence-3
- id: vault-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7510792a3b1969f9307f3845ce88e39578f2bae1'
  is: '120011678'
  says: the vault holds 120.01 USDC
  for:
  - notes
- id: vault-withdraw
  tx: '0xd9f99412047a55b4b07091fdaff2390d048f4b6bee48485be2a3d0d2c4c330ea'
  to: '0x7510792a3b1969f9307f3845ce88e39578f2bae1'
  ok: true
  says: a real withdraw to the vault succeeded; the dossier records the signer it recovered running this contract's
    code
  for:
  - notes
- id: copy-notice
  call: '0x9b36f165bab9ebe611d491180418d8de4b8f3a1f'
  fn: noticePeriod()(uint256)
  is: 0
  says: the copy 0x9b36f165bab9ebe611d491180418d8de4b8f3a1f has no notice period, so the 7 days hold at this address
    only
  for:
  - notes
- id: vault-calls
  bytecode: '0x7510792a3b1969f9307f3845ce88e39578f2bae1'
  has: 63682dbc22
  says: the vault's code pushes the selector of verifySigs, which it calls on its signature checker
  for:
  - evidence-3
  - what
- id: vault2-verifier
  call: '0xb37d31b2a74029b5951a2778f959282e2d518595'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: the second vault uses this contract as its signature checker
  for:
  - evidence-3
  - what
- id: vault2-calls
  bytecode: '0xb37d31b2a74029b5951a2778f959282e2d518595'
  has: 63682dbc22
  says: the second vault's code pushes the selector of verifySigs, which it calls on its signature checker
  for:
  - evidence-3
  - what
- id: vault2-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0xb37d31b2a74029b5951a2778f959282e2d518595'
  is: '1728003265609'
  says: the second vault holds 1,728,003 USDC
  for:
  - evidence-3
- id: replay-direct-today
  replay: '0x7d87f31517f77e0d256390644aa9d99c01ceff411026a54d47ca68948c275a75'
  run: today
  ok: true
  says: a real direct withdrawal succeeds under today's rules
  for:
  - justification
- id: replay-direct-8151
  replay: '0x7d87f31517f77e0d256390644aa9d99c01ceff411026a54d47ca68948c275a75'
  run: eip8151
  ok: false
  says: the same withdrawal fails under EIP-8151 with no account changed
  for:
  - justification
- id: replay-vault-today
  replay: '0xd9f99412047a55b4b07091fdaff2390d048f4b6bee48485be2a3d0d2c4c330ea'
  run: today
  ok: true
  says: a real vault withdrawal succeeds under today's rules
  for:
  - justification
- id: replay-vault-8151
  replay: '0xd9f99412047a55b4b07091fdaff2390d048f4b6bee48485be2a3d0d2c4c330ea'
  run: eip8151
  ok: false
  says: the same vault withdrawal fails under EIP-8151 with no account changed
  for:
  - justification
- id: vault2-usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xb37d31b2a74029b5951a2778f959282e2d518595'
  is: '846567382307'
  says: the second vault also holds 846,567 USDT
  for:
  - evidence-3
- id: peg1-verifier
  call: '0x16365b45eb269b5b5dacb34b4a15399ec79b95eb'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this pegged-token bridge uses this contract as its signature checker
  for:
  - what
- id: peg1-calls
  bytecode: '0x16365b45eb269b5b5dacb34b4a15399ec79b95eb'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
- id: peg1-mint
  selector: '0x16365b45eb269b5b5dacb34b4a15399ec79b95eb'
  fn: mint(bytes,bytes[],address[],uint256[])
  says: it has a signed mint
  for:
  - what
- id: peg2-verifier
  call: '0x52e4f244f380f8fa51816c8a10a63105dd4de084'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this pegged-token bridge uses this contract as its signature checker
  for:
  - what
- id: peg2-calls
  bytecode: '0x52e4f244f380f8fa51816c8a10a63105dd4de084'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
- id: peg2-mint
  selector: '0x52e4f244f380f8fa51816c8a10a63105dd4de084'
  fn: mint(bytes,bytes[],address[],uint256[])
  says: it has a signed mint
  for:
  - what
- id: msg1-verifier
  call: '0x479ec366ae4ec016ce25b918bdea8f78d4fa5dd8'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this contract uses this one as its signature checker
  for:
  - what
- id: msg1-calls
  bytecode: '0x479ec366ae4ec016ce25b918bdea8f78d4fa5dd8'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
- id: msg2-verifier
  call: '0x7a80254e5564ee7f7bb53b9da6c7f768a7d2e8c9'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this contract uses this one as its signature checker
  for:
  - what
- id: msg2-calls
  bytecode: '0x7a80254e5564ee7f7bb53b9da6c7f768a7d2e8c9'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
- id: msg3-verifier
  call: '0xa5ce03bc529b97350f044ee9429cec169b903e2f'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this contract uses this one as its signature checker
  for:
  - what
- id: msg3-calls
  bytecode: '0xa5ce03bc529b97350f044ee9429cec169b903e2f'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
- id: msg4-verifier
  call: '0xdd9c6479a44ff66c500b18a13d69b7245b80d39c'
  fn: sigsVerifier()(address)
  is: '0x5427fefa711eff984124bfbb1ab6fbf5e3da1820'
  says: this contract uses this one as its signature checker
  for:
  - what
- id: msg4-calls
  bytecode: '0xdd9c6479a44ff66c500b18a13d69b7245b80d39c'
  has: 63682dbc22
  says: its code pushes the selector of verifySigs
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-5427fefa, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Returned three times (the 7-day notice holds here only; a false ''nothing breaks'' while two real
    withdrawals fail on gas; the dependents). The card now names all eight contracts that verify signatures through
    it (two vaults, about $1.7M USDC and USDT and 473 WETH; two pegged-token bridges; four others), each with a
    sigsVerifier call and a bytecode check, and points the gas failure to its own row. A fresh refuter agrees (50
    checks); sheet read by Claude. The refuter''s open point is answered by Claude''s replays in replays_extra.jsonl:
    the vault withdrawal 0xd9f99412… succeeds with 300,000 more gas, so its limit is the sender''s (for the row
    sender-gas-limits|0x5427fefa…). INFORMATIONAL.'
related: []
---

## What happens

Payouts need ECDSA signatures from signers holding over two thirds of the power. A signer that moves to real code no longer counts. If over a third of the power moves, signed actions stop here and at eight contracts that check signatures through it: two vaults, two pegged-token bridges, four others.

## Evidence

- The [verified source](https://etherscan.io/address/0x5427fefa711eff984124bfbb1ab6fbf5e3da1820#code) recovers each signature with ECDSA, counts signers of the stored set, and needs two thirds of the power plus one.
- updateSigners replaces the set when the current signers sign it; the [owner](https://etherscan.io/address/0xf380166f8490f24af32bf47d1aa217fba62b6575) can reset it after a notice, 7 days at this address.
- Of these, [one vault](https://etherscan.io/address/0xb37d31b2a74029b5951a2778f959282e2d518595) holds 1,728,003 USDC and 846,567 USDT, [the other](https://etherscan.io/address/0x7510792a3b1969f9307f3845ce88e39578f2bae1) 472.88 WETH.

## Reviewer notes

### Mechanism

relay (Bridge.sol line 98) and withdraw (Pool.sol line 73) call verifySigs before paying. verifySigs (Signers.sol 32-41) requires keccak(signers, powers) from the call to equal the stored ssHash, then _verifySignedPowers (89-123) recovers each signature with OpenZeppelin ECDSA.recover (ecrecover, then require non-zero), requires ascending order, adds the power of recovered addresses in the list, returns at quorum = total*2/3+1, else reverts. An empty ecrecover result makes recover itself revert, so a signature from a signer with code cannot be included. updateSigners (51-67) passes a new set through the same verifySigs under the current set, then writes ssHash (132). resetSigners (72-76) is onlyOwner and needs block.timestamp > resetTime; resetTime is MAX_INT at the block, so the owner must first call notifyResetSigners (78-81), setting now + noticePeriod (604,800 s). The owner is a 10,262-byte contract. ssHash is non-zero and triggerTime is set, so updateSigners has run here.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: ERC-1271 or code-size path for a signer with code: _verifySignedPowers (Signers.sol 89-123) only uses ECDSA.recover; no isValidSignature call in the source.
- Ruled out: Unused implementation: this address is not a proxy, has its own non-zero ssHash, holds the value itself, and tx 0x7d87f315... called it directly.
- Ruled out: Key unset: ssHash is non-zero and updateSigners has run (triggerTime set).
- Ruled out: Setter unusable: updateSigners needs only the current quorum and has run; the owner is a contract with code; resetTime shows no reset pending, so notice must run first. The copy 0x9b36f165... has noticePeriod 0, so '7 days' applies only here.
- Ruled out: Direct path without signers: funds leave only through _sendToken, called from relay, withdraw and executeDelayedTransfer (draining queued transfers); no owner or governor function moves tokens.
- Ruled out: Path closed: paused() is false at the block.
- Ruled out: Rechecked later: each signature is checked once, at payout; nothing stored relies on it afterwards.
- Ruled out: Breaks by itself: replaying 0x7d87f315... (direct) and 0xd9f99412... (vault) under EIP-8151 alone, no account changed, flips ok to false (cold-access gas on a 12-13-signer committee). Filed separately as sender-gas-limits|0x5427fefa..., not folded in here.
- Ruled out: Other dependents: of 64 dossier addresses, 8 return this address from sigsVerifier() and push the verifySigs selector: the two vaults, two pegged-token bridges (same owner), and 4 others. The remaining 56 revert on sigsVerifier() and do not push that selector; they hold this address as a constant but do not check signatures here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
