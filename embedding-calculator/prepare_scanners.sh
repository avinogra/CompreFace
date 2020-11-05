#!/bin/bash -e

if [[ "$SCANNER" == "InsightFace" ]]; then
  MODELS_PATH=~/.insightface/models
  mkdir -p $MODELS_PATH
  for MODEL in $DETECTION_MODEL $CALCULATION_MODEL
  do
    DIR=~/srcext/insightface/models/$MODEL
    [ -d "$DIR" ] && echo "Coping $MODEL from repo..." && cp -r $DIR $MODELS_PATH && continue

    URL=http://insightface.ai/files/models/$MODEL.zip
    echo "Downloading $URL..."
    mkdir -p $MODELS_PATH/$MODEL && cd "$_" && curl -L $URL -o m.zip  \
      && unzip m.zip && rm m.zip

    # MXNET_CUDNN_AUTOTUNE_DEFAULT=0 doesn't work, need to make changes in a models
    # https://github.com/deepinsight/insightface/issues/764
    sed -i 's/limited_workspace/None/g' $MODELS_PATH/$MODEL/*.json
  done
else
  echo "  --ignore=src/services/facescan/scanner/insightface" >> pytest.ini
fi
