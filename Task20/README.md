# Task 20: Install Sonatype Nexus 3 with Ansible

![Static Badge](https://img.shields.io/badge/build-Ubuntu-brightgreen?style=flat&logo=ubuntu&label=Linux&labelColor=Orange&color=red) ![Static Badge](https://img.shields.io/badge/Linux-Task18-Orange?style=flat&label=DevOps&labelColor=blue&color=gray) ![Static Badge](https://img.shields.io/badge/ansible-v2.13.13-grey?logo=ansible&logoColor=black&label=ansible&labelColor=white) ![Static Badge](https://img.shields.io/badge/azure%20-%20v2.64.0-blue?logoColor=grey)


This Ansible role automates the installation of Sonatype Nexus 3 on a Linux server. It performs the following tasks:
- Updates the system packages.
- Installs necessary dependencies (like `wget` and `Java`).
- Downloads and installs Sonatype Nexus 3.
- Configures Nexus as a service and ensures it starts on system boot.

## Prerequisites

- **Ansible Installed**: Make sure you have Ansible installed on the control node.
- **Target Machine**: A Linux server (Ubuntu or CentOS) with SSH access from the control node.
- **Python**: The target machine should have Python installed for Ansible to run.
- **Java**: Nexus requires Java, and the role installs it if not already installed.

## Role Structure

This Task is structured as follows:

```
.
├── Install_Sonatype_Nexus_3
│   ├── defaults
│   │   └── main.yml
│   ├── files
│   ├── handlers
│   │   └── main.yml
│   ├── meta
│   │   └── main.yml
│   ├── README.md
│   ├── tasks
│   │   └── main.yml
│   ├── templates
│   │   └── nexus.service.j2
│   ├── tests
│   │   ├── inventory
│   │   └── test.yml
│   └── vars
│       └── main.yml
├── inventory
├── main.yml
├── README.md
└── Task20_Part1.png
```

### Inventory

The `inventory` file should contain the IP or hostname of the target server(s). For example:

```ini
[servers]
<target_server_ip> ansible_user=<user> ansible_ssh_private_key_file=<path_to_private_key>
```

Replace `<target_server_ip>`, `<user>`, and `<path_to_private_key>` with the actual values.

## Variables

You can define variables in `vars/main.yml` or pass them via command line:

```yaml
nexus_version: "3.73.0-12"
nexus_user: "nexus"
nexus_group: "nexus"
nexus_install_dir: "/opt"
nexus_data_dir: "/opt/sonatype-work"
nexus_port: "8081"
```

## How to Run

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Bahnasy2001/DEPI_DevOpsTasks.git
   cd Task20
   ```

2. **Initialize the Role**:

   If you haven't done so already, you can initialize the Ansible role directory:

   ```bash
   ansible-galaxy init Install_Sonatype_Nexus_3
   ```

3. **Run the Playbook**:

   ```bash
   ansible-playbook -i inventory main.yml --ask-become-pass
   ```

   This will prompt for the `sudo` password for privilege escalation on the target machine.

## Tasks Breakdown

The following tasks are included in the role:

1. **System Updates**:
    - Updates the system package manager (either `apt` for Debian-based or `yum` for RHEL-based systems).

2. **Install Dependencies**:
    - Installs `wget` to download Nexus.
    - Installs `Java`, as it's required to run Nexus.

3. **Download and Extract Nexus**:
    - Downloads the Nexus tarball from Sonatype’s official repository.
    - Extracts it into the `/opt` directory.

4. **Configure Nexus**:
    - Creates the Nexus user and group.
    - Sets up the Nexus directory structure.
    - Configures Nexus as a service.

5. **Service Management**:
    - Enables Nexus to start on boot.
    - Starts the Nexus service.

6. **Validation**:
    - After installation, the playbook checks if Nexus is running by verifying the process.

## Validating the Installation

### 1. Check if Nexus is Running

Use the following commands to verify that Nexus is running:

```bash
ps aux | grep nexus
```

This will display information about the Nexus process if it's running.

### 2. Verify via Web Browser

Nexus runs on port `8081` by default. Open your browser and navigate to:

```
http://<target_server_ip>:8081
```

If Nexus is installed correctly, you will see the Nexus Repository Manager interface.

### 3. Check Nexus Logs

To ensure everything started correctly, you can check the Nexus logs located in `/opt/sonatype-work/nexus3/log/nexus.log`:

```bash
cat /opt/sonatype-work/nexus3/log/nexus.log
```

## Troubleshooting

- **Nexus Not Starting**: Ensure the correct version of Java is installed and that the service is running.
- **Port Conflict**: If port `8081` is being used by another service, modify the Nexus configuration file to use a different port.

## Additional Information

- **Nexus Documentation**: [https://help.sonatype.com/repomanager3](https://help.sonatype.com/repomanager3)
- **Official Nexus Download**: [https://www.sonatype.com/download-oss-sonatype](https://www.sonatype.com/download-oss-sonatype)

---

### Commands Used

```bash
ansible-galaxy init Install_Sonatype_Nexus_3
ansible-playbook -i inventory main.yml --ask-become-pass
```
