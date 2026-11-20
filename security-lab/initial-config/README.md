## Security Lab Configuration

### Security Tools
- Firewall - pfSense
- SIEM - Wazuh
- Vulnerability Monitor - Nessus
- Network Traffic Analysis - Security Onion

### Target Systems
- Debian Linux
    - Docker
    - Portainer
- Windows Server/Endpoint Environment
- Metasploitable 2
- bWAPP
- DVWA
- Webgoat

### Adversary Emulation
- Caldera
- Kali Linux

## Setup
Using Proxmox as a hypervisor, I configured 4 seperate vlans to emulate an enterprise SOC environment. Systems were seperated into VLANs as follows:

- VLAN 1 - Security tools and platforms
- VLAN 2 - Known-vulnerable target systems
- VLAN 3 - Enterprise Windows environment
- VLAN 4 - Linux based containerized web app environment