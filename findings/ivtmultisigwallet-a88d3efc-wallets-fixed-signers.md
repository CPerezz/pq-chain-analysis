---
id: ivtmultisigwallet-a88d3efc-wallets-fixed-signers
title: "IvtMultiSigWallet: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa88d3efc0661aebb9c7b67dc88633f945ea96dfb"
  family: "bd290a2a19e0714d22df1447d1a104d8"
  copies: 68
  name: "IvtMultiSigWallet"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2104
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owner (deployer) and the two signers"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path; signed transfers die once a signer has code, but the owner + signers safe-mode path still moves the ETH by direct calls, so nothing of value is locked: MEDIUM. ERC-20s would stay locked (only dust today). Value $2104, txs_90d 0; value does not lower the rating."
---

## Summary

IvtMultiSigWallet: normal ETH/ERC-20 transfers need ecrecovered signatures from signers fixed in the constructor (relayed by the owner). The safe mode is a direct-call rescue: the owner activates it and `required` signers call confirmTransaction(msg.sender-checked), which sends all ETH to one signer.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: IvtMultiSigWallet: signers are set in the constructor. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source IvtMultiSigWallet.sol: signers[...] = true only in the constructor; verifySignatures uses ecrecover; confirmTransaction checks signers[msg.sender] (no ecrecover), and selfdestruct(safeAddress) moves the ETH
- Constructor args from creation tx 0xf3671aa7… (block 6708155; receipt contractAddress = this row): signers 0x7cd90e0b… EOA n3 and 0x27e078c8… EOA n0, required 2 (signer code read at latest, block ~26452937)
- slot 3 (latest; no setter for owner/required, and safeMode only goes false→true): owner 0x0b6ff3f8… EOA n5, safeMode false, required 2
- Holdings: 0.99 ETH (dossier state.json at 26438999); the ERC-20s are dust (etherscan snapshot 2026-11-19: MD+, 1e-7 WETH)

## Impact and exposure

- Value held at block 26,438,999: $2,104 (ETH and 49 priced tokens, over 68 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls activateSafeMode and both signers call confirmTransaction(sameSigner) to sweep the ETH, or the signed path is used before any signer gets code; new deployment for future use.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
