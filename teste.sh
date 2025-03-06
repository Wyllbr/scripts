#!/bin/bash

# Exibe menu com opções para o usuário escolher
opcao=$(zenity --list --title="Integração Zabbix ↔ phpIPAM" \
  --column="ID" --column="Ação" \
  1 "Executar integração completa" \
  2 "Atualizar apenas IPs" \
  3 "Sincronizar grupos" \
  4 "Sair" \
  --height=300 --width=400)

# Processa a opção escolhida
case $opcao in
  1)
    zenity --info --text="Executando integração completa..."
    # Aqui você chama a função ou comando do seu script principal
    /caminho/do/seu_script.sh --full-sync
    ;;
  2)
    zenity --info --text="Atualizando apenas IPs..."
    /caminho/do/seu_script.sh --update-ips
    ;;
  3)
    zenity --info --text="Sincronizando grupos..."
    /caminho/do/seu_script.sh --sync-groups
    ;;
  4)
    zenity --info --text="Saindo..."
    exit 0
    ;;
  *)
    zenity --error --text="Nenhuma opção selecionada."
    exit 1
    ;;
esac

# Mensagem final
zenity --info --text="Processo concluído com sucesso!"
