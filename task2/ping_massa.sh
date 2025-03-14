#!/bin/bash


if [[ ! -f "$1" ]]; then
	echo "Uso: $0 < >"
	exit 1
fi

arquivo=$1

while IFS= read -r linha; do
    echo "Processamendo> $linha"
    fping -c 1 $linha 
    echo ""
done < "$arquivo"
