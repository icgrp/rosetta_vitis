#!/bin/bash -e

tcl_name=$1

vivado -mode batch -source  ${tcl_name}
