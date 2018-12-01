#! /bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: $0 <leader ip> <local ip> <local id> [provider,default to 'sockets'] [domain,default to 'eth0']"
  exit -1;
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

TEMPLATE=/usr/local/share/derecho.cfg.template
CONFIG=derecho.cfg

LEADER_IP=$1
LOCAL_IP=$2
LOCAL_ID=$3
PROVIDER=$4
if [ -z $PROVIDER ]; then
  PROVIDER='sockets'
fi
DOMAIN=$5
if [ -z $DOMAIN ]; then
  DOMAIN='eth0'
fi

if [[ ! -e ${TEMPLATE} ]]; then
  echo -e "Configuration generation failed:"
  echo -e "${RED} Cannot find template file:${TEMPLATE}.${NC}"
fi

cat ${TEMPLATE}| \
  sed "s/\[LEADER_IP\]/${LEADER_IP}/g" | \
  sed "s/\[LOCAL_IP\]/${LOCAL_IP}/g" | \
  sed "s/\[LOCAL_ID\]/${LOCAL_ID}/g" | \
  sed "s/\[PROVIDER\]/${PROVIDER}/g" | \
  sed "s/\[DOMAIN\]/${DOMAIN}/g" > ${CONFIG}

ERRCODE=$?
if [ ${ERRCODE} -eq 0 ]; then
  echo -e "${GREEN}Configuration is successfully generated in file: ${CONFIG}."
  echo -e "To use this configuration for your experiment, you can either"
  echo -e "- copy this file side-by-side to the binary, or"
  echo -e "- set the 'DERECHO_CONF_FILE' environment variable to this file:"
  echo -e "     # ${YELLOW}export DERECHO_CONF_FILE=`pwd`/${CONFIG}${NC}"
else
  echo -e "${RED}Configuration generation failed with err:${ERRCODE}.${NC}"
fi
