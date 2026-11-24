---
id: contract-0cfabe8a-rotate-signer-before-migrating
format: 2
title: Alchemy 7702 account must set another signer before taking real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the holder moves this account to real code, and the holder can store another signer
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  code: verified
  code_url: https://etherscan.io/address/0x69007702764179f14f51cdce752f4f775d74e139#code
  copies: 98841
  family: dda3e769e166291d5abdffe6b25e08a7
value:
  usd: 361701
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Store a fallback signer with updateFallbackSignerData, or keep the EIP-7702 delegation, before the account
  takes real code.
evidence_level: source
checks:
- id: deleg
  code: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  is: delegation
  target: '0x69007702764179f14f51cdce752f4f775d74e139'
  says: the address is an account with an EIP-7702 delegation to SemiModularAccount7702
  for:
  - action
  - what
  - whose
- id: nonce
  nonce: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  is: 19
  says: the account has sent 19 transactions with its own key
  for:
  - whose
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  is: '200155681414381154525'
  says: the account holds about 200 ETH of its own
  for:
  - whose
- id: slot
  storage: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  slot: '0x5b9dc9aa943f8fa2653ceceda5e3798f0686455280432166ba472eca0bc17a32'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: no fallback signer is stored and fallback signing is not disabled
  for:
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  fn: getFallbackSignerData()(address,bool)
  is:
  - '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  - false
  says: the signer the account checks is the account itself, and fallback signing is enabled
  for:
  - evidence-2
  - what
- id: self
  source: '0x69007702764179f14f51cdce752f4f775d74e139'
  file: src/account/SemiModularAccount7702.sol
  lines:
  - 55
  - 60
  has: return address(this);
  says: with no signer stored, the fallback signer is the address the code runs at
  for:
  - evidence-2
  - what
- id: ecdsa
  source: '0x69007702764179f14f51cdce752f4f775d74e139'
  file: src/account/SemiModularAccountBase.sol
  lines:
  - 174
  - 179
  has: if (err == ECDSA.RecoverError.NoError && recovered == owner) {
  says: an EOA-flagged signature is recovered with ECDSA and accepted only if it equals the fallback signer
  for:
  - evidence-1
  - what
- id: setter
  source: '0x69007702764179f14f51cdce752f4f775d74e139'
  file: src/account/SemiModularAccountBase.sol
  lines:
  - 76
  - 83
  has: _storage.fallbackSigner = fallbackSigner;
  says: updateFallbackSignerData stores a new fallback signer
  for:
  - action
  - evidence-3
  - justification
- id: wrap
  source: '0x69007702764179f14f51cdce752f4f775d74e139'
  file: src/account/ModularAccountBase.sol
  lines:
  - 127
  - 128
  has: DensePostHookData postHookData = _checkPermittedCallerAndAssociatedHooks();
  says: updateFallbackSignerData's modifier checks who calls it
  for:
  - action
  - evidence-3
  - justification
- id: selfskip
  source: '0x69007702764179f14f51cdce752f4f775d74e139'
  file: src/account/ModularAccountBase.sol
  lines:
  - 658
  - 660
  has: msg.sender != address(_ENTRY_POINT) && msg.sender != address(this)
  says: a call from the EntryPoint or from the account itself passes the caller check (validation was done before)
  for:
  - action
  - evidence-3
  - justification
- id: no-modules
  logs: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  topic: '0xc36a28045e90a1163d24d4216c8cfd8c44c4e835a486fb84d511d6b9e0736db9'
  from: 26302590
  to: 26438999
  count: 0
  says: the account installed no validation module since its delegation, so its own key is its only signer
  for:
  - notes
- id: no-exec-modules
  logs: '0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e'
  topic: '0xa88d8623c27a239930131fa42df175f443aad0ee03cbd721e4c8a8b762869603'
  from: 26302590
  to: 26438999
  count: 0
  says: the account installed no execution module since its delegation, so no added function moves funds without
    a signature
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-0cfabe8a, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL (PQ-17): an EIP-7702 delegation to SemiModularAccount7702 with no fallback signer stored,
    so the account''s own ECDSA key is what its code checks; if the account takes real code unprepared, that check
    and the ERC-1271 path (which loops back to it) both fail. Fix first: updateFallbackSignerData. No validation
    or execution module installed since the delegation at block 26,302,590 (Claude''s log read, two logs checks).
    Rewritten from the 7702-own-key-only draft; project and label dropped after the first refuter (Alchemy cannot
    act on it); a fresh refuter agrees. Claude read the sheet.'
related: []
---

## What happens

This account accepts a signature that recovers to its fallback signer; none is stored, so that signer is the account itself. If it takes this logic as real code with no other signer stored, its own signatures stop counting. An EIP-7702 delegation keeps working.

## Evidence

- [_checkSignature](https://etherscan.io/address/0x69007702764179f14f51cdce752f4f775d74e139#code) recovers an EOA-flagged signature with ECDSA and accepts it when it matches the fallback signer.
- [getFallbackSignerData](https://etherscan.io/address/0x0cfabe8a8a5cd4ceee2baaa850cfb92f7391f47e) returns the account itself: no other signer is stored.
- [updateFallbackSignerData](https://etherscan.io/address/0x69007702764179f14f51cdce752f4f775d74e139#code) stores a new signer; the account can call it on itself or through the EntryPoint.

## Reviewer notes

### Mechanism

The address holds an EIP-7702 delegation to SemiModularAccount7702 (Alchemy). User operations and ERC-1271 checks through the fallback validation call _checkSignature(fallbackSigner, ...). _retrieveFallbackSignerUnchecked returns the stored fallbackSigner, or address(this) when none is stored; the storage slot is empty at the block, so the signer is the account itself. An EOA-flagged signature is recovered with ECDSA and compared with that signer; a CONTRACT_OWNER-flagged one asks the signer through ERC-1271, which here is the account itself and bottoms out in the same ECDSA comparison. The runtime routes (msg.sender == fallbackSigner, lines 137 and 204-208) need a call sent by the account itself, i.e. a transaction signed with its own key, which an account with real code cannot send (EIP-3607). So if the account takes this logic as real code with no other signer stored, its built-in validation accepts nothing. updateFallbackSignerData is wrapped by wrapNativeFunction, which lets the EntryPoint (after a validated user op) or the account itself call it; today the holder can store another signer, or a contract signer asked through ERC-1271.

### Checks

- Header facts: this address alone, at block 26,438,999; 98,841 addresses run this code.
- Ruled out: ERC-1271 escape: a CONTRACT_OWNER-flagged signature asks the fallback signer through ERC-1271, but with none stored that signer is the account itself, so it does not help unless another signer is stored (lines 180-181; slot empty).
- Ruled out: Direct-call routes (lines 137 and 204-208): both need msg.sender to be the fallback signer, here the account itself, so they need a transaction signed with the account's own key; not an alternative path.
- Ruled out: Breaks by itself: the account is an EIP-7702 delegation, which EIP-8151 still recovers; the family's replays under EIP-8151 alone succeed. A family replay (0x46e5eea6..., another account 0x8796...) reverts under eip8151_self_real_code; it is another account and its calls were not read, so it is not cited.
- Ruled out: Unused implementation: this is a live account, not implementation code (nonce 19, five recoveries of its own address in the trace window).
- Ruled out: Fallback disabled: the disabled flag is false (slot empty, getFallbackSignerData).
- Ruled out: A module beside the own-key check: none installed since the delegation at block 26,302,590 (no ValidationInstalled or ExecutionInstalled event; checks no-modules and no-exec-modules).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
