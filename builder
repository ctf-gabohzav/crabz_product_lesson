#!/usr/bin/env sh
sshidfile="/var/jenkins_home/crab_release_id/deploy_ssh_private.key"
fo=/tmp/constructions.out

publisher() { 
  echo "Starting builder from github at BLAKE2 $(cat * | b2sum) NANOSECOND $(date +%Y%m%d%H%M%S%N)..." | tee $fo
  echo
  echo "Backup previous state and clean conflicts..." | tee $fo
  ssh -i $sshidfile manager@secretserver<checkcleaner.sh | tee $fo
  echo "Copy out the src/ contents to the build workspace..." | tee $fo
  scp -i $sshidfile -r src/* manager@secretserver:/opt/build/workspace/ | tee $fo
  echo "Publish new content..." | tee /$fo
  ssh -i $sshidfile manager@secretserver<publisher.sh | tee $fo
  echo
  echo "Run complete." | tee $fo
  echo
}

checker() {
  curl https://crabz.io/api/v2/healthz || exit 1
}

compile() {
  cd /opt/build/workspace/
  cargo build --release
}

jenkins_spiral() {
  touch $fo
  :>$fo
  rhash=$(b2sum $sshidfile | cut -c1-10)
  thash=55f26cff2a
  if [ $rhash == "$thash" ]; then
    cd /opt/build/workspace/
    compile
    publisher
    checker
  else
    echo "private key doesn't match builder code"
  fi
}

jenkins_spiral || echo "ERROR builder failed $(date +%Y%m%d%H%M%S%N)"
