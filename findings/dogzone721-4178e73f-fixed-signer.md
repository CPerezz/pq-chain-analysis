---
id: dogzone721-4178e73f-fixed-signer
title: "DogZone721: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4178e73f2f942b814ca454a77706429f53dfae10"
  family: "d4de1d4c15c279b893ebf91a46f663fa"
  name: "DogZone721"
  upgradeable: "no"
  rating: LOW
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "contract owner 0xfb38b903bca8426f65a600aa239fdcccf9a3c911"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the same act (a free token to the recipient) stays open through the owner setting price 0 / teamMint; nothing locked. Study said HIGH."
---

## Summary

DogZone721 NFT: freeMint(hash,sig) accepts giveaway signatures only from an immutable signer 0x304cE1e5…76Cb; after EIP-8151 only if that key gets real code, which would end the 25-spot giveaway.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verified source DogZone721.sol: freeMint requires recoverSigner(hash,sig)==signer; signer is `address private immutable` 0x304ce1e59421acbc6ada104ba1b5f07f2f4676cb, no setter
- signer 0x304c…76cb: cast code = 0x (EOA) at block 26438999
- other paths to the same token: public mint(uint256) priced by onlyOwner adjustMintPrice (can be set to 0), onlyOwner teamMint(receiver)
- ETH leaves via onlyOwner disbursePayments; balance at block 26438999: 0.00099997 ETH; txs_90d=0, last_active=None, value $2

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner sets mint price to 0 or uses teamMint to give the giveaway tokens; keep the signer key an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
