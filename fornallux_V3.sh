#!/bin/bash

# Fonction pour extraire les correspondances IP <-> nom de domaine d'un fichier PCAP
extract_ip_domain_mappings() {
    tshark -r "$1" -T fields -e ip.dst -e dns.qry.name | awk 'NF > 0' | sort -u
}

# Fonction pour extraire les noms de domaine d'un fichier PCAP
extract_domains() {
    tshark -r "$1" -T fields -e dns.qry.name | sort -u
}

# Fonction pour extraire toutes les adresses IP d'un fichier PCAP
extract_ips() {
    tshark -r "$1" -T fields -e ip.addr | sort -u
}

# Fonction pour compter le nombre de fichiers PCAP dans un répertoire
count_pcap_files() {
    find "$1" -type f -name "*.pcap" | wc -l
}

# Fonction pour analyser les ports TCP ou UDP de destination et les IP
port_analyse() {
    input_file="$1"
    output_file="$2"
    protocol="$3"
    
    tshark -r "$input_file" -T fields -e ip.dst -e $protocol.dstport -Y "ip.dst and $protocol.dstport" | sort -u | 
        awk -F'\t' -v OFS='\t' '!a[$1, $2]++' | sort -t$'\t' -k2 -n > "$output_file"

    awk -F'\t' '{ if ($2 != p) { print ""; print "###port\t"$2"###"; p = $2 } print $1 }' "$output_file" > "$output_file.tmp"
    mv "$output_file.tmp" "$output_file"
}

multiport_analyse(){
    pcap_file="$1"
    output_file="$2"
    protocol="$3"
    
    echo "Traitement du fichier PCAP : $pcap_file" >> "$output_file"

    # Utilisation de tshark pour extraire les informations du pcap et les trier
    tshark -r "$pcap_file" -T fields -e ip.dst -e $protocol.dstport -Y "ip.dst and $protocol.dstport" | sort -u | awk -F'\t' -v OFS='\t' '!a[$1, $2]++' | sort -t$'\t' -k2 -n > "$output_file.tmp"

    # Utilise awk pour formater le fichier de sortie final
    awk -F'\t' '{ if ($2 != p) { print ""; print "###port\t"$2"###"; p = $2 } print $1 }' "$output_file.tmp" >> "$output_file"

    # Ajouter une ligne vide à la fin du fichier de sortie
    echo "" >> "$output_file"
}

# Fonction pour afficher le menu d'aide
menu() {
    figlet Fornallux
    echo ""
    echo "Options obligatoire :"
    echo ""
    echo "-f <fichier_pcap> : Spécifie le fichier PCAP à traiter."
    echo "-d <répertoire_pcap> : Spécifie le répertoire contenant les fichiers PCAP à traiter."
    echo "-o <fichier_sortie> : Spécifie le fichier dans lequel écrire les résultats."
    echo ""
    echo "Options de traitement :"
    echo ""
    echo "-i : Active l'extraction des correspondances IP <-> nom de domaine."
    echo "-p <tcp|udp> : Active l'analyse des ports de destination et des IP (TCP ou UDP)."
    echo "-m <tcp|udp> : Active l'analyse des ports de destination et des IP (TCP ou UDP) pour plusieurs fichiers PCAP."
    echo "-n : Active l'extraction des noms de domaine."
    echo "-a : Active l'extraction de toutes les adresses IP."
    echo ""
    echo "Options supplémentaires :"
    echo ""
    echo "-v : Active le mode verbeux."
    echo "-h : Affiche ce menu d'aide."
    echo ""
    echo "Exemples :"
    echo ""
    echo ""$0" -f fichier.pcap -o resultat.txt -i"
    echo ""$0" -d repertoire -o resultat.txt -p tcp"
    echo ""$0" -d repertoire -o resultat.txt -m udp"
    echo ""$0" -d repertoire -o resultat.txt -m udp -v"
}

