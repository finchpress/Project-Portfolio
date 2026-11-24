## Import Users from CSV * WORK IN PROGRESS *

This is a script designed to complete the following tasks:

- Import user information from a CSV.
- Compare the users in the CSV to users in AD.
- Generate the following lists of users:
    - Users present in the CSV but not present in AD.
    - Users present both in the CSV and in AD.
    - Users present in AD but not in the CSV.
- Create an AD account with a unique username if the user is in the CSV but not in AD.
- Disable the user in AD if they are present in AD but not the CSV.

Currently, the following fuctions are present in the script:
- Pull-EmployeesCSV
    - Converts CSV headers to AD properties using a hashtable variable.
    - Creates a hashtable of properties for each user.
- Pull-EmployeesAD
    - Pulls a list of users using the Get-ADUser command using a unique identifer variable.
- Compare-Users
    - Compares the list of users pulled by the above fuctions to determine whether a user is in AD, the CSV, or neither.
- Sync-UserData
    - Pipes the output of Compare-Users to seperate users based on their presence in AD and the CSV.
- Create-Username
    - Creates a unique username formatted as LastNameInitial, then converts the username to lowercase.

- Check-OU
    - Checks for an existing OU based on an OU variable. In this case the variable has the value "Department". If the OU does not exist, the function creates it.