---
id: 5975018a-wallets-fixed-signers
title: "0x5975018a: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5975018ae3e81c69264443c81aca461ca3fd2ad0"
  family: "bc35dde1fb23e91b91b61f98b32f1dc7"
  upgradeable: "no"
  rating: HIGH
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the wallet's signers"
evidence:
  level: bytecode
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
  rating: HIGH
  note: "Wallet's own ETH can only leave via 2-of-3 fixed-signer ecrecover; no setter/upgrade → HIGH. Token owner role would also be frozen, but the USDG proxy admin is a separate live EOA that can upgrade the token, so that part is not locked."
---

## Summary

Custom WalletSimple-style 2-of-3 wallet (not the 2017 template's selectors) that is also owner() of the GATE USD (USDG) FiatToken proxy 0x1c0b9c19...; all its functions require msg.sender to be a fixed signer plus an ecrecover'd different signer. Signers fixed, no other exit: its 0.4 ETH is locked once signer keys get real code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: signers, isSigner, getNextSequenceId, contractAdd (0xfdb2f39e, slot 0xb, never written at runtime), 0x97f6c448 (payable, ETH send via transfer), 0x98f44b9a (token send), 0x63f69f73 (calls contractAdd.transferOwnership/updateMasterMinter/updatePauser/updateBlacklister/changeAdmin with a new address). The only runtime SSTORE is the sequence-id window; verify routine at 0x1941: expireTime, tryInsertSequenceId, isSigner(recovered), recovered != CALLER.
- signers at block 26438999: 0x863b37865df215eabc5530e106f9e7acc9f53082 (EOA, nonce 0); 0x1d9c49d99874b70e16994c1c367a42024d94e7da (EOA, nonce 7); 0x006f9837bdd2f0fa9b2cebd8b5413ad3a7437e15 (EOA, nonce 0); cast code latest = 0x for all three.
- contractAdd = 0x1c0b9c1995ea61f8fb505e4d94aa32b0c024899e (GATE USD/USDG, totalSupply 2,000,000 USDG); its owner() = this wallet, proxy admin = 0x6e40c83f...2a72 (EOA, nonce 1), masterMinter/pauser/blacklister = 0x1c4b70a3...558c (EOA). Read via publicnode latest (reth RPC timed out for slot 0xb).
- Row: value_usd 722 (0.4 ETH), txs_90d 0, last_active null; scanner's setters changeAdmin/transferOwnership are outgoing calls to the token, and its constant 0x7461c6c7... is the swarm metadata hash.

## Impact and exposure

- Value held at block 26,438,999: $722 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH and tokens to a new wallet (e.g. a 7702-capable or code-checking multisig) with sendMultiSig/sendMultiSigToken before any signer key gets real code; afterwards the wallet only works while two of the three EOA signers keep code-free keys. The USDG owner role should be transferred (0x63f69f73 → transferOwnership) to a migrated owner too; the token's own proxy admin (EOA) can still upgrade the token regardless.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
