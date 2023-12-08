#!/bin/sh
# Launcher script for red

DATA_PATH=$SNAP_DATA/solutions/activeConfiguration/redis-server
CONFIG_FILE=$DATA_PATH/redis.conf
DUMP_FILE=$DATA_PATH/dumb.rdb

# Wait for persistent storage to be available
while ! snapctl is-connected active-solution
do
    echo "Persistent storage not ready yet. Sleep"
    sleep 5
done

# Copy default config, if doesn't exists
if [ ! -e $CONFIG_FILE ]
then
    echo "Configuration file does not exists, copy default to $CONFIG_FILE"
    mkdir $DATA_PATH
    cp $SNAP/default_config.conf $CONFIG_FILE
else
    echo "Use existing configuration file $CONFIG_FILE"
fi

# Create symlink for database dump
touch $DUMP_FILE
ln -s $DUMP_FILE $SNAP/dump.rdb

# Launch the server
$SNAP/usr/bin/redis-server $CONFIG_FILE $@
