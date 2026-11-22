"""The review of the EIP-8151 study's open rows: one agent writes each card, another tries to break it, a reader
settles it, and the filer writes it into findings/. How to run it: review/README.md.

Run every module from the registry's root:

    uv run --with pyyaml --with eth-abi --with pycryptodome python -m review.<module> ...
"""

import os
import sys
from pathlib import Path

REGISTRY = Path(__file__).resolve().parents[1]
HERE = REGISTRY / "review"
DATA = HERE / "data"  # committed: the open rows and their dossiers as of the hand-over
WORK = HERE / "work"  # not committed: the database, the dossiers in use, the agents' folders, the caches
H = 26438999  # the pinned block of the EIP-8151 study
AS_OF = "2026-11-18"
GATEWAY = os.environ.get("REVIEW_GATEWAY", "http://127.0.0.1:8546")
ISSUES = {  # root issue -> pattern; the longest name first where one ends with another
    "custody-wallets-fixed-signers": "PQ-17", "wallets-fixed-signers": "PQ-17", "fixed-signer": "PQ-17", "signer-upgrade-only": "PQ-17",
    "rotate-signer-before-migrating": "PQ-17", "fixed-gas-recovery": "PQ-14", "signature-rechecked": "PQ-15",
    "own-signature-only-exit": "PQ-16", "sender-gas-limits": "PQ-18", "signed-4337-gas-limits": "PQ-18",
    "signed-shortcut-lost": "PQ-19", "7702-own-key-only": "PQ-20", "entry-by-own-signature-only": "PQ-21",
    # not an EIP-8151 effect: a wallet whose owners' ECDSA keys a quantum computer could forge, met while reviewing a wallet's
    # migration notice. Rated by the quantum-exposure table, like the first study's wallet cards.
    "wallet-owner-keys": "PQ-12",
}

sys.path.insert(0, str(REGISTRY / "tools"))  # build, verify, new_finding


def key_dir(key: str) -> str:
    """A row's key as a folder name: <address>-<issue>, with / as _."""
    issue, address = key.split("|")
    return f"{address}-{issue.replace('/', '_')}"
