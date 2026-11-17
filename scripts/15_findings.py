"""Draft findings/<id>.md and evidence/<id>/ from the hand classification, on-chain state, activity and excerpts.

Finding files are authoritative once written: an address already listed in any `findings/*.md` header is never drafted
again, and existing files and evidence folders are never overwritten. Severity follows findings/README.md "Applying
the rubric"; the steps that decided it are written into History.

Inputs: data/report/curated_contracts.csv, data/curation/{out_*.jsonl,findings_map.csv}, data/state/state.json,
data/activity/activity.json, data/excerpts/<address>.md, data/caller_family.parquet, data/families_classified.parquet,
data/agg/alltime_caller.parquet, docs/lookup/meta.json (block -> date), data/blockscout/address/*.json (market caps).
"""

import datetime as dt
import glob
import json
import os
import shutil
from collections import defaultdict

import duckdb
import pandas as pd

TODAY = dt.date(2026, 11, 17)
CURATED_ON = "2026-11-04"
MECH = {
    "user-sig-ecdsa-only": ("PQ-1", "user-key"), "user-sig-ecdsa-first": ("PQ-2", "user-key"),
    "user-sig-code-first": ("PQ-13", "none"), "operator-key": ("PQ-4", "operator-key"),
    "committee-sigs": ("PQ-5", "committee-keys"), "bls-aggregate": ("PQ-6", "committee-keys"),
    "snark-verifier": ("PQ-7", "trusted-setup"), "kzg-blob": ("PQ-8", "trusted-setup"),
    "passkey-p256": ("PQ-9", "user-key"), "rsa-identity": ("PQ-10", "issuer-key"),
    "secp256k1-algebra": ("PQ-11", "operator-key"), "account-owner-keys": ("PQ-12", "owner-keys"),
}
UPG = {"immutable": "no", "immutable_logic_configurable_params": "config-only", "upgradeable_proxy_admin": "yes",
       "owner_controlled_account_upgrade": "yes"}
ALT = {"sole": "sole", "key_rotation_only": "key-rotation-only", "alternative_exists": "alternative-exists",
       "configurable_verifier": "configurable-verifier"}
ALT_RANK = ["sole", "key-rotation-only", "configurable-verifier", "alternative-exists"]
PRIM = {"ecrecover": "ecrecover", "bn254": "bn254", "kzg": "kzg", "bls12381": "bls12381", "p256": "p256", "sw_p256": "sw_p256",
        "sw_secp256k1": "sw_secp256k1", "sw_bn254": "sw_bn254", "sw_ed25519": "sw_ed25519", "sw_bls12381": "sw_bls12381", "rsa": "rsa"}
