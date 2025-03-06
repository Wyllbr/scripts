#!/bin/bash



dir=$1
dir2=$2


copy_files(){
#	local dir="$1"
#	local dir2="$2"
#        local caminhoreal=$(realpath "$dir")
#        local caminhoreal2=$(realpath "$dir2")
#        cp -r  "$caminhoreal/"* "$caminhoreal2"/
    local source_dir="$1"
    local dest_dir="$2"
    
    local source_path=$(realpath "$source_dir")
    local dest_path=$(realpath "$dest_dir")

    echo "Copiando arquivos de '$source_path' para '$dest_path'..."
    
    # Copia o conteúdo do diretório source para dentro do diretório destino
    cp -r "$source_path/"* "$dest_path"/
    
    echo "Cópia finalizada."
}


########################main###############################
if [[ -d "$dir" && -d "$dir2" ]]; then
   echo "Os dois argumentos são válidos"
   copy_files "$dir" "$dir2"
else
   echo "Um dos dois argmentos não são válidos"
fi
#######################endmain############################
