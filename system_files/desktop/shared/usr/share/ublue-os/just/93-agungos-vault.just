# Toggle Agung Dev Security Vault
toggle-security-vault:
    #!/usr/bin/bash
    if [ -f "$HOME/.config/agungos/vault_disabled" ]; then
        rm -f "$HOME/.config/agungos/vault_disabled"
        echo "Agung Dev Security Vault has been ENABLED."
    else
        mkdir -p "$HOME/.config/agungos"
        touch "$HOME/.config/agungos/vault_disabled"
        echo "Agung Dev Security Vault has been DISABLED."
    fi

# Create Isolated Workspace (Distrobox)
create-security-vault:
    #!/usr/bin/bash
    if [ -f "$HOME/.config/agungos/vault_disabled" ]; then
        echo "Agung Dev Security Vault is disabled. Isolated Workspace doesn't work until this feature is enabled."
        exit 1
    fi
    echo "Creating Isolated Security Vault Workspace..."
    distrobox create --name agung-vault --unshare-net --unshare-ipc --home ~/.var/home/vault
    echo "Vault created! Use 'ujust enter-security-vault' to enter."

# Enter Isolated Workspace
enter-security-vault:
    #!/usr/bin/bash
    if [ -f "$HOME/.config/agungos/vault_disabled" ]; then
        echo "Agung Dev Security Vault is disabled. Isolated Workspace doesn't work until this feature is enabled."
        exit 1
    fi
    distrobox enter agung-vault

# Setup TPM 2.0 LUKS Binding
secure-tpm-luks:
    #!/usr/bin/bash
    if [ -f "$HOME/.config/agungos/vault_disabled" ]; then
        echo "Agung Dev Security Vault is disabled. TPM Security doesn't work until this feature is enabled."
        exit 1
    fi
    echo "This will bind your root partition to the TPM 2.0 chip."
    echo "Note: This is an advanced feature and assumes your root partition is encrypted and you have a TPM 2.0 chip."
    echo "Proceed? (Press Ctrl+C to cancel)"
    read -p ""
    # We attempt to find the LUKS partition automatically, or prompt the user.
    echo "Attempting to bind... (Ensure clevis and tpm2-tools are installed and functional)"
    # Example command (commented out for safety as device names vary, users should adjust or script should detect):
    # sudo clevis luks bind -d /dev/nvme0n1p3 tpm2 '{"pcr_ids":"7"}'
    echo "Please configure the exact device name manually using clevis."
