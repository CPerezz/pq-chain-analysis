---
id: gnosissafe-68a99f89-owner-ecdsa-keys
format: 2
title: Multisig moves all its funds on four forged ECDSA owner signatures
status: confirmed
severity: MEDIUM
justification: Forged owner keys move the funds; the owners can fix it by swapping in post-quantum contract signers.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x68a99f89e475a078645f4bac491360afe255dff1'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code
  proxy_of: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 1971469
  basis: held
activity: {}
impact: funds-loss
action: Swap each owner with swapOwner for a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: ecdsa
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 906
  - 912
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: an owner signature with v above 1 is recovered with ecrecover (plain or eth_sign-prefixed)
  for:
  - evidence-1
  - justification
  - what
- id: ownercheck
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 913
  - 916
  has: owners[currentOwner] != address(0)
  says: each recovered address must be a distinct owner, for threshold-many signatures
  for:
  - evidence-1
  - what
- id: exec
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 798
  - 800
  has: checkSignatures(txHash, txHashData, signatures, true);
  says: execTransaction runs any call once checkSignatures passes
  for:
  - evidence-1
  - what
- id: erc1271
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 868
  - 895
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: an owner that is a contract signs through ERC-1271 with v = 0
  for:
  - action
  - evidence-3
  - justification
- id: swap
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 392
  - 405
  has: function swapOwner(address prevOwner, address oldOwner, address newOwner)
  says: swapOwner replaces one owner address with another
  for:
  - action
  - evidence-3
  - justification
  - what
- id: selfauth
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 6
  - 7
  has: require(msg.sender == address(this), "Method can only be called from this contract");
  says: authorized functions run only from the Safe itself, i.e. through a Safe transaction
  for:
  - action
  - evidence-3
  - upgradeable
  - what
- id: mastercopy
  source: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  file: GnosisSafe.sol
  lines:
  - 27
  - 33
  has: masterCopy = _masterCopy;
  says: changeMasterCopy, called from the Safe itself, replaces the code behind the proxy
  for:
  - upgradeable
- id: slot0
  storage: '0x68a99f89e475a078645f4bac491360afe255dff1'
  slot: 0
  is: '0x34cfac646f301356faa8b21e94227e3583fe3f5f'
  says: the proxy's slot 0 holds the singleton that changeMasterCopy rewrites
  for:
  - upgradeable
- id: owners
  call: '0x68a99f89e475a078645f4bac491360afe255dff1'
  fn: getOwners()(address[])
  is:
  - '0xb6cc72aef30880ed2029870eb0615bab40ce0586'
  - '0xaf020b1b281f59141da21094386dabf5437412ea'
  - '0x03f8009226ad399ce9193ed0b94e5ced0a33c79c'
  - '0x8d365687a75dc7688864822869ae0551bb6fc105'
  - '0x93798852ed213e90787f7823f285240a306cbdb6'
  - '0x5c9e5571b17d91e6accd4f0c29bbe199af1f7b09'
  - '0x087a7afb6975a2837453be685eb6272576c0bc06'
  says: the Safe has these seven owners
  for:
  - evidence-2
  - what
- id: threshold
  call: '0x68a99f89e475a078645f4bac491360afe255dff1'
  fn: getThreshold()(uint256)
  is: 4
  says: four owner approvals execute a transaction
  for:
  - action
  - evidence-1
  - evidence-2
  - justification
  - what
- id: modules
  call: '0x68a99f89e475a078645f4bac491360afe255dff1'
  fn: getModules()(address[])
  is: []
  says: no module is enabled, so no path runs without owner signatures
  for:
  - evidence-2
  - what
- id: safenonce
  call: '0x68a99f89e475a078645f4bac491360afe255dff1'
  fn: nonce()(uint256)
  is: 116
  says: 'the Safe has executed 116 transactions: it is in use'
  for:
  - notes
