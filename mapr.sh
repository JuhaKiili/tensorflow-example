#!/bin/bash

if [ -z "$snapshot" ]
then
  snapshot=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo "Creating snapshot: $snapshot"
  curl -k -X POST "https://$MAPR_REST/rest/volume/snapshot/create?volume=$MAPR_VOLUME&snapshotname=$MAPR_SNAPSHOT" --user valohai:valohai
fi

echo "\n"

wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/training-set-images/train-images-idx3-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/train-images-idx3-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/training-set-labels/train-labels-idx1-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/train-labels-idx1-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/test-set-images/t10k-images-idx3-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/t10k-images-idx3-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/test-set-labels/t10k-labels-idx1-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/t10k-labels-idx1-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD

echo "\n"

python train.py {parameters}