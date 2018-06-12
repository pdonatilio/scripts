#!/bin/bash 
# Create by: pdonatilio, 2018
# Find the IP of an VBox VM by name and acess they by ssh with the user
# The command syntax
#
#       ./startVmMachine <machine_name> <user_name>

echo "Starting SSH Client to Access a VirtualBox VM - v1.0"

# Gettin the Parameters
machine_name="$1"
user_name="$2"

# Verifying if the parameters are empty
if [ -z "$machine_name" ] || [ -z "$user_name" ]; then
    # Output message
    echo "You must have to give the name of machine and the user_name like example:"
    echo "./startVmMachine <machine_name> <user_name>"
else
    # Getting the VBox VM IP bu the machine name
    ip="$(VBoxManage guestproperty get $machine_name "/VirtualBox/GuestInfo/Net/0/V4/IP" | cut -f2 -d " ")"
    
    # Running the SSH command
    ssh "$user_name@$ip"
fi