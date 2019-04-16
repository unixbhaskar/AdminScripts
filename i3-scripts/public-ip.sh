#!/usr/bin/env bash

PubIP=$(wget http://ipinfo.io/ip -qO -)
echo $PubIP

