#!/bin/bash

if [ -z "$MAPR_SNAPSHOT" ]
then
  MAPR_SNAPSHOT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo "Creating MapR snapshot: $MAPR_SNAPSHOT"
  curl -k -X POST "https://$MAPR_REST/rest/volume/snapshot/create?volume=$MAPR_VOLUME&snapshotname=$MAPR_SNAPSHOT" --user $MAPR_USERNAME:$MAPR_PASSWORD
else
  echo "Using existing MapR snapshot: $MAPR_SNAPSHOT"
fi

wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/training-set-images/train-images-idx3-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/train-images-idx3-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/training-set-labels/train-labels-idx1-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/train-labels-idx1-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/test-set-images/t10k-images-idx3-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/t10k-images-idx3-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
wget -k "http://$MAPR_HTTPFS/webhdfs/v1/tmp/$MAPR_VOLUME/.snapshot/$MAPR_SNAPSHOT/test-set-labels/t10k-labels-idx1-ubyte.gz?op=open" -O "$VH_INPUTS_DIR/t10k-labels-idx1-ubyte.gz" --user $MAPR_USERNAME --password $MAPR_PASSWORD
