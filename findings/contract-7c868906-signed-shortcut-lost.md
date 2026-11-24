---
id: contract-7c868906-signed-shortcut-lost
format: 2
title: Deposits fall to the payee if their signer's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Only breaks on signer migration; the payee can still sweep after expiry, the refund address cannot.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  code: bytecode
  code_url: https://etherscan.io/address/0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10
  last: 2026-11-17
impact: liveness
action: Open or sweep each deposit with its signer's signature before that signer's account moves to real code.
evidence_level: executed
checks:
- id: opentx
  tx: '0xaebee0d21bdc7e267f6908a9cfbea85330b53f787beae23f6d58a728788ec12f'
  to: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  ok: true
  says: a real deposit opened through the signed path (b827a5b4) succeeded; the sender calls the escrow directly
  for:
  - action
  - evidence-1
- id: rcode
  replay: '0xaebee0d21bdc7e267f6908a9cfbea85330b53f787beae23f6d58a728788ec12f'
  run: eip8151_signer_code
  ok: false
  says: with real code at the recovered signer the same transaction reverts under EIP-8151
  for:
  - action
  - evidence-1
  - justification
  - what
- id: rdeleg
  replay: '0xaebee0d21bdc7e267f6908a9cfbea85330b53f787beae23f6d58a728788ec12f'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer it still succeeds
  for:
  - evidence-1
  - what
- id: r8151
  replay: '0xaebee0d21bdc7e267f6908a9cfbea85330b53f787beae23f6d58a728788ec12f'
  run: eip8151
  ok: true
  says: 'under EIP-8151 alone, with nobody migrating, it succeeds: nothing breaks by itself'
  for:
  - justification
- id: depid
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x99304b12000000000000000000000000693baed428584fe58054ece21d6cf8cbf2be2bbc00000000000000000000000099b6d029b891d918a948f10af4f070c3d6390219000000000000000000000000dd5864bba8bb8aa61735832c77d067a781075472000000000000000000000000000000000000000000000000000000006afd13e7a09c028f0024fc449b8393e97925176f42b7bbbe07be0452c92b23668313d5f0'
  is: '0xc56058798595ea1e94c1684f3bdc5258372a5a93715d7baebd5f5d280ab288fa'
  says: the escrow's view 99304b12 gives that transaction's deposit id from first party, claim address, signer,
    expiry and salt
  for:
  - what
- id: depaddr
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  fn: depositAddress(bytes32)(address)
  args:
  - '0xc56058798595ea1e94c1684f3bdc5258372a5a93715d7baebd5f5d280ab288fa'
  is: '0xb6f045a24e77d2732bd819aee7eb684b190d9a51'
  says: that deposit id gives the deposit address 0xb6f0…9a51, which sent the USDT into the escrow in that transaction
  for:
  - what
- id: clone
  code: '0xb6f045a24e77d2732bd819aee7eb684b190d9a51'
  is: contract
  bytes: 45
  says: the deposit address is a 45-byte minimal clone (of forwarder 0xc769…416e)
  for:
  - notes
- id: fwdonly
  call: '0xb6f045a24e77d2732bd819aee7eb684b190d9a51'
  data: '0xb8dc491b000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000000000d0'
  from: '0x00000000000000000000000000000000000000d0'
  reverts_with: '0xfc447f62'
  says: the deposit address refuses a sweep from anyone but the escrow
  for:
  - notes
- id: digest
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x7087bb19c56058798595ea1e94c1684f3bdc5258372a5a93715d7baebd5f5d280ab288fa29659b45e5dd57b65342f33ba588a785dd800d9a738657daf8d560d6797dfdf1'
  is: '0x7642eab91ca278b9e697b14685d07616208b37ea3301582d8329500dad0aefa5'
  says: the escrow's EIP-712 digest of (deposit id, order key) for that transaction
  for:
  - what
- id: recover
  call: '0x0000000000000000000000000000000000000001'
  data: '0x7642eab91ca278b9e697b14685d07616208b37ea3301582d8329500dad0aefa5000000000000000000000000000000000000000000000000000000000000001c0efb395e4d54c455a972cb899b0fd6127c37dfe35c8ed43d71aec1b4f46d9ddc2bd46518e9960cb30f056e24c0f9225a80a8d06ea7920a541b419f45b44c1d41'
  is: '0x000000000000000000000000dd5864bba8bb8aa61735832c77d067a781075472'
  says: the transaction's signature over that digest recovers to the signer built into the deposit id (ECDSA via
    the precompile)
  for:
  - evidence-1
  - what
