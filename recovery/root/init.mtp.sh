#!/system/bin/sh
echo "mtp_bind started" >> /tmp/mtp_debug.log
until [ -c /dev/mtp_usb ]; do sleep 0.1; done
echo "mtp_usb appeared" >> /tmp/mtp_debug.log
while (exec 3>/dev/mtp_usb) 2>/dev/null; do sleep 0.1; done
echo "mtp_usb locked by TWRP, binding UDC" >> /tmp/mtp_debug.log
echo musb-hdrc > /sys/kernel/config/usb_gadget/g1/UDC
echo "done" >> /tmp/mtp_debug.log
