#Initialize arrays for each column of the CSV along with special characters and an integer for a random number.
$wordOneArray = @(Import-Csv -Path "C:\Path\to\CSV").WordOne
$wordTwoArray = @(Import-Csv -Path "C:\Path\to\CSV").WordTwo
$wordThreeArray = @(Import-Csv -Path "C:\Path\to\CSV").WordThree
$specialArray = @("!", "#", "$", "^", "*", ".", "?", "-", "", "+", "=")
$number= Get-Random -Minimum 99 -Maximum 500

#Select a random word from each array.
$wordOne = $wordOneArray[(Get-Random -Minimum 0 -Maximum $wordOneArray.Count)]
$wordTwo = $wordTwoArray[(Get-Random -Minimum 0 -Maximum $wordTwoArray.Count)]
$wordThree = $wordThreeArray[(Get-Random -Minimum 0 -Maximum $wordThreeArray.Count)]
$special = $specialArray[(Get-Random -Minimum 0 -Maximum $specialArray.Count)]

#Generate password and copy to clipboard.
$password = $wordOne + $special + $wordTwo + $number + $wordThree
Set-Clipboard -Value $password