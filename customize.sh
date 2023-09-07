SKIPUNZIP=1

ui_print "- Creating directories in /data/v2ray"
mkdir -p /data/v2ray
mkdir -p /data/v2ray/run
mkdir -p $MODPATH/scripts
mkdir -p $MODPATH/system/bin
mkdir -p $MODPATH/system/etc

ui_print "- Extracting module files"
unzip -j -o "${ZIPFILE}" "v2ray/bin/v2ray" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" "v2ray/bin/geoip.dat" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/bin/geosite.dat" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/scripts/*" -d $MODPATH/scripts >&2
unzip -j -o "${ZIPFILE}" "service.sh" -d $MODPATH >&2
unzip -j -o "${ZIPFILE}" "uninstall.sh" -d $MODPATH >&2
rm "${download_v2ray_zip}"

ui_print "- Copying V2Ray config and data files"
[ -f /data/v2ray/softap.list ] || \
echo "192.168.43.0/24" > /data/v2ray/softap.list
[ -f /data/v2ray/resolv.conf ] || \
unzip -j -o "${ZIPFILE}" "v2ray/etc/resolv.conf" -d /data/v2ray >&2
unzip -j -o "${ZIPFILE}" "v2ray/etc/config.json.template" -d /data/v2ray >&2
[ -f /data/v2ray/config.json ] || \
cp /data/v2ray/config.json.template /data/v2ray/config.json
ln -s /data/v2ray/resolv.conf $MODPATH/system/etc/resolv.conf

inet_uid="3003"
net_raw_uid="3004"
set_perm_recursive  $MODPATH     0  0  0755  0644
set_perm  $MODPATH/service.sh    0  0  0755
set_perm  $MODPATH/uninstall.sh  0  0  0755
set_perm  $MODPATH/scripts/start.sh       0  0  0755
set_perm  $MODPATH/scripts/v2ray.service  0  0  0755
set_perm  $MODPATH/scripts/v2ray.tproxy   0  0  0755
set_perm  $MODPATH/system/bin/v2ray  ${inet_uid}  ${inet_uid}  0755
set_perm  /data/v2ray                ${inet_uid}  ${inet_uid}  0755
