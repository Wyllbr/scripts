#!/bin/bash
nome=$(zenity --entry --title="Olá" --text="Digite seu nome:")
zenity --info --text="Olá, $nome!"
