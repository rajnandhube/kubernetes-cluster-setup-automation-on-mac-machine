# Kuberetes cluster setup automation using Terraform, Ansible & Bash script

This lab demonstrates how to automate the setup of a Kubernetes cluster (1 controlplane + 2 workernodes) on Mac M1 or newer chip using Terraform for infrastructure provisioning, Ansible for configuration management, and Bash scripts for orchestration. The goal is to create a repeatable, reliable process for deploying Kubernetes clusters.

## Pre-requesite
Install multipass, Terraform, Ansible using brew
```
brew install --cask multipass
brew install ansible
brew install terraform
```

1. Run terraform scripts to provision infrastructure (VMs) on your MAC machine using Multipass.
```
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply "tfplan" -auto-approve
```
2. Once the VMs are provisioned, Note down the IP addresses and VM names and update the `setup_multipass_env.sh` and `inventory/hosts.ini` files accordingly.

- VM Names (IP Addresses): control-plane (192.168.64.45), worker-node-1 (192.168.64.46) & worker-node-2 (192.168.64.47)
- Update **VM names** in 14th line of `setup_multipass_env.sh` script.
- Update the **VM names & IP addresses** of the controlplane and workernodes in line no.of 3,6 and 7 `ansible/inventory/hosts.ini`

3. Run `setup_multipass_env.sh` bash script to enable passwordless SSH access from your MAC to the provisioned VMs.
```bash
cd ../
./setup_multipass_env.sh
```

4. Use Ansible to install and configure Kubernetes on the provisioned VMs.
``` 
cd ansible
ansible-playbook -i inventory/hosts.ini playbooks/site.yml
```




---










Let’s structure your Kubernetes Ansible setup as an enterprise-ready, CI/CD friendly project, using roles, handlers, tags, and idempotent tasks. This makes it maintainable, modular, and safe to run repeatedly.

This allows CI/CD pipelines to run `ansible-playbook -i inventory/hosts.ini playbooks/site.yml` for a full cluster setup.
Run this command from Mac terminal. if you run from VSCODE ter it may not work properly.

Here’s the recommended folder structure:
```
k8s-ansible/
├── inventory/
│   └── hosts.ini
├── playbooks/
│   ├── site.yml
│   ├── 01-prerequisites.yml
│   ├── 02-install-kubernetes.yml
│   └── 03-cluster-setup.yml
├── roles/
│   ├── prerequisites/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── handlers/
│   │       └── main.yml
│   ├── kube-install/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── handlers/
│   │       └── main.yml
│   └── kube-cluster/
│       ├── tasks/
│       │   └── main.yml
│       └── handlers/
│       │   └── main.yml
└── README.md
```

what is the use of handlers in ansible?
In Ansible, handlers are special tasks that are triggered by other tasks when they report a change. They are typically used for actions that need to be performed only when something has changed, such as restarting a service after a configuration file has been modified. Example: Restarting a service (like kubelet) only if a configuration file changed.
