sed -i '/^sm-plugins=/ s/$/ generic/' /etc/xapi.conf
cd /opt/xensource/sm/; ln -sf "GENERICSR.py" "GENERICSR"