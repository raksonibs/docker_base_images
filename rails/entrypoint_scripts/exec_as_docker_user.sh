#!/bin/bash
exec gosu docker docker-ssh-exec $@
