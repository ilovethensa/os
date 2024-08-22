exec > /tmp/revert-log.txt 2>&1
set -x

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach pci_0000_07_00_1
virsh nodedev-reattach pci_0000_07_00_0

# Reload nvidia modules
modprobe amdgpu

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
echo 1 > /sys/class/vtconsole/vtcon1/bind

#nvidia-xconfig --query-gpu-info > /dev/null 2>&1
#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start display-manager.service
