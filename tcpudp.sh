#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 fichier.pcap"
  exit 1
fi

pcap_file="$1"
output_file="analyse.txt"

# Vider le fichier de sortie s'il existe déjà
> "$output_file"

# Analyser le fichier PCAP en utilisant tshark (outil en ligne de commande de Wireshark)
tshark -r "$pcap_file" -T fields -e ip.proto -e udp.dstport -e tcp.dstport -e ip.dst | \
while read proto udp_port tcp_port dst_ip; do
  if [ -n "$udp_port" ]; then
    echo "UDP : $udp_port : $dst_ip" >> "$output_file"
  elif [ -n "$tcp_port" ]; then
    echo "TCP : $tcp_port : $dst_ip" >> "$output_file"
  fi
done

echo "Analyse terminée. Résultats enregistrés dans $output_file."
