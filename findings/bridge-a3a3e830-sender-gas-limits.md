---
id: bridge-a3a3e830-sender-gas-limits
format: 2
title: Wrap transactions sent with tight gas limits will fail under EIP-8151
status: confirmed
severity: LOW
justification: A real mint reverts on its sender's tight gas limit under the new price; more gas fixes it.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  name: Bridge
  code: verified
  code_url: https://etherscan.io/address/0xa3a3e8304c88b017153ba5dfccdaccb7116a185f#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdc3988ce217c27db9d46377af25b537cc229e658'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 90
  last: 2026-11-18
impact: liveness
action: Tell wrap senders to re-estimate gas after EIP-8151 activates; a limit estimated before it can run out.
evidence_level: executed
checks:
- id: wrap-recover
  source: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  file: contracts/Bridge.sol
  line: 108
  has: if (digest.recover(signature) != signer) revert InvalidSignature();
  says: wrap requires the signature to recover to the stored signer
  for:
  - evidence-1
  - what
- id: mint
  source: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  file: contracts/Bridge.sol
  lines:
  - 110
  - 111
  has: processed[lbcTxid] = true; token.mint(to, amount);
  says: after the check, wrap marks the deposit processed and mints to the recipient
  for:
  - evidence-1
  - what
  - whose
- id: processed
  source: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  file: contracts/Bridge.sol
  lines:
  - 105
  - 110
  has: if (processed[lbcTxid]) revert AlreadyProcessed(lbcTxid);
  says: a deposit is marked processed only after the signature check passes, so a reverted mint can be resent
  for:
  - justification
- id: builtin
  source: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover builtin, which forwards all remaining gas
  for:
  - action
  - justification
  - what
- id: signer
  call: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  fn: signer()(address)
  is: '0xdc3988ce217c27db9d46377af25b537cc229e658'
  says: the stored signer at the block
  for:
  - evidence-1
  - what
- id: signer-code
  code: '0xdc3988ce217c27db9d46377af25b537cc229e658'
  is: empty
  says: the signer has no code, so EIP-8151 still recovers it
  for:
  - evidence-1
  - justification
  - what
- id: live
  call: '0xb0f2c4f8b7c0f088f7844947ecbf1220bfca08c1'
  fn: bridge()(address)
  is: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  says: the token's minter is this bridge at the block
  for:
  - what
- id: tx
  tx: '0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3'
  to: '0xa3a3e8304c88b017153ba5dfccdaccb7116a185f'
  ok: true
  says: a real wrap sent directly to the bridge succeeded
  for:
  - evidence-2
  - whose
- id: replay-today
  replay: '0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3'
  run: today
  ok: true
  says: the replay reproduces the real success
  for:
  - evidence-2
  - what
- id: replay-8151
  replay: '0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3'
  run: eip8151
  ok: false
  says: under EIP-8151 with the sender's gas limit the same transaction reverts
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-a3a3e830, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: Second refuter (D-028) agrees: a real wrap (871 gas of headroom) reverts under EIP-8151 at its sender''s
    limit and is resendable with more gas (processed is set only after the check; Claude''s replay with +300,000
    succeeds). Both refuters agree; Claude read the sheet. LOW, kept as before.'
related: []
---

## What happens

This bridge mints wrapped LBRY tokens to a user when the bridge's signer has signed the deposit. Under EIP-8151 that signature check costs more gas, and a real mint whose sender set a tight gas limit runs out of gas and reverts.

## Evidence

- [wrap](https://etherscan.io/address/0xa3a3e8304c88b017153ba5dfccdaccb7116a185f#code) mints after checking that the signature recovers to the stored signer, an account with no code.
- A [real mint](https://etherscan.io/tx/0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3) succeeds today and reverts when replayed under EIP-8151 with the gas its sender gave.

## Reviewer notes

### Mechanism

wrap (Bridge.sol 97-114) checks processed[lbcTxid], builds the digest and requires digest.recover(signature) == signer (line 108), then sets processed and calls token.mint(to, amount). OpenZeppelin ECDSA.recover reaches the Solidity ecrecover builtin (ECDSA.sol line 148), which forwards all remaining gas: there is no gas amount fixed in code. The signer at the block is 0xdc39...e658 (also owner), an account with empty code, so EIP-8151 still returns it; the only change for this call is the price (up to 3,100 more for a cold recovery). Tx 0xf1d9...26d3 (block 26,396,646) has gas limit 73,537 and used 72,666 (margin 871, read with cast tx/receipt); under EIP-8151 the replay reverts at 73,350 used, consistent with the precompile call failing for lack of gas and the builtin reverting. The tx is a direct call to wrap from 0xea36...baf7, who is also the mint recipient; no other signed step is in it. Since processed is set only after the check, a reverted mint leaves the deposit redeemable with a resend.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas budget fixed in code: recovery goes through the ecrecover builtin, which forwards all remaining gas (ECDSA.sol line 148); the scanner also found no constant gas (ec_gas_const null).
- Ruled out: the signer having code: signer() is 0xdc39...e658 and its code is empty at the block, so the replay failure is not a recovery returning nothing.
- Ruled out: a bundled transaction: 0xf1d9...26d3 calls wrap on this bridge directly (selector 0x7c48a5f4); the sender holds an EIP-7702 delegation but is not the recovered signer and no other step checks a signature.
- Ruled out: a retired bridge: the token's bridge() is this address at the block, so it is the live minter; the dossier shows 51 recoveries up to block 26,438,771.
- Ruled out: not settled by execution: the dossier has no eip8151_more_gas run for this tx; 'more gas fixes it' is deduced from the builtin forwarding all gas and the signer being an EOA.
- Ruled out: second replay 0xc1df...70e4 not cited: its EIP-8151 runs did not execute (engine reports insufficient sender balance).
- Ruled out: a separate notice on the same contract: the single signer key 0xdc39...e658 is an EOA; if it moves to real code, wraps stop until the owner calls setSigner (lines 69-73). That is a rotate-signer-before-migrating notice for the reviewer to link, not folded here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
