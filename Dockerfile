FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV OMADA_DIR=/opt/tplink/EAPController

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget unzip gosu net-tools tzdata openjdk-17-jre-headless \
    grep sed tar coreutils curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN OMADA_VER=$(wget -qO- https://www.tp-link.com/br/support/download/omada-software-controller/v5/ \
    | grep -oP 'Omada_SDN_Controller_v\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
    | sort -V \
    | tail -n 1) && \
    echo "Última versão: $OMADA_VER" && \
    wget -nv "https://static.tp-link.com/upload/software/$(date +%Y)/$(date +%m)/$(date +%d)/Omada_SDN_Controller_v${OMADA_VER}_Linux_x64.tar.gz" -O Omada.tar.gz && \
    tar -xvf Omada.tar.gz && \
    mkdir -p ${OMADA_DIR} && \
    cd Omada_SDN_Controller_* && \
    cp -r bin data lib properties install.sh uninstall.sh "${OMADA_DIR}" && \
    echo "mongo.external=true" >> "${OMADA_DIR}/properties/omada.properties" && \
    echo "eap.mongod.uri=mongodb://mongodb:27017/omada" >> "${OMADA_DIR}/properties/omada.properties" && \
    chmod -R 777 "${OMADA_DIR}/properties" && \
    rm -rf /tmp/*

WORKDIR ${OMADA_DIR}

CMD ["bash", "-c", "bash bin/control.sh start && tail -f logs/server.log"]