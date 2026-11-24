---
id: channelmastercopy-617a7481-signature-rechecked
format: 2
title: Channel funds are lost or stuck if a participant's account takes real code
status: confirmed
severity: CRITICAL
justification: A participant can void the other's latest signed state by moving to real code, and nobody can change
  the contract.
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
impact: funds-loss
action: Ask both participants to withdraw this channel's DAI with a co-signed withdrawal before either account takes
  real code.
evidence_level: source
checks:
- id: author
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/ChannelMastercopy.sol
  line: 13
  has: '@author Connext <support@connext.network>'
  says: the verified source is Connext's channel mastercopy
  for:
  - what
- id: participants-doc
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCCore.sol
  lines:
  - 36
  - 38
  has: Address representing user with multisig deposit
  says: the source describes both participants as users of the channel
  for:
  - whose
- id: setup-once
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCCore.sol
  lines:
  - 44
  - 52
  has: 'require(alice == address(0), "CMCCore: ALREADY_SETUP");'
  says: setup sets alice and bob once and reverts afterwards
  for:
  - evidence-3
  - justification
  - what
- id: withdraw-sigs
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCWithdraw.sol
  lines:
  - 92
  - 99
  has: commitment.checkSignature(bobSignature, bob),
  says: withdraw requires signatures that recover to the stored alice and bob
  for:
  - action
  - evidence-2
  - what
- id: dispute-sigs
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 351
  - 358
  has: commitment.checkSignature(aliceSignature, ccs.alice),
  says: disputeChannel requires signatures of alice and bob on the channel state, on every call
  for:
  - evidence-1
  - justification
  - what
- id: dispute-first
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 93
  - 94
  has: verifySignaturesOnChannelStateHash(ccs, ccsHash, aliceSignature, bobSignature)
  says: 'every disputeChannel call, first or answering, verifies both signatures first: a participant with real
    code cannot dispute'
  for:
  - what
- id: dispute-nonce
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 100
  - 113
  has: channelDispute.nonce < ccs.nonce,
  says: a disputed state replaces the stored one only with a higher nonce, and the first dispute opens a timed window
  for:
  - evidence-1
  - justification
  - what
- id: defund-nosig
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 137
  - 143
  has: hashChannelState(ccs) == channelDispute.channelStateHash,
  says: 'defundChannel takes no signature: it pays out the stored disputed state once the window ends'
  for:
  - evidence-2
  - what
- id: exit
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAsset.sol
  lines:
  - 110
  - 118
  has: exitableAmount[assetId][owner]
  says: exit pays only the amount made exitable for an owner
  for:
  - evidence-2
  - what
- id: recover
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: '@openzeppelin/contracts/cryptography/ECDSA.sol'
  lines:
  - 64
  - 65
  has: 'require(signer != address(0), "ECDSA: invalid signature");'
  says: recovery calls ecrecover and reverts when it returns no address
  for:
  - justification
  - what
- id: clone
  code: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: contract
  bytes: 45
  says: the address is a 45-byte minimal clone
  for:
  - evidence-3
  - justification
- id: clone-target
  bytecode: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  has: d105b6b42206dfa6db00e6a4823bc88efac00476
  says: the clone's target is fixed in its code
  for:
  - notes
- id: no-upgrade
  selector: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  fn: upgradeTo(address)
  absent: true
  says: the mastercopy has no upgrade function
  for:
  - evidence-3
  - justification
- id: alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getAlice()(address)
  is: '0xe6887c0cc3c37cb2ee34Bc58AB258f36825CA910'
  says: alice is 0xe6887c0c
  for:
  - action
  - what
- id: bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getBob()(address)
  is: '0x8777Aa713e5f5CAD015d08F140cF73e309a9fb14'
  says: bob is 0x8777aa71
  for:
  - action
  - what
- id: alice-eoa
  code: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  is: empty
  says: alice's account has no code
  for:
  - action
- id: bob-eoa
  code: '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  is: empty
  says: bob's account has no code
  for:
  - action