SEV = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "NONE"]
FUNC = {
    "operator_signed_quote_rfq": "market-maker quotes and cosigned orders", "user_auth_intent_order": "signed orders and intents",
    "user_auth_permit": "permits and signed approvals", "bridge_committee_attestation": "cross-chain attestations",
    "oracle_report_signatures": "oracle and keeper reports", "other": "signed execution",
    "paymaster_or_sponsor_signer": "gas sponsorship", "operator_signed_claim_mint_or_voucher": "signed claims, mints and vouchers",
    "snark_proof_verification": "SNARK proofs", "sequencer_or_relayer_signature": "sequencer and relayer signatures",
    "blob_kzg_opening": "blob commitments", "account_owner_auth": "account owner signatures",
    "bls_aggregate_signature": "BLS aggregate signatures", "user_auth_metatx_forwarder": "meta-transactions",
    "passkey_webauthn": "passkey signatures", "randomness_vrf": "randomness", "rsa_dkim_jwt_identity": "RSA identity signatures",
}
MECH_TEXT = {
    "user-sig-ecdsa-only": "accepts users' offline signatures only through `ecrecover` (PQ-1). A post-quantum account cannot use the path, and a quantum attacker who recovers a holder's ECDSA key from its public key can sign for that holder, including holders who have since moved their account to post-quantum authorisation.",
    "user-sig-ecdsa-first": "accepts contract signatures (ERC-1271), so post-quantum accounts can use it, but it still accepts ECDSA for the same address, tried first or chosen by the signer (PQ-2). An address that migrates to post-quantum authorisation stays forgeable here with its old key.",
    "user-sig-code-first": "checks for account code first and sends contract accounts to ERC-1271 with the full signature (PQ-13). Code-less addresses are verified with `ecrecover`, which adds no exposure beyond the address's own key; an account that migrates with real code is not forgeable here.",
    "operator-key": "trusts one operator ECDSA key to authorise value (PQ-4). The key has signed on-chain, so its public key is known; a quantum attacker who recovers it can sign as the operator. Rotating the key does not help: the contract must verify a different scheme.",
    "committee-sigs": "trusts a set of ECDSA signers, with a threshold, to attest facts that release or mint value (PQ-5). A quantum attacker who recovers a quorum of signer keys can attest anything.",
    "bls-aggregate": "verifies BLS signatures from a committee with a pairing check (PQ-6). BLS secret keys follow from public keys, so a quantum attacker can forge any quorum.",
    "snark-verifier": "accepts SNARK proofs verified with pairings on BN254 (PQ-7). A quantum attacker can recover the trusted-setup trapdoor from its public parameters and make proofs of false statements verify.",
    "kzg-blob": "opens EIP-4844 blob commitments with the point-evaluation precompile (PQ-8). KZG rests on the same kind of trapdoor, so openings can be forged; only an Ethereum protocol change (post-quantum data availability) replaces it.",
    "passkey-p256": "verifies P-256 (passkey / WebAuthn) signatures (PQ-9). A quantum attacker can recover a P-256 private key from its public key.",
    "rsa-identity": "verifies RSA signatures from an off-chain issuer (PQ-10). The issuer has to move to post-quantum keys before the contract can.",
    "secp256k1-algebra": "uses secp256k1 arithmetic (through `ecrecover` or `modexp`) for VRF randomness or Schnorr signatures (PQ-11). A quantum attacker who recovers the key can choose the randomness or sign as the group.",
    "account-owner-keys": "is controlled by owners who are ECDSA keys (PQ-12). A quantum attacker who recovers enough owner keys controls the wallet.",
}


def load_inputs():
    cur = pd.read_csv("data/report/curated_contracts.csv")
    cur["address"] = cur.address.str.lower()
    fmap = pd.read_csv("data/curation/findings_map.csv")
    fmap["address"] = fmap.address.str.lower()
    raw = {}
    for f in sorted(glob.glob("data/curation/out_*.jsonl")):
        for line in open(f):
            if line.strip():
                d = json.loads(line)
                raw[d["address"].lower()] = {**d, "_file": os.path.basename(f)}
    df = cur.merge(fmap, on="address", how="inner", validate="one_to_one")
    state = json.load(open("data/state/state.json"))
    act = json.load(open("data/activity/activity.json"))
    meta = json.load(open("docs/lookup/meta.json"))
    return df, raw, state, act, meta


def block_date(meta, b):
    A = meta["anchors"]
    lo = max(i for i, (bb, _) in enumerate(A) if bb <= b) if b >= A[0][0] else 0
    b0, t0 = A[lo]
    t = t0 + (b - b0) * 12 if lo == len(A) - 1 else t0 + (A[lo + 1][1] - t0) * (b - b0) / (A[lo + 1][0] - b0)
    return dt.datetime.fromtimestamp(t, dt.UTC).date()


def market_caps():
    caps = {}
    for f in glob.glob("data/blockscout/address/*.json"):
        d = json.load(open(f))
        t = (d or {}).get("token") or {}
        if t.get("circulating_market_cap"):
            caps[os.path.basename(f)[:-5]] = (float(t["circulating_market_cap"]), t.get("symbol"))
    return caps


def families_for(addresses):
    """Code family of each address (only families with >= 2 pre-quantum callers): code address and member count."""
    c = duckdb.connect()
    c.register("t", pd.DataFrame({"address": list(addresses)}))
    rows = c.sql("""
      SELECT t.address, cf.family, fc.members, coalesce(fc.logic2, fc.logic) impl, fc.label
      FROM t JOIN 'data/caller_family.parquet' cf USING (address)
      JOIN 'data/families_classified.parquet' fc USING (family) WHERE fc.members >= 2""").df()
    return {r.address: r for r in rows.itertuples(index=False)}


