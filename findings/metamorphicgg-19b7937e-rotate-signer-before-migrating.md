---
id: metamorphicgg-19b7937e-rotate-signer-before-migrating
format: 2
title: Album claims stop if the backend signer's account takes real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the backend key's account takes real code; the owner can set a new key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  name: MetamorphicGG
  code: verified
  code_url: https://etherscan.io/address/0x19b7937edb65f90bfb6cd132bc9792e1db7cc521#code
  copies: 2
  family: 6c9883616f1baca330a713302bd6ba58
  upgradeable: 'no'
  admin: '0x73a6715ebe475f7e4e0ef108d4470ab0e3e81a68'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Set a new key with setBackendSigner before moving the backend signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  file: contracts/MetamorphicGG.sol
  line: 258
  has: .recover(_signature) == backendSigner,
  says: claimAlbum requires the ECDSA-recovered signer to equal the stored backendSigner
  for:
  - evidence-1
  - justification
  - what
- id: zero
  source: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 173
  has: return (address(0), RecoverError.InvalidSignature);
  says: an empty ecrecover result is an invalid signature, so recover reverts
  for:
  - evidence-1
  - what
- id: setter
  source: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  file: contracts/MetamorphicGG.sol
  lines:
  - 365
  - 366
  has: backendSigner = newAddress;
  says: setBackendSigner, onlyOwner, overwrites the backend signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner
  call: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  fn: owner()(address)
  is: '0x73a6715ebe475f7e4e0ef108d4470ab0e3e81a68'
  says: the owner who can call setBackendSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ownernonce
  nonce: '0x73a6715ebe475f7e4e0ef108d4470ab0e3e81a68'
  is: 50
  says: the owner account has sent transactions
  for:
  - notes
- id: signer
  call: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  fn: backendSigner()(address)
  is: '0xabcd747b0e10950506e18c4b898f5f2c658c5583'
  says: the backend key the contract trusts
  for:
  - what
- id: signercode
  code: '0xabcd747b0e10950506e18c4b898f5f2c658c5583'
  is: empty
  says: the backend signer's account has no code at the block
  for:
  - notes
- id: supply
  call: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  fn: totalSupply()(uint256)
  is: 0
  says: this address has minted no album
  for:
  - evidence-3
  - what
- id: max
  call: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  fn: MAX_SUPPLY()(uint256)
  is: 10
  says: at most 10 albums
  for:
  - what
- id: copysupply
  call: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  fn: totalSupply()(uint256)
  is: 6
  says: the copy has minted 6 albums
  for:
  - evidence-3
  - what
- id: copysigner
  call: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  fn: backendSigner()(address)
  is: '0xabcd747b0e10950506e18c4b898f5f2c658c5583'
  says: the copy trusts the same backend key
  for:
  - evidence-3
- id: claimdoc
  source: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  file: contracts/MetamorphicGG.sol
  line: 245
  has: can claim one album if you have 10 songs
  says: claimAlbum is the free album claim for holders of 10 songs
  for:
  - what
- id: counter
  call: '0x19b7937edb65f90bfb6cd132bc9792e1db7cc521'
  fn: albumSongCounter()(uint256)
  is: 1
  says: no paid album mint here (the counter starts at 1)
  for:
  - what
- id: copycounter
  call: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  fn: albumSongCounter()(uint256)
  is: 60
  says: 'the copy''s counter rose by 60: six paid album mints of 10 songs each'
  for:
  - evidence-3
  - what
- id: copyinit
  source: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  file: contracts/MetamorphicGG.sol
  line: 53
  has: uint256 public albumSongCounter = 0;
  says: on the copy the counter starts at 0
  for:
  - evidence-3
  - what
- id: copyinc1
  source: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  file: contracts/MetamorphicGG.sol
  line: 129
  has: albumSongCounter += 1;
  says: buyAlbum raises the counter 10 times per album
  for:
  - evidence-3
  - what
- id: copyinc2
  source: '0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3'
  file: contracts/MetamorphicGG.sol
  line: 149
  has: albumSongCounter += 1;
  says: publicMintAlbum raises the counter 10 times per album
  for:
  - evidence-3
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

Song holders claim a free album with a signature from one backend key the contract stores. If that key's account takes real code, claims fail until the owner sets a new key; an EIP-7702 delegation keeps working. This address has minted no album; its copy sold 6 of 10 by paid mints, none by claim.

## Evidence

- [claimAlbum](https://etherscan.io/address/0x19b7937edb65f90bfb6cd132bc9792e1db7cc521#code) recovers the signature with ECDSA and requires it to match the stored backend signer.
- [setBackendSigner](https://etherscan.io/address/0x19b7937edb65f90bfb6cd132bc9792e1db7cc521#code) lets the [owner](https://etherscan.io/address/0x73a6715ebe475f7e4e0ef108d4470ab0e3e81a68) replace that key.
- The [copy](https://etherscan.io/address/0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3#code) trusts the same key, but its 6 albums were paid mints of 10 songs each, none a claim; this address has minted none.

## Reviewer notes

### Mechanism

claimAlbum (MetamorphicGG.sol, lines 249-264) requires supply below MAX_SUPPLY (10) and an unused nonce, then recovers keccak256(abi.encode(nonce, msg.sender)) as an eth-signed message with OpenZeppelin ECDSA.recover and requires the result to equal the stored backendSigner. ECDSA.tryRecover (ECDSA.sol, lines 171-173) calls ecrecover and turns a zero result into InvalidSignature, so recover reverts. Under EIP-8151 a backendSigner account with real code recovers to nothing and every claim reverts. setBackendSigner (lines 365-366, onlyOwner) overwrites backendSigner. At block 26,438,999: backendSigner is 0xABCD747b0E10950506e18c4B898F5F2c658C5583, an account with no code and nonce 0; owner is 0x73a6715ebe475f7e4e0ef108d4470ab0e3e81a68, an account with no code and nonce 50. claimAlbum has no time gate or pause; totalSupply is 0 here, 6 at the copy 0xd0e9e0dfaae17d887248bebcf4ade5adbc23cbc3, which has the same owner and backend signer and the same claimAlbum, so the path is open on both. No album was ever claimed: albumSongCounter is raised only by the paid mints buyAlbum and publicMintAlbum, 10 per album, and no function burns albums; the copy reads 60 from 0 with totalSupply 6, and this address 1 from 1 with totalSupply 0.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for the signer: claimAlbum compares only the ECDSA result with backendSigner (line 258); the contracts have no isValidSignature.
- Ruled out: a fixed gas amount for the precompile: ECDSA.sol uses the Solidity ecrecover builtin (line 171), which forwards all gas; nothing breaks under EIP-8151 with nobody migrating.
- Ruled out: the path closed: no time check or pause in claimAlbum; supply is 0 of 10 here and 6 of 10 at the copy.
- Ruled out: the key unset or already code: backendSigner is a non-zero address with no code at the block.
- Ruled out: a direct path: buyAlbum and publicMintAlbum sell albums for ETH, but nothing else grants the free claim without the backend signature; not stated on the card.
- Ruled out: unused implementation: the address is not a proxy target; it has its own owner and backendSigner, read at the block.
- Ruled out: that the copy's 6 albums came from the backend key: its albumSongCounter is 60 from 0 (lines 53, 129, 149), so all 6 were paid mints of 10 songs; claimAlbum does not touch the counter.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
