#Initialize arrays for each column of the CSV along with special characters and an integer for a random number.
$wordOneArray = @(Import-Csv -Path "C:\Users\smith_ben\NewPass\words.csv").WordOne
$wordTwoArray = @(Import-Csv -Path "C:\Users\smith_ben\NewPass\words.csv").WordTwo
$wordThreeArray = @(Import-Csv -Path "C:\Users\smithben\NewPass\words.csv").WordThree
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