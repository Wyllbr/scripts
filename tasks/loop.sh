#!/bin/bash


#Primeira forma de faze

numeros=(1 2 3 4 5 6 7 8 9 10)

# Acessando os elementos
echo "Primeiro elemento: ${numeros[0]}"
echo "Todos os elementos: ${numeros[@]}"

for i in "${numeros[@]}"; do
    echo "Número: $i"
done


#Segunda forma de fazer, baseada em C

#for (( i=1; i<=10; i++)); do
#	echo "Número: $i" ;
#done