def last_used(addresses):
    c = duckdb.connect()
    c.register("t", pd.DataFrame({"caller": list(addresses)}))
    return dict(c.sql("SELECT caller, max(last_block) FROM 'data/agg/alltime_caller.parquet' SEMI JOIN t USING (caller) GROUP BY 1").fetchall())


def money(v):
    if v is None:
        return "not measured"
    return f"${v / 1e9:.2f}B" if v >= 1e9 else f"${v / 1e6:.1f}M" if v >= 1e6 else f"${v / 1e3:.0f}k" if v >= 1e3 else f"${v:,.0f}"


def rate(f):
    """Apply findings/README.md 'Applying the rubric'. Returns (severity, status_hint, impact, protocol_change, steps)."""
    mech, steps = f["mechanism"], []
    upg = [c["upgradeable"] for c in f["contracts"]]
    alt, role = f["alternative"], f["role"]
    exposure, basis = f["exposure"], f["exposure_basis"]
    recent = [c["last_active"] for c in f["contracts"] if c["last_active"]]
    newest = max(recent) if recent else None
    held = sum(c["value_usd"] or 0 for c in f["contracts"] if c.get("value_basis") == "held")

    if mech == "user-sig-code-first":
        return "NONE", "not-affected", "none", "not-needed", ["code checked first: no exposure beyond the account's own key"]
    impact = {"kzg-blob": "funds-loss", "rsa-identity": "unknown"}.get(mech, "funds-loss")
    if mech == "user-sig-ecdsa-first" and alt == "alternative-exists":
        impact = "funds-loss"

    if (newest is None or (TODAY - newest).days > 365) and held < 1:
        return "LOW", None, impact, "not-needed", [f"step 1 reach: no activity in 12 months (last {newest or 'unknown'}) and nothing held"]

    immutable = all(u == "no" for u in upg)
    can_change = any(u in ("yes", "config-only") for u in upg)
    unknown = any(u == "unknown" for u in upg)
    pc = "not-needed"
    if mech == "kzg-blob":
        sev, why, pc = "HIGH", "step 4: depends on the KZG precompile; only a protocol change replaces it", "required"
    elif mech in ("user-sig-ecdsa-only", "user-sig-ecdsa-first", "passkey-p256"):
        if mech == "passkey-p256" and role == "core" and f["is_library"]:
            sev, why = "LOW", "step 4: stateless verifier library; the exposure is rated on the wallets that use it"
        elif immutable or unknown:
            sev, why, pc = "HIGH", "step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them", "helps"
        else:
            sev, why, pc = "MEDIUM", "step 4: fix by upgrading the contract (admin or governance)", "helps"
    elif mech == "account-owner-keys":
        if can_change:
            sev, why = "MEDIUM", "step 4: owners can move to post-quantum signers in place (contract owners, modules or upgrade)"
        else:
            sev, why = "HIGH", "step 4: signer set fixed in code; funds must move, and many independent owners may not act"
    else:  # pooled: operator, committee, bls, snark, algebra, rsa
        if alt == "alternative-exists" and role == "core" and mech in ("operator-key", "committee-sigs"):
            sev, why = "LOW", "step 4: an alternative path exists that one known party can switch to"
        elif can_change or alt == "configurable-verifier":
            sev, why = "MEDIUM", "step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment"
        elif immutable and alt == "sole" and mech in ("snark-verifier", "committee-sigs", "bls-aggregate"):
            sev, why = "CRITICAL", "step 4: pooled funds released by a forged proof or attestation, and the verification cannot change"
        elif unknown:
            sev, why = "HIGH", "step 6: who can change the verification is not established; rated as if nobody can"
        else:
            sev, why = "MEDIUM", "step 4: fix by a new deployment that the operator and users move to"
    steps.append(why)
    if role == "auxiliary" and impact != "funds-loss" and sev in ("CRITICAL", "HIGH", "MEDIUM"):
        sev, _ = "LOW", steps.append("step 4: auxiliary feature through which nothing can be taken")
    if exposure is not None and exposure < 50_000 and sev in ("CRITICAL", "HIGH", "MEDIUM"):
        new = SEV[SEV.index(sev) + 1]
        steps.append(f"step 5: exposure {money(exposure)} ({basis}) under USD 50k: {sev} -> {new}")
        sev = new
    return sev, None, impact, pc, steps


