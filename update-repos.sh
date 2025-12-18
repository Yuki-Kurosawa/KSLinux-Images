#! /bin/bash
REPO_DATE=$(curl -s https://salsa.debian.org/api/v4/projects/1516/repository/branches/deploy | jq ".commit.committed_date" | tr -d '"' )
LOCAL_DATE=$(date +"%Y-%m-%dT%H:%M:%S%:z")

REPO_TS=$(date -d "$REPO_DATE" +%s)
LOCAL_TS=$(date -d "$LOCAL_DATE" +%s)
TAR_TS=$(date -r dak.tar.gz +%s 2>/dev/null || echo 0)

echo "Remote repo date: $REPO_DATE $REPO_TS"
echo "Local system date: $LOCAL_DATE $LOCAL_TS"
echo "Local tar date: $TAR_TS"

if [ $REPO_TS -gt $TAR_TS ]; then
    wget -O dak.tar.gz https://salsa.debian.org/ftp-team/dak/-/archive/deploy/dak-deploy.tar.gz?ref_type=heads
else
    echo "Local repository is up to date."
fi