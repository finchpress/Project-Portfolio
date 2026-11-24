#Functions
function Pull-EmployeesCSV{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$FilePath,
        [Parameter()]
        [string]$Delim=",",
        [Parameter(Mandatory)]
        [hashtable]$SyncMap
    )

    try{
        $SyncProperties=$SyncMap.GetEnumerator()
        $Properties=ForEach($Property in $SyncProperties){
            @{Name=$Property.Value;Expression=[scriptblock]::Create("`$_.$($Property.Key)")}
        }
        Import-Csv -Path "$FilePath" -Delimiter "$Delim" | Select-Object -Property $Properties
    }
    catch{
        Write-Error $_.Exception.Message
    }
}

function Pull-EmployeesAD{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [hashtable]$SyncMap,
        [Parameter(Mandatory)]
        [string]$Identifier,
        [Parameter(Mandatory)]
        [string]$Domain
    )

    try{
        Get-ADUser -Filter {$Identifier -like "*"} -Server $Domain -Properties @($SyncMap.Values)
    }
    catch{
        Write-Error -Message $_.Exception.Message
    }
}

function Compare-Users{
    param(
        [Parameter(Mandatory)]
        [hashtable]$SyncMap,
        [Parameter(Mandatory)]
        [string]$CSVPath,
        [Parameter()]
        [string]$Delim=",",
        [Parameter(Mandatory)]
        [string]$Identifier,
        [Parameter(Mandatory)]
        [string]$Domain
    )
    try{
        $CSVUsers=Pull-EmployeesCSV -FilePath $CSVPath -Delim $Delim -SyncMap $SyncMap
        $ADUsers=Pull-EmployeesAD -SyncMap $SyncMap -Domain $Domain -Identifier $Identifier

        Compare-Object -ReferenceObject $ADUsers -DifferenceObject $CSVUsers -Property $Identifier -IncludeEqual
    }
    catch{
        Write-Error $_.Exception.Message
    }
}

function Sync-UserData{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [hashtable]$SyncMap,
        [Parameter(Mandatory)]
        [string]$CSVPath,
        [Parameter()]
        [string]$Delim=",",
        [Parameter(Mandatory)]
        [string]$Identifier,
        [Parameter(Mandatory)]
        [string]$Domain 
    )

    try{
        $Compare=Compare-Users -SyncMap $SyncMap -CSVPath $CSVPath -Delim $Delim -Identifier $Identifier -Domain $Domain
        $ImportedUsersID=$Compare | where SideIndicator -eq "=>"
        $ExistingUsersID=$Compare | where SideIndicator -eq "=="
        $DisabledUsersID=$Compare | where SideIndicator -eq "<="

        $ImportedUsers=Pull-EmployeesCSV -FilePath $CSVPath -Delim $Delim -SyncMap $SyncMap | where $Identifier -In $ImportedUsersID.$Identifier
        $ExistingUsers=Pull-EmployeesCSV -FilePath $CSVPath -Delim $Delim -SyncMap $SyncMap | where $Identifier -In $ExistingUsersID.$Identifier
        $DisabledUsers=Pull-EmployeesAD -SyncMap $SyncMap -Domain $Domain -Identifier $Identifier | where $Identifier -In $DisabledUsersID.$Identifier

        @{
            Imported=$ImportedUsers
            Existing=$ExistingUsers
            Disabled=$DisabledUsers
        }
    }
    catch{
        Write-Error $_.Exception.Message
    }
    
}

function Create-Username{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]$GivenName,
        [Parameter(Mandatory)]
        [string]$SurName,
        [Parameter(Mandatory)]
        [string]$Domain
    )

    [RegEx]$Pattern="\s|-|'"

    $index=1
    do{
    $Username="$Surname$($GivenName.Substring(0,$index))" -replace $Pattern,""
    $Username=$Username.ToLower()
    $index++
    }
    while((Get-ADUser -Filter "SamAccountName -like '$Username'") -and ($Username -notlike "$Surname$GivenName"))

    if(Get-ADUser -Filter "SamAccountName -like '$Username'"){
        throw "A user with this username already exists."
    }
    else{
        $Username
    }
}

function Check-OU{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [hashtable]$SyncMap,
        [Parameter(Mandatory)]
        [string]$CSVPath,
        [Parameter()]
        [string]$Delim=",",
        [Parameter(Mandatory)]
        [string]$OUProperty,
        [Parameter(Mandatory)]
        [string]$Domain
    )

    try{
        $OUs=Pull-EmployeesCSV -FilePath $CSVPath -Delim $Delim -SyncMap $SyncMap | Select -Property $OUProperty -Unique

        foreach($OU in $OUs){
            $OU=$OU.$OUProperty
            if(-not (Get-ADOrganizationalUnit -Filter "name -eq '$OU'" -Server $Domain)){
                New-ADOrganizationalUnit -Name $OU -Server $Domain
            }
        }
    }
    catch{
        Write-Error $_.Exception.Message
    }

}

#Main Script
$SyncMap=@{
    EmployeeID="EmployeeID"
    FirstName="GivenName"
    LastName="SurName"
    Role="Title"
    Department="Department"
}

$CSVPath="C:\Users\Administrator\Desktop\importtest.csv"
$Delim=","
$Domain="study.local"
$Identifier="EmployeeID"
$OUProperty="Department"


$UserData=Sync-UserData -SyncMap $SyncMap -CSVPath $CSVPath -Delim $Delim -Identifier $Identifier -Domain $Domain

Check-OU -SyncMap $SyncMap -CSVPath $CSVPath -Delim $Delim -OUProperty $OUProperty -Domain $Domain

Create-Username -GivenName "Ri" -SurName "Smith" -Domain "study.local"
