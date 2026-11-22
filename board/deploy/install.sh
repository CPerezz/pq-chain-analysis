#!/bin/sh
# Set the board up on a server, or move it to a new one (board/README.md, "Deploy"). Run as the user in the units
# (ubuntu, with sudo) once /home/ubuntu/pq-outreach/registry is a clone of this repository on main. Safe to run again.
set -eu
cd /home/ubuntu/pq-outreach
test -f registry/board/sync.sh || { echo "registry/ must be a clone of the repository, on main" >&2; exit 1; }
mkdir -p data app
rsync -a --delete --exclude=__pycache__ registry/board/ app/
sudo cp app/deploy/*.service app/deploy/*.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now pq-outreach.service pq-outreach-tunnel.service pq-outreach-sync.timer pq-outreach-backup.timer
sudo systemctl restart pq-outreach.service
sudo systemctl start pq-outreach-sync.service
echo "running: $(systemctl is-active pq-outreach.service); registry.db: $(ls -l data/registry.db 2>/dev/null || echo none)"
