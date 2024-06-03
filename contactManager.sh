#!/bin/bash

header() {
	local text=$1
	local length=${#text}
	local border=""
	local i=0

	while [ $i -lt $length ]
	do
		border="$border-"
		i=$((i + 1))
	done

	echo " $border"
	echo "|$text|"
	echo " $border"
}


isFound() {
	local fname=$1
	local lname=$2

	if grep -q "^$fname $lname," contacts.txt
	then
		return 0
	fi
	return 1
}

checkValidity() {
	local fname=$1
	local lname=$2
	local number=$3
	local email=$4

	if ! echo $fname | grep -qiE "^[a-z]+$"
	then
		echo -e "\nInvalid first name. Please enter letters only.\n"
		return 1
	fi

	if [ $lname != "-" ] && ! echo $lname | grep -qiE "^[a-z]+$"
	then
		echo -e "\nInvalid last name. Please enter letters only.\n"
		return 1
	fi

	if cut -d ',' -f1 contacts.txt | grep -qEi "^$fname $lname$"
	then
		echo -e "\n$fname $lname already exists.\n"
		return 1
	fi

	if ! echo $number | grep -qE "^[0-9]+$"
	then
		echo -e "\nInvalid phone number. Please enter digits only.\n"
		return 1
	fi

	if ! echo $email | grep -qE "^[a-z0-9\._-]+@[a-z]+\.[a-z]+$"
	then
		echo -e "\nInvalid email address. Please enter a valid email address.\n"
		return 1
	fi

	return 0
}


addContact() {
	header "Add Contact"

	read -p "Enter first name: " fname
	read -p "Enter last name(optional): " lname
	read -p "Enter phone number: " number
	read -p "Enter email address: " email

	if [ -z $lname ]
	then
		lname="-"
	fi

	if ! checkValidity $fname $lname $number $email
	then
		return 1
	fi

	echo "$fname $lname,$number,$email" >> contacts.txt
	echo -e "\n$fname $lname has been added!\n"
}


removeContact() {
	header "Remove Contact"
	header "Case Sensitive"

	read -p "Enter first name of contact to delete: " dfname
	read -p "Enter last name of contact to delete(optional): " dlname

	if [ -z $dlname ]
	then
		dlname="-"
	fi

	if isFound $dfname $dlname
	then
		read -p "Are you sure you want to delete $dfname $dlname?(yes/no): " choice
		if echo $choice | grep -iqE "y(es)?"
		then
			sed -i "/^$dfname $dlname,/d" contacts.txt
			echo -e "\n$dfname $dlname has been deleted.\n"
		else
			return 1
		fi
	else
		echo -e "\n$dfname $dlname not found.\n"
	fi
}


editContact() {
	header "Edit Contact"

	read -p "Enter first name of contact to edit: " efname
	read -p "Enter last name of contact to edit(optional): " elname

	if [ -z $elname ]
	then
		elname="-"
	fi

	if isFound $efname $elname
	then
		echo -e "What would you like to edit?
	1. Name
	2. Phone number
	3. Email"
		read -p ">> " choice

		if [ $choice -eq 1 ]
		then
			read -p "Enter new first name: " nfname
			read -p "Enter new last name: " nlname

			if [ -z $nlname ]
			then
				nlname="-"
			fi

			if checkValidity $nfname $nlname 0 "a@b.com"
			then
				sed -i "s/^$efname $elname,/$nfname $nlname,/" contacts.txt
				echo -e "\nContact updated.\n"
			else
				return 1
			fi

		elif [ $choice -eq 2 ]
		then
			read -p "Enter new phone number: " nnumber
			if checkValidity "a" "b" $nnumber "a@b.com"
			then
				sed -i "s/^$efname $elname,[^,]*,/$efname $elname,$nnumber,/" contacts.txt
				echo -e "\nContact updated.\n"
			else
				return 1
			fi

		elif [ $choice -eq 3 ]
		then
			read -p "Enter new email address: " nemail
			if checkValidity "a" "b" 0 $nemail
			then
				sed -i "s/^$efname $elname,\([^,]*\),[^,]*/$efname $elname,\1,$nemail/" contacts.txt
				echo -e "\nContact updated.\n"
			else
				return 1
			fi
		else
			echo "\nInvalid Choice.\n"
		fi
	else
		echo -e "\n$efname $elname not found.\n"
	fi
}


createTable() {
	local list="$1"

	local maxNameLength=$(echo "$list" | cut -d ',' -f1 | while read line; do echo ${#line}; done | sort -nr | head -n1)
	local maxNumberLength=$(echo "$list" | cut -d ',' -f2 | while read line; do echo ${#line}; done | sort -nr | head -n1)
	local maxEmailLength=$(echo "$list" | cut -d ',' -f3 | while read line; do echo ${#line}; done | sort -nr | head -n1)

	printf "%-${maxNameLength}s | %-${maxNumberLength}s | %-${maxEmailLength}s\n" "Name" "Number" "Email"

	local headerLength=$(( maxNameLength + maxNumberLength + maxEmailLength + 5 ))
	local border=""

	for ((i=0;i<headerLength;i++))
	do
		border="$border-"
	done
	echo $border

	while read line
	do
		local name=$(echo "$line" | cut -d ',' -f1)
		local number=$(echo "$line" | cut -d ',' -f2)
		local email=$(echo "$line" | cut -d ',' -f3)
		printf "%-${maxNameLength}s | %-${maxNumberLength}s | %-${maxEmailLength}s\n" "$name" "$number" "$email"
	done <<< "$list"
}


searchContact() {
	header "Search Contact"
	echo -e "1. Search by name\n2. Search by phone number\n3. Search by email"
	read -p ">> " choice

	if [ $choice -eq 1 ]
	then
		read -p "Enter name to search: " sname
		searchResults=$(awk -v name="$sname" -F ',' 'tolower($1) ~ tolower(name)' contacts.txt)
	elif [ $choice -eq 2 ]
	then
		read -p "Enter phone number to search: " snumber
		searchResults=$(awk -v number="$snumber" -F ',' 'tolower($2) ~ tolower(number)' contacts.txt)
	elif [ $choice -eq 3 ]
	then
		read -p "Enter email to search: " semail
		searchResults=$(awk -v email="$semail" -F ',' 'tolower($3) ~ tolower(email) ' contacts.txt)
	else
		echo -e "\nInvalid choice.\n"
	fi

	if [ -z "$searchResults" ]
	then
		echo -e "\nNo matching contacts found.\n"
		return 1
	fi

	echo
	createTable "$searchResults"
	echo
}


allContacts() {
	header "All Contacts"
	allContacts=$(cat contacts.txt)

	if [ -z "$allContacts" ]
	then
		echo "Not contacts available."
		return 1
	fi

	echo
	createTable "$allContacts"
	echo
}


importCSV() {
	read -p "Enter CSV file to import from: " csvFile
	if [ -f "$csvFile" ]
	then
		tail -n +2 "$csvFile" >> contacts.txt
		echo -e "\nContacts imported.\n"
	else
		echo -e "\nFile not found.\n"
	fi
}


exportCSV() {
	read -p "Enter CSV file to export to: " csvFile
	echo "Name,Number,Email" > "$csvFile"
	cat contacts.txt >> "$csvFile"
	echo -e "\nContacts exported.\n"
}


sortContacts() {
	header "Sort Contacts"
	echo -e "1. Sort by name\n2. Sort by email"
	read -p ">> " choice

	if [ $choice -eq 1 ]
	then
		sortedContacts=$(sort -t ',' -k1,1 contacts.txt)
	elif [ $choice -eq 2 ]
	then
		sortedContacts=$(sort -t ',' -k3,3 contacts.txt)
	else
		echo -e "\nInvalid Choice\n"
		return 1
	fi

	echo
	createTable "$sortedContacts"
	echo
}


mainMenu() {
	while true
	do
		header "Contact Manager"
		echo -e "1. Add Contacts\n2. Remove Contacts\n3. Edit Contacts\n4. Search Contacts\n5. View All Contacts\n6. Additional Options\n7. Exit"
		read -p ">> " choice

		if [ $choice -eq 1 ]
		then
			addContact
		elif [ $choice -eq 2 ]
		then
			removeContact
		elif [ $choice -eq 3 ]
		then
			editContact
		elif [ $choice -eq 4 ]
		then
			searchContact
		elif [ $choice -eq 5 ]
		then
			allContacts
		elif [ $choice -eq 6 ]
		then
			header "Additional Options"
			echo -e "1. Sort Contacts\n2. Import from CSV\n3. Export to CSV"
			read -p ">> " ch

			if [ $ch -eq 1 ]
			then
				sortContacts
			elif [ $ch -eq 2 ]
			then
				importCSV
			elif [ $ch -eq 3 ]
			then
				exportCSV
			else
				echo -e "\nInvalid choice.\n"
			fi
		elif [ $choice -eq 7 ]
		then
			break
		else
			echo -e "\nInvalid choice.\n"
		fi
	done
}


mainMenu
