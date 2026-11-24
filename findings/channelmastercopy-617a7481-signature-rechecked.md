---
id: channelmastercopy-617a7481-signature-rechecked
format: 2
title: Channel participant loses its balance if the other's account takes real code
status: confirmed
severity: CRITICAL
justification: 'No update path: once one participant''s account takes real code, the other, who relied on its signature,
  loses.'
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
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Ask both participants to withdraw the balance with both signatures before either account takes real code;
  the code cannot change.
evidence_level: source
checks:
- id: withdraw-sigs
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCWithdraw.sol
  lines:
  - 52
  - 61
  has: verifySignaturesOnWithdrawDataHash(wdHash, aliceSignature, bobSignature);
  says: withdraw verifies both participants' signatures before anything else
  for:
  - action
  - evidence-1
  - what
- id: withdraw-both
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCWithdraw.sol
  lines:
  - 92
  - 99
  has: 'commitment.checkSignature(aliceSignature, alice), "CMCWithdraw: INVALID_ALICE_SIG" ); require( commitment.checkSignature(bobSignature,
    bob), "CMCWithdraw: INVALID_BOB_SIG"'
  says: a withdrawal reverts unless alice's and bob's signatures both match the stored participants
  for:
  - evidence-1
  - what
- id: withdraw-pays
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCWithdraw.sol
  line: 77
  has: transferAsset(wd.assetId, wd.recipient, actualAmount);
  says: after both signatures pass, withdraw transfers the asset to the recipient
  for:
  - action
- id: check-sig
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/lib/LibChannelCrypto.sol
  lines:
  - 13
  - 19
  has: return recoverChannelMessageSigner(hash, signature) == allegedSigner;
  says: a signature counts only when the recovered address equals the participant's address
  for:
  - evidence-1
  - justification
  - what
- id: recover
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/lib/LibChannelCrypto.sol
  lines:
  - 21
  - 28
  has: return ECDSA.recover(digest, signature);
  says: the signer is recovered with ECDSA only; the signer's account is never called
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: '@openzeppelin/contracts/cryptography/ECDSA.sol'
  lines:
  - 64
  - 65
  has: 'address signer = ecrecover(hash, v, r, s); require(signer != address(0), "ECDSA: invalid signature");'
  says: the recovery uses the precompile and reverts when it returns no address
  for:
  - evidence-2
  - justification
  - what
- id: dispute-verify
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 85
  - 94
  has: verifySignaturesOnChannelStateHash(ccs, ccsHash, aliceSignature, bobSignature);
  says: every call to disputeChannel verifies both signatures on the state it submits
  for:
  - evidence-2
  - justification
  - what
- id: dispute-both
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 351
  - 358
  has: 'commitment.checkSignature(aliceSignature, ccs.alice), "CMCAdjudicator: INVALID_ALICE_SIG" ); require( commitment.checkSignature(bobSignature,
    ccs.bob), "CMCAdjudicator: INVALID_BOB_SIG"'
  says: a channel state is rejected unless alice's and bob's signatures on it both recover
  for:
  - evidence-2
  - what
- id: channel-parties
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 34
  - 41
  has: ccs.alice == alice && ccs.bob == bob
  says: a submitted state must name the stored participants
  for:
  - notes
- id: dispute-nonce
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 99
  - 118
  has: channelDispute.nonce < ccs.nonce
  says: a stored state is replaced only by a state with a higher nonce that passed the signature check
  for:
  - evidence-2
  - what
- id: defund-stored
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 136
  - 140
  has: hashChannelState(ccs) == channelDispute.channelStateHash
  says: defundChannel pays only by the state that disputeChannel stored
  for:
  - what
- id: defund-phase
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 142
  - 143
  has: 'require(inDefundPhase(), "CMCAdjudicator: INVALID_PHASE");'
  says: defundChannel needs the defund phase, which only a dispute starts
  for:
  - what
- id: defund-pays
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 215
  - 216
  has: makeBalanceExitable(assetId, balance);
  says: defundChannel registers the stored state's balances as exitable
  for:
  - what
- id: transfer-phase
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 239
  - 240
  has: 'require(inDefundPhase(), "CMCAdjudicator: INVALID_PHASE");'
  says: disputeTransfer needs the channel's defund phase
  for:
  - what
