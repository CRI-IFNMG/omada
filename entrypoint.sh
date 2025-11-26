#!/bin/bash

OMADA_DIR="/opt/tplink/EAPController"
TEMPLATE_DIR="/opt/tplink/EAPController_template"

if [ ! -f "$OMADA_DIR/bin/control.sh" ]; then
    echo "Copiando arquivos do template para o volume..."
    cp -r $TEMPLATE_DIR/* $OMADA_DIR/
fi

exec bash $OMADA_DIR/bin/control.sh start