- id: sweepok
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x8aa5cc34000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000693baed428584fe58054ece21d6cf8cbf2be2bbc00000000000000000000000000000000000000000000000000000000000000c1000000000000000000000000ec309ff56b5136eea5c86b866dc2ed4290b7594700000000000000000000000000000000000000000000000000000000f4865700e6ce4fe93488b043608824fc61a7c8615b0c72e06aad895a5468e3bb51ca1a4f00000000000000000000000000000000000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000041f8e6e6a2e90524634bb9af26a4d088a86b8f88f237aa6b7fc49a86f60cf6a672572066948dfbaeab48278b1196779a9f43e127edc5ec72260a4e187f63b254241b00000000000000000000000000000000000000000000000000000000000000'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: 'simulation: a test signer''s signed sweep (8aa5cc34) goes through before the deposit''s expiry, to the
    recipient it signed'
  for:
  - action
  - evidence-2
  - what
- id: sweepbad
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x8aa5cc34000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000693baed428584fe58054ece21d6cf8cbf2be2bbc00000000000000000000000000000000000000000000000000000000000000c1000000000000000000000000ec309ff56b5136eea5c86b866dc2ed4290b7594700000000000000000000000000000000000000000000000000000000f4865700e6ce4fe93488b043608824fc61a7c8615b0c72e06aad895a5468e3bb51ca1a4f00000000000000000000000000000000000000000000000000000000000000d1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001200000000000000000000000000000000000000000000000000000000000000041f8e6e6a2e90524634bb9af26a4d088a86b8f88f237aa6b7fc49a86f60cf6a672572066948dfbaeab48278b1196779a9f43e127edc5ec72260a4e187f63b254241b00000000000000000000000000000000000000000000000000000000000000'
  reverts_with: '0x7ca55c77'
  says: the same sweep to another recipient than the signed one is refused (bad signature)
  for:
  - evidence-2
  - what
- id: directearly
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x72cabcbd000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000099b6d029b891d918a948f10af4f070c3d6390219000000000000000000000000dd5864bba8bb8aa61735832c77d067a78107547200000000000000000000000000000000000000000000000000000000f4865700e6ce4fe93488b043608824fc61a7c8615b0c72e06aad895a5468e3bb51ca1a4f00000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000'
  from: '0x693baed428584fe58054ece21d6cf8cbf2be2bbc'
  reverts_with: '0x085de625'
  says: the unsigned sweep (72cabcbd) is refused before the deposit's expiry
  for:
  - evidence-2
  - what
- id: directlate
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x72cabcbd000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000099b6d029b891d918a948f10af4f070c3d6390219000000000000000000000000dd5864bba8bb8aa61735832c77d067a78107547200000000000000000000000000000000000000000000000000000000000003e8e6ce4fe93488b043608824fc61a7c8615b0c72e06aad895a5468e3bb51ca1a4f00000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000'
  from: '0x693baed428584fe58054ece21d6cf8cbf2be2bbc'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the unsigned sweep goes through once the deposit's expiry has passed
  for:
  - evidence-2
  - justification
  - what
- id: callerslot
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: '604080513360208083019190915273'
  says: 'the unsigned sweep puts msg.sender first in the deposit id (pc 0x122f): only a deposit''s first party reaches
    it'
  for:
  - justification
  - what
- id: domain
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  fn: eip712Domain()(bytes1,string,string,uint256,address,bytes32,uint256[])
  is:
  - '0x0f'
  - EpicSwapEscrow
  - '2'
  - 1
  - '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  - '0x0000000000000000000000000000000000000000000000000000000000000000'
  - []
  says: the escrow signs under the EIP-712 domain EpicSwapEscrow, version 2, chain 1
  for:
  - what
- id: escrowbal
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  is: 0
  says: the escrow itself holds no USDT at the block
  for:
  - notes
- id: depid-from-order
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: 5f611c7b611bff6080890160608a01613415565b611c0f60a08a0160808b0161341556
  says: the open builds the deposit id from order field 0x60 (first party) and field 0x80 (claim key) (pc 0x1bec)
  for:
  - what
- id: claim-pays-payee
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: 61249c61246b608085016060860161341556
  says: 'a claim pays order field 0x60, the deposit id''s first party: the order''s payee (pc 0x2459)'
  for:
  - what
- id: refund-to-field40-cancel
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: 610815906107e7906060860190860161341556
  says: a cancel refunds order field 0x40, the refund address (pc 0x07d4)
  for:
  - what
- id: refund-to-field40-timeout
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: 610ae290610ad1906060870190870161341556
  says: a timeout refund goes to order field 0x40, the refund address (pc 0x0abe)
  for:
  - what
