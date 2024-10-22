#!/bin/bash

#nome script: pingar.sh

#como usar:
#   -./pingar.sg vlan 1 2 3 4 5 6 ....
#   - bash pingar.sh vlan 1 2 3 4 5 6....
 


#variaveis
vlan=$1
#elimina o primeiro argumento
shift
#lista de argumento restantes
range=$@


for i in ${range[@]}; do
    if ping -c 2 10.10.$vlan.$i > /dev/null; then
        echo "O ip 10.10.$vlan.$i está acessível"
    else
        echo "O ip 10.10.$vlan.$ip não está acessível"
    fi
    echo $i
done
