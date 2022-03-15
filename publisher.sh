#!/usr/bin/env sh
cd /opt/build/workspace/ || exit 1

cargo audit --json > cargo_audit.json

cat cargo_audit.json

syft "$1" -o json > SBOM.json

docker build -t "127.0.0.1:crabz:production" .

cosign sign --key /opt/build/cosign.key "crabz:production"

cosign attest -predicate SBOM.json -key /opt/build/cosign.key "crabz:production" || exit 1

docker push "127.0.0.1:crabz:production"

docker save "127.0.0.1:crabz:production" > crabz_prod.tar

b2sum crabz_prod.tar > checks.txt
sha256sum crabz_prod.tar >> checks.txt
b2sum SBOM.json >> checks.txt
sha256sum SBOM.json >> checks.txt

shipval=$(date +%Y%m%d%H%M%S%N)

tar czvf prod_ship_$shipval.tgz crabz_prod.tar checks.txt SBOM.json

touch /var/run/deployment.trigger
echo prod_ship_$shipval.tgz > /var/run/deployment.trigger
