---
id: safe-2bf916f8-owner-ecdsa-keys
format: 2
title: A quantum computer could forge two owner keys and empty this Safe
status: confirmed
severity: MEDIUM
justification: Two forged owner keys move all it holds; the fix needs its owners to swap their keys for post-quantum
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  name: Safe
  code: verified
  code_url: https://etherscan.io/address/0xff51a5898e281db6dfc7855790607438df2ca44b#code
  proxy_of: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  copies: 1
value:
  usd: 48772347
  basis: held
activity:
  txs_90d: 1052
impact: funds-loss
action: Use swapOwner to replace each ECDSA owner with a post-quantum signer contract that answers ERC-1271 isValidSignature(bytes32,bytes).
evidence_level: source
checks:
- id: version
  call: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  fn: VERSION()(string)
  is: 1.5.0
  says: the Safe answers version 1.5.0
  for:
  - evidence-2
- id: singleton
  storage: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  slot: '0x0'
  is: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  says: the proxy's slot 0 holds the Safe 1.5.0 singleton
  for:
  - evidence-2
- id: threshold
  call: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  fn: getThreshold()(uint256)
  is: 2
  says: two owner approvals run a transaction
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  fn: getOwners()(address[])
  is:
  - '0x2b6c7dd3aeb3a9793151156ad124368b58891af2'
  - '0x7b904b0ebbdeac5798c4207d8eb838568feee40f'
  - '0xb0555c4c2f8ad5a562a69f217598eee0585cc8d3'
  - '0xdf69ab7105b93c6db657cd314b10d89a5b3bd017'
  says: the Safe has four owners
  for:
  - evidence-2
  - what
- id: nonce-safe
  call: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  fn: nonce()(uint256)
  is: 45
  says: the Safe has executed 45 owner-approved transactions
  for:
  - notes
- id: guard
  storage: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
  - what
- id: module-guard
  storage: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  slot: '0xb104e0b93118902c651344349b610029d694cfdec91c589c91ebafbcd0289947'
  is: 0
  says: no module guard is set
  for:
  - notes
- id: modules
  call: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - - '0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134'
  - '0x0000000000000000000000000000000000000001'
  says: one module is enabled, the AllowanceModule
  for:
  - notes
- id: code-1
  code: '0x2b6c7dd3aeb3a9793151156ad124368b58891af2'
  is: empty
  says: owner 0x2b6c… has no code
  for:
  - evidence-2
  - what
- id: code-2
  code: '0x7b904b0ebbdeac5798c4207d8eb838568feee40f'
  is: empty
  says: owner 0x7b90… has no code
  for:
  - evidence-2
  - what
- id: code-3
  code: '0xb0555c4c2f8ad5a562a69f217598eee0585cc8d3'
  is: empty
  says: owner 0xb055… has no code
  for:
  - evidence-2
  - what
- id: code-4
  code: '0xdf69ab7105b93c6db657cd314b10d89a5b3bd017'
  is: empty
  says: owner 0xdf69… has no code
  for:
  - evidence-2
  - what
- id: nonce-1
  nonce: '0x2b6c7dd3aeb3a9793151156ad124368b58891af2'
  is: 15
  says: owner 0x2b6c… has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce-2
  nonce: '0x7b904b0ebbdeac5798c4207d8eb838568feee40f'
  is: 28
  says: owner 0x7b90… has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce-3
  nonce: '0xb0555c4c2f8ad5a562a69f217598eee0585cc8d3'
  is: 85
  says: owner 0xb055… has sent transactions, so its public key is on-chain
  for:
  - what
- id: nonce-4
  nonce: '0xdf69ab7105b93c6db657cd314b10d89a5b3bd017'
  is: 16
  says: owner 0xdf69… has sent transactions, so its public key is on-chain
  for:
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  is: '27027279229254343847751'
  says: the Safe holds 27,027.28 ETH
  for:
  - what
- id: exec
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 147
  has: checkSignatures(msg.sender, txHash, signatures);
  says: execTransaction checks the owners' signatures over the transaction hash
  for:
  - justification
  - what
