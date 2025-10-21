# Run this file from terminal
# chmod +x setup_multipass_env.sh
# ./setup_multipass_env.sh

#!/bin/bash
# ========================================================================
# Multipass + Ansible Environment Setup Script
# Author: Nandeeswara (Simplified by ChatGPT)
# ========================================================================

set -e

# --- CONFIG ---
VMS=("controlplane" "worker-node-1" "worker-node-2")
SSH_KEY="$HOME/.ssh/id_rsa_ansible"
SSH_PUB="$SSH_KEY.pub"

# ========================================================================

echo "🔍 Checking Multipass VMs..."
multipass list || { echo "❌ Multipass not running! Start it first."; exit 1; }

# --- STEP 1: Generate SSH Key if Missing ---
if [ ! -f "$SSH_KEY" ]; then
    echo "🔑 Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY" -N ""
else
    echo "✅ SSH key already exists: $SSH_KEY"
fi

# --- STEP 2: Ensure all VMs are running ---
for VM in "${VMS[@]}"; do
    if ! multipass info "$VM" | grep -q "Running"; then
        echo "🚀 Starting VM: $VM"
        multipass start "$VM"
    fi
done

# --- STEP 3: Copy SSH Key into Each VM ---
for VM in "${VMS[@]}"; do
    IP=$(multipass info "$VM" | grep "IPv4" | awk '{print $2}')
    echo "⚙️  Setting up SSH on $VM ($IP)..."
    multipass exec "$VM" -- bash -c "
        mkdir -p /home/ubuntu/.ssh &&
        echo '$(cat "$SSH_PUB")' >> /home/ubuntu/.ssh/authorized_keys &&
        chmod 700 /home/ubuntu/.ssh &&
        chmod 600 /home/ubuntu/.ssh/authorized_keys &&
        chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    " || echo "⚠️  Failed to configure SSH on $VM. Check Multipass connection."
done

# --- STEP 4: Regenerate known_hosts ---
echo "🧹 Cleaning up old known_hosts entries..."
for VM in "${VMS[@]}"; do
    IP=$(multipass info "$VM" | grep "IPv4" | awk '{print $2}')
    ssh-keygen -R "$IP" 2>/dev/null || true
    ssh-keyscan -H "$IP" >> ~/.ssh/known_hosts 2>/dev/null || true
done


# --- STEP 5: Verify SSH Connectivity ---
echo "🔍 Verifying SSH access..."
for VM in "${VMS[@]}"; do
    IP=$(multipass info "$VM" | grep "IPv4" | awk '{print $2}')
    echo "➡️  Testing SSH: ubuntu@$IP ..."
    if ssh -o BatchMode=yes -i "$SSH_KEY" ubuntu@"$IP" "echo '✅ Connected to $VM'" 2>/dev/null; then
        echo "✅ SSH access to $VM successful"
    else
        echo "❌ SSH access to $VM failed"
    fi
done

echo ""
echo "🎉 All done!"
echo "Try pinging all nodes with:"
echo "  ansible -i inventory/hosts.ini all -m ping"