def build():
    df, raw, state, act, meta = load_inputs()
    st, am = state["contracts"], act["contracts"]
    caps = market_caps()
    fams = families_for(df.address)
    lu = last_used(df.address)
    blk = state["meta"]["block"]
    as_of = dt.datetime.fromtimestamp(state["meta"]["time"], dt.UTC).date()
    window = act["meta"]["recent_dates"]

    claimed = claimed_addresses()
    df = df[~df.address.isin(claimed)]
    created = 0
    for fid, g in df.groupby("finding_id"):
        if os.path.exists(f"findings/{fid}.md"):
            print(f"skip {fid}: file exists but does not list {', '.join(g.address)}; add them by hand")
            continue
        g = g.sort_values("txs_y1", ascending=False, na_position="last")
        first = g.iloc[0]
        mech = first.mechanism
        pattern, trigger = MECH[mech]
        contracts = []
        for r in g.itertuples(index=False):
            s, a = st.get(r.address, {}), am.get(r.address, {})
            impl = s.get("implementation")
            ai = am.get(impl, {}) if impl else {}
            last = max(filter(None, [a.get("last_active"), ai.get("last_active") if s.get("kind") == "eip1967" else None]), default=None)
            if not last and r.address in lu:
                last = block_date(meta, int(lu[r.address])).isoformat()
            last = dt.date.fromisoformat(last) if last else None
            admin_bits = []
            if isinstance(r.admin, str) and r.admin.strip():
                admin_bits.append(r.admin.strip())
            cs = s.get("controller_safe")
            if cs:
                admin_bits.append(f"controller Safe {cs['address']} ({cs['threshold']} of {len(cs['owners'])}, read at block {blk})")
            # a contract's own holdings are its value at risk only when it holds something; verifiers and routers
            # secure funds held elsewhere (escrows, users' approvals), which stay unmeasured (null) until measured
            value, basis = (s.get("held_usd"), "held") if (s.get("held_usd") or 0) > 0 else (None, None)
            if mech in ("user-sig-ecdsa-only", "user-sig-ecdsa-first", "user-sig-code-first") and r.address in caps:
                value, basis = round(caps[r.address][0]), "market-cap"
            contracts.append({
                "address": r.address, "implementation": impl, "name": str(r.contract_name),
                "upgradeable": UPG.get(r.upgradeability, "unknown"), "admin": "; ".join(admin_bits) or None,
                "value_usd": value, "value_basis": basis if value is not None else None,
                "value_as_of": as_of if value is not None else None, "last_active": last,
                "txs_30d": a.get("txs_30d"),
                "_kind": s.get("kind"), "_row": r, "_eth": s.get("eth"), "_top": s.get("top_tokens") or [],
            })
        families, seen = [], set()
        for c in contracts:
            fr = fams.get(c["address"])
            if fr is not None and fr.family not in seen and int(fr.members) >= 2:
                seen.add(fr.family)
                code = fr.impl if isinstance(fr.impl, str) else None
                if code:
                    families.append({"code": code, "name": (fr.label or c["name"]), "instances": int(fr.members),
                                     "list": "docs/lookup (any address can be checked on the site)", "upgradeable": c["upgradeable"],
                                     "value_usd": None, "value_basis": None, "value_as_of": None})
        alts = [ALT.get(x, "sole") for x in g.reliance]
        alt = min(alts, key=ALT_RANK.index)
        role = "core" if (g.crypto_role == "core").any() else "auxiliary"
        held = [c["value_usd"] for c in contracts if c["value_basis"] == "held" and c["value_usd"] is not None]
        capsv = [c["value_usd"] for c in contracts if c["value_basis"] == "market-cap"]
        exposure, ebasis = (sum(held), "held") if any(held) else ((max(capsv), "market-cap") if capsv else (None, None))
        if ebasis == "held" and exposure < 50_000 and mech != "account-owner-keys":
            # a small own balance does not bound the exposure of a verifier, router or messaging core: the funds it
            # secures (escrow, users' approvals) are elsewhere and not yet measured, so the value step must not lower
            exposure, ebasis = None, None
        is_library = mech == "passkey-p256" and all("verifier" in str(r.contract_name).lower() for r in g.itertuples())
        f = {"mechanism": mech, "contracts": contracts, "alternative": alt, "role": role, "exposure": exposure,
             "exposure_basis": ebasis, "is_library": is_library}
        sev, status_hint, impact, pc, steps = rate(f)
        conf = set(g.confidence)
        status = status_hint or ("confirmed" if conf <= {"high", "medium"} else "candidate")
        primitives = sorted({PRIM[k.split(":")[0]] for cats in g.cats.dropna() for k in cats.split() if k.split(":")[0] in PRIM})
        ev_level = "bytecode" if "low" in conf else "source-read"
        name = first.project_name
        funcs = sorted({FUNC.get(x, x) for x in g.function})

        ev_dir = f"evidence/{fid}"
        if not os.path.exists(ev_dir):
            os.makedirs(ev_dir, exist_ok=True)
            with open(f"{ev_dir}/classification.jsonl", "w") as fh:
                for r in g.itertuples(index=False):
                    fh.write(json.dumps({k: v for k, v in raw.get(r.address, {}).items()}) + "\n")
            json.dump({"block": blk, "as_of": as_of.isoformat(), "eth_usd": state["meta"]["eth_usd"],
                       "contracts": {c["address"]: st.get(c["address"]) for c in contracts}}, open(f"{ev_dir}/onchain.json", "w"), indent=1)
            json.dump({"window": act["meta"], "contracts": {k: am.get(k) for c in contracts for k in filter(None, [c["address"], c["implementation"]])}},
                      open(f"{ev_dir}/activity.json", "w"), indent=1)
            parts = [open(f"data/excerpts/{c['address']}.md").read() for c in contracts if os.path.exists(f"data/excerpts/{c['address']}.md")]
            open(f"{ev_dir}/source-excerpts.md", "w").write(f"# Source excerpts: {fid}\n\nLines around the pre-quantum checks in verified source "
                                                            f"(Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.\n\n" + "\n\n".join(parts))
        links = [f"{ev_dir}/{n}" for n in ("classification.jsonl", "onchain.json", "activity.json", "source-excerpts.md")]

        path = f"findings/{fid}.md"
        created += 1
        title = title_for(mech, name, funcs, g, impact)
        who = who_acts(mech, contracts, g)
        layer = layer_for(mech, contracts, alt)
        header = {
            "id": fid, "title": title, "project": first.project, "status": status, "severity": sev,
            "patterns": [pattern], "primitives": primitives, "trigger": trigger, "impact": impact, "alternative": alt,
            "role": role, "contracts": [{k: v for k, v in c.items() if not k.startswith("_")} for c in contracts],
            "families": families, "fix": {"layer": layer, "who_acts": who, "protocol_change": pc},
            "evidence": {"level": ev_level, "links": links},
            "sources": [{"by": "ai-assisted", "who": "hand classification (Claude Opus agents reading verified source and bytecode)",
                         "ref": "data/curation/" + ",".join(sorted({raw[a]['_file'] for a in g.address if a in raw})),
                         "date": dt.date.fromisoformat(CURATED_ON), "verdict": "reported", "rating": ""}],
            "related": [],
        }
        body = body_for(fid, name, mech, funcs, contracts, families, g, sev, steps, exposure, ebasis, blk, as_of, window, primitives, impact, alt, who, pc)
        with open(path, "w") as fh:
            fh.write("---\n" + dump_yaml(header) + "---\n\n" + body)
    print("created", created, "findings")


