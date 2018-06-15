#!/bin/bash 
# Create by: pdonatilio, 2018
# Find the IP of an VBox VM by name and acess they by ssh with the user
# If the machine was not started this script will start it
#
# The command syntax
#
#       ./startVmMachine <machine_name> <user_name>
#

echo "Starting SSH Client to Access a VirtualBox VM - v1.5"

# Gettin the Parameters
machine_name="$1"
user_name="$2"

# Verifying if the parameters are empty
if [ -z "$machine_name" ] || [ -z "$user_name" ]; then
    # Output message
    echo "You must have to give the name of machine and the user_name like example:"
    echo "./startVmMachine <machine_name> <user_name>"
else
    # Start the machine if are is not running
    machine_is_running="$(VBoxManage list runningvms | grep $machine_name)"
    
    if [ -z "$machine_is_running" ]; then
        VBoxManage startvm "$machine_name" --type headless      
        
        # A simple progress bar just to whait the server to start
        i=0
        progress="* "        
        while [ $i -lt 10 ]
        do 
            echo "Services Starting: $progress"
            progress="$progress * "
            i=$((i+1))
            sleep 2 
        done
        echo "Services Started"
        
    fi
    # Getting the VBox VM IP bu the machine name
    ip="$(VBoxManage guestproperty get $machine_name "/VirtualBox/GuestInfo/Net/0/V4/IP" | cut -f2 -d " ")"
    
    # Running the SSH command
    ssh "$user_name@$ip"
fi