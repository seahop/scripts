#!/bin/bash
#Get timestamp
PREPEND=$(eval 'date +%s')

#Operator name and operation
echo "Welcome to the rollup script!";
read -p "Enter Your Name: " name
#Strip White Space
name=$(eval 'echo $name | sed "s/ //g"')
read -p "Name of Operation: " op
#Strip white space
op=$(eval 'echo $op | sed "s/ //g"')

#concat time, name, and op for unique ID
CONCAT="$PREPEND-$name-$op"

#Create folder to put future contents
WRITE=$(eval 'mkdir "/tmp/$CONCAT"')

#Terminator wrap-up
echo "Wrapping up terminator logs..."
for i in /var/log/terminator/*
do
   eval 'cp $i "/tmp/$CONCAT/"'
done
cp ~/.zsh_history "/tmp/$CONCAT/zsh_history"
echo "Done!"

#Cobalt Strike wrap-up
echo "Wrapping up Cobalt Strike logs..."
for i in /redteam/tools/cs/cobaltstrike/logs/*
do
    eval 'cp -r $i "/tmp/$CONCAT/cs/"'
done
echo "Done!"

#Screenshots
echo "Wrapping up screenshots..."
eval 'mkdir "/tmp/$CONCAT/screenshots/"'
for i in ~/Pictures/
    do
        eval 'cp -r $i "/tmp/$CONCAT/screenshots/"'
    done
echo "Done!"

#Metasploit wrap-up
read -p "Do the Metasploit logs need to be saved? [y/n] " validate
if [[ $validate == "N"  || $validate == "n" ]]; then
    echo "Alrighty, moving on!"
else
    eval 'mkdir /tmp/$CONCAT/metasploit && cp ~/.msf4/logs/console.log /tmp/$CONCAT/metasploit/'
fi

#Additional folders
count=1
while [[ $count > 0 ]]; do
    read -p "Are there any other folders that need to be wrapped up? [y/n] " final
        if [[ $final == "N" || $final == "n" ]]; then
        count=0
        echo "Finalizing..."
    else
        read -p "Enter folder path: " path
	count=$(eval echo $path | grep -o "/" | wc -l)
	count=$(($count+1))
	folder= eval echo $path | cut -d / -f $count &> /dev/null
        for i in $path
            do
    		eval 'cp -r $path "/tmp/$CONCAT/$folder/"'
    	    done
        fi
done

#Zip it up
eval 'tar -czvf $CONCAT.tar.gz /tmp/$CONCAT/'
eval mv $CONCAT.tar.gz /tmp/
