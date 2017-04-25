#!/bin/bash

# Configure BaseApp
if [ ! -f /baseapp-configured ]; then

	BASEAPP_DIR=github.com/richtr/baseapp
	BASEAPP_PATH=$GOPATH/src/$BASEAPP_DIR
	BASEAPP_CONF_FILE=$BASEAPP_PATH/conf/app.conf

	# Grab the best app.conf file
	if [ ! -f $BASEAPP_PATH/conf/app.conf ]; then
		BASEAPP_CONF_FILE=$BASEAPP_PATH/conf/app.conf.default
	fi

	# Ensure app secret is set
	sed -i "s/<app_secret_please_change_me>/`pwgen -c -n -1 65`/g" $BASEAPP_CONF_FILE

	if [ $BASEAPP_CONF_FILE == $BASEAPP_PATH/conf/app.conf.default ]; then
		mv $BASEAPP_CONF_FILE $BASEAPP_PATH/conf/app.conf
	fi

	touch /baseapp-configured

fi

# Install Revel
echo "Installing Revel..."
cd $GOPATH/src && go get github.com/revel/revel && go get github.com/revel/cmd/revel

# Install and start Baseapp (in test mode)
echo "Installing and running BaseApp..."
cd $BASEAPP_PATH && go get ./... && cd $GOPATH/src && revel run $BASEAPP_DIR test
