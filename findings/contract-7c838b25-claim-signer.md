---
id: contract-7c838b25-claim-signer
format: 2
title: QuestN reward claims trust an ECDSA signer key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: Recovered claim-signer key lets forged claims pay vault rewards; QuestN's admin EOA can fix it by
  upgrading the logic.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7c838b25092925d0155a8358475bfe6c19921d9e'
  project: questn
  code: decompiled
  code_url: code/0x37548b65a4d3928357a2d7cb3838c1757ada874cda297b1456bd33567bdbc566.sol
  proxy_of: '0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d'
  copies: 1
  upgradeable: 'yes'
  admin: '0x9ce99901b23fc9f65c5ff839405545b8168c6e4e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1152
impact: funds-loss
action: Upgrade claim verification to ERC-1271 from a post-quantum signer account, or a per-event Merkle allowlist.
evidence_level: bytecode
checks:
- id: sel-claim
  selector: '0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d'
  fn: claim(string,uint256,bytes)
  says: Implementation has a claim entry taking a signature bytes argument.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-signer
  selector: '0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d'
  fn: claimSigner()
  says: Implementation stores a claim signer address.
  for:
  - evidence-2
  - justification
  - what
- id: sel-setsigner
  selector: '0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d'
  fn: setClaimSigner(address)
  says: Owner can replace the claim signer address.
  for:
  - evidence-2
  - justification
- id: sel-vault
  selector: '0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d'
  fn: vaultAddress()
  says: Implementation points at a reward vault.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

QuestN's event-reward contract accepts a claim when it carries a signature from its configured claim signer. A quantum attacker who recovers that signer's key from signed claims can sign claims to mint reward NFTs and draw token rewards from the vault.

## Evidence

- [claim](https://etherscan.io/address/0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d#code) takes a signature argument alongside the event id.
- [claimSigner](https://etherscan.io/address/0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d#code) names the key claims are checked against; setClaimSigner lets the owner swap it.
- [vaultAddress](https://etherscan.io/address/0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d#code) points at the reward vault that pays token rewards.

## Reviewer notes

### Mechanism

Proxy 0x7c838b25 delegates to unverified implementation 0x43f985fc. Selectors include claim(string,uint256,bytes), claimSigner(), setClaimSigner(address), vaultAddress(). The precompile trace shows ecrecover calls from this contract, and a sample claim (tx 0x632b8e30…) minted a Quest3NFT and moved USDT from vault 0x0376a356… to the caller. The inferred path is claim -> ecrecover(signature) == claimSigner -> mint NFT and pay from vault. The signer 0x6288454b never sends transactions, but its signatures in claim calldata expose its public key. setClaimSigner only rotates to another ECDSA key. The ProxyAdmin is owned by EOA 0x2f6f4be9…, which can upgrade the logic.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Vault held no priced assets at review; exposure is whatever the vault holds later.
- Ruled out: The 63-contract proxy-code family was unrelated generic proxy code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
