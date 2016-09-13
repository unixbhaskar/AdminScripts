#!/bin/bash

find / -links +2 -type f -exec ls -li {} \;
