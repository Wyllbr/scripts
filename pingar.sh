#!/bin/bash

#nome script: pingar.sh

#como usar:
#   -./pingar.sg vlan 1 2 3 4 5 6 ....
#   - bash pingar.sh vlan 1 2 3 4 5 6....
 

vlan=$1
#variaveis
vlan_bloco=$2
#elimina o primeiro argumento
#shift
#lista de argumento restantes
range=$3


for i in $(seq 1 $range); do
    if ping -c 2 10.$vlan.$vlan_bloco.$i > /dev/null; then
        echo "O ip 10.$vlan.$vlan_bloco.$i está acessível" 
        echo -e "\U1F600"
    else
        echo "O ip 10.$vlan.$vlan_bloco.$ip não está acessível"
         echo -e "\U1fae0"
    fi
    echo $i
done
