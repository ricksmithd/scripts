echo "MAKE SURE TO RUN SCRIPT AS ROOT"

modprobe cdc_ether
modprobe cdc_subset
modprobe cdc_acm

echo "Please plug/replug the dongle, and wait 1 minute. Press enter when device initialized"
read ok

ssh -i /home/breeze/.ssh/tuntun.rsa -D 1080 tuntun@172.20.0.1 -fqNC

su breeze

google-chrome --proxy-server="socks5://127.0.0.1:1080"