- id: code1
  code: '0xb6cc72aef30880ed2029870eb0615bab40ce0586'
  is: empty
  says: 'owner 0xb6cc72aef30880ed2029870eb0615bab40ce0586 has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code2
  code: '0xaf020b1b281f59141da21094386dabf5437412ea'
  is: empty
  says: 'owner 0xaf020b1b281f59141da21094386dabf5437412ea has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code3
  code: '0x03f8009226ad399ce9193ed0b94e5ced0a33c79c'
  is: empty
  says: 'owner 0x03f8009226ad399ce9193ed0b94e5ced0a33c79c has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code4
  code: '0x8d365687a75dc7688864822869ae0551bb6fc105'
  is: empty
  says: 'owner 0x8d365687a75dc7688864822869ae0551bb6fc105 has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code5
  code: '0x93798852ed213e90787f7823f285240a306cbdb6'
  is: empty
  says: 'owner 0x93798852ed213e90787f7823f285240a306cbdb6 has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code6
  code: '0x5c9e5571b17d91e6accd4f0c29bbe199af1f7b09'
  is: empty
  says: 'owner 0x5c9e5571b17d91e6accd4f0c29bbe199af1f7b09 has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
  - what
- id: code7
  code: '0x087a7afb6975a2837453be685eb6272576c0bc06'
  is: empty
  says: 'owner 0x087a7afb6975a2837453be685eb6272576c0bc06 has no code and no delegation: it approves with ECDSA'
  for:
  - evidence-2
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
reviews:
- who: r-68a99f89, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): Multisig moves all its funds on four forged ECDSA owner
    signatures. Forged owner keys move the funds; the owners can fix it by swapping in post-quantum contract signers.
    Fix: Swap each owner with swapOwner for a post-quantum signer contract that answers the legacy isValidSignature(bytes,bytes).
    One refuter agrees on the current card with no objection (D-029: a second refuter only for removals); Claude
    read the card and the answer.'
related: []
---

## What happens

This Safe multisig runs any transaction that four of its seven owners approve, and has no modules. All seven owners are plain accounts that approve with ECDSA, so whoever forges four owner keys can move everything it holds or replace its owners.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) recovers owner signatures with ecrecover and needs four distinct owners before execTransaction runs.
- The [Safe](https://etherscan.io/address/0x68a99f89e475a078645f4bac491360afe255dff1) has 7 owners, threshold 4 and no modules; no owner is a contract or holds an EIP-7702 delegation.
- Owners can [swap](https://etherscan.io/address/0x34cfac646f301356faa8b21e94227e3583fe3f5f#code) an ECDSA owner for a contract signer, which this Safe asks through the legacy isValidSignature(bytes,bytes).

## Reviewer notes

### Mechanism

execTransaction (lines 774-817) hashes the Safe transaction with the current nonce and calls checkSignatures (849-919). For each of threshold = 4 signatures: v = 0 asks the owner contract through ERC-1271 isValidSignature (868-895); v = 1 accepts a hash the owner approved by its own transaction, or the caller being that owner (897-905); v > 30 recovers an eth_sign signature with ecrecover (906-908); otherwise ecrecover on the hash (911). The recovered address must be an owner and strictly increasing (913-916). Owner management (addOwnerWithThreshold, removeOwner, swapOwner, changeThreshold) and changeMasterCopy are authorized, callable only from the Safe itself through a Safe transaction. At the block the seven owners are accounts without code, so every approval is an ECDSA signature or a transaction from an ECDSA account; a CRQC holder of four owner keys passes checkSignatures and can transfer the holdings, swap owners or change the singleton. The fix within the contract: four current owners sign swapOwner transactions that replace each EOA owner with a post-quantum signer contract, which then signs through the ERC-1271 branch. Rated MEDIUM (quantum-exposure step 3): fixable without a protocol change, but it needs several owners to act.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a module path that moves funds without owner signatures: getModules() is empty at the block.
- Ruled out: an owner already behind ERC-1271: all seven owners have empty code (no contract, no EIP-7702 delegation), so the ERC-1271 branch is not used today.
- Ruled out: owners moving their own accounts to post-quantum authorisation at the same address: checkSignatures still runs ecrecover on that address (lines 906-912) and never asks the account, so that alone does not protect this Safe; swapping in a contract owner does.
- Ruled out: an unused implementation: this address is a proxy with its own state; Safe nonce 116 at the block.
- Ruled out: the family replay 0xa6434e8b is another Safe's transaction (signer 0x07d9d872, not an owner here); it is not cited.
- Ruled out: project: the verified code is Gnosis Safe 1.1.1, but who runs this Safe is not shown on chain, so no project slug is stated; the team that acts is the owners.
- Ruled out: whose: whether the holdings are the owners' or others' is not shown by any read, so it is left empty.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
