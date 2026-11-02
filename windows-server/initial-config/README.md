# Initial Windows Server/Host Configuration (Domain Controller, DNS, etc.)

The initial configuration of a Windows Server virtual machine and 2 Windows 11 host virtual machines were created and networked through Proxmox.

The following roles and features were installed and configured on the Windows Server VM:

- AD DS
- DNS Server
- File Server

Windows Server was configured with a static IP as a domain controller through AD DS. Once configured as the domain controller, the Windows Server VM was also configured as a DNS server with DNS forwarding set to the network gateway.

Windows 11 VMs were initially left as a standard configuration with the exception of joining them to the domain.