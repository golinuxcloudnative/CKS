#!/bin/bash
data_diretory=/opt
mkdir -p ${data_diretory}
echo "=> File create at `date`" | tee ${data_diretory}/create.log