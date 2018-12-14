#!/bin/bash

# Execute all init scripts
if [ ! -z "$(ls -A /etc/startup-scripts.d)" ]; then
  for f in /etc/startup-scripts.d/* ; do
    bash "$f"
  done
fi

/sbin/runsvdir -P /etc/service
