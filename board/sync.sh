#!/bin/sh
# The server follows main (board/README.md). pq-outreach-sync.timer runs this every minute from the deployed copy,
# ROOT/app, where ROOT holds registry/ (a clone of this repository), app/ and data/.
#
# Pull main. When what data/registry.db is built from changed (findings, the importer, data/values.db...) or board/
# differs from app/: test the board code of that commit (check.py), rebuild the database (ingest.py checks the new one
# against the files before it replaces the old one), deploy board/ to app/ and restart the board. A failed step leaves
# the last good database and code in place, and the next run tries again; a commit that changes neither (the rebuild
# of generated/) costs one fetch. data/outreach.db, the team's work, is never touched here.
set -eu
cd "$(dirname "$0")/.."
git -C registry fetch --quiet --depth 1 origin main
git -C registry checkout --quiet --force -B main FETCH_HEAD
export BOARD_DATA="$PWD/data"
built=no code=no
python3 registry/board/ingest.py --current registry data/registry.db data/values.db && built=yes
diff -rq --exclude=__pycache__ registry/board app >/dev/null 2>&1 && code=yes
[ "$built$code" = yesyes ] && exit 0
at=$(git -C registry rev-parse --short HEAD)
out=$(python3 registry/board/check.py registry 2>&1) || {
  printf '%s\n' "$out" | tail -n 15 >&2
  echo "main at $at: board/check.py fails; nothing changed" >&2
  exit 1
}
[ "$built" = yes ] || python3 registry/board/ingest.py registry data/registry.db data/values.db
if [ "$code" = no ]; then
  rsync -a --delete --exclude=__pycache__ registry/board/ app/
  sudo systemctl restart pq-outreach.service
  echo "board code of $at deployed"
fi
python3 app/server.py orphans
