ENV DEBIAN_FRONTEND=noninteractive
ENV OMADA_DIR=/opt/tplink/EAPController
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget unzip gosu net-tools tzdata openjdk-17-jre-headless \
    jsvc curl vim \
    grep sed tar coreutils curl procps && \
    ln -s /usr/lib/jvm/java-17-openjdk-* /usr/lib/jvm/java-17-openjdk-amd64 || true && \
    rm -rf /var/lib/apt/lists/*

# Baixar a versão fixa do Omada Controller com mais debug
echo "Iniciando download do Omada Controller..." && \
    # wget -nv "https://static.tp-link.com/upload/software/2025/202504/20250425/20250425/Omada_SDN_Controller_v5.15.20.20_linux_x64_20250416110546.tar.gz" -O Omada.tar.gz && \
    wget -nv "https://static.tp-link.com/upload/software/2025/202504/20250425/Omada_SDN_Controller_v5.15.20.20_linux_x64_20250416110546.tar.gz" -O Omada.tar.gz && \
    
    if [ $? -ne 0 ]; then echo "Erro ao baixar o arquivo"; exit 1; fi && \
    echo "Download concluído, descompactando..." && \
    tar -xvf Omada.tar.gz && \
    if [ $? -ne 0 ]; then echo "Erro ao descompactar o arquivo"; exit 1; fi && \
    mkdir -p ${OMADA_DIR} && \
    cd Omada_SDN_Controller_* && \
    cp -r bin data lib properties install.sh uninstall.sh "${OMADA_DIR}" && \
    echo "mongo.external=true" >> "${OMADA_DIR}/properties/omada.properties" && \
    echo "eap.mongod.uri=mongodb://omada-mongodb:27017/omada" >> "${OMADA_DIR}/properties/omada.properties" && \
    chmod -R 777 "${OMADA_DIR}/properties" && \
    rm -rf /tmp/*



# Comando final para iniciar o Omada
# CMD ["bash", "-c", "bash ${OMADA_DIR}/bin/control.sh start && tail -f ${OMADA_DIR}/logs/server.log"]
CMD ["bash", "-c", "bash /code/install.sh && tail -f ${OMADA_DIR}/logs/server.log"]
