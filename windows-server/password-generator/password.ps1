
#Initialize variables for .csv array, total rows in array, a special characters list, and a random number.
$wordArray = @(Import-Csv -Path "C:\Path\to\CSV")
[Int]$arrayLength = $wordArray.Count
$specialArray = @("!", "#", "$", "^", "*", ".", "?", "-", "", "+", "=")
$number= Get-Random -Minimum 99 -Maximum 500

#Select a random row from the imported csv, then assign the value in the WordOne column to $wordOne.
$rand = Get-Random -Minimum 0 -Maximum $arrayLength
$wordOne = $wordArray[$rand].wordOne

#Select a random row from the imported csv, then assign the value in the WordTwo column to $wordTwo.
$rand = Get-Random -Minimum 0 -Maximum $arrayLength
$wordTwo = $wordArray[$rand].wordTwo

#Select a random row from the imported csv, then assign the value in the WordThree column to $wordThree.
$rand = Get-Random -Minimum 0 -Maximum $arrayLength
$wordThree = $wordArray[$rand].wordThree

#Select a random value from $specialArray.
$rand = Get-Random -Minimum 0 -Maximum $specialArray.Count
$special = $specialArray[$rand]

#Generate password and copy to clipboard.
$password = $wordOne + $special + $wordTwo + $number + $wordThree
Set-Clipboard -Value $password