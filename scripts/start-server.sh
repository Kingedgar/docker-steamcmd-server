#!/bin/bash
usermod -o -u "$UID" steam
groupmod -o -g "$GID" steam

chown steam:steam ${DATA_DIR}

if [ "$GAME_NAME" == "tf" ] ; then 
    echo "---Fetching required files for TeamFortress2---"
    dpkg --add-architecture i386
    apt-get update
    apt-get -y install lib32z1 libncurses5:i386 libbz2-1.0:i386 lib32gcc1 libtinfo5:i386 libcurl3-gnutls:i386
fi


if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    sudo -u steam echo "Steamcmd not found!"
    sudo -u steam wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    sudo -u steam tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    sudo -u steam rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
sudo -u steam ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
echo "---Update SteamCMD finished---"
    
echo "---Update Server---"
sudo -u steam ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update $GAME_ID \
    +quit
echo "---Update Server finished---"

chown steam:steam ${SERVER_DIR}

echo "---Prepare Server---"
sudo -u steam mkdir ${DATA_DIR}/.steam/sdk32
sudo -u steam cp -R ${SERVER_DIR}/bin/* ${DATA_DIR}/.steam/sdk32/
sudo -u steam echo "---Preparation finished---"

echo "---Start Server---"
sudo -u steam ${SERVER_DIR}/srcds_run -game $GAME_NAME $GAME_PARAMS -console +port $GAME_PORT
