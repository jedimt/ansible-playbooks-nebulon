#!/bin/bash
ansible localhost -i inventory/hpe_2node.yml -m include_role -a name=jedimt.ssh