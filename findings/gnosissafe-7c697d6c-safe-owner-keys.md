---
id: gnosissafe-7c697d6c-safe-owner-keys
format: 2
title: A Safe with five ECDSA owner keys can be emptied by forging three of them
status: confirmed
severity: MEDIUM
justification: Three forged owner keys move the funds; the fix needs three of the five owners to replace the keys.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  name: GnosisSafe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 82656196
  basis: held
activity: {}
impact: funds-loss
action: Replace each owner key, with swapOwner, by a post-quantum signer contract that answers isValidSignature(bytes,bytes).
evidence_level: source
checks:
- id: singleton
  storage: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  slot: 0
  is: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  says: the proxy's slot 0 holds the singleton whose code it runs
  for:
  - what
- id: version
  call: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  fn: VERSION()(string)
  is: 1.3.0
  says: the Safe runs version 1.3.0
  for:
  - action
  - what
- id: threshold
  call: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  fn: getThreshold()(uint256)
  is: 3
  says: three owner approvals are required
  for:
  - evidence-2
  - justification
  - what
- id: owners
  call: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  fn: getOwners()(address[])
  is:
  - '0xC6B8888454BE7E59649331a073E8a6Fb4eFB9C67'
  - '0x656D9d575f904F63687a4Ea8e2A6BC80922e94bC'
  - '0xD5012982682BC33B86D25aBF371496375Ae2264D'
  - '0x7C9DbE208859e571Adbd9Ec7692772bb8395CaD9'
  - '0xE72a0b45bBC48D9E10E9921EA1C6Bd5CFA509F13'
  says: the Safe has these five owners
  for:
  - evidence-2
  - what
- id: o1-code
  code: '0xc6b8888454be7e59649331a073e8a6fb4efb9c67'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
  - what
- id: o2-code
  code: '0x656d9d575f904f63687a4ea8e2a6bc80922e94bc'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
  - what
- id: o3-code
  code: '0xd5012982682bc33b86d25abf371496375ae2264d'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
  - what
- id: o4-code
  code: '0x7c9dbe208859e571adbd9ec7692772bb8395cad9'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-2
  - what
- id: o5-code
  code: '0xe72a0b45bbc48d9e10e9921ea1c6bd5cfa509f13'
  is: empty
  says: owner 5 has no code
  for:
  - evidence-2
  - what
- id: o1-nonce
  nonce: '0xc6b8888454be7e59649331a073e8a6fb4efb9c67'
  is: 251
  says: owner 1 has sent transactions, which publish its public key
  for:
  - what
- id: o3-nonce
  nonce: '0xd5012982682bc33b86d25abf371496375ae2264d'
  is: 31
  says: owner 3 has sent transactions, which publish its public key
  for:
  - what
- id: o4-nonce
  nonce: '0x7c9dbe208859e571adbd9ec7692772bb8395cad9'
  is: 30
  says: owner 4 has sent transactions, which publish its public key
  for:
  - what
- id: o5-nonce
  nonce: '0xe72a0b45bbc48d9e10e9921ea1c6bd5cfa509f13'
  is: 44
  says: owner 5 has sent transactions, which publish its public key
  for:
  - what
- id: modules
  call: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  fn: getModulesPaginated(address,uint256)(address[],address)
  args:
  - '0x0000000000000000000000000000000000000001'
  - 10
  is:
  - []
  - '0x0000000000000000000000000000000000000001'
  says: no module is enabled
  for:
  - evidence-2
- id: guard
  storage: '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - evidence-2
- id: wsteth
  call: '0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3'
  is: '36830345288935330155082'
  says: the Safe holds about 36,830 wstETH
  for:
  - what
- id: exec
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owners' signatures over the transaction hash before executing
  for:
  - justification
  - what
- id: run
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 176
  has: success = execute(to, value, data, operation,
  says: after the signature check execTransaction runs the given call to any target
  for:
  - what
- id: ecdsa
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a signature is recovered with ECDSA; the owner's account is not called
  for:
  - evidence-1
  - justification
  - what
- id: owner-set
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 301
  has: owners[currentOwner] != address(0)
  says: the recovered address only has to be in the stored owner set
  for:
  - evidence-1
  - justification
  - what
- id: legacy-call
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 285
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  says: a contract owner is asked through isValidSignature with the data bytes and its signature
  for:
  - action
  - evidence-3
- id: legacy-magic
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/interfaces/ISignatureValidator.sol
  line: 6
  has: EIP1271_MAGIC_VALUE = 0x20c13b0b;
  says: the expected answer is the legacy value of isValidSignature(bytes,bytes)
  for:
  - action
  - evidence-3
- id: legacy-selector
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes,bytes)
  says: the singleton's code carries the legacy selector 0x20c13b0b
  for:
  - action
  - evidence-3
