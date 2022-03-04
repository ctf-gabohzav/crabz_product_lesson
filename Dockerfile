FROM ubuntu
LABEL version="0.1"
LABEL description="CTF CRAB LESSON"
RUN apt-get update && apt-get install -y apt-transport-https aptitude
COPY target/release/crabz /usr/local/sbin/
CMD /usr/local/sbin/crabz
