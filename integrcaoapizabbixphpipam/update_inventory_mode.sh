#!/bin/bash

# Configuração do Zabbix
ZABBIX_URL="https://zabbix64.ufam.edu.br/api_jsonrpc.php"
ZABBIX_TOKEN="35cf389316f46f41e34bd49cb0f577e5"

get_zabbix_host_inventorymode(){


 response=$(curl "$ZABBIX_URL" \
    --user "infra:zbxinfra" \
    -s \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{
      "jsonrpc": "2.0",
      "method": "host.get",
      "params": {
        "output": ["hostid"],
        "filter": {
          "inventory_mode": ["0"]
        }
      },
      "auth": "'"$ZABBIX_TOKEN"'",
      "id": 2
    }')
	echo "$response" | jq -r '.result[].hostid'
}

update_host_inventory_mode(){
	#Declaracao de variaveis locais
	local HOSTID="$1"
	echo "$HOSTID"
	#intergracao do comando curl em uma variavel para possivel depuracao
	response=$(curl "$ZABBIX_URL" \
    	--user "infra:zbxinfra" \
    	-s \
    	-X POST \
    	-H "Content-Type: application/json" \
    	-d '{
      	"jsonrpc": "2.0",
     	"method": "host.update",
      	"params": {
       		 "hostid": "'"$HOSTID"'",
       		 "inventory_mode": 1
      	},
     	 "auth": "'"$ZABBIX_TOKEN"'",
     	 "id": 2
    	}')
	echo "$response"
}



#########################################MAIN#############################################################

ZABBIX_ID_HOST_INVENTORY_0=$(get_zabbix_host_inventorymode)
#echo "saiu"
#echo "$ZABBIX_ID_HOST_INVENTORY_0"

# Se não encontrar nenhum, avisa e sai
if [[ -z "$ZABBIX_ID_HOST_INVENTORY_0" ]]; then
  echo "Nenhum host encontrado com inventory_mode = 0."
  exit 0
fi
#Laço de repetição para percorrer todo os host
for hostid in  $ZABBIX_ID_HOST_INVENTORY_0; do
	echo "Atualizando host zabbic om id: $hostid"
	update_host_inventory_mode "$hostid"
done
#########################################ENDMAIN##########################################################
