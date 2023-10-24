<div align="center">
<h1 align="center">
<img src="/assets/fornallux.jpg" width="100" />
<h1>FORNALLUX</h1>
<h2>◦ Developed with a lot of 💚 and a little sweat </h2>
</div>


<div>
<p align="center">
<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash" />
<img src="https://img.shields.io/badge/Markdown-000000.svg?style&logo=Markdown&logoColor=white" alt="Markdown" />
</p>
</div>



## 📖 Table of Contents
- [📖 Table of Contents](#-table-of-contents)
- [📂 Repository Structure](#-repository-structure)
- [🚀 Getting Started](#-getting-started)
    - [🔧 Installation](#-installation)
- [🤖 Running tools](#-running-the-tool)
    - [🗃️ massunziper.sh](#-massunzipersh)
    - [🔎 fornallux_V3.sh](#-fornallux_v3sh)
- [💡 Improvement](#-improvement)
- [🤝 Contributing](#-contributing)
---


## 📂 Repository Structure

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


## 🚀 Getting Started

***Dependencies***

Please ensure you have the following dependencies installed on your system:

`- ℹ️ Tshark`

`- ℹ️ Figlet`


### 🔧 Installation
1. Clone the fornallux repository :
```sh
git clone https://github.com/joblinours/fornallux.git
```

2. Change to the project directory :
```sh
cd fornallux.git
```

3. defined permissions :
```sh
sudo chmod +x dnamesearch.sh massunziper.sh dependency.sh
```
4. installation of outbuildings :
```sh
./dependency.sh
```

## 🤖 Running the tool

### 🗃️ massunziper.sh
```sh
./massunziper.sh 

Options:
  -i <source_directory>: Source directory 
  -o <destination_directory>: Destination directory
  -h: Displays help.

Example of use:
  ./massunziper.sh -i /home/user/zip_files -o /home/user/unzipped_files
```
### 🔎 fornallux_V3.sh

```sh
./fornallux_V3.sh

Mandatory options:

-f <fichier_pcap>: Specifies the PCAP file to be processed.
-d <pcap_directory>: Specifies the directory with PCAP files to be processed.
-o <output_file>: Specifies the file to write the results to.

Processing options:

-i : Enables extraction of IP <-> domain name matches.
-p <tcp|udp>: Enables analysis of destination ports and IPs (TCP or UDP).
-m <tcp|udp>: Enables destination port and IP (TCP or UDP) parsing for multiple PCAP files.
-n : Enables extraction of domain names.

Additional options :

-v: Activates verbose mode.
-h: Displays help menu.

Examples:

./fornallux_V3.sh -f file.pcap -o resultat.txt -i
./fornallux_V3.sh -d repertoire -o resultat.txt -p tcp
./fornallux_V3.sh -d repertoire -o resultat.txt -m udp
./fornallux_V3.sh -d directory -o resultat.txt -m udp -v
```
⚠️ the "-m" option can only work with the "-d" option

## 💡 Improvement

- nothing at this time 

## 🤝 Contributing

Contributions are always welcome! Please follow these steps:
1. Fork the project repository. This creates a copy of the project on your account that you can modify without affecting the original project.
2. Clone the forked repository to your local machine using a Git client like Git or GitHub Desktop.
3. Create a new branch with a descriptive name (e.g., `new-feature-branch` or `bugfix-issue-123`).
```sh
git checkout -b new-feature-branch
```
4. Make changes to the project's codebase.
5. Commit your changes to your local branch with a clear commit message that explains the changes you've made.
```sh
git commit -m 'Implemented new feature.'
```
6. Push your changes to your forked repository on GitHub using the following command
```sh
git push origin new-feature-branch
```
7. Create a new pull request to the original project repository. In the pull request, describe the changes you've made and why they're necessary.
The project maintainers will review your changes and provide feedback or merge them into the main branch.

---

[↑ Return](#Top)

---
