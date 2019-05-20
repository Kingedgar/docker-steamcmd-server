FROM ubuntu

MAINTAINER kingedgar

RUN dpkg --add-architecture i386 && apt-get update && apt-get -y install iproute2 iputils-ping net-tools gdb wget language-pack-en lib32z1 libncurses5:i386 libbz2-1.0:i386 lib32gcc1 lib32stdc++6 libtinfo5:i386 libcurl3-gnutls:i386 libstdc++6:i386 libcurl4-gnutls-dev:i386 

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV VALIDATE=""
ENV UID=1000
ENV GID=1002
ENV USERNAME=""
ENV PASSWRD=""

RUN mkdir $DATA_DIR && mkdir $STEAMCMD_DIR && mkdir $SERVER_DIR
RUN groupadd --gid $GID steam && useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID steam &&chown -R steam $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && chown -R steam /opt/scripts

USER steam

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
