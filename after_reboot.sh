#!/bin/bash

sudo mv /root/.bashrc ~/.bashrc
sudo chown $(whoami) ~/.bashrc
source ~/.bashrc