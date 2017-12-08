#!/bin/bash

variable=$1
echo "please enter the command to execute!"
read input_var
for i in $(echo $variable | sed "s/,/ /g")
do
    scp -i /path/to/the/pem sshd_config user@$i:/etc/ssh/sshd_config
    sshpass -p 'vagrant' ssh vagrant@$i "${input_var}"
done
