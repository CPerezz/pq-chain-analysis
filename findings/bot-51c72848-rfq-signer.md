---
id: bot-51c72848-rfq-signer
format: 2
title: Market-maker contract lets one ECDSA key approve trades of its own funds
status: confirmed
severity: MEDIUM
justification: One forged key lets exchanges take its approved tokens; the check is ECDSA-only, so the fix is a
  new contract.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  name: Bot
  code: verified
  code_url: https://etherscan.io/address/0x51c72848c68a965f66fa7a88855f9f7784502a7f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 67654990
  whose: operator
  basis: held
activity: {}
impact: funds-loss
action: Move the funds to a contract that checks a post-quantum signature for RFQ orders; killContract stops the
  signed path meanwhile.
evidence_level: source
checks:
- id: ecdsa
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 694
  - 704
  has: address recovered = ECDSA.recover(hash, signature);
  says: _validateSignature recovers with ECDSA and returns the magic value only if the result is the stored _rfqSigner
  for:
  - evidence-1
  - justification
  - what
- id: isvalid
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 689
  - 692
  has: require(_approvedRfqCallers_1CiVF7[msg.sender], "H19"); return _validateSignature(hash, signature);
  says: isValidSignature answers approved RFQ callers while the contract is active, through _validateSignature alone
  for:
  - evidence-1
  - what
- id: signer-set
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 294
  - 297
  has: require(_rfqSigner == address(0), "H20"); _rfqSigner = account;
  says: the signer is set only by the access-control registry, one at a time
  for:
  - notes
- id: signer
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: _rfqSigner()(address)
  is: '0xa0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8'
  says: the stored RFQ signer is 0xa0f1…b1d8
  for:
  - justification
  - what
- id: signer-code
  code: '0xa0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8'
  is: empty
  says: the signer is an account with no code
  for:
  - what
- id: active
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: isActive()(bool)
  is: true
  says: the contract is active, so isValidSignature answers
  for:
  - what
- id: caller-bebop
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: _approvedRfqCallers_1CiVF7(address)(bool)
  args:
  - '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  is: true
  says: BebopSettlement is an approved RFQ caller
  for:
  - what
- id: caller-permit2
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: _approvedRfqCallers_1CiVF7(address)(bool)
  args:
  - '0x000000000022d473030f116ddee9f6b43ac78ba3'
  is: true
  says: Permit2 is an approved RFQ caller
  for:
  - what
- id: caller-1inch5
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: _approvedRfqCallers_1CiVF7(address)(bool)
  args:
  - '0x1111111254eeb25477b68fb85ed929f73a960582'
  is: true
  says: the 1inch v5 router is an approved RFQ caller
  for:
  - what
- id: caller-1inch6
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: _approvedRfqCallers_1CiVF7(address)(bool)
  args:
  - '0x111111125421ca6dc452d289314280a0f8842a65'
  is: true
  says: the 1inch v6 router is an approved RFQ caller
  for:
  - what
