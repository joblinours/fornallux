#!/bin/bash

# Fonction pour extraire les correspondances IP <-> nom de domaine d'un fichier PCAP
extract_ip_domain_mappings() {
    tshark -r "$1" -T fields -e ip.dst -e dns.qry.name | awk 'NF > 0' | sort -u
}

# Fonction pour extraire les noms de domaine d'un fichier PCAP
extract_domains() {
    tshark -r "$1" -T fields -e dns.qry.name | sort -u
}

# Fonction pour compter le nombre de fichiers PCAP dans un répertoire
count_pcap_files() {
    find "$1" -type f -name "*.pcap" | wc -l
}

# Fonction pour analyser les ports de destination et les ip
port_analyse(){
    # tshark...
    echo "in progress"
}

# fonction d'affichage du menu 

menu(){
    figlet fornallux
    echo ""
    echo "Options possibles :"
    echo "-f <fichier_pcap> : Spécifie le fichier PCAP à traiter."
    echo "-d <répertoire_pcap> : Spécifie le répertoire contenant les fichiers PCAP à traiter."
    echo "-o <fichier_sortie> : Spécifie le fichier dans lequel écrire les résultats."
    echo "-ip : Active l'extraction des correspondances IP <-> nom de domaine."
    echo "-p : Active l'analyse des ports de destination et des IP."
    echo "-n : Active l'extraction des noms de domaine."
    echo "-v : Active le mode verbeux."
    echo "-h : Affiche l'aide."
    echo ""
}

# Vérifie les arguments de ligne de commande
if [ $# -lt 3 ]; then
    echo "Usage: $0 -f <fichier_pcap> -o <fichier_sortie> OR -d <répertoire_pcap> -o <fichier_sortie> [-v] [-ip]"
    exit 1
fi

while getopts "f:d:o:ipnvh" opt; do
    case $opt in
        f)
            input_file="$OPTARG"
            if [ ! -f "$input_file" ]; then
                echo "Le fichier PCAP '$input_file' n'existe pas."
                exit 1
            fi
            ;;
        d)
            input_dir="$OPTARG"
            if [ ! -d "$input_dir" ]; then
                echo "Le répertoire '$input_dir' n'existe pas."
                exit 1
            fi
            ;;
        o)
            output_file="$OPTARG"
            ;;
        i)
            ip_mapping=1
            ;;
        p)
            port=1
            ;;
        n)
            domain_name=1
            ;;
        v)
            verbose=1
            ;;
        h)
             menu
            exit 0
            ;;        
        \?)
            echo "Option invalide: -$OPTARG"
            exit 1
            ;;
    esac
done

if [ -n "$ip_mapping" ]; then
    if [ -n "$input_file" ]; then
        extract_ip_domain_mappings "$input_file" > "$output_file"
        echo "Correspondances IP <-> Nom de domaine extraites du fichier '$input_file' et enregistrées dans '$output_file'."
    elif [ -n "$input_dir" ]; then
        num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

        find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
            extract_ip_domain_mappings "$pcap_file" >> "$output_file"
            processed_files=$((processed_files + 1))
            if [ -n "$verbose" ]; then
                percentage=$((processed_files * 100 / num_pcap_files))
                echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
            fi
        done

        echo "Correspondances IP <-> Nom de domaine extraites des fichiers PCAP dans le répertoire '$input_dir' et enregistrées dans '$output_file'."
    fi
elif [ -n "$domain_name" ]; then
    if [ -n "$input_file" ]; then
        extract_domains "$input_file" > "$output_file"
        echo "Noms de domaine extraits du fichier '$input_file' et enregistrés dans '$output_file'."
    elif [ -n "$input_dir" ]; then
        num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

        find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
            extract_domains "$pcap_file" >> "$output_file"
            processed_files=$((processed_files + 1))
            if [ -n "$verbose" ]; then
                percentage=$((processed_files * 100 / num_pcap_files))
                echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
            fi
        done

        echo "Noms de domaine extraits des fichiers PCAP dans le répertoire '$input_dir' et enregistrés dans '$output_file'."
    fi
elif


else 
    echo "Aucune option n'a été spécifiée."
    menu
    exit 1
fi
