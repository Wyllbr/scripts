#!/bin/bash

arquivo=$1


if [[ -f $arquivo ]]; then
	echo "É um arquivo"
else
	echo "Não é um arquivo ou não existe"
fi