- id: exec-call
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 180
  has: success = execute(to, value, data, operation,
  says: then it executes whatever call or delegatecall the owners signed
  for:
  - what
- id: ecdsa
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 336
  has: currentOwner = ecrecover(dataHash, uint8(v), r, s);
  says: an owner's signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: ethsign
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 332
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: an eth_sign signature is recovered with ECDSA too
  for:
  - evidence-1
- id: isowner
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 338
  has: owners[currentOwner] == address(0)
  says: each recovered or named address must be an owner
  for:
  - evidence-1
  - what
- id: approve
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 328
  has: if (executor != currentOwner && approvedHashes[currentOwner][dataHash] == 0)
  says: an owner also counts if it sends the transaction or approved the hash on-chain
  for:
  - evidence-1
- id: erc1271
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/Safe.sol
  line: 270
  has: ISignatureValidator(owner).isValidSignature(dataHash, contractSignature) != EIP1271_MAGIC_VALUE
  says: a contract owner is asked through isValidSignature(bytes32,bytes) with the full signature
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
- id: magic
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 7
  has: bytes4 internal constant EIP1271_MAGIC_VALUE = 0x1626ba7e;
  says: the answer it wants is the final ERC-1271 magic value
  for:
  - action
  - evidence-3
- id: magic-code
  bytecode: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  has: 631626ba7e
  says: the singleton's code holds the final ERC-1271 selector
  for:
  - action
  - evidence-3
- id: legacy-absent
  bytecode: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  has: 20c13b0b
  absent: true
  says: the singleton's code does not hold the legacy isValidSignature(bytes,bytes) value
  for:
  - action
- id: swap
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/base/OwnerManager.sol
  lines:
  - 90
  - 102
  has: owners[newOwner] = owners[oldOwner]; owners[prevOwner] = newOwner; owners[oldOwner] = address(0);
  says: swapOwner puts a new owner in place of an old one
  for:
  - action
  - evidence-3
  - justification
- id: swap-auth
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/base/OwnerManager.sol
  line: 90
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner) public override authorized
  says: swapOwner is authorized only
  for:
  - notes
- id: self
  source: '0xff51a5898e281db6dfc7855790607438df2ca44b'
  file: contracts/common/SelfAuthorized.sol
  line: 12
  has: if (msg.sender != address(this)) revertWithError("GS031");
  says: authorized functions run only when the Safe calls itself, that is through an owner-approved transaction
  for:
  - action
  - evidence-3
  - justification
- id: swap-tx
  tx: '0x18dd460ec50cfe328016066abbf789c4acecfd0e086ba5d48dc69bd1a6058b06'
  to: '0x2bf916f8169ed2a77324d3e168284fc252ae4087'
  ok: true
  says: the owners' swapOwner transaction went to this Safe and succeeded
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

This Safe runs any transaction that two of its four owners approve, and all four owners are plain ECDSA keys that have sent transactions. A quantum computer that recovers two of those keys from their public keys can move the 27,027 ETH the Safe holds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xff51a5898e281db6dfc7855790607438df2ca44b#code) counts an owner whose ECDSA signature recovers to it, who approved on-chain, or that is a contract answering ERC-1271.
- [This Safe](https://etherscan.io/address/0x2bf916f8169ed2a77324d3e168284fc252ae4087) runs version 1.5.0, needs 2 of 4 owners and has no transaction guard; none of the four owners has code.
- [swapOwner](https://etherscan.io/address/0xff51a5898e281db6dfc7855790607438df2ca44b#code) lets the owners, through the Safe itself, replace an owner with a contract that answers isValidSignature(bytes32,bytes).

## Reviewer notes

### Mechanism

The proxy delegates to the Safe 1.5.0 singleton (slot 0). execTransaction (Safe.sol 115-212) checks the owners' signatures over the transaction hash (line 147), then executes the call or delegatecall the owners signed (line 180); no guard is set. checkNSignatures (287-341) reads threshold-many 65-byte slots: v == 0 asks a contract owner isValidSignature(bytes32,bytes) and wants the final ERC-1271 value 0x1626ba7e (line 270); v == 1 accepts an owner that is the sender or approved the hash on-chain; v > 30 recovers the eth_sign hash; otherwise ecrecover(dataHash, v, r, s) (line 336). Each address must be an owner (line 338). All four owners have no code, so each counts only through its ECDSA key. With threshold 2, two recovered keys run any call: moving the ETH, swapOwner (OwnerManager.sol 90) or a singleton change, all gated by `authorized` (self-call only, SelfAuthorized.sol 12), so the honest owners can use the same path to rotate a compromised key first.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 protecting these owners: line 270 asks it only of owners that are contracts; all four owners have no code at the block, so their ECDSA keys decide.
- Ruled out: an owner migrating to real code or a 7702 delegation fixing this on its own: the Safe still recovers its address and never asks it, so that owner stays forgeable until swapOwner runs.
- Ruled out: an unused implementation: this address is the proxy in use, nonce 45, holding 27,027.28 ETH, with 1,052 calls in 90 days per the study.
- Ruled out: a dead setter: tx 0x18dd460e… (block 26,347,588), signed by owner 0xb055…, called swapOwner on this Safe and replaced one owner, so the path is live.
- Ruled out: a guard blocking forged calls: the transaction-guard and module-guard slots are both empty.
- Ruled out: AllowanceModule 0xcfbfac74… is enabled with 15 delegates; it moves funds under owner-set allowances through its own signature check, a separate path not folded into this card.
- Ruled out: family replays that fail under EIP-8151 alone (0xa9bf5b31…, 0xcd1bf7e7…, 0x47392e33…) go to other addresses (0xd37133a2…, 0xa83c336b…, 0x8c8ee396…), not to this Safe.
- Ruled out: tx 0x6013724c… (block 26,347,609) is a delegatecall by the owners to 0x6439e7ab… (selector 0xed007fc6), not identified and not used here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
