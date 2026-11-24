---
id: fishgame-0dc55e87-rotate-signer-before-migrating
format: 2
title: Presale signer must be replaced before its account moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the presale signer moves its account to real code; the owner can set a new signer
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  name: FISHGAME
  code: verified
  code_url: https://etherscan.io/address/0x0dc55e87741bf7c62b4fb05479868b0751e5b80d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x12854d0bd17853ce57a171ff7d5534ae09eff2b5'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10
  last: 2026-09-28
impact: liveness
action: Set a new signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: gate
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  lines:
  - 1705
  - 1707
  has: require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
  says: presaleBuy reverts unless the signature check passes
  for:
  - evidence-1
  - what
- id: compare
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  line: 1669
  has: return _signerAddress == hash.recover(signature);
  says: the address recovered with ECDSA must equal the stored signer; there is no other branch
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  line: 1583
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  lines:
  - 1743
  - 1745
  has: _signerAddress = addr;
  says: setSignerAddress, owner only, overwrites the stored signer
  for:
  - action
  - evidence-3
  - justification
  - what
- id: setter-owner
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  line: 1743
  has: function setSignerAddress(address addr) external onlyOwner {
  says: only the owner can call setSignerAddress
  for:
  - notes
- id: toggle
  source: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  file: FishGame.sol
  lines:
  - 1734
  - 1736
  has: presaleLive = !presaleLive;
  says: togglePresaleStatus, owner only, turns the presale on or off
  for:
  - what
- id: presale-off
  call: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  fn: presaleLive()(bool)
  is: false
  says: the presale is off at the block
  for:
  - what
- id: signer-slot
  storage: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  slot: 19
  is: '0x000000000000000000000000956231b802d9494296acde7b3ce3890c8b0438b8'
  says: the stored signer is 0x956231b802d9494296acde7b3ce3890c8b0438b8 (slot 19, packed with three false flags)
  for:
  - action
  - evidence-2
  - what
- id: signer-code
  code: '0x956231b802d9494296acde7b3ce3890c8b0438b8'
  is: empty
  says: the signer's account has no code
  for:
  - evidence-2
- id: owner
  call: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  fn: owner()(address)
  is: '0x12854d0bd17853ce57a171ff7d5534ae09eff2b5'
  says: the owner that can replace the signer and toggle the presale
  for:
  - action
  - evidence-3
  - justification
  - what
- id: owner-eoa
  code: '0x12854d0bd17853ce57a171ff7d5534ae09eff2b5'
  is: empty
  says: the owner is an account without code, not renounced
  for:
  - evidence-3
  - justification
  - what
- id: owner-nonce
  nonce: '0x12854d0bd17853ce57a171ff7d5534ae09eff2b5'
  min: 100
  says: the owner's account has sent transactions
  for:
  - evidence-3
- id: supply
  call: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  fn: totalSupply()(uint256)
  is: 1600
  says: 1,600 tokens exist
  for:
  - notes
- id: max
  call: '0x0dc55e87741bf7c62b4fb05479868b0751e5b80d'
  fn: FISH_MAX_COUNT()(uint256)
  is: 3333
  says: the cap is 3,333, so tokens remain to mint
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
- who: r-0dc55e87, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''); a fresh refuter agrees on every part; Claude read the changed sentences.
    Kept as before (FISHGAME; Q2-class: presale off at the block, reopenable).'
related: []
---

## What happens

FISHGAME sells presale tokens only to buyers who hold an ECDSA signature from one stored key. The presale is off now and the owner can turn it on. If that key's account moves to real code, presale buys fail until the owner sets a new key.

## Evidence

- In the [verified source](https://etherscan.io/address/0x0dc55e87741bf7c62b4fb05479868b0751e5b80d#code), presaleBuy reverts unless the signature recovers to the stored signer.
- The stored [signer](https://etherscan.io/address/0x956231b802d9494296acde7b3ce3890c8b0438b8) is an account without code.
- setSignerAddress lets the [owner](https://etherscan.io/address/0x12854d0bd17853ce57a171ff7d5534ae09eff2b5), an account without code that has sent transactions, replace the signer.

## Reviewer notes

### Mechanism

presaleBuy (FishGame.sol, lines 1705-1714) requires presaleLive, then matchAddresSigner(signature). matchAddresSigner (1664-1670) hashes msg.sender with the constant word "private" under the Ethereum signed-message prefix and returns _signerAddress == hash.recover(signature); ECDSA.recover ends in ecrecover (line 1583) and reverts on a zero result, so a signer with code makes presaleBuy revert. _signerAddress is storage slot 19 (packed with presaleLive, saleLive, locked, all false at the block): 0x956231b8…38b8, the value written in the source, with empty code and nonce 0. setSignerAddress (1743-1745, onlyOwner) overwrites it; owner() is 0x12854d0b…f2b5, empty code, nonce 106. presaleLive is false at the block; togglePresaleStatus (1734-1736, onlyOwner) flips it. totalSupply is 1,600 of FISH_MAX_COUNT 3,333, so mints are still possible. The contract holds no ETH or priced tokens; whose is left empty because there is nothing held to attribute.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for a signer with code: matchAddresSigner only compares the ECDSA recovery (lines 1664-1670); the file has no isValidSignature call.
- Ruled out: the key being unset or already a contract: slot 19 holds 0x956231b8…38b8, whose code is empty at the block.
- Ruled out: the setter being dead: setSignerAddress writes _signerAddress (line 1744) and the owner is a codeless account with nonce 106, not renounced.
- Ruled out: the signed path being closed for good: presaleLive is false at the block, but togglePresaleStatus reopens it and supply is 1,600 of 3,333; the path is closed now, not for good.
- Ruled out: a direct path for the same act: buy() mints without a signature but only while saleLive (false at the block) and at the main-sale price, a different sale; gift and founderMint are owner-only.
- Ruled out: a later recheck of the signature: it is checked once inside presaleBuy and nothing relies on it afterwards.
- Ruled out: proxy or other code: the tool reads no proxy slots and no DELEGATECALL; the scanner counts one ecrecover site, matching ECDSA line 1583.
- Ruled out: real use of the signed path: the dossier shows no recovery in the trace window and totalTokensSoldInPresale() is 0 (the code never increments it, so it proves nothing about past presale buys).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
