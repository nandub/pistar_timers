#!/usr/bin/env bash

sudo cp ysf/*.service /lib/systemd/system/
sudo cp ysf/*.timer /lib/systemd/system/
sudo cp ysf/*.sh /root/
sudo chmod 700 /root/ysfconnect.sh
