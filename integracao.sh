#!/bin/bash

# Configuração do Zabbix
ZABBIX_URL="https://zabbix64.ufam.edu.br/api_jsonrpc.php"
ZABBIX_TOKEN="35cf389316f46f41e34bd49cb0f577e5"
HOSTGROUP_ID="36"  # ID do grupo de hosts no Zabbix

# Configuração do phpIPAM
PHPIPAM_URL="https://gerencia-redes.ufam.edu.br:8888/api/zabbix"
PHPIPAM_TOKEN="cIic2oq-LS4uqc_xrLjy09cJQ2Fwohs9"
SECTION_ID="1"  # ID da seção no phpIPAM onde os IPs serão gerenciados

# Função para obter hosts do grupo específico no Zabbix
get_zabbix_hosts_by_group() {
    curl --user infra:zbxinfra -s -X POST -H "Content-Type: application/json" -d '{
        "jsonrpc": "2.0",
        "method": "host.get",
        "params": {
            "output": ["name"],
            "selectInterfaces": ["ip"],
            "selectInventory": ["macaddress_b"],
            "groupids": "'"$HOSTGROUP_ID"'"
        },
        "auth": "'"$ZABBIX_TOKEN"'",
        "id": 1
    }' "$ZABBIX_URL"
}

# Função para verificar se um IP já existe no phpIPAM
check_phpipam_ip() {
    #local IP="$1"
    #RESPONSE=$(curl -s -X GET -H "token: $PHPIPAM_TOKEN" "$PHPIPAM_URL/addresses/search/$IP/")
    #echo "$RESPONSE" | jq -r '.code'
    local IP="$1"

    # Primeira consulta para verificar se o IP existe
    RESPONSE=$(curl -s -X GET -H "token: $PHPIPAM_TOKEN" \
        -H "Content-Type: application/json" \
        "$PHPIPAM_URL/addresses/search/$IP")

    # Extrai o código da resposta
    CODE=$(echo "$RESPONSE" | jq -r '.code')

    # Se o código for 200, faz uma segunda consulta para obter o ID
    if [[ "$CODE" == "200" ]]; then
        # Extrai todos os IDs do IP (caso existam múltiplos registros)
        echo "$RESPONSE" | jq -r '.data[].id'
    else
        echo "null"
    fi

}

# Função para atualizar um IP no phpIPAM com Nome e MAC Address
update_phpipam_ip() {
    local IP_ID="$1"
    local HOSTNAME="$2"
    local MAC="$3"

    echo "èAQUI Atualizando IP $IP_ID no phpIPAM..."
    echo -e "\n#########$IP_ID##########\n"
     RESPONSE=$(curl -s -X PATCH -H "token: $PHPIPAM_TOKEN" -H "Content-Type: application/json" -d '{
        "hostname": "'"$HOSTNAME"'",
        "mac": "'"$MAC"'"
    }' "$PHPIPAM_URL/addresses/"$IP_ID"/")

    echo "✅ Resposta do phpIPAM: $RESPONSE"
}

# Função para adicionar um IP no phpIPAM se não existir
add_phpipam_ip() {
    local IP="$1"
    local HOSTNAME="$2"
    local MAC="$3"
    local SUBNET_16=$(change_ip_to_subnet_16 "$IP")
    local SUBNET_ID=$(get_subnet_id "$SUBNET_16")
    echo -e "$SUBNET_16"
    echo -e "$SUBNET_ID"
    echo "➕ Adicionando IP $IP com hostname $HOSTNAME no phpIPAM..."
    RESPONSE=$(curl_add_ip "$IP" "$HOSTNAME" "$MAC" "$SUBNET_ID")
     echo "✅ Resposta do phpIPAM: $RESPONSE"
}

get_subnet_id() {
    local NETWORK="$1"
    curl -s -X GET -H "token: $PHPIPAM_TOKEN" "$PHPIPAM_URL/subnets/search/$NETWORK" | jq -r '.data[].id'
}

change_ip_to_subnet_16() {
    local IP="$1"
    echo "$IP" | sed -E 's/^([0-9]+\.[0-9]+)\.[0-9]+\.[0-9]+/\1.0.0\/16/'
}

curl_add_ip() {
    local IP="$1"
    local HOSTNAME="$2"
    local MAC="$3"
    local SUBNET_ID="$4"
    echo  -e "\nentrou no curl_add_ip\n"
    echo -e "IP - $IP"
    echo -e "NOME - $HOSTNAME"
    echo -e "MAC - $MAC"
    echo -e "ID DE SUBREDE - $SUBNET_ID"

    curl -s -X POST "$PHPIPAM_URL/addresses/" \
        -H "token: $PHPIPAM_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{
            \"ip\": \"$IP\",
            \"hostname\": \"$HOSTNAME\",
            \"mac\": \"$MAC\",
            \"subnetId\": $SUBNET_ID
        }"
}

############################MAIN############################################


# Obtém os hosts do grupo no Zabbix
echo "🔹 Buscando hosts do grupo no Zabbix..."
ZABBIX_HOSTS=$(get_zabbix_hosts_by_group)
echo "passou"
# Itera sobre os hosts e adiciona/atualiza no phpIPAM
echo "$ZABBIX_HOSTS" | jq -c '.result[]' | while read HOST; do
    echo "######################################"
    echo -e "comeco de uma interacao\n"
    HOSTNAME=$(echo "$HOST" | jq -r '.name')
    IP=$(echo "$HOST" | jq -r '.interfaces[0].ip // empty')
    MAC=$(echo "$HOST" | jq -r '.inventory.macaddress_b // empty')

    if [[ -z "$IP" ]]; then
        echo "⚠ O host $HOSTNAME não tem IP configurado. Pulando..."
        continue
    fi

    echo "🔍 Verificando IP $IP do host $HOSTNAME no phpIPAM..."
    IP_ID=$(check_phpipam_ip "$IP")
    echo -e "$IP_ID"
    if [[   "$IP_ID" != "null" && -n "$IP_ID" ]]; then
        echo "✅ IP encontrado no phpIPAM. Atualizando..."
        update_phpipam_ip "$IP_ID" "$HOSTNAME" "$MAC"
    else
        echo "🚀 IP não encontrado no phpIPAM. Adicionando..."
        add_phpipam_ip "$IP" "$HOSTNAME" "$MAC"
    fi
    echo  -e "\nfim de uma interacao"
    echo -e  "###########################\n"

done

echo "✅ Sincronização concluída!"

################################END-MAIN####################################
