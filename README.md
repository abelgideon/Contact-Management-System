# Contact Management System

This is a bash script-based Contact Manager developed as a final project for the Introduction to UNIX course. It allows users to manage their contacts by adding, removing, editing, searching, viewing, sorting, and importing/exporting contact records.

## Features

- **Add Contact:** Users can add new contacts with details such as first name, last name, phone number, and email address.
- **Remove Contact:** Users can remove existing contacts by their name.
- **Edit Contact:** Users can edit the details of existing contacts.
- **Search Contacts:** Users can search for contacts by name, phone number, or email address.
- **View All Contacts:** Users can view a list of all contacts.
- **Sort Contacts:** Users can sort contacts by name or email.
- **Import/Export Contacts:** Users can import contacts from a CSV file and export contacts to a CSV file.

## Getting Started

### Prerequisites

- UNIX-based operating system (e.g., Linux, macOS)
- Bash shell

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/abelgideon/Contact-Management-System.git
    ```
2. Navigate to the project directory:
    ```sh
    cd contact-manager
    ```

### Running

Make the script executable and run it:
```sh
chmod +x contactManager.sh
./contactManager.sh
```

## Usage

### Add Contacts:

- Choose the option to add a new contact.
- Enter the first name, last name, phone number, and email address.

### Remove Contacts:

- Choose the option to remove a contact.
- Enter the first and last name of the contact to delete.

### Edit Contacts:

- Choose the option to edit a contact.
- Enter the first and last name of the contact to edit, then choose which field to update.

### Search Contacts:

- Choose the option to search for contacts.
- Select the search criterion (name, phone number, email) and enter the search term.

### View All Contacts:

- Choose the option to view all contacts.

### Additional Options:

- Sort contacts by name or email.
- Import contacts from a CSV file.
- Export contacts to a CSV file.

## File Structure

- contactManager.sh: The main script file containing all the functionalities.
- contacts.txt: Stores contact records.
- sampleContacts.csv: Stores sample contact records.

## Example

### Adding a Contact

--- Add Contact ---


Enter first name: John

Enter last name(optional): Doe

Enter phone number: 1234567890

Enter email address: john.doe@example.com

John Doe has been added!

### Viewing All Contacts

--- All Contacts ---

Name       | Number      | Email

John Doe   | 1234567890  | john.doe@example.com

### Searching for a Contact

--- Search Contact ---

1. Search by name

2. Search by phone number

3. Search by email

\>\> 1

Enter name to search: John

Name       | Number      | Email

John Doe   | 1234567890  | john.doe@example.com

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.