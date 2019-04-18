FROM ubuntu

MAINTAINER ich777

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV UID=99
ENV GID=100
ARG USER=steam
ARG GROUP=steam

RUN mkdir $DATA_DIR
RUN mkdir $STEAMCMD_DIR
RUN mkdir $SERVER_DIR
RUN groupadd -g $GID $GROUP
RUN useradd -u $UID -G $GROUP -s /bin/sh -SDH $USER

RUN chown -R $USER:GROUP $DATA_DIR $STEAMCMD_DIR $SERVER_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

USER $USER

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