def title_for(mech, name, funcs, g, impact):
    what = " and ".join(funcs[:2])
    n = len(g)
    return {
        "user-sig-ecdsa-only": f"{name}: {what} accept ECDSA only; post-quantum accounts are locked out and an exposed key can be forged for any holder, including after they migrate",
        "user-sig-ecdsa-first": f"{name}: {what} still accept ECDSA for accounts that migrate to post-quantum keys, so their old key keeps working",
        "user-sig-code-first": f"{name}: {what} check account code first; not affected beyond the account's own key",
        "operator-key": f"{name}: one operator ECDSA key authorises {what}; a quantum attacker who recovers it can sign as the operator",
        "committee-sigs": f"{name}: {what} rest on ECDSA signer keys; forging a quorum releases what they attest",
        "bls-aggregate": f"{name}: {what} rest on BLS keys that a quantum attacker can recover",
        "snark-verifier": f"{name}: {n} BN254 SNARK verifier{'s' if n > 1 else ''}; a recovered setup trapdoor makes false proofs verify",
        "kzg-blob": f"{name}: blob commitments opened with KZG; only a protocol change replaces it",
        "passkey-p256": f"{name}: P-256 passkey signatures that a quantum attacker can forge",
        "rsa-identity": f"{name}: RSA issuer signatures verified on-chain",
        "secp256k1-algebra": f"{name}: secp256k1 VRF / Schnorr keys a quantum attacker can recover",
        "account-owner-keys": f"{name}: wallet owners are ECDSA keys; a quantum attacker who recovers them controls the wallet",
    }[mech]


