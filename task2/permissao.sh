#!/bin/bash

read permissao

if [[ -e $permissao  ]]; then
   chmod 755 $permissao
   echo "Permissão alteradas"
   echo ""
else
	echo "Entre com um arquivo válido"
fi
 
