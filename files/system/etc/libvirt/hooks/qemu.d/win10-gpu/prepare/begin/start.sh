exec > /tmp/start-log.txt 2>&1
# Helpful to read output when debugging
set -x

# Stop display manager
systemctl stop display-manager.service
systemctl stop gdm
## Uncomment the following line if you use GDM
killall gdm-wayland-session
killall gdm
#${pkgs.killall}/bin/killall sway
pkill -u tht

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
#echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

modprobe -r amdgpu
# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_07_00_0
virsh nodedev-detach pci_0000_07_00_1

# Load VFIO Kernel Module
modprobe vfio-pci