def who_acts(mech, contracts, g):
    admins = [c["admin"] for c in contracts if c["admin"]]
    if mech == "kzg-blob":
        return "Ethereum protocol (post-quantum data availability), then the rollup's admin to adopt it" + (f"; admin: {admins[0]}" if admins else "")
    if mech == "account-owner-keys":
        return "each wallet's owners"
    if mech in ("user-sig-ecdsa-only", "user-sig-ecdsa-first") and all(c["upgradeable"] == "no" for c in contracts):
        return "nobody can change the contract; holders protect themselves by moving funds to a post-quantum account (or a protocol change such as EIP-8151)"
    return admins[0] if admins else "unknown"


def layer_for(mech, contracts, alt):
    upg = {c["upgradeable"] for c in contracts}
    if mech == "kzg-blob":
        return "protocol"
    if mech == "account-owner-keys":
        return "account-migration"
    if mech == "user-sig-code-first":
        return "none"
    if "yes" in upg:
        return "contract-upgrade"
    if alt == "configurable-verifier" or "config-only" in upg:
        return "onchain-config" if alt == "configurable-verifier" else "new-deployment"
    if upg == {"no"}:
        return "account-migration" if mech in ("user-sig-ecdsa-only", "user-sig-ecdsa-first") else "new-deployment"
    return "unknown"


