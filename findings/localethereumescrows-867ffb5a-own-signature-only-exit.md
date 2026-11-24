---
id: localethereumescrows-867ffb5a-own-signature-only-exit
format: 2
title: Escrow parties lose arbitration if they move their accounts to real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a buyer or seller moves to real code before signing; the other party's signature still
  allows a ruling.
category: migration-notice
pattern: PQ-16
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  name: LocalEthereumEscrows
  project: localethereum
  label: LocalEthereum 1
  code: verified
  code_url: https://etherscan.io/address/0x867ffb5a3871b500f65bdfafe0136f9667deae06#code
  copies: 2
  family: 583c5a3723df423540d14111dee85852
  upgradeable: 'no'
  admin: '0x47d70d729c6efd464cc49ebb6f4ee240219ecb9e'
value:
  usd: 11923
  whose: mixed
  basis: held
activity: {}
impact: funds-locked
action: Tell buyers and sellers to sign any arbitration permission before moving their accounts to real code.
evidence_level: source
checks:
- id: resolve-arbitrator
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 160
  has: ) external onlyArbitrator {
  says: resolveDispute can be called only by the arbitrator
  for:
  - evidence-1
  - what
- id: resolve-hash
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  lines:
  - 161
  - 164
  has: INSTRUCTION_RESOLVE
  says: the permission signs only the trade id and the resolve instruction
  for:
  - action
- id: resolve-recover
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 161
  has: address _signature = recoverAddress(keccak256(abi.encodePacked(
  says: resolveDispute recovers the signer of the permission
  for:
  - action
  - evidence-1
  - justification
  - what
- id: resolve-party
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 165
  has: require(_signature == _buyer || _signature == _seller, "Must be buyer or seller");
  says: the recovered signer must be the trade's buyer or seller
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 717
  has: return ecrecover(_prefixedHash, _v, _r, _s);
  says: recoverAddress is a plain ecrecover, with no ERC-1271 fallback
  for:
  - justification
  - what
- id: direct-release
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  lines:
  - 199
  - 200
  has: require(msg.sender == _seller, "Must be seller");
  says: the seller can release the escrow to the buyer by a direct call
  for:
  - what
- id: direct-buyer-cancel
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  lines:
  - 235
  - 236
  has: return doBuyerCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
  says: the buyer can cancel by a direct call, returning the ether to the seller
  for:
  - what
- id: direct-seller-cancel
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  lines:
  - 253
  - 254
  has: return doSellerCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
  says: the seller can cancel by a direct call when the payment window allows it
  for:
  - what
- id: deposit
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 130
  has: require(msg.value == _value && msg.value > 0, "Incorrect ether sent");
  says: each escrow is funded with the trade's ether when it is created
  for:
  - whose
- id: fees-cap
  source: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  file: LocalEthereumEscrows.sol
  line: 325
  has: require(_amount <= feesAvailableForWithdraw, "Amount is higher than amount available");
  says: the owner can withdraw ether only up to the collected fees
  for:
  - evidence-2
- id: fees
  call: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  fn: feesAvailableForWithdraw()(uint256)
  is: 2922583526635070226
  says: 2.92 ETH of the balance are fees the owner can withdraw
  for:
  - evidence-2
  - whose
- id: owner
  call: '0x867ffb5a3871b500f65bdfafe0136f9667deae06'
  fn: owner()(address)
  is: '0x47d70d729c6efd464cc49ebb6f4ee240219ecb9e'
  says: the owner at the block
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-867ffb5a, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. LocalEthereumEscrows: resolveDispute needs the buyer''s
    or seller''s ECDSA signature; release and cancel are direct; the owner can take only capped fees. INFORMATIONAL.'
related: []
---

## What happens

This escrow lets its arbitrator settle a disputed trade only when the buyer or the seller signs a permission checked with ECDSA. A party whose account takes real code can no longer give it; release and cancel stay open by direct call, and an EIP-7702 delegation keeps working.

## Evidence

- [resolveDispute](https://etherscan.io/address/0x867ffb5a3871b500f65bdfafe0136f9667deae06#code) runs only for the arbitrator and requires the recovered signer to be the trade's buyer or seller.
- The [owner](https://etherscan.io/address/0x47d70d729c6efd464cc49ebb6f4ee240219ecb9e) can withdraw only collected fees, 2.92 ETH at this block, not escrowed ether.

## Reviewer notes

### Mechanism

resolveDispute (onlyArbitrator, lines 150-183) recovers a signature over (tradeID, INSTRUCTION_RESOLVE) with recoverAddress (eth_sign prefix, plain ecrecover, line 717) and requires it to equal the trade's buyer or seller (line 165); it then splits the escrow by _buyerPercent. There is no direct-call or ERC-1271 way for a party to grant this permission. The other exits are direct calls from the party's own address: release by the seller (line 199), disableSellerCancel and buyerCancel by the buyer (lines 217, 235), sellerCancel and sellerRequestCancel by the seller (lines 253, 271), plus signed versions of the same through batchRelay. Once the buyer has marked the trade paid (sellerCanCancelAfter = 0), the seller can no longer cancel (line 601), so the escrow moves only by the seller's release, the buyer's cancel, or the arbitrator with a party's signature. If the party that wants a ruling has real code and the other refuses both to act and to sign, the ether stays in escrow. The owner cannot move escrowed ether: withdrawFees is capped by feesAvailableForWithdraw (line 325), and transferToken only moves ERC-20 tokens. The permission hash binds only tradeID and the instruction, so a party can sign it in advance. At block 26,438,999 the arbitrator 0xa38f...3e18, relayer 0xf008...6420 and owner 0x47d7...9e9e are accounts without code; the contract holds 6.61 ETH of which 2.92 ETH are withdrawable fees.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: a direct-call or ERC-1271 path to permit arbitration: resolveDispute is the only function that reaches DisputeResolved, and it accepts only an ECDSA signature (lines 160-165).
- Ruled out: an owner rescue of escrowed ether: withdrawFees is capped by feesAvailableForWithdraw (line 325); transferToken, transferTokenFrom and approveToken act only on ERC-20 contracts (lines 360-392).
- Ruled out: a break with nobody migrating: arbitrator and owner act by msg.sender; the relayer signature that createEscrow requires (line 126) recovers an account without code at the block (nonce 319,337). That relayer key, replaceable by the owner through setRelayer (line 344), is a separate rotation notice; the relayed party instructions in batchRelay are signed shortcuts with direct-call twins.
- Ruled out: copies: 0xdc674cb497ba6202876aafa6064e7bfefad1b9b0 runs the same code with owner, relayer and arbitrator 0x797a30afb8d9a4e9703d36436aeb48b3d4b2dae6, no fees and 0.074 ETH; this address is the one with value and recent calls.
- Ruled out: a fixed gas budget for the recovery: the scanner found no constant gas on the ecrecover call (scan.codes ec_gas_const null).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
