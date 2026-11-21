---
id: blockbrokerengine-7d30e81e-signed-shortcut-lost
format: 2
title: Broker holders whose accounts take real code lose gasless withdrawals
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a holder moves to real code, and the direct withdrawal still pays that holder.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  name: BlockBrokerEngine
  code: verified
  code_url: https://etherscan.io/address/0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68#code
  copies: 1
  upgradeable: 'no'
  admin: '0x25f62864541e26521db3d72a0bc08050d41f7d47'
value:
  usd: 901
  whose: users
  basis: held
activity:
  txs_90d: 669
  last: 2026-09-11
impact: liveness
action: Tell broker holders who move their accounts to real code to withdraw by direct call instead of by signature.
evidence_level: source
checks:
- id: ecdsa
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 656
  has: address recovered = ecrecover(digest, v, r, s);
  says: withdrawAllWithSig recovers the signer with ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: holder-match
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 657
  has: if (recovered == address(0) || recovered != holder) revert BadSignature();
  says: the recovered address must be the holder, otherwise the call reverts
  for:
  - evidence-1
  - justification
  - what
- id: holder-is-owner
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 648
  has: address holder = nft.ownerOf(tokenId);
  says: the holder is the broker NFT's current owner
  for:
  - evidence-1
- id: payout-holder
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 659
  has: _payout(tokenId, holder);
  says: on a valid signature the vault is paid to the holder
  for:
  - evidence-1
  - what
- id: direct
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  lines:
  - 623
  - 626
  has: _payout(tokenId, msg.sender);
  says: withdrawAll pays the whole vault to the caller with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: only-holder
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 246
  has: if (nft.ownerOf(tokenId) != msg.sender) revert NotBrokerHolder();
  says: the direct withdrawal is open to the NFT's current owner
  for:
  - action
  - evidence-2
  - what
- id: payout-vault
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  line: 808
  has: uint256 u = vaultUnits[tokenId][j];
  says: a payout sends the broker's vault units
  for:
  - whose
- id: vault-owner
  source: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  file: src/BlockBrokerEngine.sol
  lines:
  - 64
  - 66
  has: broker's vault but the token's current holder
  says: the source states that only a broker's holder can move its vault and the owner takes only the ops reserve
  for:
  - whose
- id: reserve-zero
  call: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  fn: reserveEth()(uint256)
  is: '0'
  says: the owner's ops reserve is empty at the block
  for:
  - whose
- id: nft-set
  call: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  fn: nft()(address)
  is: '0x0071a3e9D8d71eE79A4Afd488867d40457E3fcD5'
  says: the broker NFT is wired, so the withdrawal paths are live
  for:
  - what
- id: no-1271
  selector: '0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a holder with code through ERC-1271
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

BlockBrokerEngine pays a broker NFT's reward vault to its holder, on the holder's direct call or on the holder's ECDSA signature that anyone can relay. A holder whose account takes real code loses the signed path; an EIP-7702 delegation keeps it.

## Evidence

- [withdrawAllWithSig](https://etherscan.io/address/0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68#code) pays the vault only if the ECDSA-recovered address is the NFT's current holder.
- [withdrawAll](https://etherscan.io/address/0x7d30e81e6b8c6975fbecf6d23fac82d4067c4a68#code) pays the same vault to the holder on a direct call, with no signature.

## Reviewer notes

### Mechanism

withdrawAllWithSig (lines 643-661) builds an EIP-712 digest over tokenId, a per-token nonce (incremented on use) and a deadline, recovers it with ecrecover, requires the result to be non-zero and equal to nft.ownerOf(tokenId), then settles and pays the whole vault (_payout, lines 804-816) to that holder. The same payout is available without a signature: withdrawAll (623-626) and withdrawAsset (629-639) behind onlyHolder (msg.sender == nft.ownerOf, line 246), and pushOut (663-668) for brokers that opted into direct payouts. Under EIP-8151 a holder account with real code no longer recovers, so only the gasless relayed path is lost; funds stay withdrawable directly. At the block the engine is wired and live: nft() is set, 11 assets are listed, and the ops reserve is 0, so the held tokens are reward inventory owed to broker holders.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for holders with code: none in the source, and the isValidSignature selector is absent from the runtime code.
- Ruled out: a fixed gas amount for the precompile: Solidity's ecrecover at line 656 forwards the available gas, so the change does not break the path by itself.
- Ruled out: a signature others rely on later: the signature is consumed once with a nonce and pays its own signer, so a voided signature costs nobody else funds.
- Ruled out: unused implementation or unset state: not a proxy, nft() is set and 11 assets are listed at the block; the code has no pause.
- Ruled out: the owner (0x25f6...7d47) holds an EIP-7702 delegation, which is irrelevant here: the recovered key is the NFT holder's, not the owner's.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