def body_for(fid, name, mech, funcs, contracts, families, g, sev, steps, exposure, ebasis, blk, as_of, window, primitives, impact, alt, who, pc):
    n = len(contracts)
    subj = f"{name}'s {'contract' if n == 1 else f'{n} contracts'}"
    lines = ["## Summary", "",
             f"{subj} {MECH_TEXT[mech]}",
             "",
             f"Exposure: {money(exposure)}{' (' + ebasis.replace('-', ' ') + ', as of ' + as_of.isoformat() + ')' if exposure is not None else ''}. "
             f"Rated {sev}: {steps[0]}." if steps else f"Rated {sev}.",
             "", "## Mechanism", ""]
    for c in contracts:
        r = c["_row"]
        lines.append(f"- `{c['address']}` {c['name']}: {r.evidence} ({FUNC.get(r.function, r.function)}; signer: {str(r.signer).replace('_', ' ')}; "
                     f"check order: {str(r.ecdsa_order).replace('_', ' ')}; {r.confidence} confidence)")
    lines += ["", f"Pattern: see `patterns.md`. Source excerpts: [`source-excerpts.md`](../evidence/{fid}/source-excerpts.md).", ""]
    lines += ["## Evidence", "",
              f"- CHECKED (precompile trace, all mainnet transactions to March 2026): primitives used: {', '.join(primitives) or 'none recorded'}.",
              f"- CHECKED (on-chain read at block {blk:,}, {as_of}): code, proxy implementation, admin and owner, Safe threshold, ETH and token holdings "
              f"([`onchain.json`](../evidence/{fid}/onchain.json)).",
              f"- CHECKED (Xatu transactions and call frames, any function): transactions in {window[0]} to {window[1]}, and the last "
              f"transaction since 2026-03-18 (before that, the last pre-quantum call in the trace) "
              f"([`activity.json`](../evidence/{fid}/activity.json)).",
              f"- {'INFERRED from bytecode (unverified source) for low-confidence rows' if 'low' in set(g.confidence) else 'CHECKED (verified source read by the classifier)'}: "
              f"the mechanism above ([`classification.jsonl`](../evidence/{fid}/classification.jsonl)).", ""]
    lines += ["## Impact and exposure", "",
              "| Contract | Upgradeable | Held now | Last active | 30-day txs |", "|---|---|---|---|---|"]
    for c in contracts:
        held = money(c["value_usd"]) + (" (market cap)" if c["value_basis"] == "market-cap" else "") if c["value_usd"] is not None else "—"
        lines.append(f"| `{c['address'][:10]}…` {c['name'][:48]} | {c['upgradeable']} | {held} | {c['last_active'] or '—'} | "
                     f"{'' if c['txs_30d'] is None else format(c['txs_30d'], ',')} |")
    lines.append("")
    if families:
        for fam in families:
            lines.append(f"- Same code elsewhere: {fam['instances']:,} contracts run `{fam['code']}` ({fam['name']}); any of them can be checked on the site.")
        lines.append("")
    if impact == "funds-loss" and mech in ("snark-verifier", "kzg-blob", "committee-sigs", "bls-aggregate") and exposure is None:
        lines += ["The verifier contracts hold little or nothing themselves; the funds they secure sit in the consumer's escrow or bridge, "
                  "which is not yet measured here (exposure: not measured, so the value step lowers nothing).", ""]
    lines += ["## Remediation", ""]
    repl = sorted({str(x) for x in g.pq_replacement.dropna()})
    for x in repl[:4]:
        lines.append(f"- {x}")
    lines += ["", f"Who acts: {who}. Protocol change: {pc}.", ""]
    lines += ["## History", "",
              f"- {CURATED_ON}: classified from verified source or bytecode (hand classification pass; `data/curation/`).",
              f"- {TODAY}: finding created by `scripts/15_findings.py` from that classification, on-chain state at block {blk:,} and "
              f"activity {window[0]} to {window[1]}. Rated {sev} ({'; '.join(steps)}).", ""]
    return "\n".join(lines)


def dump_yaml(h):
    """Block-style YAML, one field per line, no line wrapping; short scalar lists inline; quoted addresses."""
    import yaml
    return yaml.dump(h, Dumper=yaml_dumper(), sort_keys=False, allow_unicode=True, width=10**6, default_flow_style=False)


def yaml_dumper():
    import yaml

    class Dumper(yaml.SafeDumper):
        def ignore_aliases(self, data):
            return True

    def str_rep(d, s):
        style = '"' if s.startswith("0x") or s in ("yes", "no", "null") or ":" in s or s.startswith(("*", "&", "!", "%", "@", "`")) else None
        return d.represent_scalar("tag:yaml.org,2002:str", s, style=style)

    Dumper.add_representer(str, str_rep)
    Dumper.add_representer(type(None), lambda d, _: d.represent_scalar("tag:yaml.org,2002:null", "null"))
    Dumper.add_representer(list, lambda d, xs: d.represent_sequence(
        "tag:yaml.org,2002:seq", xs, flow_style=all(isinstance(x, str) and len(x) < 24 for x in xs)))
    return Dumper


def claimed_addresses():
    """Every address listed in an existing finding's contracts[]."""
    import yaml
    out = set()
    for p in glob.glob("findings/*.md"):
        if p.endswith("README.md"):
            continue
        head = open(p).read().split("---\n")[1]
        out |= {c["address"].lower() for c in (yaml.safe_load(head).get("contracts") or [])}
    return out


if __name__ == "__main__":
    build()
