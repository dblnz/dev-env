# Systemd unit files

These units are used to start and stop custm services.

## Installation
Place the units at `/etc/systemd/system/` and run `systemctl daemon-reload`
to reload the units or `systemctl enable <unit>` to enable the unit.

## Units
- macspoof.service - changes the MAC address of the network interface
  ```bash
  sudo systemctl enable macspoof@wlan0.service
  ```

