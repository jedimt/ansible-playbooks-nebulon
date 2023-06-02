#!/bin/bash
ansible localhost -i inventory/lenovo.yml -m include_role -a name=jedimt.ssh