- id: bebop1271
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopSigning.sol
  lines:
  - 152
  - 154
  has: if (IERC1271(validationAddress).isValidSignature(hash, signature) != EIP1271_MAGICVALUE){
  says: Bebop accepts a contract maker's order when the maker's isValidSignature returns the magic value
  for:
  - evidence-2
  - justification
  - what
- id: bebop-pull
  source: '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  file: src/base/BebopTransfer.sol
  line: 254
  has: IERC20(maker_tokens[j]).safeTransferFrom(from, receiver, amount);
  says: Bebop then pulls the maker's tokens under its allowance
  for:
  - evidence-2
  - what
- id: bal-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  is: 14800932090272
  says: the contract holds 14,800,932 USDC
  for:
  - evidence-2
  - what
- id: bal-usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  is: 12112902118966
  says: the contract holds 12,112,902 USDT
  for:
  - evidence-2
  - what
- id: bal-weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  is: 6546587290402100358149
  says: the contract holds 6,546.6 WETH
  for:
  - evidence-2
  - what
- id: allow-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: allowance(address,address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  - '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  is: 115792089237316195423570985008687907853269984665640564039457563716124801524929
  says: Bebop's USDC allowance from the contract exceeds its balance
  for:
  - evidence-2
  - justification
  - what
- id: allow-usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: allowance(address,address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  - '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  is: 115792089237316195423570985008687907853269984665640564039457584007913129639935
  says: Bebop's USDT allowance from the contract is unlimited
  for:
  - evidence-2
  - what
- id: allow-weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: allowance(address,address)(uint256)
  args:
  - '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  - '0xbbbbbbb520d69a9775e85b458c58c648259fad5f'
  is: 115792089237316195423570985008687907853269984665640564039457584007913129639935
  says: Bebop's WETH allowance from the contract is unlimited
  for:
  - evidence-2
  - what
- id: no-1271-alt
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 694
  - 704
  has: if (recovered == signer) { return 0x1626ba7e; } else { revert("H22"); }
  says: 'there is no other way to pass the check: no ERC-1271 call to a signer contract, no second key'
  for:
  - action
  - evidence-1
  - justification
- id: kill
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 373
  - 381
  has: '|| msg.sender == multiSigOwner, "H11" ); isActive = false; revokeAllApprovals_IXLJyu();'
  says: killContract (operators, transferers, WETH handlers, multisig) deactivates the contract and revokes approvals
  for:
  - action
- id: multisig
  call: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  fn: multiSigOwner()(address)
  is: '0xce466fc694c971b95bb1193e494942e22197f759'
  says: the multisig owner is 0xce46…f759
  for:
  - action
- id: ms-threshold
  call: '0xce466fc694c971b95bb1193e494942e22197f759'
  fn: getThreshold()(uint256)
  is: 4
  says: the multisig is a Safe with threshold 4
  for:
  - action
- id: own-funds
  source: '0x51c72848c68a965f66fa7a88855f9f7784502a7f'
  file: src/Bot.sol
  lines:
  - 459
  - 464
  has: onlyTransferer onlyApprovedRecipients(to)
  says: funds leave by transfer only to recipients the registry approved; the contract has no deposit or user-balance
    accounting
  for:
  - whose
- id: recovery-tx
  tx: '0x69c5f7d32292623b2240b88cfc3d2afc408017bed31bb45432b4062eab2c96ee'
  to: '0x8f5835e9d756c9bd934bce527157a4b0ef3c5cb7'
  ok: true
  says: a successful transaction in which the scan saw the signer recovered (signatures of this key are on-chain,
    so its public key is known)
  for:
  - notes
- id: signer-nonce
  nonce: '0xa0f1898fb62aee04f9aa1aa5866bc48e6b4cb1d8'
  is: 0
  says: the signer has never sent a transaction
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-51c72848, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-4): this market maker''s isValidSignature approves an RFQ
    order when one ECDSA key recovers, with no second key and no call to the signer, so a forged key lets Bebop
    and the 1inch routers pull its $67.65M of approved tokens to the forger''s own order; the code is immutable,
    so a post-quantum check needs a new contract; killContract stops the signed path meanwhile. Two refuters agree;
    Claude read the sheet.'
related: []
---

## What happens

This market-maker contract approves orders for Bebop, Permit2 and two 1inch routers by recovering an ECDSA signature and comparing it with one stored signer key. A quantum attacker who recovers that key can sign orders that move the contract's tokens, such as everything Bebop may pull.

## Evidence

- [isValidSignature](https://etherscan.io/address/0x51c72848c68a965f66fa7a88855f9f7784502a7f#code) returns the magic value only if ECDSA recovers the stored signer.
- [Bebop](https://etherscan.io/address/0xbbbbbbb520d69a9775e85b458c58c648259fad5f#code) asks it through ERC-1271, and may pull all its USDC, USDT and WETH.

## Reviewer notes

### Mechanism

isValidSignature (Bot.sol 689-692) is whenActive, requires msg.sender to be an approved RFQ caller and calls _validateSignature (694-704): it loads _rfqSigner, requires it set, runs OZ 4.7.3 ECDSA.recover and returns 0x1626ba7e only if the result equals _rfqSigner; else it reverts. No ERC-1271 call to a signer, no second key. Approved callers at the block: BebopSettlement, Permit2, 1inch v5 and v6. Bebop (BebopSigning 152-154) asks a contract maker's isValidSignature and then pulls the maker's tokens (BebopTransfer 254) under its allowance, which is unlimited for USDT/WETH and above the balance for USDC. _rfqSigner is set and cleared only by the access-control registry 0x7ff4…6b93 (onRoleGranted/onRoleRevoked 294-297, 333-337); any replacement is again an ECDSA key, so rotation does not help. killContract (373-381; operators, transferers, WETH handlers or the multisig Safe 1.3.0 0xce46…f759, threshold 4) sets isActive false, which closes isValidSignature, and revokes approvals; unkillContract (multisig) reopens it. Funds: no deposit path or user balances; outflows go to registry-approved recipients (459-491).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: no path for a signer with code; only ECDSA equality (694-704).
- Ruled out: key-state: signer 0xa0f1…b1d8 is set, no code, nonce 0 (presumed live); the scan saw it recovered 21,940 times in the window, so its public key is on-chain.
- Ruled out: path-closed: isActive true; the four RFQ callers approved at the block.
- Ruled out: setter: the registry can replace the signer only with another ECDSA key; the registry is unverified and its controller not established.
- Ruled out: gas: Solidity ecrecover forwards all gas; no fixed gas.
- Ruled out: wrong-code: not a proxy, one address runs this code; source is a verified partial-match reconstruction.
- Ruled out: value-whose: no user deposits; it trades its own funds. Project not stated: source names no team, Blockscout shows no public tag.
- Ruled out: Permit2 and 1inch hold allowances too, but their pull paths were not cited; the card relies on Bebop.
- Ruled out: EIP-8151, separate notice: replay 0x328d0863… reverts with code at the signer. Replay 0x65fc7c04… (to 0xf67e35af…, tight) did not match its receipt under EIP-8151 alone; not sent here, check for a row elsewhere.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
