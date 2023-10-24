#!/bin/bash

# Fonction pour afficher l'aide
afficher_aide() {
  echo "Options:"
  echo "  -i <répertoire_source>: Répertoire source contenant les fichiers ZIP (obligatoire)."
  echo "  -o <répertoire_destination>: Répertoire de destination pour les fichiers décompressés (créé s'il n'existe pas)."
  echo "  -h: Affiche l'aide."
  echo ""
  echo "Exemple d'utilisation:"
  echo "  ./massunziper.sh -i /home/user/zip_files -o /home/user/unzipped_files"
  exit 1
}

# Initialise les variables
repertoire_source=""
repertoire_destination=""

# Traite les options en utilisant getopts
while getopts ":i:o:h" opt; do
  case "$opt" in
    i)
      # L'option -i a été spécifiée, donc définir le répertoire source
      repertoire_source="$OPTARG"
      ;;
    o)
      # L'option -o a été spécifiée, donc définir le répertoire de destination
      repertoire_destination="$OPTARG"
      ;;
    h)
      # L'option -h a été spécifiée, donc afficher l'aide
      afficher_aide
      ;;
    \?)
      echo "Option invalide: -$OPTARG"
      ;;
  esac
done

# Vérifie si le répertoire source a été spécifié et s'il existe
if [ -z "$repertoire_source" ] || [ ! -d "$repertoire_source" ]; then
  echo "Le répertoire source n'est pas spécifié ou n'existe pas."
  afficher_aide
fi

# Si le répertoire de destination a été spécifié, le créer s'il n'existe pas
if [ -n "$repertoire_destination" ] && [ ! -d "$repertoire_destination" ]; then
  mkdir -p "$repertoire_destination"
  if [ $? -ne 0 ]; then
    echo "Échec de la création du répertoire de destination '$repertoire_destination'."
    exit 1
  fi
fi

# Se déplace dans le répertoire source
cd "$repertoire_source" || exit 1

# Parcours tous les fichiers .zip dans le répertoire source
for fichier_zip in *.zip; do
  if [ -f "$fichier_zip" ]; then
    # Détermine le répertoire de destination
    if [ -n "$repertoire_destination" ]; then
      destination="$repertoire_destination"
    else
      destination="."
    fi

    # Décompresse le fichier ZIP dans le répertoire de destination
    unzip -d "$destination" "$fichier_zip"
    if [ $? -eq 0 ]; then
      echo "Décompression de '$fichier_zip' vers '$destination' terminée avec succès."
    else
      echo "Échec de la décompression de '$fichier_zip' vers '$destination'."
    fi
  fi
done