#!/bin/bash

# Mettre à jour les informations sur les paquets
echo "Mise à jour des informations sur les paquets..."
if sudo apt-get update; then
    echo "Mise à jour des informations sur les paquets réussie."
else
    echo "Échec de la mise à jour des informations sur les paquets. Veuillez vérifier votre connexion Internet ou les erreurs du gestionnaire de paquets."
    exit 1
fi

# Vérifie si tshark est installé
if ! command -v tshark &> /dev/null; then
    echo "tshark n'est pas installé. Tentative d'installation..."
    if sudo apt-get install -y tshark; then
        echo "tshark a été installé avec succès."
    else
        echo "Échec de l'installation de tshark."
    fi
else
    echo "tshark est déjà installé."
fi

# Vérifie si figlet est installé
if ! command -v figlet &> /dev/null; then
    echo "figlet n'est pas installé. Tentative d'installation..."
    if sudo apt-get install -y figlet; then
        echo "figlet a été installé avec succès."
    else
        echo "Échec de l'installation de figlet."
    fi
else
    echo "figlet est déjà installé."
fi
