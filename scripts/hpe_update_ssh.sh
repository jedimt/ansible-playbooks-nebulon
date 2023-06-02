#!/bin/bash
ansible localhost -i inventory/hpe.yml -m include_role -a name=jedimt.ssh
