FROM debian:stable-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential cmake git telnet libxml2-dev && \
    mkdir openv && \
    cd openv && \
    git clone https://github.com/openv/vcontrold.git && \
    cd vcontrold && \
    mkdir build && \
    cd build && \
    cmake .. -DVSIM=OFF -DMANPAGES=OFF -DVCLIENT=ON && \
    make && \
    make install && \
    apt-get remove -y build-essential cmake git

ADD vcontrold.xml /etc/vcontrold/
ADD vito.xml /etc/vcontrold/
ADD startup.sh /

ENTRYPOINT ["/startup.sh"]