- id: no-dispute
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  data: '0xf19eb10e'
  is: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  says: 'getChannelDispute is all zero: no dispute has been started'
  for:
  - what
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: '94373884992489827601308'
  says: the channel holds 94,373.88 DAI
  for:
  - what
- id: deposits-alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalDepositsAlice(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: '0'
  says: alice deposited no DAI
  for:
  - whose
- id: deposits-bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalDepositsBob(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: '94373884992489827601308'
  says: all DAI held is counted on-chain as bob's deposit
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

This Connext channel holds 94,373 DAI for two participants fixed at setup; no dispute has been started. Withdrawals and disputed states need both participants' ECDSA signatures. If one takes real code, nothing exits; if it disputes an old state first, the other cannot answer and that state pays out.

## Evidence

- [disputeChannel](https://etherscan.io/address/0xd105b6b42206dfa6db00e6a4823bc88efac00476#code) checks both signatures again on every state, including a newer one sent to answer a dispute.
- [withdraw](https://etherscan.io/address/0xd105b6b42206dfa6db00e6a4823bc88efac00476#code) needs both signatures; without them, funds leave only through a finished dispute.
- This [clone](https://etherscan.io/address/0x617a74814d2c73b4a1655633c97654274cdb8775#code) runs fixed code with no upgrade function, and its participants are set once.

## Reviewer notes

### Mechanism

The address is a 45-byte clone of ChannelMastercopy 0xd105b6b4. setup stores alice and bob once (CMCCore 44-52; no setter). withdraw (CMCWithdraw 61, 92-99) recovers both signatures on the withdrawal and compares them with the stored alice and bob. disputeChannel (CMCAdjudicator 94, 351-358) recovers both signatures on the channel state each time it is called, and accepts a state only with a higher nonce (100-103); the first dispute opens a consensus window of ccs.timeout (109-113). After it, defundChannel needs no signature, only the stored state hash (137-140), and makes the stored state's balances exitable (216); exit (CMCAsset 102-113) pays them out. Recovery is OpenZeppelin ECDSA.recover, which calls ecrecover and reverts on a zero result (ECDSA 64-65), via LibChannelCrypto.checkSignature (13-27). Under EIP-8151, once alice or bob has real code, every withdraw and every disputeChannel reverts: nobody can exit the DAI. And if one participant disputes an old co-signed state while still an EOA and then takes real code, the other's newer state is rejected and the old one is paid out. At the block: alice 0xe6887c0c (EOA, nonce 6244), bob 0x8777aa71 (EOA, nonce 0), no dispute stored, 94,373.88 DAI held, all of it credited on-chain to bob (depositsAlice 0).

### Checks

- Header facts: this address alone, at block 26,438,999; 1,647 addresses run this code.
- Ruled out: an ERC-1271 or code-size path: LibChannelCrypto.checkSignature (lines 13-19) only compares an ECDSA recovery with the participant.
- Ruled out: an unused implementation: this address is a clone initialized with its own participants (getAlice, getBob) and holds 94,373 DAI.
- Ruled out: key-state: both participants are accounts without code at the block, and they are the addresses withdraw and disputeChannel compare with.
- Ruled out: a setter or upgrade: setup reverts once alice is set (line 44), the clone's target is fixed in its 45-byte code, and the mastercopy has no upgradeTo.
- Ruled out: a direct path: exit needs no signature but pays only exitable amounts, which are 0 for both participants in DAI and are set only by defundChannel or defundTransfer after a signed dispute; defundTransfer's direct responder call also needs a finished channel dispute (disputeTransfer, lines 233-240).
- Ruled out: path closed: no dispute was ever started (getChannelDispute all zero), so withdraw and disputeChannel are open.
- Ruled out: a fixed-gas issue: Solidity ecrecover forwards all gas; the scan found no constant gas and the dossier lists no replays.
- Ruled out: the other 1,646 clones of this mastercopy were not read; each has its own participants and balances.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
