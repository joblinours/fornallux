<div align="center">
<h1 align="center">
<img src="/assets/fornallux.jpg" width="100" />
<h1>FORNALLUX</h1>
<h2>◦ Développé avec beaucoup de 💚 et un peu de sueur </h2>
</div>


<div>
<p align="center">
<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash" />
<img src="https://img.shields.io/badge/Markdown-000000.svg?style&logo=Markdown&logoColor=white" alt="Markdown" />
</p>
</div>



## 📖 Table des matières
- [📖 Table des matières](#📖-table-des-matières)
- [📂 Structure du dossier](#📂-structure-du-dossier)
- [🚀 Pour commencer](#🚀-pour-commencer)
    - [🔧 Installation](#🔧-installation)
- [🤖 Execution des outils ](#🤖-execution-des-outils)
    - [🗃️ massunziper.sh](#🗃️-massunzipersh)
    - [🔎 fornallux_V3.sh](#🔎-fornallux_v3sh)
- [💡 Amélioration](#💡-Amélioration)
- [🤝 Contribuer](#🤝-Contribuer)
---


## 📂 Structure du dossier

```sh
└── fornallux/
    ├── assets/
    │   └── fornallux.jpg
    ├── fornallux_V3.sh
    ├── massunziper.sh
    ├── dependency.sh
    ├── readme.md
    └── LisezMoi.md
```


---


## 🚀 Pour commencer

***Dépendances***

Veuillez vous assurer que les dépendances suivantes sont installées sur votre système :

`- ℹ️ Tshark`

`- ℹ️ Figlet`


### 🔧 Installation
1. Cloner le dépôt fornallux:
```sh
git clone https://github.com/joblinours/fornallux.git
```

2. Se rendre dans le répertoire du projet:
```sh
cd fornallux.git
```

3. définir les autorisations :
```sh
sudo chmod +x dnamesearch.sh massunziper.sh dependency.sh
```
4. installation de dépendances : 
```sh
./dependency.sh
```

## 🤖 Execution des outils

### 🗃️ massunziper.sh
```sh
./massunziper.sh 

Options :
  -i <répertoire_source> : Répertoire source 
  -o <répertoire_destination> : Répertoire de destination
  -h : Affiche l'aide.

Exemple d'utilisation :
  ./massunziper.sh -i /home/user/zip_files -o /home/user/unzipped_files
```
### 🔎 fornallux_V3.sh

```sh
./fornallux_V3.sh

Options obligatoires :

-f <fichier_pcap> : Spécifie le fichier PCAP à traiter.
-d <répertoire_pcap> : Spécifie le répertoire contenant les fichiers PCAP à traiter.
-o <fichier_sortie> : spécifie le fichier dans lequel les résultats doivent être écrits.

Options de traitement :

-i : Active l'extraction des correspondances IP <-> nom de domaine.
-p <tcp|udp> : Active l'analyse des ports et des IP de destination (TCP ou UDP).
-m <tcp|udp> : active l'analyse des ports de destination et des IP (TCP ou UDP) pour plusieurs fichiers PCAP.
-n : permet d'extraire les noms de domaine.

Options supplémentaires :

-v : Active le mode verbeux.
-h : Affiche le menu d'aide.

Exemples :

./fornallux_V3.sh -f file.pcap -o resultat.txt -i
./fornallux_V3.sh -d repertoire -o resultat.txt -p tcp
./fornallux_V3.sh -d repertoire -o resultat.txt -m udp
./fornallux_V3.sh -d répertoire -o resultat.txt -m udp -v
```
⚠️ l'option "-m" ne peut fonctionner qu'avec l'option "-d".


## 💡 Amélioration

- Rien pour le moment

## 🤝 Contribuer

Les contributions sont toujours les bienvenues ! Veuillez suivre les étapes suivantes :
1. Mettre le référentiel du projet en fourche (Fork). Cela crée une copie du projet sur votre compte que vous pouvez modifier sans affecter le projet original.
2. Clonez le dépôt forké sur votre machine locale en utilisant un client Git comme Git ou GitHub Desktop.
3. Créez une nouvelle branche avec un nom descriptif (ex : `new-feature-branch` or `bugfix-issue-123`).
```sh
git checkout -b new-feature-branch
```
4. Apporter des modifications à la base de code du projet.
5. Transmettez vos modifications à votre branche locale avec un message de transmission clair qui explique les changements que vous avez apportés.
```sh
git commit -m 'Implemented new feature.'
```
6. Poussez vos changements vers votre dépôt forké sur GitHub en utilisant la commande suivante
```sh
git push origin new-feature-branch
```
7. Créez une nouvelle demande d'extraction dans le référentiel d'origine du projet. Dans cette demande, décrivez les modifications que vous avez apportées et expliquez pourquoi elles sont nécessaires.
Les responsables du projet examineront vos modifications et vous feront part de leurs commentaires ou les fusionneront dans la branche principale.

---

[↑ Return](#Top)

---
