#!/bin/sh

echo "generating config" 
syncthing --generate="/config" 
sed -i "s/<folder id=\"default\" label=\"Default Folder\" path=\"\/root\/Sync\/\"/<folder id=\"default\" label=\"Default Folder\" path=\"\/data\/\"/"  /config/config.xml  
sed -i "s/<globalAnnounceEnabled>true<\/globalAnnounceEnabled>/<globalAnnounceEnabled>false<\/globalAnnounceEnabled>/"  /config/config.xml  
sed -i "s/<address>127.0.0.1:8384<\/address>/<address>0.0.0.0:8384<\/address>/"  /config/config.xml && \
sed -i "s/<autoUpgradeIntervalH>12<\/autoUpgradeIntervalH>/<autoUpgradeIntervalH>0<\/autoUpgradeIntervalH>/"  /config/config.xml


#run syncthing
syncthing -no-browser -no-restart -gui-address=0.0.0.0:8384 -home=/config
