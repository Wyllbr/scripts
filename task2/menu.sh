#!/bin/bash

opcao=$(dialog --menu "Gerenciamento de Serviços" 12 50 4 \
1 "Iniciar Apache" \
2 "Parar Apache" \
3 "Reiniciar Apache" \
4 "Sair" --stdout)

clear

#echo "$opcao"
case $opcao in
    1) echo "Iniciando o Apache..."; ls . ;;
    2) echo "Parando o Apache..."; df -h ;;
    3) echo "Reiniciando o Apache..."; history ;;
    4) echo "Saindo..."; exit 0 ;;
    *) echo "Opção inválida!" ;;
esac
