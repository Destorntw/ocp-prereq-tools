#!/bin/bash

# Set the parameters
VM_TEMPLATE="vm-template-name"  # Name of the VM template to be replicated
VAPP_NAME="ocp-test"  # Name of the vApp where the VMs will be created
VM_NAME_PREFIX="ocp-app"  # Prefix for the VM names
START_INDEX=1  # Starting index for numbering the VMs
END_INDEX=10  # Ending index for numbering the VMs

# Set the customization parameters
VLAN_NAME="vlan-name"  # Name of the VLAN to assign to the VMs
VNIC_NAME="vnic-name"  # Name of the vNIC to assign to the VMs
HARD_DISK_SIZE_GB=100  # Hard disk size in GB for each VM
HARD_DISK_SOURCE="datastore-name"  # Name of the datastore for the hard disk source

# Set the VM folder (optional)
VM_FOLDER="vm-folder-name"  # Name of the folder where the VMs will be created

# Loop through the specified range of VMs
for ((i=$START_INDEX; i<=$END_INDEX; i++))
do
    VM_NAME="$VM_NAME_PREFIX-$(printf "%02d" $i)"
    
    echo "Creating VM: $VM_NAME"
    
    # Clone the VM template to create a new VM
    vm-cli vm clone "$VM_TEMPLATE" --vapp "$VAPP_NAME" --name "$VM_NAME" --folder "$VM_FOLDER"
    
    # Customize the VM's resources
    if [ ! -z "$VLAN_NAME" ]; then
        vm-cli network connect "$VM_NAME" --network "$VLAN_NAME"
    fi
    
    if [ ! -z "$VNIC_NAME" ]; then
        vm-cli vnic update "$VM_NAME" --vnic "$VNIC_NAME"
    fi
    
    if [ ! -z "$HARD_DISK_SIZE_GB" ]; then
        vm-cli disk create "$VM_NAME" --size "$HARD_DISK_SIZE_GB" --datastore "$HARD_DISK_SOURCE"
    fi
done
