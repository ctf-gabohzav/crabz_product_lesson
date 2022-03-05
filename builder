#!/usr/bin/env sh
sshidfile="/var/jenkins_home/crab_release_id/deploy_ssh_private.key"
fo=/tmp/constructions.out

publisher() { 
  echo "Starting builder from github at BLAKE2 $(cat Dockerfile src/main.rs README.txt | b2sum) NANOSECOND $(date +%Y%m%d%H%M%S%N)..." | tee $fo
  echo
  echo "Backup previous state and clean conflicts..." | tee $fo
  #ssh -i $sshidfile manager@secretserver<checkcleaner.sh 
  echo "Copy out the src/ contents to the build workspace..." | tee $fo
  tar czvf load.tgz ./*
  scp -i $sshidfile load.tgz manager@secretserver:/opt/build/workspace/
  ssh -i $sshidfile manager@secretserver "cd /opt/build/workspace/ && tar xzvf load.tgz; exit"
  echo "Publish new content..." | tee $fo
  #ssh -i $sshidfile manager@secretserver<publisher.sh 
  echo
  echo "Run complete." | tee $fo
  echo
}

checker() {
  curl https://crabz.io/api/v2/healthz || exit 1
}


jenkins_spiral() {
  touch $fo
  :>$fo
  rhash=$(b2sum $sshidfile | cut -c1-10)
  thash=55f26cff2a
  if [ "$rhash" = "$thash" ]; then
    publisher
    checker
  else
    echo "private key doesn't match builder code"
    exit 1
  fi;
  exit 0
}

jenkins_spiral || echo "ERROR builder failed $(date +%Y%m%d%H%M%S%N)"