- id: refund-party-other-id
  call: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  data: '0x99304b120000000000000000000000006083e83f2dbb8a81b6489b408296ff7ae560cab400000000000000000000000099b6d029b891d918a948f10af4f070c3d6390219000000000000000000000000dd5864bba8bb8aa61735832c77d067a781075472000000000000000000000000000000000000000000000000000000006afd13e7a09c028f0024fc449b8393e97925176f42b7bbbe07be0452c92b23668313d5f0'
  is: '0x0b0e962a7f7e14ef1aa74328f9ba5df3e70d9fb5aaa2698c3fdc07ddf1555983'
  says: 'with the cited order''s refund address 0x6083… first, the id is not the cited deposit''s (0xc560…): the
    refund address cannot sweep it'
  for:
  - justification
  - what
- id: sweepto
  bytecode: '0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c'
  has: 73ffffffffffffffffffffffffffffffffffffffff8b811660048301528681166024830152
  says: the unsigned sweep passes the token and the caller's chosen recipient to the deposit address's b8dc491b
    (pc 0x12be-0x12e2)
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-7c868906, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Sent back once (who can sweep was hidden behind ''nothing is locked''; the action was empty). The
    card now names the order''s payee as the only party that can sweep an expired deposit (the refund address has
    no path) and tells signer-key holders to open or sweep before migrating. A fresh refuter agrees; sheet read
    by Claude. INFORMATIONAL; candidate (unverified; who funds deposits and holds signer keys needs logs). The signed
    sweep has no deadline: if anyone keeps pre-signed sweeps as vouchers, that would be a rated case, not shown
    on chain.'
related: []
---

## What happens

This swap escrow opens or sweeps a deposit when the signer built into it signs with ECDSA. If that signer's account takes real code, both fail; after expiry only the order's payee can sweep the deposit, to any address, and its refund address cannot. An EIP-7702 delegation keeps working.

## Evidence

- [This deposit](https://etherscan.io/tx/0xaebee0d21bdc7e267f6908a9cfbea85330b53f787beae23f6d58a728788ec12f) opens on its signer's signature; real code there reverts it, a 7702 delegation does not.
- [Escrow code](https://etherscan.io/address/0x7c868906b4cf8e1eab29c9bcba24b80e57f9835c#code): a signed sweep moves a deposit at any time; the unsigned sweep is refused before expiry, allowed after.

## Reviewer notes

### Mechanism

Unverified bytecode, read by disassembly. A deposit id is keccak(abi.encode(firstParty, claimAddress, signer, uint64 expiry, salt)) (view 99304b12); depositAddress(id) is a CREATE2 clone of forwarder 0xc769…416e that obeys only the escrow (fc447f62). Funds leave a deposit address three ways via the clone's b8dc491b(token, to): (1) open b827a5b4(order, signer, expiry, sig): any caller; id built from order fields 0x60 (payee) and 0x80 (claim key) (pc 0x1bec); requires ECDSA-recover(digest(id, orderKey)) == signer (7ca55c77); pulls the deposit into the order. An opened order pays field 0x60 on claim (pc 0x2459) and refunds field 0x40 on cancel/timeout (pc 0x07d4, 0x0abe). (2) signed sweep 8aa5cc34: recover(digest(id, to)) == signer, sends to `to`, no expiry gate. (3) unsigned sweep 72cabcbd(token, claim, signer, expiry, salt, to, ...): reverts 085de625 before expiry; id uses CALLER as first party (pc 0x1233); b8dc491b gets the caller's `to` (pc 0x12be). So once the signer takes real code, an unopened deposit leaves only by (3): by the order's payee, after expiry, to any address; with the refund address first the id differs, so it has no path. No upper bound on expiry was found. Recovery is a STATICCALL to 0x01 with all gas: no fixed-gas issue. Every tx seen in the window is sent by 0x693b…2bbc, the payee of the cited order; each signer is a fresh key with nonce 0.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271/code-size branch: none; b827a5b4 and 8aa5cc34 compare the ECDSA result with the signer (7ca55c77); the replay with code at the signer reverts.
- Ruled out: breaks by itself: the eip8151 replay of the same transaction succeeds; recovery passes all gas to the precompile, not a constant.
- Ruled out: replay bundling: a direct EOA call to the escrow; its other steps check no signature; one recovery per tx in the window.
- Ruled out: locked funds: the unsigned sweep moves an expired deposit, but only for the order's payee (CALLER first in the id); the refund address has no path (its id differs), so 'nothing is locked' was dropped.
- Ruled out: owner/admin rescue: not upgradeable, no admin (facts); no path other than the three in the mechanism moves a deposit's balance.
- Ruled out: rechecked-later: order claims recover order field 0x80 (5d868bc8, 11eacae9), never the deposit signer; one check per deposit.

### Questions

- Who funds deposit addresses and holds the signer keys (user wallets or the payee's service): every signer seen is a fresh key with nonce 0; needs a log scan, so whose is left empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