- id: transfer-started
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAdjudicator.sol
  lines:
  - 276
  - 280
  has: transferDispute.transferDisputeExpiry != 0
  says: defundTransfer needs a transfer dispute already started by disputeTransfer
  for:
  - what
- id: exit-amount
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAsset.sol
  lines:
  - 115
  - 122
  has: 'exitableAmount[assetId][owner] ); // Revert if amount is 0 require(amount > 0, "CMCAsset: NO_OP");'
  says: exit pays only an amount registered as exitable and reverts when there is none
  for:
  - what
- id: exit-caller
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAsset.sol
  lines:
  - 110
  - 113
  has: msg.sender == owner || owner == recipient
  says: 'exit asks for no signature: the owner calls it, or anyone pays the owner'
  for:
  - what
- id: registers
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCAsset.sol
  lines:
  - 90
  - 95
  has: registerTransfer(assetId, amount);
  says: every transfer out of the channel is added to the asset's total transferred
  for:
  - evidence-3
- id: setup-once
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/CMCCore.sol
  lines:
  - 44
  - 52
  has: 'require(alice == address(0), "CMCCore: ALREADY_SETUP");'
  says: the two participants are set once in setup, which refuses a second call
  for:
  - action
  - justification
- id: author
  source: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  file: src.sol/ChannelMastercopy.sol
  lines:
  - 12
  - 15
  has: '@author Connext <support@connext.network>'
  says: the verified source names Connext as the author of the channel code
  for:
  - notes
- id: clone
  code: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: contract
  bytes: 45
  says: the channel's code is 45 bytes
  for:
  - justification
- id: clone-target
  bytecode: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  has: 363d3d373d3d3d363d73d105b6b42206dfa6db00e6a4823bc88efac004765af43d82803e903d91602b57fd5bf3
  says: 'the whole code is a fixed delegate to the mastercopy 0xd105…0476: no upgrade function'
  for:
  - action
  - justification
- id: alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getAlice()(address)
  is: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  says: the first participant (alice) is 0xe688…a910
  for:
  - evidence-3
- id: bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getBob()(address)
  is: '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  says: the second participant (bob) is 0x8777…fb14
  for:
  - evidence-3
- id: alice-code
  code: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  is: empty
  says: alice's account has no code and no delegation at the block
  for:
  - evidence-3
- id: bob-code
  code: '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  is: empty
  says: bob's account has no code and no delegation at the block
  for:
  - evidence-3
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: '94373884992489827601308'
  says: the channel holds 94,373.88 DAI
  for:
  - evidence-3
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x617a74814d2c73b4a1655633c97654274cdb8775'
  is: 0
  says: the channel holds no ETH
  for:
  - notes
- id: no-dispute
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getChannelDispute()(bytes32,uint256,bytes32,uint256,uint256)
  is:
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - 0
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - 0
  - 0
  says: 'no channel state is stored and no dispute phase is set: no dispute is open'
  for:
  - evidence-3
  - what