# Vérifie les arguments de ligne de commande
if [ $# -lt 3 ]; then
    menu
    exit 1
fi

input_file=""
input_dir=""
output_file=""
ip_mapping=""
port_analysis=""
multiport_analysis=""
domain_name=""
all_ips=""
verbose=""

options_selected=0  # Compteur pour les options -p, -m, -i, -n

# Récupération des arguments de ligne de commande
while getopts "f:d:o:p:m:navhi" opt; do
    case $opt in
        f)
            if [ -n "$input_dir" ]; then
                echo "-f et -d ne peuvent pas être utilisés ensemble."
                exit 1
            fi
            input_file="$OPTARG"
            if [ ! -f "$input_file" ]; then
                echo "Le fichier PCAP '$input_file' n'existe pas."
                exit 1
            fi
            [ -n "$verbose" ] && echo "L'option -v ne peut pas être utilisée avec -f."
            ;;
        d)
            if [ -n "$input_file" ]; then
                echo "-f et -d ne peuvent pas être utilisés ensemble."
                exit 1
            fi
            input_dir="$OPTARG"
            if [ ! -d "$input_dir" ]; then
                echo "Le répertoire '$input_dir' n'existe pas."
                exit 1
            fi
            [ -n "$verbose" ] && echo "L'option -v ne peut pas être utilisée avec -d."
            ;;
        o)
            output_file="$OPTARG"
            ;;
        p)
            if [ -n "$ip_mapping" ] || [ -n "$multiport_analysis" ] || [ -n "$domain_name" ] || [ -n "$all_ips" ]; then
                echo "-p ne peut pas être utilisé avec -i, -m, -n, ou -a."
                exit 1
            fi
            protocol="$OPTARG"
            if [ "$protocol" != "tcp" ] && [ "$protocol" != "udp" ]; then
                echo "Protocole invalide. Utilisez 'tcp' ou 'udp'."
                exit 1
            fi
            port_analysis="1"
            options_selected=1
            ;;
        m)
            if [ -n "$ip_mapping" ] || [ -n "$port_analysis" ] || [

 -n "$domain_name" ] || [ -n "$all_ips" ]; then
                echo "-m ne peut pas être utilisé avec -i, -p, -n, ou -a."
                exit 1
            fi
            protocol="$OPTARG"
            if [ "$protocol" != "tcp" ] && [ "$protocol" != "udp" ]; then
                echo "Protocole invalide. Utilisez 'tcp' ou 'udp'."
                exit 1
            fi
            multiport_analysis="1"
            options_selected=1
            ;;
        i)
            if [ -n "$port_analysis" ] || [ -n "$multiport_analysis" ] || [ -n "$domain_name" ] || [ -n "$all_ips" ]; then
                echo "-i ne peut pas être utilisé avec -p, -m, -n, ou -a."
                exit 1
            fi
            ip_mapping="1"
            options_selected=1
            ;;
        n)
            if [ -n "$ip_mapping" ] || [ -n "$all_ips" ]; then
                echo "-n ne peut pas être utilisé avec -i ou -a."
                exit 1
            fi
            domain_name="1"
            options_selected=1
            ;;
        a)
            if [ -n "$ip_mapping" ] || [ -n "$port_analysis" ] || [ -n "$multiport_analysis" ] || [ -n "$domain_name" ]; then
                echo "-a ne peut pas être utilisé avec -i, -p, -m, ou -n."
                exit 1
            fi
            all_ips="1"
            options_selected=1
            ;;
        v)
            verbose="1"
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

# Validation des options
if [ -z "$output_file" ]; then
    echo "L'option -o est obligatoire."
    exit 1
fi

if [ -z "$input_file" ] && [ -z "$input_dir" ]; then
    echo "Il faut au moins -f ou -d."
    exit 1
fi

if [ "$options_selected" -eq 0 ]; then
    echo "Une des options doit être sélectionnée (-p, -m, -i, -n, ou -a)."
    exit 1
fi

# Application des fonctions
if [ -n "$ip_mapping" ]; then
    if [ -n "$input_file" ]; then
        extract_ip_domain_mappings "$input_file" > "$output_file"
        echo "Correspondances IP <-> Nom de domaine extraites du fichier '$input_file' et enregistrées dans '$output_file'."
    elif [ -n "$input_dir" ]; then
        num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

        find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
            echo "Traitement du fichier PCAP : $pcap_file" >> "$output_file"
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
            echo "Traitement du fichier PCAP : $pcap_file" >> "$output_file"
            extract_domains "$pcap_file" >> "$output_file"
            processed_files=$((processed_files + 1))
            if [ -n "$verbose" ]; then
                percentage=$((processed_files * 100 / num_pcap_files))
                echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
            fi
        done

        echo "Noms de domaine extraits des fichiers PCAP dans le répertoire '$input_dir' et enregistrés dans '$output_file'."
    fi
elif [ -n "$all_ips" ]; then
    if [ -n "$input_file" ]; then
        extract_ips "$input_file" > "$output_file"
        echo "Toutes les adresses IP extraites du fichier '$input_file' et enregistrées dans '$output_file'."
    elif [ -n "$input_dir" ]; then
        num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

        find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
            echo "Traitement du fichier PCAP : $pcap_file" >> "$output_file"
            extract_ips "$pcap_file" >> "$output_file"
            processed_files=$((processed_files + 1))
            if [ -n "$verbose" ]; then
                percentage=$((processed_files * 100 / num_pcap_files))
                echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
            fi
        done

        echo "Toutes les adresses IP extraites des fichiers PCAP dans le répertoire '$input_dir' et enregistrées dans '$output_file'."
    fi
elif [ -n "$port_analysis" ]; then
    if [ -n "$input_file" ]; then
        port_analyse "$input_file" "$output_file" "$protocol"
        echo "Analyse des ports de destination en '$protocol' et des IP du fichier '$input_file' et enregistrées dans '$output_file'."
    elif [ -n "$input_dir" ]; then
        num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

        find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
            echo "Traitement du fichier PCAP : $pcap_file" >> "$output_file"
            port_analyse "$pcap_file" "$output_file" "$protocol"
            processed_files=$((processed_files + 1))
            if [ -n "$verbose" ]; then
                percentage=$((processed_files * 100 / num_pcap_files))
                echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
            fi
        done

        echo "Analyse des ports de destination et des IP des fichiers PCAP dans le répertoire

 '$input_dir' et enregistrées dans '$output_file'."
    fi
elif [ -n "$multiport_analysis" ]; then
    if [ -z "$input_dir" ]; then
        error "L'option -m ne peut être utilisée qu'avec l'option -d."
    fi
    num_pcap_files=$(count_pcap_files "$input_dir")
        processed_files=0

    #vider le fichier de sortie
    echo "" > "$output_file"
    
    find "$input_dir" -type f -name "*.pcap" | while read -r pcap_file; do
        multiport_analyse "$pcap_file" "$output_file" "$protocol"
        processed_files=$((processed_files + 1))
        if [ -n "$verbose" ]; then
            percentage=$((processed_files * 100 / num_pcap_files))
            echo "Progress: $processed_files/$num_pcap_files ($percentage%)"
        fi
    done
    rm "$output_file.tmp"
else 
    error "Aucune option n'a été spécifiée."
fi

