#!/bin/bash


echo -e "Forneca um arquivo..."
echo ">"
read arquivo

if [[ -f "$arquivo" ]]; then
  # echo "O arquivo é um arquivo"
   linhas=$(wc -l $arquivo | awk '{print $1}') 
  # awk '{print $1}' $linhas
   echo "O número de linhas do arquivo $arquivo é $linhas"
else
	echo "não é um arquivo"
fi
