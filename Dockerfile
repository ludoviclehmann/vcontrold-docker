FROM debian:stable-slim AS devBuild
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends git ca-certificates build-essential cmake telnet libxml2-dev && \
    mkdir openv && \
    cd openv && \
    git clone https://github.com/openv/vcontrold.git && \
    cd vcontrold && \
    mkdir build && \
    cd build && \
    cmake .. -DVSIM=OFF -DMANPAGES=OFF -DVCLIENT=ON && \
    make && \
    mkdir -p vcontroldPackage/DEBIAN && \
    echo 'Package: vcontrold\n\
Version: 1.0\n\
Section: custom\n\
Priority: optional\n\
Architecture: all\n\
Essential: no\n\
Installed-Size: 1024\n\
Maintainer: ludoviclehmann\n\
Description: Vcontrold package\
'   > vcontroldPackage/DEBIAN/control && \
    cat vcontroldPackage/DEBIAN/control && \
    mkdir -p vcontroldPackage/usr/bin && \
    cp vclient vcontroldPackage/usr/bin/ && \
    mkdir -p vcontroldPackage/usr/sbin && \
    cp vcontrold vcontroldPackage/usr/sbin/ && \
    dpkg-deb --build vcontroldPackage/

FROM debian:stable-slim
COPY --from=devBuild /openv/vcontrold/build/vcontroldPackage.deb vcontroldPackage.deb
RUN apt-get update && \
    apt-get upgrade -y && \
apt-get install --no-install-recommends -y libxml2 && \
rm -rf /var/lib/apt/lists/* && \
dpkg -i vcontroldPackage.deb
ADD vcontrold.xml /etc/vcontrold/
ADD vito.xml /etc/vcontrold/
ADD startup.sh /

ENTRYPOINT ["/startup.sh"]