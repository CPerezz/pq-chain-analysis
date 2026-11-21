---
id: gnosissafe-220866b1-owner-ecdsa-keys
format: 2
title: Safe multisig whose six owners all approve with ECDSA keys
status: candidate
severity: MEDIUM
justification: Four forged owner keys move everything; the fix needs the owners to swap in post-quantum signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code
  proxy_of: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 404620801
  basis: held
activity: {}
impact: funds-loss
action: Replace each owner with swapOwner by a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 797
  - 800
  has: checkSignatures(txHash, txHashData, signatures, true);
  says: execTransaction checks the owners' signatures before executing the call
  for:
  - what
- id: ecdsa
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 911
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an owner's approval is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa-prefixed
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 908
  has: currentOwner = ecrecover(keccak256(abi.encodePacked(
  says: an eth_sign approval is also recovered with ECDSA
  for:
  - evidence-1
  - what
- id: owner-match
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 913
  - 916
  has: currentOwner > lastOwner && owners[currentOwner] != address(0)
  says: each recovered address must be a distinct owner
  for:
  - evidence-1
  - justification
  - what
- id: legacy-magic
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 583
  has: EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: a contract owner must answer the legacy ERC-1271 magic value 0x20c13b0b
  for:
  - action
  - evidence-3
- id: legacy-bytes
  bytecode: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  has: 20c13b0b
  says: the singleton's code holds the legacy isValidSignature(bytes,bytes) selector and magic value
  for:
  - action
  - evidence-3
- id: no-final
  selector: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the singleton's code never uses the final ERC-1271 selector 0x1626ba7e
  for:
  - action
  - evidence-3
- id: approve
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 950
  - 954
  has: approvedHashes[msg.sender][hashToApprove] = 1;
  says: an owner can approve a transaction hash by calling approveHash from its own account
  for:
  - notes
- id: approve-sender
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 901
  has: require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0
  says: an approved hash or the owner's own call counts as that owner's approval, with no signature recovered
  for:
  - notes
- id: master
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 27
  - 33
  has: masterCopy = _masterCopy;
  says: changeMasterCopy replaces the code address the proxy runs
  for:
  - upgradeable
- id: master-auth
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 27
  - 29
  has: authorized
  says: changeMasterCopy carries the authorized modifier, so only a Safe transaction the owners approve can call
    it
  for:
  - upgradeable
- id: proxy-delegate
  source: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  file: Proxy.sol
  lines:
  - 28
  - 35
  has: delegatecall(gas, masterCopy
  says: the proxy runs the code at the address stored in slot 0
  for:
  - proxy_of
  - upgradeable
- id: erc1271
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 895
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner's approval is asked through ERC-1271
  for:
  - action
  - evidence-3
- id: swap
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 392
  - 408
  has: owners[prevOwner] = newOwner;
  says: swapOwner replaces an owner with a new address
  for:
  - action
  - evidence-3
  - justification
- id: self-only
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 392
  - 394
  has: authorized
  says: swapOwner carries the authorized modifier
  for:
  - action
  - evidence-3
  - justification
- id: authorized
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  line: 7
  has: require(msg.sender == address(this)
  says: the authorized modifier admits only the Safe itself, so a transaction the owners approve
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: threshold
  call: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner approvals are needed
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  fn: getOwners()(address[])
  is:
  - '0xd8da6bf26964af9d7eed9e03e53415d37aa96045'
  - '0xb1edfe0273e46d4368e8032408cc87d3ed86ce36'
  - '0x97adc5f09e167127e40004b6a8b5742fc336ae28'
  - '0xbf6d39a24b0c416fda5c487bb6a563928b34ba7d'
  - '0x1affd7e547ed7a464b81ea423cf6defa5047ea66'
  - '0x4e5c743a824595c249f85d6807ac5e397cd8df1b'
  says: the Safe has six owners
  for:
  - evidence-2
  - what
- id: no-modules
  call: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  fn: getModules()(address[])
  is: []
  says: no module is enabled
  for:
  - evidence-2
  - what
- id: owner1
  code: '0xd8da6bf26964af9d7eed9e03e53415d37aa96045'
  is: delegation
  target: '0x5a7fc11397e9a8ad41bf10bf13f22b0a63f96f6d'
  says: this owner has an EIP-7702 delegation, so it is still controlled by its ECDSA key
  for:
  - evidence-2
  - what
- id: owner2
  code: '0xb1edfe0273e46d4368e8032408cc87d3ed86ce36'
  is: empty
  says: this owner has no code
  for:
  - evidence-2
  - what
- id: owner3
  code: '0x97adc5f09e167127e40004b6a8b5742fc336ae28'
  is: empty
  says: this owner has no code
  for:
  - evidence-2
  - what
- id: owner4
  code: '0xbf6d39a24b0c416fda5c487bb6a563928b34ba7d'
  is: empty
  says: this owner has no code
  for:
  - evidence-2
  - what
- id: owner5
  code: '0x1affd7e547ed7a464b81ea423cf6defa5047ea66'
  is: empty
  says: this owner has no code
  for:
  - evidence-2
  - what
- id: owner6
  code: '0x4e5c743a824595c249f85d6807ac5e397cd8df1b'
  is: empty
  says: this owner has no code
  for:
  - evidence-2
  - what
- id: singleton
  storage: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  slot: 0
  is: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  says: the proxy runs the Safe 1.1.1 singleton
  for:
  - proxy_of
  - upgradeable
- id: in-use
  call: '0x220866b1a2219f40e72f5c628b65d54268ca3a9d'
  fn: nonce()(uint256)
  is: 20
  says: the Safe has executed 20 transactions
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

This Safe multisig runs any transaction once four of its six owners approve it. All six owners are ECDSA keys, one of them with an EIP-7702 delegation, and no module is enabled. Whoever forges four owners' signatures with a quantum computer can move everything it holds.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) recovers each owner's approval with ECDSA and matches it against the owner list.
- [The Safe](https://etherscan.io/address/0x220866b1a2219f40e72f5c628b65d54268ca3a9d#readProxyContract) needs 4 of 6 owners; all six are ECDSA keys and no module is enabled.
- [swapOwner](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) replaces an owner by a Safe transaction; a contract owner is asked only through the legacy isValidSignature(bytes,bytes).

## Reviewer notes

### Mechanism

execTransaction (GnosisSafe.sol 774-800) hashes the transaction with the nonce and calls checkSignatures (849-919), which walks threshold-many 65-byte slots. v == 0: the owner named in r is asked through isValidSignature (ERC-1271, legacy bytes form, line 895). v == 1: the owner named in r is msg.sender or has called approveHash (901). v > 30: ecrecover of the eth_sign hash (908). Otherwise ecrecover(dataHash, v, r, s) (911). Each result must be an owner in ascending order (913-916). With threshold 4 met, execute runs any call or delegatecall from the Safe. Owners, threshold and the singleton change only through the Safe calling itself (authorized, line 7: swapOwner 392, addOwnerWithThreshold, removeOwner, changeThreshold, changeMasterCopy 27-33), so the same four approvals are needed. At the block: proxy slot 0 is the 1.1.1 singleton 0x34cfac64, threshold 4, six owners: 0xd8da6bf2 carries an EIP-7702 delegation to 0x5a7fc113 (still an ECDSA key), the other five have no code. getModules is empty, so no module can execute without owner approval. A CRQC that recovers four owner keys signs a transaction that moves everything or replaces the owners.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 owner already: none of the six owners has real code (five have none, one has an EIP-7702 delegation, which is still its ECDSA key).
- Ruled out: a module that executes without owner approvals: getModules returns an empty list; Safe 1.1.1 has no guard.
- Ruled out: the approved-hash path (v == 1) as protection: it needs the owner's own account to call approveHash or execTransaction, which a recovered ECDSA key also controls.
- Ruled out: the EIP-8151 replay in the dossier: it is another Safe of the same singleton, signed by an address that is not an owner here; not cited.
- Ruled out: a singleton not in use: this proxy holds its own state (nonce 20, threshold 4, slot 0 the 1.1.1 singleton) and its own funds.

### Questions

- Whose funds does this Safe hold (a team treasury, an exchange's reserve, users' deposits)? No read at the block shows it, so whose is left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
