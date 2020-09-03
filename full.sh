# Arch Linux Bootstrap script 00
#
# To install when you are on chroot (after partionning and configuring with iso)
#






./scripts/05-install-grub.sh
./scripts/10-conf-locales-timezones-hostname.sh
./scripts/15-install-xorg.sh
./scripts/20-install-config-xfce.sh
./scripts/25-install-dependencies.sh
./scripts/30-create-config-new-user.sh
./scripts/35-install-yay-moreniceties-with-yay.sh

echo "SCRIPT FINI"