- id: no-exit-alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getExitableAmount(address,address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  - '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  is: 0
  says: alice has no DAI registered as exitable
  for:
  - notes
- id: no-exit-bob
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getExitableAmount(address,address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  - '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  is: 0
  says: bob has no DAI registered as exitable
  for:
  - notes
- id: none-out
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalTransferred(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: 0
  says: the channel has transferred out no DAI
  for:
  - evidence-3
- id: deposits-alice
  call: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  fn: getTotalDepositsAlice(address)(uint256)
  args:
  - '0x6b175474e89094c44da98b954eedeac495271d0f'
  is: 0
  says: alice deposited no DAI through depositAlice
  for:
  - notes
- id: alice-nonce-then
  nonce: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  is: 6244
  at: 16000000
  says: alice's account had sent 6,244 transactions by block 16,000,000
  for:
  - notes
- id: alice-nonce
  nonce: '0xe6887c0cc3c37cb2ee34bc58ab258f36825ca910'
  is: 6244
  says: alice's account has sent nothing since block 16,000,000
  for:
  - notes
- id: bob-nonce
  nonce: '0x8777aa713e5f5cad015d08f140cf73e309a9fb14'
  is: 0
  says: bob's account has never sent a transaction
  for:
  - notes
- id: gas-all
  bytecode: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  has: 6020604051602081039080840390855afa
  says: 'the mastercopy''s call to the recovery forwards all gas (GAS, STATICCALL): no constant amount'
  for:
  - notes
- id: direct
  call: '0xd105b6b42206dfa6db00e6a4823bc88efac00476'
  fn: getAlice()(address)
  reverts_with: ONLY_VIA_PROXY
  says: 'the mastercopy refuses direct calls: it is used only through clones'
  for:
  - notes
- id: past-tx
  tx: '0x0b6f91cbbd17ad49037d8a27217b1ca397650e7aad87f22d83de9cea3641cbe0'
  to: '0x617a74814d2c73b4a1655633c97654274cdb8775'
  ok: true
  says: a transaction to this channel in block 12,106,029 succeeded
  for:
  - notes
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

This two-party channel pays out only on ECDSA signatures of both participants. Once one account takes real code, no withdrawal or new dispute passes, and a dispute opened earlier on an old balance cannot be answered: the other loses. No dispute is open and it holds DAI.

## Evidence

- [withdraw](https://etherscan.io/address/0xd105b6b42206dfa6db00e6a4823bc88efac00476#code) needs both participants' signatures, recovered with ECDSA; an account with real code is never asked itself.
- [disputeChannel](https://etherscan.io/address/0xd105b6b42206dfa6db00e6a4823bc88efac00476#code) checks both signatures on every balance submitted, so a newer one cannot replace an old one once a signer has real code.
- The [channel](https://etherscan.io/address/0x617a74814d2c73b4a1655633c97654274cdb8775) holds 94,373 DAI and has paid out none; no dispute is open, and both participants are accounts without code.

## Reviewer notes

### Mechanism

The address is a 45-byte clone that delegates to ChannelMastercopy 0xd105b6b4…0476. alice and bob are set once in setup (CMCCore.sol line 44); nothing replaces them. withdraw (CMCWithdraw.sol lines 52-83) and disputeChannel (CMCAdjudicator.sol lines 85-122) each require LibChannelCrypto.checkSignature for alice and for bob: ECDSA.recover of a prefixed digest, compared with the stored address, with no ERC-1271 branch; the library reverts when the precompile returns no address. Funds leave by withdraw, or by exit, which pays only amounts registered by defundChannel or defundTransfer; both need a state stored by disputeChannel and its defund phase. So every way out starts with both signatures. Under EIP-8151 a participant whose account has real code recovers to nothing: withdraw and disputeChannel revert for every state it signed. With no dispute open, the balance stays in the channel for both. If a dispute on an older state was opened before the account took real code, the other participant's newer state (nonce rule, lines 100-103) is rejected, and after the consensus phase defundChannel pays by the older state; exit needs no signature. At the block: no dispute stored, no exitable DAI, 94,373.88 DAI held, both participants are accounts without code or delegation.

### Checks

- Header facts: this address alone, at block 26,438,999; 1,647 addresses run this code.
- Ruled out: a signer with real code asked another way: checkSignature (LibChannelCrypto.sol lines 13-19) only compares the ECDSA-recovered address; no ERC-1271 call, no code-size branch.
- Ruled out: a way out without signatures: exit pays only registered amounts; getExitableAmount is 0 for both participants and getChannelDispute is all zero. The source has no owner, admin or rescue function.
- Ruled out: an unused implementation: this row is a clone with its own state. The mastercopy reverts ONLY_VIA_PROXY when called directly. The other 1,646 clones are other channels with their own participants and state; none was read.
- Ruled out: a failure with nobody migrating: the recovery forwards all gas (check gas-all), and the dossier lists no replay for this code, so nothing was executed.
- Ruled out: whose money: getTotalDepositsAlice(DAI) is 0, so the code counts all the DAI as bob's deposits, but the split is set by the latest state signed off chain, and who holds the two keys is not shown on chain. `whose` is left empty; if one party held both keys, only its own money would be at stake.
- Ruled out: use: no call in the 90 days before the block (dossier). alice's nonce is 6,244 at block 16,000,000 and at the block; bob's is 0. A transaction alice sent to the channel in block 12,106,029 (withdraw selector) succeeded.
- Ruled out: value: the DAI is this address's own; the row's earlier figure covered all 1,647 clones.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