- id: final-absent
  selector: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the final ERC-1271 selector 0x1626ba7e is not in the singleton's code
  for:
  - action
  - evidence-3
- id: swap
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/base/OwnerManager.sol
  lines:
  - 94
  - 108
  has: owners[newOwner] = owners[oldOwner];
  says: swapOwner replaces one owner address with another
  for:
  - action
  - justification
- id: self-only
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/common/SelfAuthorized.sol
  line: 8
  has: require(msg.sender == address(this), "GS031");
  says: owner changes are accepted only as a call from the Safe itself, that is, a transaction its owners approved
  for:
  - action
  - justification
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
  pattern: PQ-12
reviews:
- who: r-7c697d6c, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: refuted
  note: 'disagree: whose: the card never says whose the $82.7M is. The dossier does not establish it (no signers,
    no notes), so the card should say outright that the owner of these funds is not established. Every other part
    holds: what-3''s ''four of them'' is exact (owner 2 nonce 0), and swapOwner to a contract that answers isValidSignature(bytes,bytes)
    does remove ECDSA acceptance.'
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 3-of-5 Safe 1.3.0 ($82.66M) whose five owners are plain
    ECDSA keys, four exposed; checkNSignatures never asks the owner''s account; fix: swapOwner to post-quantum signer
    contracts answering the legacy isValidSignature(bytes,bytes). Both refuters agree on every part; their one objection,
    that the card is silent on whose money it is, is resolved by the card header, which now says ''whose funds not
    established'' when the value is held but whose cannot be shown (nothing on-chain names the owners). Claude read
    the sheet.'
related: []
---

## What happens

This Safe 1.3.0 wallet executes any transaction that three of its five owners sign with ECDSA. A quantum attacker who recovers three owner keys can move everything it holds. All five owners are plain keys, and four of them have sent transactions, so their public keys are public.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code), line 299, recovers an owner from an ECDSA signature without calling the owner's account.
- The [Safe](https://etherscan.io/address/0x7c697d6cff279f3f9c2401d0ea2ac7e7ede0e2c3) has a threshold of 3 and five owners, none of which has code; it has no module and no guard.
- The [code](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) asks a contract owner through isValidSignature(bytes,bytes), line 285; the final ERC-1271 selector is absent.

## Reviewer notes

### Mechanism

The proxy delegates every call to the singleton in slot 0, Safe 1.3.0. execTransaction (GnosisSafe.sol 111-194) hashes the transaction with the nonce, calls checkSignatures (145), which requires `threshold` signatures (227-230), then runs the call or delegatecall (176). checkNSignatures (240-304) reads each signature's v, chosen by whoever submits: v=0 calls the owner contract's legacy isValidSignature(bytes,bytes) and wants 0x20c13b0b (285); v=1 takes an approved hash, set by a call from the owner's own address (291, 333-335); any other v goes to ecrecover (295, 299). Line 301 only requires the resulting address to be an owner, in ascending order. The ecrecover branch never looks at the owner's code, so an owner account that later takes code or a delegation at the same address stays forgeable from its old key. Owners change only by a call from the Safe itself (SelfAuthorized 8): swapOwner, addOwnerWithThreshold, removeOwner, changeThreshold in OwnerManager, reached through execTransaction with three signatures. At the block: threshold 3, five owners with no code, four with a nonce above 0, nonce 85, no module, no guard, 36,830 wstETH.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Owners asked through ERC-1271: only when the submitted signature has v=0 (line 257-285); the ECDSA branch (299) stays open for every owner address, and no owner has code at the block.
- Ruled out: A module or guard that moves funds without owner signatures or blocks forged ones: getModulesPaginated returns none and the guard slot is zero at the block.
- Ruled out: Approved hashes (v=1): approveHash needs a call from the owner's own address, so it rests on the same key.
- Ruled out: Unused implementation: this address is a proxy with its own state (threshold 3, five owners, nonce 85, wstETH held), not the singleton.
- Ruled out: changeMasterCopy as an upgrade path, named in the old finding: that selector (0x7de7edef) is not in the 1.3.0 singleton's code; I did not state upgradeable or admin.
- Ruled out: Whose money it is and which team runs this Safe: nothing in the source or the chain reads I made shows it; whose and project are left empty.
- Ruled out: The family's replays (0x16a1d468…, 0x5b42f691… fail under EIP-8151) are Safe 1.3.0 transactions I did not check to be this address's; not cited. They belong to the EIP-8151 study, not to this quantum-exposure row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
