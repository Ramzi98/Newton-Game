#TCHOULAK Ramzi
#!/bin/bash

# si les argument sont inferieur à 3, on affiche ce message d'usage...
if [ "$#" -lt 3 ]
then
	echo "Usage : sh joueur.sh host port nom_joueur"
	exit
fi

hostServeur=$1
portServeur=$2
nomJoueur=$3

#on lance le joueur
export LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/x86_64-linux/
cd Client-Moia/src
make clean
make "ADRESSE=${hostServeur} ${portServeur} ${nomJoueur}"
make clean
