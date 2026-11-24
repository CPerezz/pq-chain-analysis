---
id: channelmastercopy-617a7481-signature-rechecked
format: 2
title: Connext channel strands a party if its counterpart's account takes real code
status: confirmed
severity: CRITICAL
justification: Both signers are re-checked at payout; one moving to real code strands the other, and the channel
  is fixed.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  name: ChannelMastercopy
  project: connext
  code: verified
  code_url: https://etherscan.io/address/0xd105b6b42206dfa6db00e6a4823bc88efac00476#code
  proxy_of: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  copies: 1647
  family: 58b8e695129ef8eab1cfe41710150735
  upgradeable: 'no'
value:
  usd: 94328
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Tell both participants to withdraw with both signatures before either moves its account to real code; the
  channel cannot be upgraded.
evidence_level: source
checks:
- id: lib-check
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: LibChannelCrypto.sol
  line: 18
  has: return recoverChannelMessageSigner(hash, signature) == allegedSigner;
  says: a signature counts only if the ECDSA-recovered address equals the alleged signer
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: ECDSA.sol
  line: 64
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is the ecrecover opcode
  for:
  - evidence-1
  - justification
  - what
- id: withdraw-call
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCWithdraw.sol
  line: 61
  has: verifySignaturesOnWithdrawDataHash(wdHash, aliceSignature, bobSignature);
  says: withdraw checks both signatures before paying
  for:
  - action
  - evidence-2
  - what
- id: withdraw-sigs
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCWithdraw.sol
  lines:
  - 92
  - 99
  has: commitment.checkSignature(bobSignature, bob)
  says: the withdrawal needs Alice's and Bob's signatures, each checked against the stored participant
  for:
  - evidence-2
  - justification
  - what
- id: dispute-sigs
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCAdjudicator.sol
  lines:
  - 351
  - 358
  has: commitment.checkSignature(bobSignature, ccs.bob)
  says: a channel state is disputed only with both participants' signatures, checked at the time of the dispute
  for:
  - evidence-3
  - justification
  - what
- id: defund-needs-dispute
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCAdjudicator.sol
  lines:
  - 137
  - 143
  has: 'require(inDefundPhase(), "CMCAdjudicator: INVALID_PHASE");'
  says: defundChannel needs the stored dispute hash and the defund phase that a dispute opens
  for:
  - evidence-3
  - justification
  - what
- id: exit
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCAsset.sol
  lines:
  - 115
  - 130
  has: exitableAmount[assetId][owner]
  says: exit pays only the amount already made exitable for the owner
  for:
  - what
- id: setup-once
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCCore.sol
  line: 44
  has: 'require(alice == address(0), "CMCCore: ALREADY_SETUP");'
  says: the participants are set once
  for:
  - action
  - justification
- id: project
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: CMCCore.sol
  line: 9
  has: '@author Connext <support@connext.network>'
  says: the source names Connext as author
  for:
  - notes
- id: clone
  bytecode: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  has: 363d3d373d3d3d363d73d105b6b42206dfa6db00e6a4823bc88efac004765af43d82803e903d91602b57fd5bf3
  says: the whole code is a fixed EIP-1167 clone forwarding to the mastercopy
  for:
  - action
  - justification
- id: alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getAlice()(address)
  is: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  says: Alice is the stored first participant
  for:
  - evidence-2
  - what
- id: bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getBob()(address)
  is: '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  says: Bob is the stored second participant
  for:
  - evidence-2
  - what
- id: dai-held
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: '94373884992489827601308'
  says: the channel holds this much DAI
  for:
  - whose
- id: deposits-bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalDepositsBob(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: '94373884992489827601308'
  says: the channel counts all its DAI as Bob's deposits
  for:
  - whose
- id: deposits-alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalDepositsAlice(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: '0'
  says: Alice deposited no DAI through depositAlice
  for:
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

Getting funds out of this Connext channel takes a withdrawal signed by both participants, or a dispute of a state they both signed. If a participant's account takes real code, its signature stops counting and neither can withdraw or dispute. An EIP-7702 delegation keeps working.

## Evidence

- [checkSignature](https://etherscan.io/address/0x617a74814d2c73b4a1655633c97654274cdb8775#code) accepts a signature only if ECDSA recovers the stored participant; there is no ERC-1271 branch.
- [withdraw](https://etherscan.io/address/0x617a74814d2c73b4a1655633c97654274cdb8775#code) requires the signatures of both stored participants, Alice and Bob.
- [disputeChannel](https://etherscan.io/address/0x617a74814d2c73b4a1655633c97654274cdb8775#code) requires both signatures; defundChannel needs that dispute first.

## Reviewer notes

### Mechanism

checkSignature (LibChannelCrypto.sol line 18) is ECDSA.recover (ECDSA.sol line 64, plain ecrecover) compared with the stored participant; nothing asks the account itself. withdraw (CMCWithdraw.sol lines 61, 92-99) and disputeChannel (CMCAdjudicator.sol lines 94, 351-358) call it for both Alice and Bob at the time of the call, not when the state was signed. defundChannel needs the dispute's stored hash and the defund phase (lines 137-143); exit pays only amounts that defundChannel or defundTransfer made exitable (CMCAsset.sol lines 102-131), and defundTransfer needs a dispute of the channel. So if Alice or Bob moves its account to real code, neither the cooperative withdrawal nor a dispute can pass and the DAI stays in the channel. The address is an EIP-1167 clone of the mastercopy, set up once with Alice 0xe688... (nonce 6244, no code) and Bob 0x8777... (nonce 0, no code). No dispute is open at the block. The clone's 94,374 DAI is all counted as Bob's deposit by the contract (Alice deposited 0); the off-chain split cannot be read. The dossier lists no call in the last 90 days: the channel is dormant, and its last recoveries in the study's table are in March-April 2021. Alice and Bob are the two addresses recovered then (6 calls).

### Checks

- Header facts: this address alone, at block 26,438,999; 1,647 addresses run this code.
- Ruled out: an ERC-1271 path for participants with code: none; checkSignature compares the recovered address only (LibChannelCrypto.sol line 18), and the source has no isValidSignature.
- Ruled out: a payout path without both signatures: depositAlice only takes tokens in, exit pays only what defundChannel or defundTransfer made exitable, and both need a dispute signed by both (CMCAdjudicator.sol lines 94, 137-143).
- Ruled out: a way to replace a participant or the code: the address is a fixed EIP-1167 clone and setup runs once (CMCCore.sol line 44).
- Ruled out: the mastercopy 0xd105... itself: it refuses calls (onlyViaProxy) and is not this card's subject; the other 1,646 copies hold their own participants and state.
- Ruled out: a fixed gas amount or a failure with nobody migrating: the recovery is the plain ecrecover opcode with all gas forwarded (ECDSA.sol line 64); the dossier lists no replay for this code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
