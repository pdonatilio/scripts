#!/bin/bash 
# Create by: pdonatilio, 2018
# Find the IP of an VBox VM by name and acess they by ssh with the user
# If the machine was not started this script will start it
#
# The command syntax
#
#       ./startVmMachine <machine_name> <user_name>
#

echo "Starting SSH Client to Access a VirtualBox VM - v2.0"

# Gettin the Parameters
machine_name="$1"
user_name="$2"


# Verifying if the parameters are empty
if [ -z "$machine_name" ] || [ -z "$user_name" ]; then
    # Output message
    echo "You must have to give the name of machine and the user_name like example:"
    echo "./startVmMachine <machine_name> <user_name>"

    # Verifying if the app exists
    app_requisites="$(command -v arp-scan)"
    if [ -z "$app_requisites" ]; then
        echo "You need to install the arp-scan, please running:"
        echo "$ sudo apt intall arp-scan"    
    fi
else
    #Checking if the machine exsits
    machine_exists="$(VBoxManage list vms | grep $machine_name)"

    if [ -z "$machine_exists" ]; then
        echo "Machine Not Found. Please verify if this name are correct with this command below:"
        echo "$ VBoxManage list vms"
    else
        
        # Check if the machine is running
        machine_is_running="$(VBoxManage list runningvms | grep $machine_name)"
        
        # If the machine are not running start it
        if [ -z "$machine_is_running" ]; then
            VBoxManage startvm "$machine_name" --type headless      
            
            # A simple progress bar just to whait the server to start
            i=0
            progress="* "    

            while [ $i -lt 20 ]
            do 
                if [[ $i == 0 ]]; then
                    echo -n "Services Starting: "
                else
                    echo -en "$progress"
                fi
                 
                #progress="$progress * "
                i=$((i+1))
                sleep 2 
            done
            echo -e "\nServices Started"           
        fi

        # Getting the VBox VM IP bu the machine name
        #ip="$(VBoxManage guestproperty get $machine_name "/VirtualBox/GuestInfo/Net/0/V4/IP" | cut -f2 -d " ")"
        ip="$(arp -a | grep $(vboxmanage showvminfo $machine_name | grep "NIC 1:" | awk '{print tolower($4)}' | sed 's/.\{2\}/&:/g' | sed 's/.\{2\}$//') | awk '{print $2}' | tail -c +2 | head -c -2)"

        if [[ -z "$ip" ]]; then
            echo "Something wrong occurs when we try get the ip, please try again."
        else
            echo "ssh $user_name@$ip"
            # Running the SSH command
            ssh "$user_name@$ip"
        fi
    fi 
fi