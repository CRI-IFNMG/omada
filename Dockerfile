# Dockerfile.omada

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV OMADA_DIR=/opt/tplink/EAPController

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget unzip gosu net-tools tzdata openjdk-17-jre-headless \
    grep sed tar coreutils curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Baixar a versão fixa do Omada Controller
RUN wget -nv "https://static.tp-link.com/upload/software/2025/202504/20250425/20250425/Omada_SDN_Controller_v5.15.20.20_linux_x64_20250416110546.tar.gz" -O Omada.tar.gz && \
    tar -xvf Omada.tar.gz && \
    mkdir -p ${OMADA_DIR} && \
    cd Omada_SDN_Controller_* && \
    cp -r bin data lib properties install.sh uninstall.sh "${OMADA_DIR}" && \
    echo "mongo.external=true" >> "${OMADA_DIR}/properties/omada.properties" && \
    echo "eap.mongod.uri=mongodb://omada-mongodb:27017/omada" >> "${OMADA_DIR}/properties/omada.properties" && \
    chmod -R 777 "${OMADA_DIR}/properties" && \
    rm -rf /tmp/*

WORKDIR ${OMADA_DIR}

CMD ["bash", "-c", "bash bin/control.sh start && tail -f logs/server.log"]